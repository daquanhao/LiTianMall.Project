//
//  HSQClassGoodsListViewController.m
//  LiTianDecoration
//
//  Created by administrator on 2018/4/30.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import "HSQClassGoodsListViewController.h"
#import "HSQScreeningViewController.h"
#import "HSQClassSecondGoodsListCell.h"
#import "HSQDropdownMenuView.h"
#import "HSQGoodsDataListModel.h"
#import "HSQStoreDetailViewController.h"

@interface HSQClassGoodsListViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,HSQDropdownMenuViewDelegate,HSQClassSecondGoodsListCellDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic,strong) NSMutableArray *dataSource;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ViewHeight;

@property (weak, nonatomic) IBOutlet UIButton *ComprehensiveBtn;  // 综合按钮

@property (weak, nonatomic) IBOutlet UIButton *XiaoLiang_Btn;  // 销量

@property (weak, nonatomic) IBOutlet UIButton *Price_Btn;

@property (nonatomic, strong) HSQDropdownMenuView *bgView;

@property (nonatomic, copy) NSString *IsSelectString;

@property (nonatomic, copy) NSString *SelectIndex;

@property (nonatomic, assign) BOOL isGrid;

@property (nonatomic, assign) NSInteger currentPage; // 当前的页数

@property (nonatomic, strong) HSQNoDataView *noDataView;

@property (nonatomic, copy) NSString *totalPage; // 总页数

// 综合排序：空或不传；销量优先：sale_desc；价格从高到低：price_desc；价格从低到高：price_asc；人 气：comment_desc ; commission_desc:佣金比例高到低；diffusion_desc：推广量高到底；commission_desc：支出佣金高到底)
@property (nonatomic, copy) NSString *sort; // 排列方式

// 自营店铺-1 非自营店铺-0
@property (nonatomic, copy) NSString *own;

// 价格区间 0-0，必须以-为连接符
@property (nonatomic, copy) NSString *price;

// 促销类型(限时折扣：1)
@property (nonatomic, copy) NSString *promotion;

// 起批量
@property (nonatomic, copy) NSString *batch;

// 分类id
@property (nonatomic, copy) NSString *cat;

// 品牌id(多个用‘,’隔开，如：1,2,3,4,5。最多选择五个)
@property (nonatomic, copy) NSString *brand;

// 属性（形式“attributeId-attributeValueId:attributeValueId,attributeId- attributeValueId:attributeValueId”。每个属性的属性值最多选择五个
@property (nonatomic, copy) NSString *attr;

//  包邮-1 全部-0
@property (nonatomic, copy) NSString *express;

// 优惠券-1 全部-0
@property (nonatomic, copy) NSString *voucher;

// 佣金比例 （形式“1-100”）
@property (nonatomic, copy) NSString *commission;

// 销量
@property (nonatomic, copy) NSString *sellNum;

// 赠品-1 全部-0
@property (nonatomic, copy) NSString *gift;

@end

@implementation HSQClassGoodsListViewController

-(NSMutableArray *)dataSource{
    
    if (_dataSource == nil) {
        
        self.dataSource = [NSMutableArray array];
    }
    
    return _dataSource;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.view.backgroundColor = KViewBackGroupColor;
    
    // 默认列表视图
    self.isGrid = YES;
    
    // 创建集合视图
    [self SetUpCollectionView];
    
    // 默认第一个被点击
    self.IsSelectString = self.SelectIndex =@"0";
    
    self.ComprehensiveBtn.selected = YES;
    
    // 添加菜单按钮
    [self addMenuView];
    
    // 搜索商品的数据
    [self RequestGoodsSearchData];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"布局" style:(UIBarButtonItemStylePlain) target:self action:@selector(RightItemClick:)];
    
    // 添加搜索视图
    [self AddSearchViewWithPlacher:self.SearchKeywords];

}

/**
 * @brief 请求店铺搜索数据
 */
- (void)RequestGoodsSearchData{
    
    // 1.下拉加载更多的数据
    self.collectionView.mj_header  = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(LoadNewSearchGoodsListData)];
    
    [self.collectionView.mj_header beginRefreshing];
    
    // 3.上啦加载更多的代码
    self.collectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(LoadMoreSearchGoodsListData)];
}

