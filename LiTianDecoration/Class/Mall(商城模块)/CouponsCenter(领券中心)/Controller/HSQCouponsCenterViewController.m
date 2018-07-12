//
//  HSQCouponsCenterViewController.m
//  LiTianDecoration
//
//  Created by administrator on 2018/5/9.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import "HSQCouponsCenterViewController.h"
#import "HSQVoucherTemplateListCell.h"
#import "HSQStoreClassListHeadView.h"
#import "HSQAccountTool.h"
#import "HSQStoreClassListModel.h"
#import "HSQVoucherTemplateListModel.h"
#import "HSQStoreDetailViewController.h"
#import "HSQLoginHomeViewController.h"
#import "HSQNoDataShowCell.h"

@interface HSQCouponsCenterViewController ()<UITableViewDelegate,UITableViewDataSource,HSQStoreClassListHeadViewDelelgate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, strong) NSMutableArray *storeClassList;

@property (nonatomic, assign) NSInteger currentPage; // 当前的页数

@property (nonatomic, copy) NSString *totalPage; // 总页数

@property (nonatomic, strong) HSQNoDataView *noDataView;

@property (nonatomic, copy) NSString *StoreClass_id;

@property (nonatomic, strong) UIImageView *Head_ImageView;

@property (nonatomic, strong) NSDictionary *webSliderJson;

@end

@implementation HSQCouponsCenterViewController

-(NSMutableArray *)dataSource{
    
    if (_dataSource == nil) {
        
        self.dataSource = [NSMutableArray array];
    }
    
    return _dataSource;
}

-(NSMutableArray *)storeClassList{
    
    if (_storeClassList == nil) {
        
        self.storeClassList = [NSMutableArray array];
    }
    
    return _storeClassList;
}

- (HSQNoDataView *)noDataView{
    
    if (!_noDataView) {
        
        _noDataView = [[HSQNoDataView alloc] initWithTitle:@"亲，还没有相关的数据额" imageName:@"WaitingForView" height:50 TopMargin:0];
    }
    return _noDataView;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.view.backgroundColor = KViewBackGroupColor;
    
    self.navigationItem.title = @"领券中心";
    
    self.webSliderJson = [NSDictionary dictionary];
    
    self.currentPage = 1;
    
    // 创建tableView
    [self CreatTableView];
    
    // 加载领券中心首页的数据
    [self LoadTheDataOnTheFrontPageOfTheCouponCenter];
    
    // 添加刷新的视图
    [self AddHeadTableViewRefView];
    
    // 监听用户的登录
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(UserLoginSuccessNotif:) name:@"UserDidLoginSuccessNotif" object:nil];
}

/**
 * @brief 创建tableView
 */
- (void)CreatTableView{
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - KSafeTopeHeight - KSafeBottomHeight) style:(UITableViewStylePlain)];
    
    tableView.backgroundColor = [UIColor clearColor];
    
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    tableView.delegate = self;
    
    tableView.dataSource = self;
    
    [tableView registerNib:[UINib nibWithNibName:@"HSQVoucherTemplateListCell" bundle:nil] forCellReuseIdentifier:@"HSQVoucherTemplateListCell"];
    
    [tableView registerClass:[HSQStoreClassListHeadView class] forHeaderFooterViewReuseIdentifier:@"HSQStoreClassListHeadView"];
        
    [tableView registerNib:[UINib nibWithNibName:@"HSQNoDataShowCell" bundle:nil] forCellReuseIdentifier:@"HSQNoDataShowCell"];
    
    [self.view addSubview:tableView];
    
    self.tableView = tableView;
    
    // 头部的图片
    UIImageView *Head_ImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, (KScreenWidth * 30) / 64)];
    
    Head_ImageView.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *TapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(TapGRClickAction:)];
    
    [Head_ImageView addGestureRecognizer:TapGR];
    
    self.tableView.tableHeaderView = Head_ImageView;
    
    self.Head_ImageView = Head_ImageView;
}

