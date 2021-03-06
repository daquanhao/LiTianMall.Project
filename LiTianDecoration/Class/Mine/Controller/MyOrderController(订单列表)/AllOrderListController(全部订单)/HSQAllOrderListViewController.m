//
//  HSQAllOrderListViewController.m
//  LiTianDecoration
//
//  Created by administrator on 2018/5/26.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import "HSQAllOrderListViewController.h"
#import "HSQOrderListFirstCengModel.h"
#import "HSQAccountTool.h"
#import "HSQOrderGoodsListCell.h"
#import "HSQOrderListFooterView.h"
#import "HSQOrderListHeaderView.h"
#import "HSQShopCarGoodsTypeListModel.h"
#import "HSQOrderGoodsListBgView.h"
#import "HSQStoreDetailViewController.h"
#import "HSQEvaluationOrderViewController.h"
#import "HSQZhuiJiaRateViewController.h"
#import "HSQMallShopCarViewController.h"
#import "HSQOrderDetailViewController.h"
#import "HSQPayMoneryView.h"   // 支付界面
#import "HSQPayMonerySuccessViewController.h"  // 支付成功界面

@interface HSQAllOrderListViewController ()<UITableViewDelegate,UITableViewDataSource,HSQOrderListFooterViewDelegate,HSQOrderGoodsListCellDelegate,HSQPayMoneryViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, assign) NSInteger currentPage; // 当前的页数

@property (nonatomic, strong) HSQNoDataView *noDataView;

@property (nonatomic, copy) NSString *keyword; // 搜索的关键字

@property (nonatomic, copy) NSString *totalPage; // 总页数

@property (nonatomic, copy) NSString *payId; // 支付单Id

@end

@implementation HSQAllOrderListViewController

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
    
    // 1.创建tableView
    [self CreatTableView];
    
    // 2.添加刷新控件
    [self AddRefreshControls];
    
    // 监听支付成功界面的消息
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(AllOrderLookUpOrderNotif:) name:@"LookUpOrderNotif" object:nil];
    
}

/**
 * @brief 监听支付成功界面的消息
 */
- (void)AllOrderLookUpOrderNotif:(NSNotification *)notif{
    
    [self.tableView.mj_header beginRefreshing];
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
    
    [tableView registerNib:[UINib nibWithNibName:@"HSQOrderGoodsListCell" bundle:nil] forCellReuseIdentifier:@"HSQOrderGoodsListCell"];
    
    [tableView registerClass:[HSQOrderListFooterView class] forHeaderFooterViewReuseIdentifier:@"HSQOrderListFooterView"];
    
    [tableView registerClass:[HSQOrderListHeaderView class] forHeaderFooterViewReuseIdentifier:@"HSQOrderListHeaderView"];
    
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
    
    // 0.清空数组
    [self.dataSource removeAllObjects];
    
    // 结束上啦
    [self.tableView.mj_footer endRefreshing];
    
    self.currentPage = 1;
    
    HSQAccount *account = [HSQAccountTool account];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"token"] = account.token;
    params[@"page"] = @(self.currentPage);
    if (self.keyword.length != 0)
    {
        params[@"keyword"] = self.keyword;
    }
    
    AFNetworkRequestTool *requestTool = [AFNetworkRequestTool shareRequestTool];
    
    [requestTool.manger POST:UrlAdress(KOrderListUrl) parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [[HSQProgressHUDManger Manger] DismissProgressHUD];
        
        HSQLog(@"===订单数据===%@",responseObject);
        
        self.totalPage = [NSString stringWithFormat:@"%@",responseObject[@"datas"][@"pageEntity"][@"totalPage"]];
        
        if ([responseObject[@"code"] integerValue] == 200)
        {
            // 取出商品的数据
            [self QuChuGoodsDataFromeServer:responseObject];
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
        [[HSQProgressHUDManger Manger] ShowProgressHUDPromptText:@"网络出现问题" SupView:self.view];
    }];
}

/**
 * @brief 加载更多的订单数据
 */