- (void)LoadNewSearchGoodsListData{
    
    [[HSQProgressHUDManger Manger] ShowLoadingDataFromeServer:@"" ToView:self.view IsClearColor:YES];
    
    // 0.清空数组
    [self.dataSource removeAllObjects];
    
    // 结束上啦
    [self.collectionView.mj_footer endRefreshing];
    
    self.currentPage = 1;
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"client"] = @"app";
    params[@"page"] =  @(self.currentPage);
    params[@"pageSize"] = @"20";
    params[@"keyword"] = self.SearchKeywords;
    params[@"sort"] = self.sort;
    params[@"own"] = self.own;
    params[@"price"] = self.price;
    params[@"promotion"] = self.promotion;
    params[@"batch"] = self.batch;
    params[@"cat"] = self.cat;
    params[@"brand"] = self.brand;
    params[@"attr"] = self.attr;
    params[@"express"] = self.express;
    params[@"voucher"] = self.voucher;
    params[@"commission"] = self.commission;
    params[@"sellNum"] = self.sellNum;
    params[@"gift"] = self.gift;
    
    AFNetworkRequestTool *requestTool = [AFNetworkRequestTool shareRequestTool];
    
    [requestTool.manger GET:UrlAdress(KGoodsSearchUrl) parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [[HSQProgressHUDManger Manger] DismissProgressHUD];
        
        HSQLog(@"===店铺搜索数据===%@",responseObject);
        
        self.totalPage = [NSString stringWithFormat:@"%@",responseObject[@"datas"][@"pageEntity"][@"totalPage"]];
        
        if ([responseObject[@"code"] integerValue] == 200)
        {
            NSArray *goodsList = responseObject[@"datas"][@"goodsList"];
            
            for (NSInteger i = 0 ; i < goodsList.count; i++) {
                
                NSDictionary *diction = goodsList[i];
                
                HSQGoodsDataListModel *model = [[HSQGoodsDataListModel alloc] init];
                
                model.isGrid = self.isGrid;
                
                model.IsOpen = 0;
                
                [model setValuesForKeysWithDictionary:diction];
                
                [self.dataSource addObject:model];
            }
        }
        else
        {
            NSString *errorString = [NSString stringWithFormat:@"%@",responseObject[@"datas"][@"error"]];
            
            [[HSQProgressHUDManger Manger] ShowDisplayFailedToLoadData:errorString SuperView:self.view];
        }
        
        if (self.dataSource.count == 0)
        {
            [self.collectionView addSubview:self.noDataView];
        }
        
        [self.collectionView.mj_header endRefreshing];
        
        [self.collectionView reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        // 结束刷新
        [self.collectionView.mj_header endRefreshing];
        
        [self.collectionView addSubview:self.noDataView];
        
        // 提示数据请求失败
        [[HSQProgressHUDManger Manger] ShowProgressHUDPromptText:KErrorPlacherString SupView:self.view];
    }];
}

- (void)LoadMoreSearchGoodsListData{
    
    [self.collectionView.mj_header endRefreshing];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"client"] = @"app";
    params[@"page"] =  @(++self.currentPage);
    params[@"pageSize"] = @"20";
    params[@"keyword"] = self.SearchKeywords;
    params[@"sort"] = self.sort;
    params[@"own"] = self.own;
    params[@"price"] = self.price;
    params[@"promotion"] = self.promotion;
    params[@"batch"] = self.batch;
    params[@"cat"] = self.cat;
    params[@"brand"] = self.brand;
    params[@"attr"] = self.attr;
    params[@"express"] = self.express;
    params[@"voucher"] = self.voucher;
    params[@"commission"] = self.commission;
    params[@"sellNum"] = self.sellNum;
    params[@"gift"] = self.gift;
    
    AFNetworkRequestTool *requestTool = [AFNetworkRequestTool shareRequestTool];
    
    [requestTool.manger GET:UrlAdress(KGoodsSearchUrl) parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [[HSQProgressHUDManger Manger] DismissProgressHUD];
        
        HSQLog(@"===加载更多商品数据===%@",responseObject);
        
        if ([responseObject[@"code"] integerValue] == 200)
        {
            NSArray *goodsList = responseObject[@"datas"][@"goodsList"];
            
            for (NSInteger i = 0 ; i < goodsList.count; i++) {
                
                NSDictionary *diction = goodsList[i];
                
                HSQGoodsDataListModel *model = [[HSQGoodsDataListModel alloc] init];
                
                model.isGrid = self.isGrid;
                
                model.IsOpen = 0;
                
                [model setValuesForKeysWithDictionary:diction];
                
                [self.dataSource addObject:model];
            }
        }
        else
        {
            NSString *errorString = [NSString stringWithFormat:@"%@",responseObject[@"datas"][@"error"]];
            
            [[HSQProgressHUDManger Manger] ShowDisplayFailedToLoadData:errorString SuperView:self.view];
        }
        
        [self.collectionView.mj_footer endRefreshing];
        
        [self.collectionView reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        // 结束刷新
        [self.collectionView.mj_footer endRefreshing];
        
        // 提示数据请求失败
        [[HSQProgressHUDManger Manger] ShowProgressHUDPromptText:KErrorPlacherString SupView:self.view];
    }];
}