/**
 * @brief 加载领券中心首页的数据
 */
- (void)LoadTheDataOnTheFrontPageOfTheCouponCenter{
    
    [[HSQProgressHUDManger Manger] ShowLoadingDataFromeServer:@"" ToView:self.view IsClearColor:YES];
    
    AFNetworkRequestTool *RequestTool = [AFNetworkRequestTool shareRequestTool];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    NSString *token = [HSQAccountTool account].token;
    
    params[@"token"] = (token.length == 0 ? @"": token);
    
    [RequestTool.manger GET:UrlAdress(KvoucheHomeUrl) parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [[HSQProgressHUDManger Manger] DismissProgressHUD];
        
        HSQLog(@"=领券中心活动==%@",responseObject);
        
         self.totalPage = [NSString stringWithFormat:@"%@",responseObject[@"datas"][@"pageEntity"][@"totalPage"]];
        
        if ([responseObject[@"code"] integerValue] == 200)
        {
            // 店铺的分类
            self.storeClassList = [HSQStoreClassListModel mj_objectArrayWithKeyValuesArray:responseObject[@"datas"][@"storeClassList"]];
            
            HSQStoreClassListModel *model = self.storeClassList.firstObject;
            
            self.StoreClass_id = model.StoreClass_id;
            
            // 优惠券
            self.dataSource = [HSQVoucherTemplateListModel mj_objectArrayWithKeyValuesArray:responseObject[@"datas"][@"voucherTemplateList"]];
            
            // 头部的图片视图
            NSString *voucherCenterWap = [NSString stringWithFormat:@"%@",responseObject[@"datas"][@"voucherCenterWap"][@"webSliderJson"]];
            
            self.webSliderJson = [self dictionaryWithJsonString:voucherCenterWap];
            
            NSString *image = [NSString stringWithFormat:@"/%@",self.webSliderJson[@"image"]];
            
            HSQLog(@"===image=%@===%@",image,self.webSliderJson);
            
            [self.Head_ImageView sd_setImageWithURL:[NSURL URLWithString:UrlAdress(image)] placeholderImage:KGoodsPlacherImage];
        }
        else
        {
            NSString *message = [NSString stringWithFormat:@"%@",responseObject[@"datas"][@"error"]];
            
            [[HSQProgressHUDManger Manger] ShowDisplayFailedToLoadData:message SuperView:self.view];
        }
        
        [self.tableView reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [[HSQProgressHUDManger Manger] ShowDisplayFailedToLoadData:KErrorPlacherString SuperView:self.view];
    }];
}

/**
 * @brief 添加刷新的视图
 */
- (void)AddHeadTableViewRefView{
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(LoadNewCouponeListDataFromeServer)];
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(LoadMoreCouponeListDataFromeServer)];
}

/**
 * @brief 1.请求优惠券列表的数据
 */
- (void)LoadNewCouponeListDataFromeServer{
    
    self.currentPage = 1;
    
    [self.tableView.mj_footer endRefreshing];
    
    [self.dataSource removeAllObjects];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    params[@"page"] = @(self.currentPage);
    
     params[@"storeClassId"] = self.StoreClass_id;
    
    NSString *token = [HSQAccountTool account].token;
    
    params[@"token"] = (token.length == 0 ? @"": token);
    
    [[HSQProgressHUDManger Manger] ShowLoadingDataFromeServer:@"" ToView:self.view IsClearColor:YES];
    
    AFNetworkRequestTool *RequestTool = [AFNetworkRequestTool shareRequestTool];
    
    [RequestTool.manger POST:UrlAdress(KvouchListUrl) parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *responseObject) {
        
        [[HSQProgressHUDManger Manger] DismissProgressHUD];
        
        self.totalPage = [NSString stringWithFormat:@"%@",responseObject[@"datas"][@"pageEntity"][@"totalPage"]];
        
        HSQLog(@"=优惠券的数据==%@",responseObject);
        
        if ([responseObject[@"code"] integerValue] == 200)
        {
            if ([[responseObject allKeys] containsObject:@"datas"])
            {
                self.totalPage = [NSString stringWithFormat:@"%@",responseObject[@"datas"][@"pageEntity"][@"totalPage"]];
                
                self.dataSource = [HSQVoucherTemplateListModel mj_objectArrayWithKeyValuesArray:responseObject[@"datas"][@"voucherTemplateList"]];
            }
        }
        else
        {
            NSString *errorString = [NSString stringWithFormat:@"%@",responseObject[@"datas"][@"error"]];
            
            [[HSQProgressHUDManger Manger] ShowDisplayFailedToLoadData:errorString SuperView:self.view];
        }
        
        [self.tableView.mj_header endRefreshing];
        
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:(UITableViewRowAnimationNone)];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [self.tableView.mj_header endRefreshing];
        
        [[HSQProgressHUDManger Manger] ShowDisplayFailedToLoadData:KErrorPlacherString SuperView:self.view];
        
    }];
}

