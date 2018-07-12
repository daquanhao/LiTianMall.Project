//
//  HSQRedEnvelopeListViewController.m
//  LiTianDecoration
//
//  Created by administrator on 2018/6/26.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import "HSQRedEnvelopeListViewController.h"
#import "HSQAccountTool.h"
#import "HSQRedEnvelopeHeadView.h"
#import "HSQRedEnvelopeListCell.h"
#import "HSQRedEnvelopeListModel.h"

@interface HSQRedEnvelopeListViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableDictionary *RedEnvelopes_Diction;

@property (nonatomic, strong) NSMutableArray *dataSource; // 可用红包

@property (nonatomic, strong) NSMutableArray *AvailableRedEnvelopes; // 可用红包

@property (nonatomic, strong) NSMutableArray *NoRedEnvelope; // 不可用红包

@property (nonatomic, assign) NSInteger currentPage; // 当前的页数

@property (nonatomic, strong) HSQNoDataView *noDataView;

@property (nonatomic, copy) NSString *totalPage; // 总页数

@end

@implementation HSQRedEnvelopeListViewController

-(NSMutableArray *)dataSource{
    
    if (_dataSource == nil) {
        
        self.dataSource = [NSMutableArray array];
    }
    
    return _dataSource;
}

-(NSMutableArray *)AvailableRedEnvelopes{
    
    if (_AvailableRedEnvelopes == nil) {
        
        self.AvailableRedEnvelopes = [NSMutableArray array];
    }
    
    return _AvailableRedEnvelopes;
}

-(NSMutableArray *)NoRedEnvelope{
    
    if (_NoRedEnvelope == nil) {
        
        self.NoRedEnvelope = [NSMutableArray array];
    }
    
    return _NoRedEnvelope;
}

- (HSQNoDataView *)noDataView{
    
    if (!_noDataView) {
        
        _noDataView = [[HSQNoDataView alloc] initWithTitle:@"亲，还没有相关的红包额" imageName:@"WaitingForView" height:50 TopMargin:0];
    }
    return _noDataView;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.RedEnvelopes_Diction = [NSMutableDictionary dictionary];

    // 创建tableView
    [self CreatTableView];
    
    // 添加刷新控件
    [self AddRefreshControls];
    
    // 监听卡密码红包领取成功的消息
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(RedEnvelopeWasSuccessfullyReceivedNotif:) name:@"RedEnvelopeWasSuccessfullyReceivedNotif" object:nil];
}

/**
 * @brief 创建tableView
 */
- (void)CreatTableView{
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - KSafeTopeHeight - KSafeBottomHeight - 50) style:(UITableViewStyleGrouped)];
    
    tableView.backgroundColor = [UIColor clearColor];
    
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    tableView.delegate = self;
    
    tableView.dataSource = self;
    
    [tableView registerClass:[HSQRedEnvelopeListCell class] forCellReuseIdentifier:@"HSQRedEnvelopeListCell"];

    [tableView registerClass:[HSQRedEnvelopeHeadView class] forHeaderFooterViewReuseIdentifier:@"HSQRedEnvelopeHeadView"];
    
    [self.view addSubview:tableView];
    
    self.tableView = tableView;
}

/**
 * @brief 添加刷新控件
 */
- (void)AddRefreshControls{
    
    // 1.下拉加载更多的数据
    self.tableView.mj_header  = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(LoadNewWaitPayMoneryOrderListData)];
    
    [self.tableView.mj_header beginRefreshing];
    
    // 3.上啦加载更多的代码
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(LoadMoreWaitPayMoneryOrderData)];
}

/**
 * @brief 加载最新的订单数据
 */
- (void)LoadNewWaitPayMoneryOrderListData{
    
    [[HSQProgressHUDManger Manger] ShowLoadingDataFromeServer:@"" ToView:self.view IsClearColor:YES];
    
    [self.AvailableRedEnvelopes removeAllObjects];
    
    [self.NoRedEnvelope removeAllObjects];
    
    [self.dataSource removeAllObjects];
    
    // 结束上啦
    [self.tableView.mj_footer endRefreshing];
    
    self.currentPage = 1;
    
    NSDictionary *params = @{@"token":[HSQAccountTool account].token,@"page":@(self.currentPage)};

    AFNetworkRequestTool *requestTool = [AFNetworkRequestTool shareRequestTool];
    
    [requestTool.manger POST:UrlAdress(KMemberRedBaoListUrl) parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [[HSQProgressHUDManger Manger] DismissProgressHUD];
        
        HSQLog(@"===红包列表数据===%@",[NSString stringWithFormat:@"%@",responseObject]);
        
        self.totalPage = [NSString stringWithFormat:@"%@",responseObject[@"datas"][@"pageEntity"][@"totalPage"]];
        
        if ([responseObject[@"code"] integerValue] == 200)
        {
            self.dataSource = [HSQRedEnvelopeListModel mj_objectArrayWithKeyValuesArray:responseObject[@"datas"][@"redpackageList"]];

            // 筛选红包的种类
            [self ScreenRedEnvelopes];
        }
        else
        {
            NSString *errorString = [NSString stringWithFormat:@"%@",responseObject[@"datas"][@"error"]];
            
            [[HSQProgressHUDManger Manger] ShowDisplayFailedToLoadData:errorString SuperView:self.view];
        }
        
        [self.tableView.mj_header endRefreshing];
        
        [self.tableView reloadData];
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        // 结束刷新
        [self.tableView.mj_header endRefreshing];
        
        [self.tableView addSubview:self.noDataView];
        
        // 提示数据请求失败
        [[HSQProgressHUDManger Manger] ShowProgressHUDPromptText:KErrorPlacherString SupView:self.view];
    }];
}

