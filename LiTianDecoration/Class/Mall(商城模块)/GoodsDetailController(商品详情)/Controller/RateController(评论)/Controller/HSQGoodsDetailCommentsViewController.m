//
//  HSQGoodsDetailCommentsViewController.m
//  LiTianDecoration
//
//  Created by administrator on 2018/5/11.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import "HSQGoodsDetailCommentsViewController.h"
#import "HSQGoodsRateFootCollectionReusableView.h"
#import "HSQGoodsRateHeadCollectionReusableView.h"
#import "HSQGoodsRateListModel.h"
#import "HSQGoodsRateListCollectionViewCell.h"
#import "HSQGoodsRateListFrameModel.h"

@interface HSQGoodsDetailCommentsViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UIButton *AllRate_Button; // 全部评价

@property (weak, nonatomic) IBOutlet UIButton *GoodsRate_Button; // 好评

@property (weak, nonatomic) IBOutlet UIButton *ZhongRate_Button; // 中评

@property (weak, nonatomic) IBOutlet UIButton *BadRate_Button; // 差评

@property (weak, nonatomic) IBOutlet UIButton *RateImage_Button; // 晒图

@property (weak, nonatomic) UIButton *Select_Button;

@property (strong, nonatomic) NSMutableArray *dataSource;

@property (strong, nonatomic) NSMutableArray *GoodsRateTypeSource;

@property (strong, nonatomic) UICollectionView *collectionView;

@property (assign, nonatomic) NSInteger CurrentPage;

@property (copy, nonatomic) NSString *evalLv; // 1好评 2中评 3差评 4有图 all全部

@property (nonatomic, copy) NSString *totalPage;  // 总页数

@property (nonatomic, strong) HSQNoDataView *NoDataView; // 空界面

@end

@implementation HSQGoodsDetailCommentsViewController

-(NSMutableArray *)dataSource{
    
    if (_dataSource == nil) {
        
        self.dataSource = [NSMutableArray array];
    }
    
    return _dataSource;
}

- (NSMutableArray *)GoodsRateTypeSource{
    
    if (_GoodsRateTypeSource == nil) {
        
        self.GoodsRateTypeSource = [NSMutableArray arrayWithObjects:@"all",@"1",@"2",@"3",@"4", nil];
    }
    
    return _GoodsRateTypeSource;
}

-(HSQNoDataView *)NoDataView{
    
    if (_NoDataView == nil) {
        
        self.NoDataView = [[HSQNoDataView alloc] initWithTitle:@"亲，该商品没有相应的评价哦~" imageName:@"3-1P106112Q1-51" height:50 TopMargin:0];
        
    }
    
    return _NoDataView;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.view.backgroundColor = KViewBackGroupColor;
    
    [self TopRateButtonClickAction:self.AllRate_Button];
    
    // 设置顶部评论按钮的属性
    [self SetThePropertiesOfTheTopButton];
    
    // 按钮赋值
    [self ButtonSetValue];
    
    // 添加集合视图
    [self AddCollectionView];
    
    // 请求评论数据
    [self AddRateRefuentView];
}

- (void)setDataDiction:(NSDictionary *)dataDiction{
    
    _dataDiction = dataDiction;
}

/**
 * @brief 设置顶部按钮的属性
 */
- (void)SetThePropertiesOfTheTopButton{
    
    self.AllRate_Button.titleLabel.numberOfLines =self.GoodsRate_Button.titleLabel.numberOfLines =  self.ZhongRate_Button.titleLabel.numberOfLines = 0;
    
    self.BadRate_Button.titleLabel.numberOfLines = self.RateImage_Button.titleLabel.numberOfLines = 0;
    
    self.AllRate_Button.titleLabel.textAlignment = self.GoodsRate_Button.titleLabel.textAlignment = self.ZhongRate_Button.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    self.BadRate_Button.titleLabel.textAlignment = self.RateImage_Button.titleLabel.textAlignment = NSTextAlignmentCenter;
}

/**
 * @brief 按钮赋值
 */