- (void)LoadMoreWaitPayMoneryOrderData{
    
    [self.tableView.mj_header endRefreshing];
    
    HSQAccount *account = [HSQAccountTool account];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"token"] = account.token;
    params[@"page"] = @(++self.currentPage);
    if (self.keyword.length != 0)
    {
        params[@"keyword"] = self.keyword;
    }
    
    AFNetworkRequestTool *requestTool = [AFNetworkRequestTool shareRequestTool];
    
    [requestTool.manger POST:UrlAdress(KOrderListUrl) parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [[HSQProgressHUDManger Manger] DismissProgressHUD];
        
        HSQLog(@"===加载更多订单数据===%@",responseObject);
        
        if ([responseObject[@"code"] integerValue] == 200)
        {
            // 取出商品的数据
            [self QuChuGoodsDataFromeServer:responseObject];
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

/**
 * @brief 取出商品的数据
 */
- (void)QuChuGoodsDataFromeServer:(NSDictionary *)responseObject{
    
    NSArray *ordersPayVoList = responseObject[@"datas"][@"ordersPayVoList"];
    
    if (ordersPayVoList.count == 0)
    {
        [self.tableView addSubview:self.noDataView];
    }
    else
    {
        // 中间的规格列表
        for (NSDictionary *dict in responseObject[@"datas"][@"ordersPayVoList"]){
            
            // 外层数据 有多少个分区
            HSQOrderListFirstCengModel *FirstModel = [[HSQOrderListFirstCengModel alloc] initWithDictionary:dict error:nil];
            
            FirstModel.ordersVoList = [NSMutableArray array];
            
            [self.dataSource addObject:FirstModel];
            
            // 内层数据 每个店铺有几个cell
            for (NSInteger i = 0; i < [dict[@"ordersVoList"] count] ; i++) {
                
                NSDictionary *ModelDiction = dict[@"ordersVoList"][i];
                
                HSQOrderListSecondCengModel *SecondModel = [[HSQOrderListSecondCengModel alloc] init];
                
                SecondModel.ordersGoodsVoList_array = [NSMutableArray array];
                
                [SecondModel setValuesForKeysWithDictionary:ModelDiction];
                
                [FirstModel.ordersVoList addObject:SecondModel];
                
                // 每个商品下有几种规格
                for (NSDictionary *ThirdDiction in ModelDiction[@"ordersGoodsVoList"]) {
                    
                    HSQShopCarGoodsTypeListModel *ThirdModel = [[HSQShopCarGoodsTypeListModel alloc] init];
                    
                    [ThirdModel setValuesForKeysWithDictionary:ThirdDiction];
                    
                    [SecondModel.ordersGoodsVoList_array addObject:ThirdModel];
                }
            }
        }
    }
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
    
    HSQOrderListFirstCengModel *FirstModel = self.dataSource[section];
    
    return FirstModel.ordersVoList.count;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section{
    
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 5;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    HSQOrderListHeaderView *HeaderView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"HSQOrderListHeaderView"];
    
    return HeaderView;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForFooterInSection:(NSInteger)section{
    
    HSQOrderListFirstCengModel *FirstModel = self.dataSource[section];
    
    if (FirstModel.ordersOnlineDiffAmount.integerValue > 0) // 待支付
     {
         return 50;
     }
    else
    {
        return 5;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    HSQOrderListFirstCengModel *FirstModel = self.dataSource[section];
    
    if (FirstModel.ordersOnlineDiffAmount.integerValue > 0) // 待支付
    {
        return 50;
    }
    else
    {
        return 5;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    HSQOrderListFooterView *FooterView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"HSQOrderListFooterView"];
    
    FooterView.model = self.dataSource[section];
    
    FooterView.Section = section;
    
    FooterView.delegate = self;
    
    return FooterView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    HSQOrderListFirstCengModel *FirstModel = self.dataSource[indexPath.section];
    
    HSQOrderListSecondCengModel *SecondModel = FirstModel.ordersVoList[indexPath.row];
    
    CGSize photosSize = [HSQOrderGoodsListBgView SizeWithDataModelArray:SecondModel.ordersGoodsVoList_array];
    
    if (SecondModel.ordersState.integerValue == 10 || SecondModel.ordersState.integerValue == 0 || SecondModel.ordersState.integerValue == 40)  // 待支付，已取消，已完成
    {
         return 125 + photosSize.height;
    }
    else
    {
        if (SecondModel.showRefundWaiting.integerValue == 1)
        {
            return 125 + photosSize.height;
        }
        else
        {
            return 85 + photosSize.height;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HSQOrderGoodsListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HSQOrderGoodsListCell" forIndexPath:indexPath];
    
    HSQOrderListFirstCengModel *FirstModel = self.dataSource[indexPath.section];
    
    cell.model = FirstModel.ordersVoList[indexPath.row];
    
    cell.delegate = self;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    HSQOrderListFirstCengModel *FirstModel = self.dataSource[indexPath.section];
    
    HSQOrderListSecondCengModel *secondModel = FirstModel.ordersVoList[indexPath.row];
    
    HSQOrderDetailViewController *OrderDetailVC = [[HSQOrderDetailViewController alloc] init];
    
    OrderDetailVC.ordersId = secondModel.ordersId;
        
    OrderDetailVC.OrderDetailTealSuccessModel = ^(id success) {

        [self.tableView.mj_header beginRefreshing];
    };

    [self.navigationController pushViewController:OrderDetailVC animated:YES];
    
}

/**
 * @brief 底部支付按钮的点击
 */
- (void)hsqOrderListFooterViewBottomButtonClickAction:(UIButton *)sender{
    
    HSQOrderListFooterView *footerView = (HSQOrderListFooterView *)sender.superview.superview;
    
    HSQOrderListFirstCengModel *FirstModel = self.dataSource[footerView.Section];
    
    [[HSQProgressHUDManger Manger] ShowLoadingDataFromeServer:@"" ToView:self.view IsClearColor:YES];
    
    HSQAccount *account = [HSQAccountTool account];
    
    NSDictionary *params = @{@"token":account.token,@"clientType":@"app",@"payId":FirstModel.payId};
    
    AFNetworkRequestTool *requestTool = [AFNetworkRequestTool shareRequestTool];
    
    [requestTool.manger POST:UrlAdress(KGetUserPayTypeListUrl) parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [[HSQProgressHUDManger Manger] DismissProgressHUD];
        
        HSQLog(@"===支付数据===%@",responseObject);
        
        if ([responseObject[@"code"] integerValue] == 200)
        {
            [self PopUpPaymentInterfaceViewWithData:responseObject[@"datas"]];
            
            // 支付单Id
            self.payId = [NSString stringWithFormat:@"%@",responseObject[@"datas"][@"payId"]];
        }
        else
        {
            NSString *errorString = [NSString stringWithFormat:@"%@",responseObject[@"datas"][@"error"]];
            
            [[HSQProgressHUDManger Manger] ShowDisplayFailedToLoadData:errorString SuperView:self.view];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        // 提示数据请求失败
        [[HSQProgressHUDManger Manger] ShowProgressHUDPromptText:@"网络出现问题" SupView:self.view];
    }];
    
}


/**
 * @brief 弹出支付界面
 */
- (void)PopUpPaymentInterfaceViewWithData:(NSDictionary *)diction{
    
    HSQPayMoneryView *payMonery = [HSQPayMoneryView initPayMoneryView];
    
    payMonery.datas = diction;
    
    payMonery.delegate = self;
    
    [payMonery ShowPayMoneryView];
    
}

/**
 * @brief 选择支付方式的回调,      此方法使用预存款支付
 */
- (void)ConfirmTheClickEventOfThePayButton:(UIButton *)sender PassWord:(NSString *)PayPassWord{
    
    [[HSQProgressHUDManger Manger] ShowLoadingDataFromeServer:@"" ToView:self.view IsClearColor:YES];
    
    NSDictionary *params = @{@"token":[HSQAccountTool account].token,@"payId":self.payId,@"predepositPay":@"1",@"payPwd":PayPassWord};
    
    AFNetworkRequestTool *requestTool = [AFNetworkRequestTool shareRequestTool];
    
    [requestTool.manger POST:UrlAdress(KYuCunKuanPayMoneryUrl) parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [[HSQProgressHUDManger Manger] DismissProgressHUD];
        
        HSQLog(@"==支付===%@==%@",responseObject,params);
        
        HSQPayMonerySuccessViewController *PayMoneryVC = [[HSQPayMonerySuccessViewController alloc] init];
        
        if ([responseObject[@"code"] integerValue] == 200)
        {
            PayMoneryVC.payId = [NSString stringWithFormat:@"%@",responseObject[@"datas"][@"payId"]];
        }
        else
        {
            PayMoneryVC.Code = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
        }
        
        [self.navigationController pushViewController:PayMoneryVC animated:YES];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [[HSQProgressHUDManger Manger] ShowDisplayFailedToLoadData:@"网络出问题啦！" SuperView:self.view];
        
    }];
}


/**
 * @brief 删除订单
 */
- (void)DeleteOrderButtonClickAction:(UIButton *)sender{
    
    HSQOrderGoodsListCell *cell = (HSQOrderGoodsListCell *)sender.superview.superview.superview;
    
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    HSQOrderListFirstCengModel *FirstModel = self.dataSource[indexPath.section];
    
    HSQOrderListSecondCengModel *secondModel = FirstModel.ordersVoList[indexPath.row];
    
    if (secondModel.ordersState.integerValue == 40 || secondModel.ordersState.integerValue == 0)
    {
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:@"确认删除该订单？" preferredStyle:(UIAlertControllerStyleAlert)];
        
        UIAlertAction *Cancel_action = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:nil];
        
        UIAlertAction *delete_action = [UIAlertAction actionWithTitle:@"删除" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            
            [self DeleteOrderFromeServerWithModel:secondModel];
        }];
        
        [alertVC addAction:delete_action];
        
        [alertVC addAction:Cancel_action];
        
        [self presentViewController:alertVC animated:YES completion:nil];
        
    }
}

/**
 * @brief 删除订单
 */
- (void)DeleteOrderFromeServerWithModel:(HSQOrderListSecondCengModel *)secondModel{
    
    [[HSQProgressHUDManger Manger] ShowLoadingDataFromeServer:@"" ToView:self.view IsClearColor:YES];
    
    HSQAccount *account = [HSQAccountTool account];
    
    NSDictionary *params = @{@"token":account.token,@"ordersId":secondModel.ordersId};
    
    AFNetworkRequestTool *requestTool = [AFNetworkRequestTool shareRequestTool];
    
    [requestTool.manger POST:UrlAdress(KDeteleOrderUrl) parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [[HSQProgressHUDManger Manger] DismissProgressHUD];
        
        HSQLog(@"===删除订单===%@",responseObject);
        
        if ([responseObject[@"code"] integerValue] == 200)
        {
            [self.dataSource removeObject:secondModel];
        }
        else
        {
            NSString *errorString = [NSString stringWithFormat:@"%@",responseObject[@"datas"][@"error"]];
            
            [[HSQProgressHUDManger Manger] ShowDisplayFailedToLoadData:errorString SuperView:self.view];
        }
        
        [self.tableView reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        // 提示数据请求失败
        [[HSQProgressHUDManger Manger] ShowProgressHUDPromptText:@"网络出现问题" SupView:self.view];
    }];
}

/**
 * @brief 进入店铺
 */
- (void)JoinStoreButtonClickAction:(UIButton *)sender{
    
    HSQOrderGoodsListCell *cell = (HSQOrderGoodsListCell *)sender.superview.superview.superview;
    
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    HSQOrderListFirstCengModel *FirstModel = self.dataSource[indexPath.section];
    
    HSQOrderListSecondCengModel *secondModel = FirstModel.ordersVoList[indexPath.row];
    
    HSQStoreDetailViewController *StoreVC = [[HSQStoreDetailViewController alloc] init];
    
    StoreVC.storeId = secondModel.storeId;
    
    [self.navigationController pushViewController:StoreVC animated:YES];
}

/**
 * @brief 评价订单或者追加评论
 */
- (void)EvaluationOfTheOrderButtonClickAction:(UIButton *)sender{
    
    HSQOrderGoodsListCell *cell = (HSQOrderGoodsListCell *)sender.superview.superview.superview;
    
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    HSQOrderListFirstCengModel *FirstModel = self.dataSource[indexPath.section];
    
    HSQOrderListSecondCengModel *secondModel = FirstModel.ordersVoList[indexPath.row];
    
    if (secondModel.ordersState.integerValue == 40) // 交易完成，等待评价
    {
        if (secondModel.showEvaluationAppend.integerValue == 0)  // 第一次评论
        {
            HSQEvaluationOrderViewController *EvaluationOrderVC = [[HSQEvaluationOrderViewController alloc] init];
            
            EvaluationOrderVC.orderId = secondModel.ordersId;
            
            EvaluationOrderVC.SelectFirstRateSuccessModel = ^(id success) {
                
                [self.tableView.mj_header beginRefreshing];
                
            };
            
            [self.navigationController pushViewController:EvaluationOrderVC animated:YES];
        }
        else  // 追加评论
        {
            HSQZhuiJiaRateViewController *ZhuiJiaRateOrderVC = [[HSQZhuiJiaRateViewController alloc] init];
            
            ZhuiJiaRateOrderVC.orderId = secondModel.ordersId;
            
            [self.navigationController pushViewController:ZhuiJiaRateOrderVC animated:YES];
        }
    }
}

/**
 * @brief 再次购买，
 */
- (void)OrderCancelBtnClickAction:(UIButton *)sender{
    
    HSQOrderGoodsListCell *cell = (HSQOrderGoodsListCell *)sender.superview.superview.superview;
    
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    HSQOrderListFirstCengModel *FirstOrderModel = self.dataSource[indexPath.section];
    
    HSQOrderListSecondCengModel *secondOrderModel = FirstOrderModel.ordersVoList[indexPath.row];
    
    HSQLog(@"====再次购买==%@",secondOrderModel.ordersState);
    
    if (secondOrderModel.ordersState.integerValue == 40) // 购买完成，等待平台的状态
    {
        [self NotifyTheServerToPurchaseAgainWithBtn:secondOrderModel];
    }
}

/**
 * @brief 通知服务器再次购买
 */
- (void)NotifyTheServerToPurchaseAgainWithBtn:(HSQOrderListSecondCengModel *)model{
    
    [[HSQProgressHUDManger Manger] ShowLoadingDataFromeServer:@"" ToView:self.view IsClearColor:YES];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"token"] = [HSQAccountTool account].token;
    params[@"ordersId"] = model.ordersId;
    params[@"clientType"] = KClientType;
    
    AFNetworkRequestTool *requestTool = [AFNetworkRequestTool shareRequestTool];
    
    [requestTool.manger POST:UrlAdress(KOrderRepurchaseInterfaceUrl) parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
    
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
    
        if ([responseObject[@"code"] integerValue] == 200)
        {
            HSQMallShopCarViewController *shopCarVC = [[HSQMallShopCarViewController alloc] init];
    
            shopCarVC.source = @"100";
    
            [self.navigationController pushViewController:shopCarVC animated:YES];
        }
        else
        {
            NSString *errorString = [NSString stringWithFormat:@"%@",responseObject[@"datas"][@"error"]];
    
            [[HSQProgressHUDManger Manger] ShowDisplayFailedToLoadData:errorString SuperView:self.view];
        }
    
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    
        [[HSQProgressHUDManger Manger] ShowProgressHUDPromptText:@"网络出问题啦！" SupView:self.view];
    
    }];

}




@end
