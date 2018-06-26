//
//  HSQStoreSearchViewController.m
//  LiTianDecoration
//
//  Created by administrator on 2018/6/18.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import "HSQStoreSearchViewController.h"
#import "HSQStoreSearchGoodsListCell.h"
#import "HSQStoreSearchHeadReusableView.h"
#import "HSQStoreSearchListDataModel.h"
#import "HSQStoreSearchFooterReusableView.h"
#import "HSQStoreDetailViewController.h"

@interface HSQStoreSearchViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,HSQStoreSearchHeadReusableViewDelegate>

@property (nonatomic, weak) UIView *titlesView; // 顶部的所有标签

@property (nonatomic, weak) UIImageView *indicatorView; // 标签栏底部的红色指示器

@property (nonatomic, weak) UIButton *selectedButton; // 当前选中的按钮

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, assign) NSInteger currentPage; // 当前的页数

@property (nonatomic, strong) HSQNoDataView *noDataView;

@property (nonatomic, copy) NSString *totalPage; // 总页数

@property (nonatomic, copy) NSString *sort; // 总页数

@end

@implementation HSQStoreSearchViewController

-(NSMutableArray *)dataSource{
    
    if (_dataSource == nil) {
        
        self.dataSource = [NSMutableArray array];
    }
    
    return _dataSource;
}

