//
//  HSQPointExchangeGoodsOrderViewController.m
//  LiTianDecoration
//
//  Created by administrator on 2018/6/22.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import "HSQPointExchangeGoodsOrderViewController.h"
#import "HSQHomeTabBarController.h"
#import "HSQAccountTool.h"
#import "HSQPointsOrdersListModel.h"
#import "HSQPointExchangeGoodsOrderListCell.h"
#import "HSQStoreDetailViewController.h"
#import "HSQPointExchangeGoodsHeadView.h"
#import "HSQPointExchangeGoodsFooterView.h"
#import "HSQPointExchangeOrderDetailViewController.h"

@interface HSQPointExchangeGoodsOrderViewController ()<UITableViewDelegate,UITableViewDataSource,HSQPointExchangeGoodsHeadViewDelegate,HSQPointExchangeGoodsFooterViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, assign) NSInteger currentPage; // 当前的页数

@property (nonatomic, strong) HSQNoDataView *noDataView;

@property (nonatomic, copy) NSString *totalPage; // 总页数

@property (nonatomic, assign) NSInteger section;

@end

@implementation HSQPointExchangeGoodsOrderViewController

-(NSMutableArray *)dataSource{
    
    if (_dataSource == nil) {
        
        self.dataSource = [NSMutableArray array];
    }
    
    return _dataSource;
}

- (HSQNoDataView *)noDataView{
    
    if (!_noDataView) {
        
        _noDataView = [[HSQNoDataView alloc] initWithTitle:@"亲，还没有相关的订单额" imageName:@"WaitingForView" height:50 TopMargin:0];
    }
    return _noDataView;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.view.backgroundColor = KViewBackGroupColor;
    
    self.navigationItem.title = @"积分兑换";
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:KImageName(@"LeftBackIcon") style:(UIBarButtonItemStylePlain) target:self action:@selector(LeftItemBackAction:)];
    
    // 创建tableView
    [self CreatTableView];
    
    // 添加刷新控件
    [self AddRefreshControls];
    
    // 监听订单详情的修改
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(OrderStateChangeSuccessNotif:) name:@"OrderStateChangeSuccessNotif" object:nil];
}

/**
 * @brief 返回按钮
 */
- (void)LeftItemBackAction:(UIBarButtonItem *)sender{
    
    if (self.source == 100)
    {
        HSQHomeTabBarController *tabbar = (HSQHomeTabBarController *)self.tabBarController;
        
        tabbar.selectedIndex = 4;
        
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}


/**
 * @brief 创建tableView
 */
- (void)CreatTableView{
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - KSafeTopeHeight - KSafeBottomHeight) style:(UITableViewStyleGrouped)];
    
    tableView.backgroundColor = [UIColor clearColor];
    
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    tableView.delegate = self;

    tableView.dataSource = self;
    
    [tableView registerClass:[HSQPointExchangeGoodsOrderListCell class] forCellReuseIdentifier:@"HSQPointExchangeGoodsOrderListCell"];
    
    [tableView registerClass:[HSQPointExchangeGoodsHeadView class] forHeaderFooterViewReuseIdentifier:@"HSQPointExchangeGoodsHeadView"];
    
     [tableView registerClass:[HSQPointExchangeGoodsFooterView class] forHeaderFooterViewReuseIdentifier:@"HSQPointExchangeGoodsFooterView"];
    
    [self.view addSubview:tableView];
    
    self.tableView = tableView;
}

/**
 * @brief 添加刷新控件
 */
- (void)AddRefreshControls{
    
    // 1.下拉加载更多的数据
    self.tableView.mj_header  = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(LoadNewPointExchangeOrderListData)];
    
    [self.tableView.mj_header beginRefreshing];
    
    // 3.上啦加载更多的代码
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(LoadMorePointExchangeOrderListData)];
}

/**
 * @brief 加载最新的订单数据
 */
