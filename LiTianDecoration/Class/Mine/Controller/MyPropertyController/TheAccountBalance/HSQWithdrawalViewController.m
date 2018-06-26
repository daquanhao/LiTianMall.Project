//
//  HSQWithdrawalViewController.m
//  LiTianDecoration
//
//  Created by administrator on 2018/4/29.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import "HSQWithdrawalViewController.h"
#import "HSQBandMobileViewController.h"
#import "HSQAccountTool.h"
#import "HSQSetingViewController.h"
#import "HSQCommissionWithdrawalListCell.h"
#import "HSQCommissionWithdrawaLlisModel.h"
#import "HSQShowDetailsViewController.h"

@interface HSQWithdrawalViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UIButton *ApplyWithdrawalButton; // 申请提现的按钮

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, assign) NSInteger currentPage;

@property (nonatomic, copy) NSString *totalPage; // 总页数

@property (nonatomic, strong) HSQNoDataView *noDataView;

@end

@implementation HSQWithdrawalViewController

-(NSMutableArray *)dataSource{
    
    if (_dataSource == nil) {
        
        self.dataSource = [NSMutableArray array];
    }
    
    return _dataSource;
}

- (HSQNoDataView *)noDataView{
    
    if (!_noDataView) {
        
        _noDataView = [[HSQNoDataView alloc] initWithTitle:@"亲，您尚未提现过预存款哦~" imageName:@"WaitingForView" height:50 TopMargin:0];
    }
    return _noDataView;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.view.backgroundColor = KViewBackGroupColor;
    
    // 申请提现按钮
    [self ApplyForTheWithdrawalButton];
    
    // 创建tableView
    [self CreatTableView];

    // 添加刷新控件
    [self AddPromotionCommissionWithdrawalListRefreshControls];
    
    // 监听提现是否成功
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(AdvanceWithdrawalSuccess:) name:@"AdvanceWithdrawalSuccess" object:nil];
    
}

/**
 * @brief 申请提现
 */
- (void)ApplyForTheWithdrawalButton{
    
    UIButton *ApplyWithdrawalButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
    
    [ApplyWithdrawalButton setTitle:@"申请提现" forState:(UIControlStateNormal)];
    
    ApplyWithdrawalButton.titleLabel.font = [UIFont systemFontOfSize:14.0];
    
    ApplyWithdrawalButton.backgroundColor = [UIColor redColor];
    
    [ApplyWithdrawalButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    
    ApplyWithdrawalButton.frame = CGRectMake(0, KScreenHeight - KSafeTopeHeight - KSafeBottomHeight - 100 - 44, KScreenWidth, 44);
    
    [ApplyWithdrawalButton addTarget:self action:@selector(ApplyWithdrawalButtonClickAction:) forControlEvents:(UIControlEventTouchUpInside)];
    
    [self.view addSubview:ApplyWithdrawalButton];
    
    self.ApplyWithdrawalButton = ApplyWithdrawalButton;
}

/**
 * @brief 申请提现的点击事件
 */
- (void)ApplyWithdrawalButtonClickAction:(UIButton *)sender{
    
    // 验证是否绑定手机
    
    [[HSQProgressHUDManger Manger] ShowLoadingDataFromeServer:@"" ToView:self.view IsClearColor:YES];
    
    NSDictionary *diction = @{@"token":[HSQAccountTool account].token};
    
    AFNetworkRequestTool *RequestTool = [AFNetworkRequestTool shareRequestTool];
    
    [RequestTool.manger POST:UrlAdress(KUserCenterDataUrl) parameters:diction progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *responseObject) {
        
        HSQLog(@"=用户中心的数据==%@",responseObject);
        
        [[HSQProgressHUDManger Manger] DismissProgressHUD];
        
        if ([responseObject[@"code"] integerValue] == 200)
        {
            // 手机是否绑定 1-已绑定，0-未绑定
            NSString *mobileIsBind = [NSString stringWithFormat:@"%@",responseObject[@"datas"][@"memberInfo"][@"mobileIsBind"]];
            
            // 支付密码是否绑定 1-已绑定，0-未绑定
            NSString *payPwdIsExist = [NSString stringWithFormat:@"%@",responseObject[@"datas"][@"memberInfo"][@"payPwdIsExist"]];
            
            if (mobileIsBind.integerValue == 1 && payPwdIsExist.integerValue == 1) // 跳转至设置界面
            {
                NSString *Mobile = [NSString stringWithFormat:@"%@",responseObject[@"datas"][@"memberInfo"][@"mobile"]];
                
                HSQBandMobileViewController *BandMobileVC = [[HSQBandMobileViewController alloc] init];
                
                BandMobileVC.NavtionTitle = @"手机安全验证";
                
                BandMobileVC.sendType = @"5";
                
                BandMobileVC.Source = 600;
                
                BandMobileVC.MobileString = Mobile;
                
                [self.navigationController pushViewController:BandMobileVC animated:YES];
            }
            else
            {
                HSQSetingViewController *setvc = [[HSQSetingViewController alloc] init];
                
                [self.navigationController pushViewController:setvc animated:YES];
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [[HSQProgressHUDManger Manger] ShowDisplayFailedToLoadData:@"网络出问题啦！" SuperView:self.view];
    }];
    
 
    
}

/**
 * @brief 创建tableView
 */
- (void)CreatTableView{
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - KSafeTopeHeight - KSafeBottomHeight - 100 - 44) style:(UITableViewStylePlain)];
    
    tableView.backgroundColor = [UIColor clearColor];
    
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    tableView.delegate = self;
    
    tableView.dataSource = self;
    
    [tableView registerClass:[HSQCommissionWithdrawalListCell class] forCellReuseIdentifier:@"HSQCommissionWithdrawalListCell"];
    
    [self.view addSubview:tableView];
    
    self.tableView = tableView;
}