- (HSQNoDataView *)noDataView{
    
    if (!_noDataView) {
        
        _noDataView = [[HSQNoDataView alloc] initWithTitle:@"亲，没有相关的店铺哦~" imageName:@"WaitingForView" height:50 TopMargin:0];
    }
    return _noDataView;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.view.backgroundColor = KViewBackGroupColor;
    
    self.sort = @"";
    
    // 添加搜索视图
    [self AddSearchViewWithPlacher:self.keyword];
    
    // 2.设置顶部标题栏
    [self setupTopTitlesView];
    
    // 创建集合视图
    [self CreatCollectionView];
    
    // 请求店铺搜索数据
    [self RequestStoreSearchData];
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
 * @brief 设置顶部标题栏
 */
- (void)setupTopTitlesView{
    
    NSArray *TopTitle_Array = @[@"默认排序",@"销量优先",@"店铺收藏量"];
    
    // 标签栏整体
    UIView *titlesView = [[UIView alloc] init];
    titlesView.backgroundColor = [UIColor whiteColor];
    titlesView.mj_w = [UIScreen mainScreen].bounds.size.width;
    titlesView.mj_h = 50;
    titlesView.mj_y = 0;
    [self.view addSubview:titlesView];
    self.titlesView = titlesView;
    
    // 底部的红色指示器
    UIImageView *indicatorView = [[UIImageView alloc] init];
    indicatorView.backgroundColor = RGB(255, 83, 63);
    indicatorView.mj_h = 2;
    indicatorView.tag = -1;
    indicatorView.mj_y = titlesView.mj_h - indicatorView.mj_h;
    self.indicatorView = indicatorView;
    
    // 内部的子标签
    CGFloat width = titlesView.mj_w / TopTitle_Array.count;
    
    CGFloat height = titlesView.mj_h;
    
    for (NSInteger i = 0; i < TopTitle_Array.count; i++) {
        
        UIButton *button = [UIButton buttonWithType:(UIButtonTypeCustom)];
        button.tag = i;
        button.mj_h = height;
        button.mj_w = width;
        button.mj_x = i * width;
        
        [button setTitle:TopTitle_Array[i] forState:UIControlStateNormal];
        
        [button setTitleColor:RGB(131, 131, 131) forState:UIControlStateNormal];
        
        [button setTitleColor:RGB(255, 83, 63) forState:UIControlStateDisabled];
        
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        
        [button addTarget:self action:@selector(titleClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [titlesView addSubview:button];
        
        // 默认点击了第一个按钮
        if (i == 0)
        {
            button.enabled = NO;

            self.selectedButton = button;

            // 让按钮内部的label根据文字内容来计算尺寸
            [button.titleLabel sizeToFit];

            self.indicatorView.mj_w = button.titleLabel.mj_w;

            self.indicatorView.centerX = button.centerX;
        }
    }
    
    [titlesView addSubview:indicatorView];
}

/**
 * @brief 顶部按钮的点击事件
 */
- (void)titleClick:(UIButton *)button{
    
    // 修改按钮状态
    self.selectedButton.enabled = YES;
    
    button.enabled = NO;
    
    self.selectedButton = button;
    
    // 动画
    [UIView animateWithDuration:0.25 animations:^{
        
        self.indicatorView.width = button.titleLabel.mj_w;
        
        self.indicatorView.centerX = button.centerX;
    }];
    
    if (button.tag == 0) // 默认排序
    {
        self.sort = @"";
    }
    else if (button.tag == 1) // 销量优先
    {
        self.sort = @"sale_desc";
    }
    else if (button.tag == 2) // 店铺收藏量
    {
        self.sort = @"collect_desc";
    }
    
    [self.collectionView.mj_header beginRefreshing];
}


/**
 * @brief  创建集合视图
 */
- (void)CreatCollectionView{
    
    UICollectionViewFlowLayout *Layout = [[UICollectionViewFlowLayout alloc] init];
    
    CGFloat collectionHeight = KScreenHeight - KSafeBottomHeight - KSafeTopeHeight - 50;
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 50, KScreenWidth, collectionHeight) collectionViewLayout:Layout];
    
    collectionView.backgroundColor = [UIColor whiteColor];
    
    collectionView.dataSource = self;
    
    collectionView.delegate = self;
    
    [collectionView registerClass:[HSQStoreSearchHeadReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HSQStoreSearchHeadReusableView"];
    
    [collectionView registerClass:[HSQStoreSearchFooterReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"HSQStoreSearchFooterReusableView"];
    
    [collectionView registerNib:[UINib nibWithNibName:@"HSQStoreSearchGoodsListCell" bundle:nil] forCellWithReuseIdentifier:@"HSQStoreSearchGoodsListCell"];
    
    [self.view addSubview:collectionView];
    
    [self.view sendSubviewToBack:collectionView];
    
    self.collectionView = collectionView;
}

/**
 * @brief 请求店铺搜索数据
 */
- (void)RequestStoreSearchData{
    
    // 1.下拉加载更多的数据
    self.collectionView.mj_header  = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(LoadNewStoreListData)];
    
    [self.collectionView.mj_header beginRefreshing];
    
    // 3.上啦加载更多的代码
    self.collectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(LoadMoreStoreListData)];
}

- (void)LoadNewStoreListData{
    
    [[HSQProgressHUDManger Manger] ShowLoadingDataFromeServer:@"" ToView:self.view IsClearColor:YES];
    
    // 0.清空数组
    [self.dataSource removeAllObjects];
    
    // 结束上啦
    [self.collectionView.mj_footer endRefreshing];
    
    self.currentPage = 1;
    
    NSDictionary *params = @{@"keyword":self.keyword,@"page":@(self.currentPage),@"sort":self.sort};
    
    AFNetworkRequestTool *requestTool = [AFNetworkRequestTool shareRequestTool];
    
    [requestTool.manger GET:UrlAdress(KStoreSearchUrl) parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [[HSQProgressHUDManger Manger] DismissProgressHUD];
        
        HSQLog(@"===店铺搜索数据===%@",responseObject);
        
        self.totalPage = [NSString stringWithFormat:@"%@",responseObject[@"datas"][@"pageEntity"][@"totalPage"]];
        
        if ([responseObject[@"code"] integerValue] == 200)
        {
            // 中间的规格列表
            for (NSDictionary *dict in responseObject[@"datas"][@"storeList"]){
                
                // 外层数据 有多少个店铺
                HSQStoreSearchListDataModel *StoreListModel = [[HSQStoreSearchListDataModel alloc] initWithDictionary:dict error:nil];

                StoreListModel.goodsCommonList = [NSMutableArray array];
                
                [self.dataSource addObject:StoreListModel];
                
                // 内层数据 每个店铺有几个商品
                for (NSInteger i = 0; i < [dict[@"goodsCommonList"] count] ; i++) {
                    
                    NSDictionary *ModelDiction = dict[@"goodsCommonList"][i];
                    
                    HSQGoodsCommonListModel *GoodsListModel = [[HSQGoodsCommonListModel alloc] init];
                
                    [GoodsListModel setValuesForKeysWithDictionary:ModelDiction];
                    
                    [StoreListModel.goodsCommonList addObject:GoodsListModel];
                    
                }
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

- (void)LoadMoreStoreListData{
    
    [self.collectionView.mj_header endRefreshing];
    
    NSDictionary *params = @{@"keyword":self.keyword,@"page":@(++self.currentPage),@"sort":self.sort};
    
    AFNetworkRequestTool *requestTool = [AFNetworkRequestTool shareRequestTool];
    
    [requestTool.manger GET:UrlAdress(KPromoteOrderListDataUrl) parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [[HSQProgressHUDManger Manger] DismissProgressHUD];
        
        HSQLog(@"===加载更多店铺数据===%@",responseObject);
        
        if ([responseObject[@"code"] integerValue] == 200)
        {
            // 中间的规格列表
            for (NSDictionary *dict in responseObject[@"datas"][@"storeList"]){
                
                // 外层数据 有多少个店铺
                HSQStoreSearchListDataModel *StoreListModel = [[HSQStoreSearchListDataModel alloc] initWithDictionary:dict error:nil];
                
                StoreListModel.goodsCommonList = [NSMutableArray array];
                
                [self.dataSource addObject:StoreListModel];
                
                // 内层数据 每个店铺有几个商品
                for (NSInteger i = 0; i < [dict[@"goodsCommonList"] count] ; i++) {
                    
                    NSDictionary *ModelDiction = dict[@"goodsCommonList"][i];
                    
                    HSQGoodsCommonListModel *GoodsListModel = [[HSQGoodsCommonListModel alloc] init];
                    
                    [GoodsListModel setValuesForKeysWithDictionary:ModelDiction];
                    
                    [StoreListModel.goodsCommonList addObject:GoodsListModel];
                }
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionViewDelegate,UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
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

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    HSQStoreSearchListDataModel *model = self.dataSource[section];
    
    return (model.goodsCommonList.count > 3 ? 3 : model.goodsCommonList.count);
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    
   return CGSizeMake(KScreenWidth, 80);
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    
    if (section == self.dataSource.count - 1)
    {
        return CGSizeMake(KScreenWidth, 0);
    }
    else
    {
        return CGSizeMake(KScreenWidth, 20);
    }
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionReusableView *reusableView = nil;
    
    if (kind == UICollectionElementKindSectionHeader)
    {
        HSQStoreSearchHeadReusableView *headView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HSQStoreSearchHeadReusableView" forIndexPath:indexPath];
        
        headView.model = self.dataSource[indexPath.section];
        
        headView.delegate = self;
        
        headView.section = indexPath.section;
                
        reusableView = headView;
    }
    
    if (kind == UICollectionElementKindSectionFooter)
    {
        HSQStoreSearchFooterReusableView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"HSQStoreSearchFooterReusableView" forIndexPath:indexPath];
        
        reusableView = footerView;
    }
    
    return reusableView;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake((KScreenWidth - 20)/3, (KScreenWidth - 20)/3);
}

// 两个cell之间的最小间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    
     return 10;
}

// 行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    HSQStoreSearchGoodsListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HSQStoreSearchGoodsListCell" forIndexPath:indexPath];
    
    HSQStoreSearchListDataModel *StoreModel = self.dataSource[indexPath.section];
    
    cell.model = StoreModel.goodsCommonList[indexPath.row];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
}

/**
 * @brief 进入店铺详情
 */
- (void)JoinStoreDetailDataWithButton:(UIButton *)sender{
    
    HSQStoreSearchHeadReusableView *HeadView = (HSQStoreSearchHeadReusableView *)sender.superview.superview;
    
    HSQStoreSearchListDataModel *model = self.dataSource[HeadView.section];
    
    HSQStoreDetailViewController *StoreDetailVC = [[HSQStoreDetailViewController alloc] init];
    
    StoreDetailVC.storeId = model.storeId;
    
    [self.navigationController pushViewController:StoreDetailVC animated:YES];
    
}







@end