- (void)LoadNewPointExchangeOrderListData{
    
    [[HSQProgressHUDManger Manger] ShowLoadingDataFromeServer:@"" ToView:self.view IsClearColor:YES];
    
    // 0.清空数组
    [self.dataSource removeAllObjects];
    
    // 结束上啦
    [self.tableView.mj_footer endRefreshing];
    
    self.currentPage = 1;
    
    NSDictionary *params = @{@"token":[HSQAccountTool account].token, @"page":@(self.currentPage)};

    AFNetworkRequestTool *requestTool = [AFNetworkRequestTool shareRequestTool];
    
    [requestTool.manger POST:UrlAdress(KpointExchangeGoodsOrderListUrl) parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [[HSQProgressHUDManger Manger] DismissProgressHUD];
        
        HSQLog(@"===订单数据===%@",responseObject);
        
        self.totalPage = [NSString stringWithFormat:@"%@",responseObject[@"datas"][@"pageEntity"][@"totalPage"]];
        
        if ([responseObject[@"code"] integerValue] == 200)
        {
            self.dataSource = [HSQPointsOrdersListModel mj_objectArrayWithKeyValuesArray:responseObject[@"datas"][@"pointsOrdersList"]];
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
- (void)LoadMorePointExchangeOrderListData{
    
    [self.tableView.mj_header endRefreshing];
    
    NSDictionary *params = @{@"token":[HSQAccountTool account].token, @"page":@(++self.currentPage)};
    
    AFNetworkRequestTool *requestTool = [AFNetworkRequestTool shareRequestTool];
    
    [requestTool.manger POST:UrlAdress(KpointExchangeGoodsOrderListUrl) parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [[HSQProgressHUDManger Manger] DismissProgressHUD];
        
        HSQLog(@"===加载更多订单数据===%@",responseObject);
        
        if ([responseObject[@"code"] integerValue] == 200)
        {
            NSArray *pointsOrdersList = [HSQPointsOrdersListModel mj_objectArrayWithKeyValuesArray:responseObject[@"datas"][@"pointsOrdersList"]];
            
            [self.dataSource addObjectsFromArray:pointsOrdersList];
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
        [[HSQProgressHUDManger Manger] ShowProgressHUDPromptText:@"网络出现问题" SupView:self.view];
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
     return 1;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section{
    
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 50;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    HSQPointExchangeGoodsHeadView *HeadView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"HSQPointExchangeGoodsHeadView"];
    
    HeadView.section = section;
    
    HeadView.delegate = self;
    
    HeadView.model = self.dataSource[section];
    
    return HeadView;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForFooterInSection:(NSInteger)section{
    
    HSQPointsOrdersListModel *model = self.dataSource[section];
    
    if (model.pointsOrdersState.integerValue == 0 || model.pointsOrdersState.integerValue == 30)
    {
        return 41;
    }
    else
    {
         return 82;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    HSQPointsOrdersListModel *model = self.dataSource[section];
    
    if (model.pointsOrdersState.integerValue == 0 || model.pointsOrdersState.integerValue == 30)
    {
        return 41;
    }
    else
    {
        return 82;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    HSQPointExchangeGoodsFooterView *footerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"HSQPointExchangeGoodsFooterView"];
    
    footerView.section = section;
    
    footerView.model = self.dataSource[section];
    
    footerView.delegate = self;
    
    return footerView;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    HSQPointsOrdersListModel *model = self.dataSource[indexPath.section];
    
    return [self.tableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:[HSQPointExchangeGoodsOrderListCell class] contentViewWidth:KScreenWidth];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HSQPointExchangeGoodsOrderListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HSQPointExchangeGoodsOrderListCell" forIndexPath:indexPath];
    
    cell.model = self.dataSource[indexPath.section];
        
    // 此步设置用于实现cell的frame缓存，可以让tableview滑动更加流畅
    [cell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    self.section = indexPath.section;
    
    HSQPointsOrdersListModel *model = self.dataSource[indexPath.section];
    
    HSQPointExchangeOrderDetailViewController *OrderDetailVC = [[HSQPointExchangeOrderDetailViewController alloc] init];
    
    OrderDetailVC.pointsOrdersId = model.pointsOrdersId;
    
    [self.navigationController pushViewController:OrderDetailVC animated:YES];
}

/**
 * @brief 取消订单
 */
- (void)CancelPointExchangeGoodsOrderButtonClickAction:(UIButton *)sender{
    
    HSQPointExchangeGoodsOrderListCell *cell = (HSQPointExchangeGoodsOrderListCell *)sender.superview.superview.superview;
    
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    HSQPointsOrdersListModel *model = self.dataSource[indexPath.row];
    
    NSString *title_string = @"";
    
    if (model.pointsOrdersState.integerValue == 20) // 确认收货
    {
        title_string = @"确认收到该货物？";
    }
    else
    {
        title_string = @"确认取消订单？";
    }
    
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:title_string preferredStyle:(UIAlertControllerStyleAlert)];
    
    UIAlertAction *Cancel_action = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:nil];
    
    UIAlertAction *delete_action = [UIAlertAction actionWithTitle:@"确认" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        
        [self CancelOrderNotifserverWithIndex:model];
    }];
    
    [alertVC addAction:delete_action];
    
    [alertVC addAction:Cancel_action];
    
    [self presentViewController:alertVC animated:YES completion:nil];

}

/**
 * @brief 通知服务器，取消订单 或者 确认收货
 */
- (void)CancelOrderNotifserverWithIndex:(HSQPointsOrdersListModel *)model{
    
    NSString *Url = (model.pointsOrdersState.integerValue == 20 ? UrlAdress(KPointGoodsQRShouHuoUrl) : UrlAdress(KCancelPointGoodsOrderUrl));
    
    [[HSQProgressHUDManger Manger] ShowLoadingDataFromeServer:@"" ToView:self.view IsClearColor:YES];
    
    NSDictionary *params = @{@"token":[HSQAccountTool account].token,@"pointsOrdersId":model.pointsOrdersId};
    
    AFNetworkRequestTool *requestTool = [AFNetworkRequestTool shareRequestTool];
    
    [requestTool.manger POST:Url parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        HSQLog(@"==数据==%@===%@==%@",responseObject,model.pointsOrdersState,model.pointsOrdersStateText);
        
        [[HSQProgressHUDManger Manger] DismissProgressHUD];
        
        if ([responseObject[@"code"] integerValue] == 200)
        {
            if (model.pointsOrdersState.integerValue == 20) // 确认收货
            {
                model.pointsOrdersState = @"30";
                
                model.pointsOrdersStateText = @"已完成";
            }
            else if (model.pointsOrdersState.integerValue == 10) // 取消订单
            {
                model.pointsOrdersState = @"0";
                
                model.pointsOrdersStateText = @"已取消";
            }
        }
        else
        {
            NSString *errorString = [NSString stringWithFormat:@"%@",responseObject[@"datas"][@"error"]];
            
            [[HSQProgressHUDManger Manger] ShowDisplayFailedToLoadData:errorString SuperView:self.view];
        }
        
        [self.tableView reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [[HSQProgressHUDManger Manger] ShowProgressHUDPromptText:KErrorPlacherString SupView:self.view];
        
    }];
}

/**
 * @brief 进入店铺详情
 */
- (void)JoinGoodsInStoreHomePageWithBtnClickAction:(UIButton *)sender{
    
    HSQPointExchangeGoodsOrderListCell *cell = (HSQPointExchangeGoodsOrderListCell *)sender.superview.superview.superview;
    
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    HSQPointsOrdersListModel *model = self.dataSource[indexPath.row];
    
    HSQStoreDetailViewController *StoreVC = [[HSQStoreDetailViewController alloc] init];
    
    StoreVC.storeId = model.storeId;
    
    [self.navigationController pushViewController:StoreVC animated:YES];
    
}

/**
 * @brief 监听订单详情的修改
 */
- (void)OrderStateChangeSuccessNotif:(NSNotification *)notif{
    
    NSString *pointsOrdersState = notif.userInfo[@"pointsOrdersState"];
    
    HSQPointsOrdersListModel *model = self.dataSource[self.section];
    
    if (pointsOrdersState.integerValue == 10)
    {
        model.pointsOrdersState = @"0";
        
        model.pointsOrdersStateText = @"已取消";
    }
    else if (pointsOrdersState.integerValue == 20)
    {
        model.pointsOrdersState = @"30";
        
        model.pointsOrdersStateText = @"已完成";
    }
    
    [self.tableView reloadData];

}

- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}






@end