/**
 * @brief 添加搜索视图
 */
- (void)AddSearchViewWithPlacher:(NSString *)keyword{
    
    UIButton *SearchBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    
    [SearchBtn setBackgroundImage:[UIImage ImageWithColor:RGB(234, 234, 234)] forState:(UIControlStateNormal)];
    
    SearchBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
    
    [SearchBtn setTitleColor:RGB(74, 74, 74) forState:(UIControlStateNormal)];
    
    [SearchBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
    
    [SearchBtn setImage:KImageName(@"6DE36884-837C-44C3-B808-CE7F7D8C4FFA") forState:(UIControlStateNormal)];
    
    [SearchBtn setTitle:keyword forState:(UIControlStateNormal)];
    
    SearchBtn.frame = CGRectMake(0, 0, KScreenWidth * 0.8, 35);
    
    SearchBtn.layer.cornerRadius = 5;
    
    SearchBtn.clipsToBounds = YES;
    
    [SearchBtn addTarget:self action:@selector(SearchBtnClickAction:) forControlEvents:(UIControlEventTouchUpInside)];
    
    self.navigationItem.titleView = SearchBtn;
}

/**
 * @brief 进入搜索界面
 */
- (void)SearchBtnClickAction:(UIButton *)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 * @brief 综合按钮的点击
 */
- (IBAction)ClickEventForTheHeadFilterButton:(UIButton *)sender {
    
    self.ComprehensiveBtn.selected = YES;
    
    [self.XiaoLiang_Btn setEnabled:YES];
    
    [self.Price_Btn setEnabled:YES];
    
     [self.Price_Btn setSelected:NO];
    
    // 显示筛选界面
    if (self.IsSelectString.integerValue == 0 || self.IsSelectString.integerValue == 1)
    {
        [self.bgView ShowMenuView];
        
        self.IsSelectString = @"2";
    }
    else
    {
        [self.bgView HiddenMenuView];
        
        self.IsSelectString = @"1";
    }
    
    self.bgView.SelectNumber = self.SelectIndex;
    
}

/**
 * @brief 销量的点击
 */
- (IBAction)ClickOnTheSalesButton:(UIButton *)sender {
    
    // 1.首先隐藏综合排序的界面
    [self.bgView HiddenMenuView];
    
    self.bgView.SelectNumber = @"0";
    
    self.IsSelectString = @"1";
    
    self.SelectIndex = @"0";
    
    self.ComprehensiveBtn.selected = NO;
    
    [self.Price_Btn setEnabled:YES];
    
    [self.Price_Btn setSelected:NO];
    
     [self.ComprehensiveBtn setTitle:@"综合" forState:(UIControlStateNormal)];
    
    // 2.修改按钮状态
    self.XiaoLiang_Btn.enabled = NO;
    
    self.sort = @"sale_desc";
    
    [self.collectionView.mj_header beginRefreshing];
}

/**
 * @brief 价格的点击
 */
- (IBAction)ClickOnPriceSort:(UIButton *)sender {
    
    // 1.首先隐藏综合排序的界面
    [self.bgView HiddenMenuView];
    
    self.bgView.SelectNumber = @"0";
    
    self.IsSelectString = @"1";
    
    self.SelectIndex = @"0";
    
    self.ComprehensiveBtn.selected = NO;
    
    [self.Price_Btn setEnabled:YES];
    
    [self.ComprehensiveBtn setTitle:@"综合" forState:(UIControlStateNormal)];
    
    // 2.修改按钮状态
    self.XiaoLiang_Btn.enabled = YES;
    
    [self.Price_Btn setSelected:YES];
    
    if ([self.sort isEqualToString:@"price_desc"]) // 价格从高到低
    {
        self.sort = @"price_asc"; // 价格从低到高
    }
    else
    {
         self.sort = @"price_desc";
    }
    
    [self.collectionView.mj_header beginRefreshing];
}

/**
 * @brief 筛选的点击
 */
- (IBAction)FilteredClickAction:(UIButton *)sender {
    
    HSQScreeningViewController *ScreeningVC = [[HSQScreeningViewController alloc] init];
    
    [self.navigationController pushViewController:ScreeningVC animated:YES];
}

/**
 * @brief 布局按钮的点击
 */
- (void)RightItemClick:(UIBarButtonItem *)sender{
    
    _isGrid = !_isGrid;
    
    for (HSQGoodsDataListModel *model in self.dataSource) {
        
        model.isGrid = _isGrid;
        
    }
    
    [self.collectionView reloadData];
    
    if (_isGrid)
    {
        //        [self.swithBtn setImage:[UIImage imageNamed:@"product_list_grid_btn"] forState:0];
    }
    else
    {
        //        [self.swithBtn setImage:[UIImage imageNamed:@"product_list_list_btn"] forState:0];
    }
}

/**
 * @brief 创建集合视图
 */
- (void)SetUpCollectionView{
    
    UICollectionViewFlowLayout *flowlayout = [[UICollectionViewFlowLayout alloc] init];
    
    [flowlayout setScrollDirection:UICollectionViewScrollDirectionVertical]; //设置滚动方向
    
    flowlayout.minimumInteritemSpacing = 2; //左右间距
    
    flowlayout.minimumLineSpacing = 2; //上下间距
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0 , self.ViewHeight.constant , KScreenWidth, KScreenHeight - KSafeTopeHeight - KSafeBottomHeight - 50) collectionViewLayout:flowlayout];
    
    collectionView.delegate = self;
    
    collectionView.dataSource = self;
    
    collectionView.showsVerticalScrollIndicator = NO;
    
    collectionView.showsHorizontalScrollIndicator = NO;
    
    [collectionView setBackgroundColor:[UIColor clearColor]];
    
    [collectionView registerClass:[HSQClassSecondGoodsListCell class] forCellWithReuseIdentifier:@"HSQClassSecondGoodsListCell"];
    
    [self.view addSubview:collectionView];
    
    self.collectionView = collectionView;

}