/**
 * @brief 2.请求更多的优惠券列表的数据
 */
- (void)LoadMoreCouponeListDataFromeServer{
    
    // 结束下拉
    [self.tableView.mj_header endRefreshing];
    
    [[HSQProgressHUDManger Manger] ShowLoadingDataFromeServer:@"" ToView:self.view IsClearColor:YES];
    
    AFNetworkRequestTool *RequestTool = [AFNetworkRequestTool shareRequestTool];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    params[@"page"] = @(++self.currentPage);
    
     params[@"storeClassId"] = self.StoreClass_id;
    
    NSString *token = [HSQAccountTool account].token;
    
    params[@"token"] = (token.length == 0 ? @"": token);
    
    [RequestTool.manger POST:UrlAdress(KvouchListUrl) parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        HSQLog(@"加载更多%@",[NSString stringWithFormat:@"%@",responseObject]);
        
        [[HSQProgressHUDManger Manger] DismissProgressHUD];
        
        if ([responseObject[@"code"] integerValue] == 200)
        {
            if ([[responseObject allKeys] containsObject:@"datas"])
            {
                // 1.字典转模型
                NSArray *array1 =  [HSQVoucherTemplateListModel mj_objectArrayWithKeyValuesArray:responseObject[@"datas"][@"voucherTemplateList"]];
                
                [self.dataSource addObjectsFromArray:array1];
                
                // 3,停止加载
                [self.tableView.mj_footer endRefreshing];
            }
            else
            {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
        }
        else
        {
            // 3,停止加载
            [self.tableView.mj_footer endRefreshing];
        }
        
        // 2.刷新数据
         [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:(UITableViewRowAnimationNone)];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        // 结束刷新
        [self.tableView.mj_footer endRefreshing];
        
        [[HSQProgressHUDManger Manger] ShowDisplayFailedToLoadData:KErrorPlacherString SuperView:self.view];
        
    }];
}

/**
 * @brief 监听用户的登录
 */
