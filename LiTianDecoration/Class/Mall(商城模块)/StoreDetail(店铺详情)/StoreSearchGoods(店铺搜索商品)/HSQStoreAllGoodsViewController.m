
//
//  HSQStoreAllGoodsViewController.m
//  LiTianDecoration
//
//  Created by administrator on 2018/5/17.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import "HSQStoreAllGoodsViewController.h"
#import "HSQTopShaiXuanView.h"
#import "HSQClassSecondGoodsListCell.h"

@interface HSQStoreAllGoodsViewController ()<HSQTopShaiXuanViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) HSQTopShaiXuanView *TopShaiXuanView;

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, assign) BOOL isGrid;

@property (nonatomic, assign) NSInteger CurrentPage; // 页数

@property (nonatomic, copy) NSString *totalPage; // 总页数

@property (nonatomic, copy) NSString *sort;  // 排列顺序

@property (nonatomic, strong) HSQNoDataView *NoDataView; // 空界面

@end

@implementation HSQStoreAllGoodsViewController

-(NSMutableArray *)dataSource{
    
    if (_dataSource == nil) {
        
        self.dataSource = [NSMutableArray array];
    }
    
    return _dataSource;
}

-(HSQNoDataView *)NoDataView{
    
    if (_NoDataView == nil) {
        
        self.NoDataView = [[HSQNoDataView alloc] initWithTitle:@"亲，店铺内没有该商品哦~" imageName:@"3-1P106112Q1-51" height:50 TopMargin:0];
    }
    
    return _NoDataView;
}


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.view.backgroundColor = KViewBackGroupColor;
    
    self.isGrid = YES; // 默认列表视图
    
    self.sort = @"default_desc";  // 综合排序
    
    // 添加头部的搜索框按钮视图
    [self AddHeadSearchBtnView];
    
    // 添加头部筛选按钮
    [self AddAHeaderFilterButton];
    
    // 添加商品的列表
    [self CreatCollectionView];
    
    // 添加顶部的刷新视图
    [self addCollectionRefView];
}

/**
 * @brief 添加头部的搜索框按钮视图
 */
- (void)AddHeadSearchBtnView{
    
    UIButton *SearchBar = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [SearchBar setTitle:@"搜索店铺商品" forState:(UIControlStateNormal)];
    SearchBar.titleLabel.font = [UIFont systemFontOfSize:14];
    [SearchBar setTitleColor:RGB(150, 150, 150) forState:(UIControlStateNormal)];
    [SearchBar setImage:[UIImage imageNamed:@"6DE36884-837C-44C3-B808-CE7F7D8C4FFA"] forState:(UIControlStateNormal)];
    [SearchBar setBackgroundImage:[UIImage ReturnAPictureOfStretching:@"7D99DFED-F3B6-4DB1-9F77-E24CA867DD17"] forState:(UIControlStateNormal)];
    SearchBar.frame = CGRectMake(0, 0, KScreenWidth * 0.7, 30);
    [SearchBar setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
    [SearchBar addTarget:self action:@selector(TopSearchBarClickAction:) forControlEvents:(UIControlEventTouchUpInside)];
    self.navigationItem.titleView = SearchBar;
}

/**
 * @brief 搜索按钮的点击事件
 */
- (void)TopSearchBarClickAction:(UIButton *)sender{
    
    [self.navigationController popViewControllerAnimated:NO];
    
}

/**
 * @brief 添加头部筛选按钮
 */
- (void)AddAHeaderFilterButton{
    
    HSQTopShaiXuanView *TopShaiXuanView = [[HSQTopShaiXuanView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 50)];
    
    TopShaiXuanView.delegate = self;
    
    [self.view addSubview:TopShaiXuanView];
    
    self.TopShaiXuanView = TopShaiXuanView;
}


/**
 * @brief 创建集合视图
 */
- (void)CreatCollectionView{
    
    UICollectionViewFlowLayout *Layout = [[UICollectionViewFlowLayout alloc] init];
    
    Layout.minimumLineSpacing = 3;  // 最小的行间距
    
    Layout.minimumInteritemSpacing = 3; // 最小的列间距
    
    CGFloat collectionHeight = KScreenHeight - KSafeBottomHeight - KSafeTopeHeight - CGRectGetMaxY(self.TopShaiXuanView.frame);
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.TopShaiXuanView.frame), KScreenWidth, collectionHeight) collectionViewLayout:Layout];
    
    collectionView.backgroundColor = [UIColor clearColor];
        
    collectionView.dataSource = self;
    
    collectionView.delegate = self;
    
    collectionView.showsVerticalScrollIndicator = NO;
    
    collectionView.showsHorizontalScrollIndicator = NO;
    
    [collectionView registerClass:[HSQClassSecondGoodsListCell class] forCellWithReuseIdentifier:@"HSQClassSecondGoodsListCell"];
    
    [self.view addSubview:collectionView];
    
    [self.view sendSubviewToBack:collectionView];
    
    self.collectionView = collectionView;
}

/**
 * @brief 添加刷新控件
 */
- (void)addCollectionRefView{
    
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(LoadNewAllGoodsDataFromeServer)];
    
    self.collectionView.mj_header.automaticallyChangeAlpha = YES;
    
    self.collectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(LoadMoreAllGoodsDataFromeServer)];
    
    [self.collectionView.mj_header beginRefreshing];

}

/**
 * @brief 加载最新的店铺的商品
 */