- (void)ButtonSetValue{
    
    // 全部评论
    NSString *AllRateCount = [NSString stringWithFormat:@"全部评价\n%@",self.dataDiction[@"evaluateGoodsTotal"]];
    [self.AllRate_Button setTitle:AllRateCount forState:(UIControlStateNormal)];
    [self.AllRate_Button setTitle:AllRateCount forState:(UIControlStateDisabled)];
    
    // 好评
    NSString *GoodsRateCount = [NSString stringWithFormat:@"好评\n%@",self.dataDiction[@"evaluateCount"][@"1"]];
    [self.GoodsRate_Button setTitle:GoodsRateCount forState:(UIControlStateNormal)];
    [self.GoodsRate_Button setTitle:GoodsRateCount forState:(UIControlStateDisabled)];
    
    // 中评
    NSString *ZhongRateCount = [NSString stringWithFormat:@"中评\n%@",self.dataDiction[@"evaluateCount"][@"2"]];
    [self.ZhongRate_Button setTitle:ZhongRateCount forState:(UIControlStateNormal)];
    [self.ZhongRate_Button setTitle:ZhongRateCount forState:(UIControlStateDisabled)];
    
    // 差评
    NSString *BadRateCount = [NSString stringWithFormat:@"差评\n%@",self.dataDiction[@"evaluateCount"][@"3"]];
    [self.BadRate_Button setTitle:BadRateCount forState:(UIControlStateNormal)];
    [self.BadRate_Button setTitle:BadRateCount forState:(UIControlStateDisabled)];
    
    // 晒图
    NSString *RateImageCount = [NSString stringWithFormat:@"晒图\n%@",self.dataDiction[@"evaluateCount"][@"4"]];
    [self.RateImage_Button setTitle:RateImageCount forState:(UIControlStateNormal)];
    [self.RateImage_Button setTitle:RateImageCount forState:(UIControlStateDisabled)];

}

/**
 * @brief 顶部按钮的点击事件
 */
- (IBAction)TopRateButtonClickAction:(UIButton *)sender {
    
    self.Select_Button.enabled = YES;
    
    sender.enabled = NO;
    
    self.Select_Button = sender;
    
    self.evalLv = self.GoodsRateTypeSource[sender.tag];
    
    [self.collectionView.mj_header beginRefreshing];
}

/**
 * @brief 添加评论的刷新控件
 */
- (void)AddRateRefuentView{
    
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(LoadNewGoodsRateDataFromeServer)];
    
    self.collectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(LoadMoreGoodsRateDataFromeServer)];
    
    self.collectionView.mj_header.automaticallyChangeAlpha = YES;
    
    [self.collectionView.mj_header beginRefreshing];
    
}

/**
 * @brief 加载最新的商品评论
 */
- (void)LoadNewGoodsRateDataFromeServer{
    
    [self.collectionView.mj_footer endRefreshing];
    
    [self.dataSource removeAllObjects];
    
    self.CurrentPage = 1;
    
    NSDictionary *params = @{@"page":@(self.CurrentPage),@"commonId":self.commonId,@"evalLv":self.evalLv};
    
    [[HSQProgressHUDManger Manger] ShowLoadingDataFromeServer:@"" ToView:self.view IsClearColor:YES];
    
    AFNetworkRequestTool *requestTool = [AFNetworkRequestTool shareRequestTool];
    
    [requestTool.manger GET:UrlAdress(KGoodsRateListUrl) parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
    
        HSQLog(@"===%@",responseObject);
        
        [[HSQProgressHUDManger Manger] DismissProgressHUD];
        
        // 总页数
        self.totalPage = [NSString stringWithFormat:@"%@",responseObject[@"datas"][@"pageEntity"][@"totalPage"]];
        
        NSArray *array = responseObject[@"datas"][@"evaluateGoodsVoList"];
        
        if ([responseObject[@"code"] integerValue] == 200)
        {
            if (array.count != 0)
            {
                NSArray *ModelArray = [HSQGoodsRateListModel mj_objectArrayWithKeyValuesArray:array];
                
                NSArray *NewArray = [self stausFramesWithStatuses:ModelArray];
                
                [self.dataSource addObjectsFromArray:NewArray];
            }
            else
            {
                [self.collectionView addSubview:self.NoDataView];
            }
        }
        else
        {
            [self.collectionView addSubview:self.NoDataView];
        }
        
        [self.collectionView.mj_header endRefreshing];
        
        [self.collectionView reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [self.collectionView.mj_header endRefreshing];
        
        [self.collectionView addSubview:self.NoDataView];
        
        [[HSQProgressHUDManger Manger] ShowDisplayFailedToLoadData:KErrorPlacherString SuperView:self.view];
        
    }];
    
}

/**
 * @brief 加载更多的商品评论
 */