/**
 * @brief 加载更多的订单数据
 */
- (void)LoadMoreWaitPayMoneryOrderData{
    
    [self.tableView.mj_header endRefreshing];
    
    NSDictionary *params = @{@"token":[HSQAccountTool account].token,@"page":@(++self.currentPage)};
    
    AFNetworkRequestTool *requestTool = [AFNetworkRequestTool shareRequestTool];
    
    [requestTool.manger POST:UrlAdress(KMemberRedBaoListUrl) parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [[HSQProgressHUDManger Manger] DismissProgressHUD];
        
        HSQLog(@"===加载更多红包列表数据===%@",responseObject);
        
        if ([responseObject[@"code"] integerValue] == 200)
        {
            NSArray *array = [HSQRedEnvelopeListModel mj_objectArrayWithKeyValuesArray:responseObject[@"datas"][@"redpackageList"]];
            
            [self.dataSource addObjectsFromArray:array];
            
            // 筛选红包的种类
            [self ScreenRedEnvelopes];
        }
        else
        {
            NSString *errorString = [NSString stringWithFormat:@"%@",responseObject[@"datas"][@"error"]];
            
            [[HSQProgressHUDManger Manger] ShowDisplayFailedToLoadData:errorString SuperView:self.view];
        }
        
        [self.tableView.mj_footer endRefreshing];
        
        [self.tableView reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        // 结束刷新
        [self.tableView.mj_footer endRefreshing];
        
        // 提示数据请求失败
        [[HSQProgressHUDManger Manger] ShowProgressHUDPromptText:KErrorPlacherString SupView:self.view];
    }];
    
}

/**
 * @brief 筛选红包的种类
 */
- (void)ScreenRedEnvelopes{
    
    for (HSQRedEnvelopeListModel *model in self.dataSource) {
        
        // 红包状态 0-未用,1-已用,2-作废 redPackageExpiredState 0未过期，1已过期
        if (model.redPackageExpiredState.integerValue == 0)
        {
            [self.AvailableRedEnvelopes addObject:model];
        }
        
         if (model.redPackageExpiredState.integerValue == 1)
        {
            [self.NoRedEnvelope addObject:model];
        }
    }
    
    if (self.NoRedEnvelope.count != 0)
    {
        [self.RedEnvelopes_Diction setValue:self.NoRedEnvelope forKey:@"NoRedEnvelope"];
    }
    
    if (self.AvailableRedEnvelopes.count != 0)
    {
        [self.RedEnvelopes_Diction setValue:self.AvailableRedEnvelopes forKey:@"AvailableRedEnvelopes"];
    }
}


/**
 * @brief 监听卡密码红包领取成功
 */
- (void)RedEnvelopeWasSuccessfullyReceivedNotif:(NSNotification *)notification{
    
    [self.tableView.mj_header beginRefreshing];
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.RedEnvelopes_Diction.allKeys.count;
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
    
    NSString *key = self.RedEnvelopes_Diction.allKeys[section];
    
    NSMutableArray *array = [self.RedEnvelopes_Diction objectForKey:key];
    
    return array.count;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section{

    return (section == 0 ? 1 : 40);
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    return (section == 0 ? 1 : 40);
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    HSQRedEnvelopeHeadView *HeaderView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"HSQRedEnvelopeHeadView"];
    
    if (section == 0)
    {
        HeaderView.placher_Label.text = @"";
    }
    else
    {
        HeaderView.placher_Label.text = @"已失效红包";
    }

    return HeaderView;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForFooterInSection:(NSInteger)section{
    
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *key = self.RedEnvelopes_Diction.allKeys[indexPath.section];
    
    NSMutableArray *array = [self.RedEnvelopes_Diction objectForKey:key];
    
    HSQRedEnvelopeListModel *model = array[indexPath.row];
    
    return [self.tableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:[HSQRedEnvelopeListCell class] contentViewWidth:KScreenWidth] + 10;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HSQRedEnvelopeListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HSQRedEnvelopeListCell" forIndexPath:indexPath];
    
    NSString *key = self.RedEnvelopes_Diction.allKeys[indexPath.section];
    
    NSMutableArray *array = [self.RedEnvelopes_Diction objectForKey:key];
    
     cell.model = array[indexPath.row];
    
    // 此步设置用于实现cell的frame缓存，可以让tableview滑动更加流畅
    [cell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