- (void)UserLoginSuccessNotif:(NSNotification *)notif{
    
    [self LoadTheDataOnTheFrontPageOfTheCouponCenter];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (self.currentPage == self.totalPage.integerValue || self.totalPage.integerValue == 0)
    {
        self.tableView.mj_footer.hidden = YES;
    }
    else
    {
        self.tableView.mj_footer.hidden = NO;
    }
    
    self.noDataView.hidden = (self.dataSource.count != 0);
    
    if (section == 0)
    {
        return 0;
    }
    else
    {
        return (self.dataSource.count == 0 ? 1 : self.dataSource.count);
    }
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section{
    
    return (section == 0 ? 50 : 0);
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return (section == 0 ? 50 : 0);
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (section == 0)
    {
        HSQStoreClassListHeadView *HeadView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"HSQStoreClassListHeadView"];
        
        HeadView.storeClassList = self.storeClassList;
        
        HeadView.delegate = self;
        
        return HeadView;
    }
    else
    {
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return (self.dataSource.count == 0 ? KScreenHeight - KSafeTopeHeight - KSafeBottomHeight - 50 - (KScreenWidth * 30) / 64: 80);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
   return (self.dataSource.count == 0 ? KScreenHeight - KSafeTopeHeight - KSafeBottomHeight - 50 - (KScreenWidth * 30) / 64: 80);
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.dataSource.count == 0)
    {
        HSQNoDataShowCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HSQNoDataShowCell" forIndexPath:indexPath];
        
        cell.Placher_Label.text = @"亲，暂无可领取的优惠券额";
        
        cell.Placher_ImageView.image = KImageName(@"WaitingForView");
        
        return cell;
    }
    else
    {
        HSQVoucherTemplateListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HSQVoucherTemplateListCell" forIndexPath:indexPath];
        
        cell.model = self.dataSource[indexPath.row];
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    NSString *token = [HSQAccountTool account].token;
    
    if (token.length == 0)
    {
        HSQLoginHomeViewController *LoginVC = [[HSQLoginHomeViewController alloc] init];
        
        [self.navigationController pushViewController:LoginVC animated:YES];
    }
    else
    {
        HSQVoucherTemplateListModel *model = self.dataSource[indexPath.row];
        
        if (model.memberIsReceive.integerValue == 0) // 0未领完，1已领完
       {
           [self NotifyTheServerToCollectCoupons:model];
        }
        else
        {
            HSQStoreDetailViewController *StoreDetailVC = [[HSQStoreDetailViewController alloc] init];
            
            StoreDetailVC.storeId = model.storeId;
            
            [self.navigationController pushViewController:StoreDetailVC animated:YES];
        }
    }
}

/**
 * @brief 领取优惠券
 */
- (void)NotifyTheServerToCollectCoupons:(HSQVoucherTemplateListModel *)model{
    
    [[HSQProgressHUDManger Manger] ShowLoadingDataFromeServer:@"" ToView:self.view IsClearColor:YES];
    
    NSDictionary *params = @{@"token":[HSQAccountTool account].token,@"templateId":model.templateId};
    
    AFNetworkRequestTool *requestTool = [AFNetworkRequestTool shareRequestTool];
    
    [requestTool.manger POST:UrlAdress(KfreeGetCouponsUrl) parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        HSQLog(@"==领取优惠券==%@===",responseObject);
        
        [[HSQProgressHUDManger Manger] DismissProgressHUD];
        
        if ([responseObject[@"code"] integerValue] == 200)
        {
            model.memberIsReceive = @"1";
            
            [[HSQProgressHUDManger Manger] ShowProgressHUDPromptText:@"领取成功" SupView:self.view];
            
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:(UITableViewRowAnimationNone)];
        }
        else
        {
            NSString *errorString = [NSString stringWithFormat:@"%@",responseObject[@"datas"][@"error"]];
            
            [[HSQProgressHUDManger Manger] ShowDisplayFailedToLoadData:errorString SuperView:self.view];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [[HSQProgressHUDManger Manger] ShowProgressHUDPromptText:KErrorPlacherString SupView:self.view];
        
    }];
}

/**
 * @brief 头部分类的点击
 */
- (void)StoreClassBtnClickAction:(UIButton *)sender{
    
    HSQStoreClassListModel *model = self.storeClassList[sender.tag];
        
    self.StoreClass_id = model.StoreClass_id;
    
    [self LoadNewCouponeListDataFromeServer];
}

/**
 * @brief 头部图片的点击
 */
- (void)TapGRClickAction:(UITapGestureRecognizer *)tap{
    
    HSQLog(@"=====%@=====%@===%ld",self.webSliderJson[@"linkType"],self.totalPage,(long)self.currentPage);
}

/**
 * @brief 将Json字符串转化为字典
 */
- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString{
    
    if (jsonString == nil)
    {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError *err;
    
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers  error:&err];
    
    if(err)
    {
        NSLog(@"json解析失败：%@",err);
        
        return nil;
    }
    return dic;
}












@end
