//
//  HSQPublicAdressView.m
//  LiTianDecoration
//
//  Created by administrator on 2018/4/18.
//  Copyright © 2018年 administrator. All rights reserved.
//

#define KPlacherLabelHeight 40

#define KTableViewsCountt 3

#import "HSQPublicAdressView.h"
#import "HSQAddressView.h"
#import "HSQAdressListModel.h"
#import "AddressTableViewCell.h"

@interface HSQPublicAdressView ()<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UIView *BgView;

@property (nonatomic, strong) UIView *TopView;

@property (nonatomic, strong) UILabel *placher_Label;

@property (nonatomic, strong) HSQAddressView *TopBarView;

@property (nonatomic, strong) NSMutableArray *topTabbarItems;

@property (nonatomic,weak) UIView * underLine;  // 按钮下面的下划线

@property (nonatomic,weak) UIButton * selectedBtn;

@property (nonatomic, strong) UIScrollView *contentView;

@property (nonatomic, strong) NSMutableArray *tableViews;

@property (nonatomic,strong) NSMutableArray * cityDataSouce;

@property (nonatomic,strong) NSMutableArray * districtDataSouce;

@property (nonatomic, copy) NSString *ProvinceId;  // 省级id

@property (nonatomic, copy) NSString *CityId;  // 市级id

@property (nonatomic, copy) NSString *AreaId;  // 县级id

@end

@implementation HSQPublicAdressView

- (NSMutableArray *)topTabbarItems{
    
    if (_topTabbarItems == nil) {
        
        _topTabbarItems = [NSMutableArray array];
    }
    return _topTabbarItems;
}

- (NSMutableArray *)tableViews{
    
    if (_tableViews == nil) {
        
        self.tableViews = [NSMutableArray array];
    }
    return _tableViews;
}

- (NSMutableArray *)dataSource{
    
    if (_dataSource == nil) {
        
        self.dataSource = [NSMutableArray array];
    }
    
    return _dataSource;
}

- (NSMutableArray *)cityDataSouce{
    
    if (_cityDataSouce == nil) {
        
        self.cityDataSouce = [NSMutableArray array];
    }
    
    return _cityDataSouce;
}

- (NSMutableArray *)districtDataSouce{
    
    if (_districtDataSouce == nil) {
        
        self.districtDataSouce = [NSMutableArray array];
    }
    
    return _districtDataSouce;
}

/**
 * @brief 初始化视图
 */
+ (instancetype)initAdressView{
    
    HSQPublicAdressView *publicView = [[HSQPublicAdressView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - KSafeBottomHeight)];
    
    publicView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
    
    [[[UIApplication sharedApplication] keyWindow]addSubview:publicView];
    
    return publicView;
}

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        // 1.创建控件
        [self SetUpViews];

        // 2.请求省级的数据
        [self RequestAreaDataFromeServer];
        
    }
    
    return self;
}