- (void)LoadMoreGoodsRateDataFromeServer{
    
    [self.collectionView.mj_header endRefreshing];
    
    if ( self.totalPage.integerValue == self.CurrentPage || self.totalPage.integerValue == 0)
    {
        [self.collectionView.mj_footer endRefreshingWithNoMoreData];
    }
    else
    {
        NSDictionary *params = @{@"page":@(++self.CurrentPage),@"commonId":self.commonId,@"evalLv":self.evalLv};
        
        [[HSQProgressHUDManger Manger] ShowLoadingDataFromeServer:@"" ToView:self.view IsClearColor:YES];
        
        AFNetworkRequestTool *requestTool = [AFNetworkRequestTool shareRequestTool];
        
        [requestTool.manger GET:UrlAdress(KGoodsRateListUrl) parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            HSQLog(@"===%@",responseObject);
            
            [[HSQProgressHUDManger Manger] DismissProgressHUD];
            
            if ([responseObject[@"code"] integerValue] == 200)
            {
                // 1.字典转模型
                NSArray *array1 = [HSQGoodsRateListModel mj_objectArrayWithKeyValuesArray:responseObject[@"datas"][@"evaluateGoodsVoList"]];
                
                NSArray *NewArray = [self stausFramesWithStatuses:array1];
                
                 [self.dataSource addObjectsFromArray:NewArray];
                
                // 3,停止加载
                [self.collectionView.mj_footer endRefreshing];
            }
            else
            {
                [self.collectionView.mj_footer endRefreshingWithNoMoreData];
            }
            
            [self.collectionView reloadData];
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            [self.collectionView.mj_footer endRefreshing];
            
            [[HSQProgressHUDManger Manger] ShowDisplayFailedToLoadData:KErrorPlacherString SuperView:self.view];
            
        }];
    }
}


/**
 *  将HWStatus模型转为HWStatusFrame模型
 */
- (NSArray *)stausFramesWithStatuses:(NSArray *)statuses{
    
    NSMutableArray *frames = [NSMutableArray array];
    
    for (HSQGoodsRateListModel *status in statuses) {
        
        HSQGoodsRateListFrameModel *frame = [[HSQGoodsRateListFrameModel alloc] init];
        
        frame.model = status;
        
        [frames addObject:frame];
    }
    return frames;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 创建集合视图
- (void)AddCollectionView{
    
    UICollectionViewFlowLayout *Layout = [[UICollectionViewFlowLayout alloc] init];
    
    Layout.minimumLineSpacing = 1;  // 最小的行间距
    
    Layout.minimumInteritemSpacing = 1; // 最小的列间距
    
    CGFloat collectionHeight = KScreenHeight - KSafeBottomHeight - KSafeTopeHeight - 50 - 50;
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 50, KScreenWidth, collectionHeight) collectionViewLayout:Layout];
    
    collectionView.backgroundColor = [UIColor clearColor];
    
    collectionView.dataSource = self;
    
    collectionView.delegate = self;
    
    collectionView.showsVerticalScrollIndicator = NO;
    
    collectionView.showsHorizontalScrollIndicator = NO;
    
    [collectionView registerClass:[HSQGoodsRateHeadCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HSQGoodsRateHeadCollectionReusableView"];
    
    [collectionView registerClass:[HSQGoodsRateFootCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"HSQGoodsRateFootCollectionReusableView"];
        
    [collectionView registerClass:[HSQGoodsRateListCollectionViewCell class] forCellWithReuseIdentifier:@"HSQGoodsRateListCollectionViewCell"];
    
    [self.view addSubview:collectionView];
    
    [self.view sendSubviewToBack:collectionView];
    
    self.collectionView = collectionView;
}

#pragma mark - UICollectionViewDelegate,UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    if (self.totalPage.integerValue == self.CurrentPage || self.totalPage.integerValue == 0)
    {
        self.collectionView.mj_footer.hidden = YES;
    }
    else
    {
        self.collectionView.mj_footer.hidden = NO;
    }
    
    self.NoDataView.hidden = (self.dataSource.count != 0);
    
    return self.dataSource.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return 1;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    
    return CGSizeMake(KScreenWidth, 85);
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    
    HSQGoodsRateListFrameModel *model = self.dataSource[section];
    
    return CGSizeMake(KScreenWidth, model.FooterViewHeight);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionReusableView *reusableView = nil;
    
    if (kind == UICollectionElementKindSectionHeader)
    {
        HSQGoodsRateHeadCollectionReusableView *headView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HSQGoodsRateHeadCollectionReusableView" forIndexPath:indexPath];
        
        if (self.dataSource.count != 0)
        {
            headView.FrameModel = self.dataSource[indexPath.section];
        }
        
        reusableView = headView;
    }
    if (kind == UICollectionElementKindSectionFooter)
    {
        HSQGoodsRateFootCollectionReusableView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"HSQGoodsRateFootCollectionReusableView" forIndexPath:indexPath];
        
        if (self.dataSource.count != 0)
        {
            footerView.FrameModel = self.dataSource[indexPath.section];
        }
        
        reusableView = footerView;
    }
    return reusableView;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    HSQGoodsRateListFrameModel *FrameModel = self.dataSource[indexPath.section];
    
    HSQLog(@"===cellde高低压==%f",FrameModel.CellHeight);
    
    return CGSizeMake(KScreenWidth, FrameModel.CellHeight);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
        
    HSQGoodsRateListCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HSQGoodsRateListCollectionViewCell" forIndexPath:indexPath];

    if (self.dataSource.count != 0)
    {
        cell.FrameModel = self.dataSource[indexPath.section];
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
}








@end