- (void)LoadNewAllGoodsDataFromeServer{
    
    self.CurrentPage = 1;
    
    [self.dataSource removeAllObjects];
    
    [self.collectionView.mj_footer endRefreshing];
    
    [[HSQProgressHUDManger Manger] ShowLoadingDataFromeServer:@"" ToView:self.view IsClearColor:YES];
    
    NSMutableDictionary *Params = [NSMutableDictionary dictionary];
    Params[@"storeId"] = self.storeId;
    Params[@"keyword"] = self.KeyWord;
    Params[@"sort"] = self.sort;
    Params[@"page"] = @(self.CurrentPage);
    Params[@"discountId"] = @"";   // 折扣促销id
    Params[@"conformId"] = @"";  // 满优惠id
    Params[@"templateId"] = @"";  // 优惠券活动促销id
    
    AFNetworkRequestTool *requestTool = [AFNetworkRequestTool shareRequestTool];
    
    [requestTool.manger GET:UrlAdress(KSearchGoodsInStoreUrl) parameters:Params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [[HSQProgressHUDManger Manger] DismissProgressHUD];
        
        // 总页数
        self.totalPage = [NSString stringWithFormat:@"%@",responseObject[@"pageEntity"][@"totalPage"]];
        
        if ([responseObject[@"code"] integerValue] == 200)
        {
            NSArray *array = responseObject[@"datas"][@"goodsCommonList"];
            
            if (array.count != 0)
            {
                [self.dataSource addObjectsFromArray:array];
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
        
        [[HSQProgressHUDManger Manger] ShowDisplayFailedToLoadData:@"数据加载失败" SuperView:self.view];
        
    }];
}

/**
 * @brief 加载更多的店铺的商品
 */
- (void)LoadMoreAllGoodsDataFromeServer{
    
    [self.collectionView.mj_header endRefreshing];
    
    if (self.totalPage.integerValue == self.CurrentPage || self.totalPage.integerValue == 0)
    {
        [self.collectionView.mj_footer endRefreshingWithNoMoreData];
    }
    else
    {
        [self.collectionView.mj_header endRefreshing];
        
        [[HSQProgressHUDManger Manger] ShowLoadingDataFromeServer:@"" ToView:self.view IsClearColor:YES];
        
        NSMutableDictionary *Params = [NSMutableDictionary dictionary];
        Params[@"storeId"] = self.storeId;
        Params[@"keyword"] = self.KeyWord;
        Params[@"sort"] = self.sort;
        Params[@"page"] = @(++self.CurrentPage);
        Params[@"discountId"] = @"";   // 折扣促销id
        Params[@"conformId"] = @"";  // 满优惠id
        Params[@"templateId"] = @"";  // 优惠券活动促销id
        
        AFNetworkRequestTool *requestTool = [AFNetworkRequestTool shareRequestTool];
        
        [requestTool.manger GET:UrlAdress(KSearchGoodsInStoreUrl) parameters:Params progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            [[HSQProgressHUDManger Manger] DismissProgressHUD];
            
            if ([responseObject[@"code"] integerValue] == 200)
            {
                NSArray *array = responseObject[@"datas"][@"goodsCommonList"];
                
                [self.dataSource addObjectsFromArray:array];
            }
            else
            {
                [self.collectionView.mj_footer endRefreshingWithNoMoreData];
            }
            
            [self.collectionView.mj_footer endRefreshing];
            
            [self.collectionView reloadData];
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            [self.collectionView.mj_footer endRefreshing];
            
            [[HSQProgressHUDManger Manger] ShowDisplayFailedToLoadData:@"数据加载失败" SuperView:self.view];
            
        }];
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionViewDelegate,UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
     self.NoDataView.hidden = (self.dataSource.count != 0);
    
     self.collectionView.mj_footer.hidden = (self.dataSource.count == 0);
    
    return self.dataSource.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.isGrid)
    {
        return CGSizeMake((KScreenWidth - 3) / 2, (KScreenWidth - 5) / 2 + 75);
    }
    else
    {
        return CGSizeMake(KScreenWidth, 120);
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    HSQClassSecondGoodsListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HSQClassSecondGoodsListCell" forIndexPath:indexPath];
    
    cell.isGrid = _isGrid;
    
    cell.dataDiction = self.dataSource[indexPath.row];
    
    cell.DiscountBtn.hidden = YES;
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
}

/**
 * @brief 顶部筛选的按钮的点击
 */
- (void)ClickTheButtonOnTheTopScreen:(UIButton *)sender{
    
    if (sender.tag == 3) // 布局
    {
        [self ChangeViewLayOut];
    }
    else if (sender.tag == 2) // 销量
    {
        if ([self.sort isEqualToString:@"sale_desc"]) // 销量从低到高
        {
            self.sort = @"sale_asc";
            [self.collectionView.mj_header beginRefreshing];
        }
        else
        {
            self.sort = @"sale_desc";
            [self.collectionView.mj_header beginRefreshing];
        }
    }
    else if (sender.tag == 1) // 价格
    {
        if ([self.sort isEqualToString:@"price_desc"]) // 价格从低到高
        {
            self.sort = @"price_asc";
            [self.collectionView.mj_header beginRefreshing];
        }
        else
        {
            self.sort = @"price_desc";
            [self.collectionView.mj_header beginRefreshing];
        }
    }
    else if (sender.tag == 0) // 综合
    {
        if (![self.sort isEqualToString:@"default_desc"])
        {
            self.sort = @"default_desc";
            [self.collectionView.mj_header beginRefreshing];
        }
    }
    
    HSQLog(@"==排列的参数=%@",self.sort);
}

/**
 * @brief 改变控件的布局
 */
- (void)ChangeViewLayOut{
    
    if (self.isGrid == YES)
    {
        self.isGrid = NO;
    }
    else
    {
        self.isGrid = YES;
    }
    
    [self.collectionView reloadData];
}







@end