/**
 * @brief 添加菜单视图
 */
- (void)addMenuView{
    
    HSQDropdownMenuView *menuView = [[HSQDropdownMenuView alloc] initWithFrame:CGRectMake(0, self.ViewHeight.constant, KScreenWidth, KScreenHeight - KSafeTopeHeight - KSafeBottomHeight - self.ViewHeight.constant)];
   
    menuView.delegate = self;
    
    [self.view addSubview:menuView];
    
    self.bgView = menuView;
}

/**
 * @brief 菜单视图的点击事件
 */
- (void)MenuButtonSelectionClickIndexPath:(NSIndexPath *)indexPath content:(NSString *)SelectString{
    
    HSQLog(@"===%@",SelectString);
    
    self.ComprehensiveBtn.selected = YES;
    
    [self.XiaoLiang_Btn setEnabled:YES];
    
    [self.Price_Btn setEnabled:YES];
    
    self.IsSelectString = @"1";
    
    [self.bgView HiddenMenuView];
    
    if ([SelectString containsString:@"综合"])
    {
        [self.ComprehensiveBtn setTitle:@"综合" forState:(UIControlStateSelected)];
        self.SelectIndex = @"0";
        
        self.sort = @"";
    }
    else
    {
        [self.ComprehensiveBtn setTitle:@"评论" forState:(UIControlStateSelected)];
        self.SelectIndex = @"1";
        
        self.sort = @"comment_desc";
    }
    
    [self.collectionView.mj_header beginRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    if (self.currentPage == self.totalPage.integerValue || self.totalPage.integerValue == 0)
    {
        self.collectionView.mj_footer.hidden = YES;
    }
    else
    {
        self.collectionView.mj_footer.hidden = NO;
    }
    
    self.noDataView.hidden = (self.dataSource.count != 0);
    
    return self.dataSource.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.isGrid == YES)
    {
        return CGSizeMake((KScreenWidth - 6) / 2, (KScreenWidth - 6) / 2 + 70);
    }
    else
    {        
         return CGSizeMake(KScreenWidth, 100);
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    HSQClassSecondGoodsListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HSQClassSecondGoodsListCell" forIndexPath:indexPath];
    
    cell.model = self.dataSource[indexPath.row];
    
    cell.delegate = self;
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
}

/**
 * @brief 是否展开
 */
- (void)ExpandViewButtonClickAction:(UIButton *)sender{
    
    HSQClassSecondGoodsListCell *cell = (HSQClassSecondGoodsListCell *)sender.superview.superview;
    
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
    
    for (NSInteger i = 0; i < self.dataSource.count; i ++) {
        
        HSQGoodsDataListModel *model = self.dataSource[i];
        
        if (indexPath.row == i)
        {
            model.IsOpen = 1;
            
            [self StoreDynamicRatingWithStoreId:model];
        }
        else
        {
            model.IsOpen = 0;
            
             [self.collectionView reloadData];
        }
    }
}

/**
 * @brief 店铺的动态评分
 */
- (void)StoreDynamicRatingWithStoreId:(HSQGoodsDataListModel *)model{
    
    [[HSQProgressHUDManger Manger] ShowLoadingDataFromeServer:@"" ToView:self.view IsClearColor:YES];
    
    NSDictionary *params = @{@"storeId":model.storeId};
    
    AFNetworkRequestTool *requestTool = [AFNetworkRequestTool shareRequestTool];
    
    [requestTool.manger GET:UrlAdress(KStoreDynamicScoreUrl) parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [[HSQProgressHUDManger Manger] DismissProgressHUD];
        
        HSQLog(@"===店铺的动态评分===%@",responseObject);
        
        if ([responseObject[@"code"] integerValue] == 200)
        {
            NSDictionary *evaluateStoreVo = responseObject[@"datas"][@"evaluateStoreVo"];
            
            model.desEvalArrow = evaluateStoreVo[@"desEvalArrow"];
            
            model.storeDesEval  = evaluateStoreVo[@"storeDesEval"];
            
            model.storeServiceEval = evaluateStoreVo[@"storeServiceEval"];
            
            model.serviceEvalArrow  = evaluateStoreVo[@"serviceEvalArrow"];
            
            model.storeDeliveryEval = evaluateStoreVo[@"storeDeliveryEval"];
            
            model.deliveryEvalArrow  = evaluateStoreVo[@"deliveryEvalArrow"];
        }
        else
        {
            NSString *errorString = [NSString stringWithFormat:@"%@",responseObject[@"datas"][@"error"]];
            
            [[HSQProgressHUDManger Manger] ShowDisplayFailedToLoadData:errorString SuperView:self.view];
        }
        
        [self.collectionView reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        // 提示数据请求失败
        [[HSQProgressHUDManger Manger] ShowProgressHUDPromptText:KErrorPlacherString SupView:self.view];
    }];
}

/**
 * @brief 进入店铺详情
 */
- (void)JoinStoreDetailButtonClickAction:(UIButton *)sender{
    
    HSQClassSecondGoodsListCell *cell = (HSQClassSecondGoodsListCell *)sender.superview.superview.superview;
    
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
    
    HSQGoodsDataListModel *model = self.dataSource[indexPath.row];
    
    HSQStoreDetailViewController *storeDetailVC = [[HSQStoreDetailViewController alloc] init];
    
    storeDetailVC.storeId = model.storeId;
    
    [self.navigationController pushViewController:storeDetailVC animated:YES];
}

/**
 * @brief 关闭店铺评分界面
 */
- (void)StoreClosingScoreButtonClickAction:(UIButton *)sender{
    
    for (NSInteger i = 0; i < self.dataSource.count; i ++) {
        
        HSQGoodsDataListModel *model = self.dataSource[i];
        
        model.IsOpen = 0;
        
    }
    
     [self.collectionView reloadData];
}











@end