// 1.创建控件
- (void)SetUpViews{
    
    // 最底部的点击按钮
    UIButton *Bottombtn = [UIButton buttonWithType:(UIButtonTypeSystem)];
    Bottombtn.frame = self.bounds;
    Bottombtn.backgroundColor = [UIColor clearColor];
    [Bottombtn addTarget:self action:@selector(btnClickAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:Bottombtn];
    
    // 1.屏幕一半的背景图
    UIView *BgView = [[UIView alloc] initWithFrame:CGRectMake(0, KScreenHeight, KScreenWidth, KScreenHeight/2)];
    BgView.backgroundColor = [UIColor whiteColor];
    [self addSubview:BgView];
    self.BgView = BgView;
    
    // 2.头部的提示标题
    UILabel *placher_Label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KPlacherLabelHeight)];
    placher_Label.textColor = [UIColor grayColor];
    placher_Label.backgroundColor = [UIColor clearColor];
    placher_Label.font = [UIFont systemFontOfSize:15.0];
    placher_Label.textAlignment = NSTextAlignmentCenter;
    [BgView addSubview:placher_Label];
    self.placher_Label = placher_Label;
    
    // 3.右边的退出按钮
    UIButton *right_button = [UIButton buttonWithType:(UIButtonTypeCustom)];
    right_button.frame = CGRectMake(KScreenWidth - KPlacherLabelHeight, 0, KPlacherLabelHeight, KPlacherLabelHeight);
    right_button.backgroundColor = [UIColor orangeColor];
    [right_button addTarget:self action:@selector(dismissAdressView) forControlEvents:(UIControlEventTouchUpInside)];
    [BgView addSubview:right_button];
    
    // 4.提示文字下面的地址视图
    HSQAddressView *TopBarView = [[HSQAddressView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(placher_Label.frame), KScreenWidth, KPlacherLabelHeight)];
    TopBarView.backgroundColor = [UIColor whiteColor];
    [BgView addSubview:TopBarView];
    self.TopBarView = TopBarView;
    
    // 4.1.添加请选择按钮
    [self addTopBarItem];
    
    // 4.2.按钮下面的下划线
    UIView * underLine = [[UIView alloc] initWithFrame:CGRectZero];
    underLine.height = 2.0f;
    underLine.top = TopBarView.mj_h - underLine.height;
    underLine.backgroundColor = [UIColor redColor];
    [TopBarView addSubview:underLine];
    self.underLine = underLine;
    UIButton * btn = self.topTabbarItems.lastObject;
    [self changeUnderLineFrame:btn];
    
    // 5.底部的滚动式图
    CGFloat contentViewH = self.BgView.mj_h - KPlacherLabelHeight * 2 - KSafeBottomHeight;
    UIScrollView * contentView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.TopBarView.frame), self.BgView.mj_w, contentViewH)];
    contentView.contentSize = CGSizeMake(KScreenWidth * KTableViewsCountt, 0);
    [self.BgView addSubview:contentView];
    self.contentView = contentView;
    self.contentView.pagingEnabled = YES;
    self.contentView.delegate = self;
    
    // 6.添加省级的tableView
    [self addTableView];
    
}

