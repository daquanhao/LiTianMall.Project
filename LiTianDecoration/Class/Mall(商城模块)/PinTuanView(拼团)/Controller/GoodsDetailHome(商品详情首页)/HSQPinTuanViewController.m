//
//  HSQPinTuanViewController.m
//  LiTianDecoration
//
//  Created by administrator on 2018/4/12.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import "HSQPinTuanViewController.h"
#import "HSQPublicMenuView.h"
#import "HSQLeftCategoryModel.h"
#import "HSQPinTuanListModel.h"
#import "HSQPinTuanListCell.h"
#import "HSQPinTuanDetailHomeViewController.h"

@interface HSQPinTuanViewController ()<UITableViewDelegate,UITableViewDataSource,HSQPublicMenuViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableView_BottomMargin;

@property (nonatomic, strong) HSQPublicMenuView *publicMenuView;

@property (nonatomic, strong) NSMutableArray *Class_Array;

@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, assign) NSInteger CurrentPage;

@property (nonatomic, copy) NSString *categoryId;

@property (nonatomic, copy) NSString *totalPage;  // 总页数

@end

@implementation HSQPinTuanViewController

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
    [self.publicMenuView DismissMenuView];
}

- (NSMutableArray *)Class_Array{
    
    if (_Class_Array == nil) {
        
        self.Class_Array = [NSMutableArray array];
    }
    
    return _Class_Array;
}

- (NSMutableArray *)dataSource{
    
    if (_dataSource == nil) {
        
        self.dataSource = [NSMutableArray array];
    }
    
    return _dataSource;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.view.backgroundColor = KViewBackGroupColor;
    
    self.navigationItem.title = self.NavtionTitle;
    
    self.tableView_BottomMargin.constant = KSafeBottomHeight;
    
    [self.tableView registerClass:[HSQPinTuanListCell class] forCellReuseIdentifier:@"HSQPinTuanListCell"];
    
     // 1.请求顶部标题栏的数据
    [self RequestTopClassDataFromeServer];
    
    // 3.添加刷新的视图
    [self AddHeadTableViewRefView];
    
}

/**
 * @brief 添加刷新的视图
 */
- (void)AddHeadTableViewRefView{
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(LoadNewClassListDataFromeServer)];
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(LoadMoreClassListDataFromeServer)];
    
    [self.tableView.mj_header beginRefreshing];
}


/**
 * @brief 1.请求顶部标题栏的数据
 */
- (void)RequestTopClassDataFromeServer{
    
    [[HSQProgressHUDManger Manger] ShowLoadingDataFromeServer:@"" ToView:self.view IsClearColor:YES];
    
    AFNetworkRequestTool *RequestTool = [AFNetworkRequestTool shareRequestTool];
    
    [RequestTool.manger GET:UrlAdress(KClassDataUrl) parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *responseObject) {
        
        [[HSQProgressHUDManger Manger] DismissProgressHUD];
        
        HSQLog(@"=分类=%@",responseObject);
        
        if ([[responseObject allKeys] containsObject:@"datas"])
        {
            self.Class_Array = [HSQLeftCategoryModel mj_objectArrayWithKeyValuesArray:responseObject[@"datas"][@"categoryList"]];
            
            [self.Class_Array insertObject:@"全部" atIndex:0];
          
            [self addHeadClassView:self.Class_Array];
        }
        else
        {
            NSString *errorString = [NSString stringWithFormat:@"%@",responseObject[@"datas"][@"error"]];
            
            [[HSQProgressHUDManger Manger] ShowDisplayFailedToLoadData:errorString SuperView:self.view];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [[HSQProgressHUDManger Manger] ShowDisplayFailedToLoadData:@"分类数据加载失败" SuperView:self.view];
        
    }];
    
}

/**
 * @brief 1.请求拼团列表的数据
 */