/**
 * @brief 添加刷新控件
 */
- (void)AddPromotionCommissionWithdrawalListRefreshControls{
    
    // 1.下拉加载更多的数据
    self.tableView.mj_header  = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(LoadNewPromotionCommissionWithdrawalListData)];
    
    [self.tableView.mj_header beginRefreshing];
    
    // 3.上啦加载更多的代码
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(LoadMorePromotionCommissionWithdrawalListData)];
}

/**
 * @brief 加载最新的预存款提现数据
 */
- (void)LoadNewPromotionCommissionWithdrawalListData{
    
    [[HSQProgressHUDManger Manger] ShowLoadingDataFromeServer:@"" ToView:self.view IsClearColor:YES];
    
    // 0.清空数组
    [self.dataSource removeAllObjects];
    
    // 结束上啦
    [self.tableView.mj_footer endRefreshing];
    
    self.currentPage = 1;
    
    NSDictionary *params = @{@"token":[HSQAccountTool account].token,@"page":@(self.currentPage)};
    
    AFNetworkRequestTool *requestTool = [AFNetworkRequestTool shareRequestTool];
    
    [requestTool.manger POST:UrlAdress(KWithdrawalListUrl) parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [[HSQProgressHUDManger Manger] DismissProgressHUD];
        
        HSQLog(@"===预存款提现数据===%@",responseObject);
        
        self.totalPage = [NSString stringWithFormat:@"%@",responseObject[@"datas"][@"pageEntity"][@"totalPage"]];
        
        if ([responseObject[@"code"] integerValue] == 200)
        {
            self.dataSource = [HSQCommissionWithdrawaLlisModel mj_objectArrayWithKeyValuesArray:responseObject[@"datas"][@"cashList"]];
        }
        else
        {
            NSString *errorString = [NSString stringWithFormat:@"%@",responseObject[@"datas"][@"error"]];
            
            [[HSQProgressHUDManger Manger] ShowDisplayFailedToLoadData:errorString SuperView:self.view];
        }
        
        if (self.dataSource.count == 0)
        {
            [self.tableView addSubview:self.noDataView];
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
 * @brief 加载更多的预存款提现数据
 */
- (void)LoadMorePromotionCommissionWithdrawalListData{
    
    [self.tableView.mj_header endRefreshing];
    
    NSDictionary *params = @{@"token":[HSQAccountTool account].token,@"page":@(++self.currentPage)};
    
    AFNetworkRequestTool *requestTool = [AFNetworkRequestTool shareRequestTool];
    
    [requestTool.manger POST:UrlAdress(KWithdrawalListUrl) parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [[HSQProgressHUDManger Manger] DismissProgressHUD];
        
        HSQLog(@"===预存款提现数据===%@",responseObject);
        
        if ([responseObject[@"code"] integerValue] == 200)
        {
            NSArray *cashList = [HSQCommissionWithdrawaLlisModel mj_objectArrayWithKeyValuesArray:responseObject[@"datas"][@"cashList"]];
            
            if (cashList.count == 0)
            {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
            else
            {
                [self.dataSource addObjectsFromArray:cashList];
            }
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
 * @brief 监听提现是否成功
 */
- (void)AdvanceWithdrawalSuccess:(NSNotification *)notif{
    
    [self.tableView.mj_header beginRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
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
    
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return [self.tableView cellHeightForIndexPath:indexPath model:self.dataSource[indexPath.row] keyPath:@"model" cellClass:[HSQCommissionWithdrawalListCell class] contentViewWidth:KScreenWidth];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return [self.tableView cellHeightForIndexPath:indexPath model:self.dataSource[indexPath.row] keyPath:@"model" cellClass:[HSQCommissionWithdrawalListCell class] contentViewWidth:KScreenWidth];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HSQCommissionWithdrawalListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HSQCommissionWithdrawalListCell" forIndexPath:indexPath];
    
    cell.model = self.dataSource[indexPath.row];
    
    // 此步设置用于实现cell的frame缓存，可以让tableview滑动更加流畅
    [cell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    HSQCommissionWithdrawaLlisModel *model = self.dataSource[indexPath.row];
    
    HSQShowDetailsViewController *ShowDetailsVC = [[HSQShowDetailsViewController alloc] init];
    
    ShowDetailsVC.cashId = model.cashId;
    
    ShowDetailsVC.source = 100;
    
    [self.navigationController pushViewController:ShowDetailsVC animated:YES];
}









@end