// 2.添加请选择的按钮
- (void)addTopBarItem{
    
    UIButton * topBarItem = [UIButton buttonWithType:UIButtonTypeCustom];
    
    topBarItem.backgroundColor = [UIColor clearColor];
    
    [topBarItem setTitle:@"请选择" forState:UIControlStateNormal];
    
    [topBarItem setTitleColor:RGB(43, 43, 43) forState:UIControlStateNormal];
    
    [topBarItem setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
    
    topBarItem.titleLabel.font = [UIFont systemFontOfSize:14.0];
    
    [topBarItem sizeToFit];
    
    topBarItem.centerY = self.TopBarView.mj_h * 0.5;
    
    [self.topTabbarItems addObject:topBarItem];
    
    [self.TopBarView addSubview:topBarItem];
}

// 3.调整指示条位置
- (void)changeUnderLineFrame:(UIButton  *)btn{
    
    self.selectedBtn.selected = NO;
    btn.selected = YES;
    self.selectedBtn = btn;
    self.underLine.centerX = btn.centerX;
    self.underLine.width = btn.mj_w;
}

// 4.添加数据的tableview
- (void)addTableView{
    
    for (NSInteger i = 0; i < KTableViewsCountt; i++) {
        
       
    }
    
    UITableView * tabbleView = [[UITableView alloc]initWithFrame:CGRectMake(self.tableViews.count * KScreenWidth, 0, KScreenWidth, self.contentView.mj_h)];
    tabbleView.backgroundColor = [UIColor clearColor];
    tabbleView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tabbleView.delegate = self;
    tabbleView.dataSource = self;
    tabbleView.contentInset = UIEdgeInsetsMake(0, 0, 10, 0);
    [tabbleView registerNib:[UINib nibWithNibName:@"AddressTableViewCell" bundle:nil] forCellReuseIdentifier:@"AddressTableViewCell"];
    [self.contentView addSubview:tabbleView];
    [self.tableViews addObject:tabbleView];
}

 // 5.请求省级的数据
- (void)RequestAreaDataFromeServer{
    
        AFNetworkRequestTool *mangerTool = [AFNetworkRequestTool shareRequestTool];

        [mangerTool.manger GET:UrlAdress(KGetAdressInfoUrl) parameters:@{@"areaId":@"0"} progress:^(NSProgress * _Nonnull downloadProgress) {

        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

            self.dataSource = [HSQAdressListModel mj_objectArrayWithKeyValuesArray:responseObject[@"datas"][@"areaList"]];

//            HSQLog(@"我的数据%@===%@",self.dataSource,UrlAdress(KGetAdressInfoUrl));
            
            UITableView *tableView = (UITableView *)[self.tableViews firstObject];
            
            [tableView reloadData];

        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {

        }];
}

 // 6.请求市级的数据
- (void)requestCityLevelDataFromeServer:(NSString *)areaId{
    
    AFNetworkRequestTool *mangerTool = [AFNetworkRequestTool shareRequestTool];
    
    [mangerTool.manger GET:UrlAdress(KGetAdressInfoUrl) parameters:@{@"areaId":areaId} progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        self.cityDataSouce = [HSQAdressListModel mj_objectArrayWithKeyValuesArray:responseObject[@"datas"][@"areaList"]];
        
//        HSQLog(@"我的市级数据%@===%@",self.cityDataSouce,UrlAdress(KGetAdressInfoUrl));
        
        UITableView *tableView = (UITableView *)self.tableViews[1];
        
        [tableView reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

// 6.请求县级的数据
- (void)requestDistrictLevelDataFromeServer:(NSString *)areaId{
    
    AFNetworkRequestTool *mangerTool = [AFNetworkRequestTool shareRequestTool];
    
    [mangerTool.manger GET:UrlAdress(KGetAdressInfoUrl) parameters:@{@"areaId":areaId} progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        self.districtDataSouce = [HSQAdressListModel mj_objectArrayWithKeyValuesArray:responseObject[@"datas"][@"areaList"]];
        
//        HSQLog(@"我的县级数据%@===%@",self.districtDataSouce,UrlAdress(KGetAdressInfoUrl));
        
        UITableView *tableView = (UITableView *)self.tableViews[2];
        
        [tableView reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

#pragma mark - TableViewDatasouce

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if([self.tableViews indexOfObject:tableView] == 0)
    {
        return self.dataSource.count;
    }
    else if ([self.tableViews indexOfObject:tableView] == 1)
    {
        return self.cityDataSouce.count;
    }
    else if ([self.tableViews indexOfObject:tableView] == 2)
    {
        return self.districtDataSouce.count;
    }
    
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    AddressTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"AddressTableViewCell" forIndexPath:indexPath];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    HSQAdressListModel * item;
    
    if([self.tableViews indexOfObject:tableView] == 0) //省级别
    {
        item = self.dataSource[indexPath.row];
    }
    else if ([self.tableViews indexOfObject:tableView] == 1)  //市级别
    {
        item = self.cityDataSouce[indexPath.row];
    }
    else if ([self.tableViews indexOfObject:tableView] == 2) //县级别
    {
        item = self.districtDataSouce[indexPath.row];
    }
    
    cell.item = item;
    
    return cell;
}

#pragma mark - TableViewDelegate

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    HSQLog(@"===我又来啦");

    if ([self.tableViews indexOfObject:tableView] == 0)
    {
        //1.1 获取下一级别的数据源(市级别,如果是直辖市时,下级则为区级别)
        HSQAdressListModel * provinceItem = self.dataSource[indexPath.row];

        // 获取市级数据
        self.cityDataSouce = self.dataSource;

        if(self.cityDataSouce.count == 0){
            
            for (int i = 0; i < self.tableViews.count && self.tableViews.count != 1; i++) {
                
                [self removeLastItem];
            }
            
            [self setUpAddress:provinceItem.areaName addressProvinceId:provinceItem.areaId addressCityId:provinceItem.areaId addressAreaId:provinceItem.areaId];

            return indexPath;
        }
        
        //1.1 判断是否是第一次选择,不是,则重新选择省,切换省.
        NSIndexPath * indexPath0 = [tableView indexPathForSelectedRow];

        if ([indexPath0 compare:indexPath] != NSOrderedSame && indexPath0) {

            for (int i = 0; i < self.tableViews.count && self.tableViews.count != 1; i++) {
                [self removeLastItem];
            }
            
            [self addTopBarItem];
            
            [self addTableView];
            
            [self scrollToNextItem:provinceItem.areaName];
            
            return indexPath;

        }
        else if ([indexPath0 compare:indexPath] == NSOrderedSame && indexPath0)
        {

            for (int i = 0; i < self.tableViews.count && self.tableViews.count != 1 ; i++) {
                [self removeLastItem];
            }
            
            [self addTopBarItem];
            
            [self addTableView];
            
            [self scrollToNextItem:provinceItem.areaName];
            
            return indexPath;
        }

        //之前未选中省，第一次选择省
        [self addTopBarItem];
        
        [self addTableView];
        
        HSQAdressListModel * item = self.dataSource[indexPath.row];
        
        [self scrollToNextItem:item.areaName ];

    }
    else if ([self.tableViews indexOfObject:tableView] == 1)
    {
        HSQAdressListModel * cityItem = self.cityDataSouce[indexPath.row];
        
        // 获得县级数据
        self.districtDataSouce = self.dataSource;
        
        NSIndexPath * indexPath0 = [tableView indexPathForSelectedRow];

        if ([indexPath0 compare:indexPath] != NSOrderedSame && indexPath0) {

            for (int i = 0; i < self.tableViews.count - 1; i++) {
                
                [self removeLastItem];
            }
            
            [self addTopBarItem];
            
            [self addTableView];
            
            [self scrollToNextItem:cityItem.areaName];
            
            return indexPath;

        }
        else if ([indexPath0 compare:indexPath] == NSOrderedSame && indexPath0){

            [self scrollToNextItem:cityItem.areaName];
            
            return indexPath;
        }

        [self addTopBarItem];
        
        [self addTableView];
        
        HSQAdressListModel * item = self.cityDataSouce[indexPath.row];
        
        [self scrollToNextItem:item.areaName];
    }
    else if ([self.tableViews indexOfObject:tableView] == 2)
    {
        HSQAdressListModel * item = self.districtDataSouce[indexPath.row];
        
        [self setUpAddress:item.areaName addressProvinceId:item.areaId addressCityId:item.areaId addressAreaId:item.areaId];
    }
    return indexPath;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    HSQAdressListModel * item;
    
    if([self.tableViews indexOfObject:tableView] == 0)
    {
        item = self.dataSource[indexPath.row];
        
        self.ProvinceId = item.areaId;
        
        // 请求市一级的数据
        [self requestCityLevelDataFromeServer:item.areaId];
    }
    else if ([self.tableViews indexOfObject:tableView] == 1)
    {
        item = self.cityDataSouce[indexPath.row];
        
        self.CityId = item.areaId;
        
         // 请求县一级的数据
        [self requestDistrictLevelDataFromeServer:item.areaId];
    }
    else if ([self.tableViews indexOfObject:tableView] == 2)
    {
        item = self.districtDataSouce[indexPath.row];
        
        self.AreaId = item.areaId;
    }
    
    item.isSelected = YES;
    
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    
    [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{

    HSQAdressListModel * item;
    
    if([self.tableViews indexOfObject:tableView] == 0)
    {
        item = self.dataSource[indexPath.row];
    }
    else if ([self.tableViews indexOfObject:tableView] == 1)
    {
        item = self.cityDataSouce[indexPath.row];
    }
    else if ([self.tableViews indexOfObject:tableView] == 2)
    {
        item = self.districtDataSouce[indexPath.row];
    }
    
    item.isSelected = NO;
    
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];

}

#pragma mark - <UIScrollView>
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    if(scrollView != self.contentView) return;
    
    __weak typeof(self)weakSelf = self;
    
    [UIView animateWithDuration:0.25 animations:^{
        
        NSInteger index = scrollView.contentOffset.x / KScreenWidth;
        
        UIButton * btn = weakSelf.topTabbarItems[index];
        
        [weakSelf changeUnderLineFrame:btn];
    }];
}

//当重新选择省或者市的时候，需要将下级视图移除。
- (void)removeLastItem{
    
    [self.tableViews.lastObject performSelector:@selector(removeFromSuperview) withObject:nil withObject:nil];
    [self.tableViews removeLastObject];

    [self.topTabbarItems.lastObject performSelector:@selector(removeFromSuperview) withObject:nil withObject:nil];
    [self.topTabbarItems removeLastObject];
}

//完成地址选择,执行chooseFinish代码块
- (void)setUpAddress:(NSString *)address addressProvinceId:(NSString *)ProvinceId addressCityId:(NSString *)CityId addressAreaId:(NSString *)AreaId{
    
    NSInteger index = self.contentView.contentOffset.x / KScreenWidth;
    
    UIButton * btn = self.topTabbarItems[index];
    
    [btn setTitle:address forState:UIControlStateNormal];
    
    [btn sizeToFit];
    
    [self.TopBarView layoutIfNeeded];
    
    [self changeUnderLineFrame:btn];
    
    NSMutableString * addressStr = [[NSMutableString alloc] init];
    
    for (UIButton * btn  in self.topTabbarItems) {
        
        if ([btn.currentTitle isEqualToString:@"县"] || [btn.currentTitle isEqualToString:@"市辖区"] ) {
            continue;
        }
        
        [addressStr appendString:btn.currentTitle];
        
        [addressStr appendString:@" "];
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        self.hidden = YES;
        
       __weak typeof(self) weakself = self;
        
        if (self.chooseFinish) {
            
            self.chooseFinish(addressStr,weakself.ProvinceId,weakself.CityId,weakself.AreaId);
        }
    });
}

//滚动到下级界面,并重新设置顶部按钮条上对应按钮的title
- (void)scrollToNextItem:(NSString *)preTitle{
    
    NSInteger index = self.contentView.contentOffset.x / KScreenWidth;
    
    UIButton * btn = self.topTabbarItems[index];
    
    [btn setTitle:preTitle forState:UIControlStateNormal];
    
    [btn sizeToFit];
    
    [self.TopBarView layoutIfNeeded];
    
    [UIView animateWithDuration:0.25 animations:^{
        
        self.contentView.contentSize = (CGSize){self.tableViews.count * KScreenWidth,0};
        
        CGPoint offset = self.contentView.contentOffset;
        
        self.contentView.contentOffset = CGPointMake(offset.x + KScreenWidth, offset.y);
        
        [self changeUnderLineFrame: [self.TopBarView.subviews lastObject]];
    }];
}


















- (void)setPlacherString:(NSString *)placherString{
    
    _placherString = placherString;
    
    self.placher_Label.text = placherString;
}





















/** 点击背景按钮的点击事件*/
- (void)btnClickAction:(UIButton *)sender{
    
//    [self dismissAdressView];
    
    UITableView *table = (UITableView *)self.tableViews[0];
    
    [table reloadData];
}

/**
 * @brief 显示视图
 */
- (void)ShowAdressView{
    
    [UIView animateWithDuration:0.25 animations:^{
        
        self.BgView.frame = ({
            
            CGRect frame = self.BgView.frame;
            
            frame.origin.y = KScreenHeight / 2;
            
            frame;
        });
    }];
}

/**
 * @brief 隐藏视图
 */
- (void)dismissAdressView{
    
    [UIView animateWithDuration:0.25 animations:^{
        
        self.BgView.frame = ({
            
            CGRect frame = self.BgView.frame;
            
            frame.origin.y = KScreenHeight;
            
            frame;
        });
    }completion:^(BOOL finished) {
        
        [self.BgView removeFromSuperview];
        
        [self removeFromSuperview];
    }];
}





@end