- (void)LoadNewClassListDataFromeServer{
    
    self.CurrentPage = 1;
    [self.tableView.mj_footer endRefreshing];
    [self.dataSource removeAllObjects];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"page"] = @(self.CurrentPage);
    if (self.categoryId.length != 0)
    {
        params[@"categoryId"] = self.categoryId;
    }
    
    [[HSQProgressHUDManger Manger] ShowLoadingDataFromeServer:@"" ToView:self.view IsClearColor:YES];
    
    AFNetworkRequestTool *RequestTool = [AFNetworkRequestTool shareRequestTool];
    
    [RequestTool.manger GET:UrlAdress(KPinTuanListDataUrl) parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *responseObject) {
        
        [[HSQProgressHUDManger Manger] DismissProgressHUD];
        
        HSQLog(@"=拼团的数据==%@",responseObject);
        
        if ([responseObject[@"code"] integerValue] == 200)
        {
            if ([[responseObject allKeys] containsObject:@"datas"])
            {
                self.totalPage = [NSString stringWithFormat:@"%@",responseObject[@"datas"][@"pageEntity"][@"totalPage"]];
                
                self.dataSource = [HSQPinTuanListModel mj_objectArrayWithKeyValuesArray:responseObject[@"datas"][@"groupList"]];
            }
        }
        else
        {
            NSString *errorString = [NSString stringWithFormat:@"%@",responseObject[@"datas"][@"error"]];
            
            [[HSQProgressHUDManger Manger] ShowDisplayFailedToLoadData:errorString SuperView:self.view];
        }
        
        [self.tableView.mj_header endRefreshing];
        
        [self.tableView reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [self.tableView.mj_header endRefreshing];
        
        [[HSQProgressHUDManger Manger] ShowDisplayFailedToLoadData:@"分类数据加载失败" SuperView:self.view];
        
    }];
}

/**
 * @brief 2.请求更多的拼团列表的数据
 */
- (void)LoadMoreClassListDataFromeServer{
    
    // 结束下拉
    [self.tableView.mj_header endRefreshing];
    
    [[HSQProgressHUDManger Manger] ShowLoadingDataFromeServer:@"" ToView:self.view IsClearColor:YES];
    
    AFNetworkRequestTool *RequestTool = [AFNetworkRequestTool shareRequestTool];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"page"] = @(++self.CurrentPage);
    if (self.categoryId.length != 0)
    {
        params[@"categoryId"] = self.categoryId;
    }
    
    [RequestTool.manger POST:UrlAdress(KPinTuanListDataUrl) parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        HSQLog(@"加载更多%@",[NSString stringWithFormat:@"%@",responseObject]);
        
      [[HSQProgressHUDManger Manger] DismissProgressHUD];
        
        if ([responseObject[@"code"] integerValue] == 200)
        {
            if ([[responseObject allKeys] containsObject:@"datas"])
            {
                // 1.字典转模型
                NSArray *array1 =  [HSQPinTuanListModel mj_objectArrayWithKeyValuesArray:responseObject[@"datas"][@"groupList"]];
                
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
        [self.tableView reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        // 结束刷新
        [self.tableView.mj_footer endRefreshing];
        
        [[HSQProgressHUDManger Manger] ShowDisplayFailedToLoadData:@"分类数据加载失败" SuperView:self.view];
        
    }];
}

/**
 * @brief 添加头部标题视图
 */
- (void)addHeadClassView:(NSArray *)title_array{
        
    HSQPublicMenuView *PublicMenuView = [[HSQPublicMenuView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 45)];
    
    PublicMenuView.dataSource = [NSMutableArray arrayWithArray:title_array];
    
    PublicMenuView.delegate = self;
    
    [self.view addSubview:PublicMenuView];
    
    self.publicMenuView = PublicMenuView;
    
}

#pragma mark - HSQPublicMenuViewDelegate

- (void)topButtonClickAction:(UIButton *)sender{
    
    if (sender.tag == 0)
    {
        self.categoryId = @"";
    }
    else
    {
        HSQLeftCategoryModel *model = self.Class_Array[sender.tag];
        self.categoryId = model.categoryId;
    }
    
    [self.tableView.mj_header beginRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate,UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
        
    if (self.CurrentPage == self.totalPage.integerValue || self.totalPage.integerValue == 0)
    {
        self.tableView.mj_footer.hidden = YES;
    }
    else
    {
         self.tableView.mj_footer.hidden = NO;
    }
    
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 100;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return [self.tableView cellHeightForIndexPath:indexPath model:self.dataSource[indexPath.row] keyPath:@"model" cellClass:[HSQPinTuanListCell class] contentViewWidth:KScreenWidth];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    HSQPinTuanListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HSQPinTuanListCell" forIndexPath:indexPath];
    
    if (self.dataSource.count != 0)
    {
        cell.model = self.dataSource[indexPath.row];
    }
    
    // 此步设置用于实现cell的frame缓存，可以让tableview滑动更加流畅
    [cell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    HSQPinTuanListModel *model = self.dataSource[indexPath.row];
    
    HSQPinTuanDetailHomeViewController *PinTuanDetailVC = [[HSQPinTuanDetailHomeViewController alloc] init];
    
    PinTuanDetailVC.commonId = model.commonId;
    
    [self.navigationController pushViewController:PinTuanDetailVC animated:YES];

}



- (void)dealloc{
    
    [self.publicMenuView removeFromSuperview];
}




@end

