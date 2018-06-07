//
//  HSQOrderDetailViewController.m
//  LiTianDecoration
//
//  Created by administrator on 2018/6/1.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import "HSQOrderDetailViewController.h"
#import "HSQOrderListFirstCengModel.h"
#import "HSQOrderDetailHeaderView.h"
#import "HSQShopCarGoodsTypeListModel.h"
#import "HSQOrderDetailFooterView.h"
#import "HSQOrderDetailGoodsLisCell.h"
#import "HSQAccountTool.h"
#import "HSQEvaluationOrderViewController.h"
#import "HSQZhuiJiaRateViewController.h"
#import "HSQComplaintsViewController.h"    // 投诉
#import "HSQTuiGoodsViewController.h"  // 退货
#import "HSQTuiMoneryViewController.h" // 退款
#import "HSQTuiGoodAndMoneryDetailViewController.h"  // 投诉详情
#import "HSQGoodsRefundViewController.h"

@interface HSQOrderDetailViewController ()<UITableViewDelegate,UITableViewDataSource,HSQOrderDetailFooterViewDelegate,HSQOrderDetailGoodsLisCellDelegate>

@property (nonatomic, strong) NSDictionary *dataDiction;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation HSQOrderDetailViewController

-(NSMutableArray *)dataSource{
    
    if (_dataSource == nil) {
        
        self.dataSource = [NSMutableArray array];
    }
    
    return _dataSource;
}


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.view.backgroundColor = KViewBackGroupColor;
    
    self.navigationItem.title = @"订单详情";
    
    self.dataDiction = [NSDictionary dictionary];
    
    // 创建tableView
    [self CreatTableView];
    
    // 请求订单详情的数据
    [self RequestDataForOrderDetails];
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
    
    tableView.showsVerticalScrollIndicator = NO;
    
    tableView.showsHorizontalScrollIndicator = NO;
    
    [tableView registerNib:[UINib nibWithNibName:@"HSQOrderDetailGoodsLisCell" bundle:nil] forCellReuseIdentifier:@"HSQOrderDetailGoodsLisCell"];
    
    [tableView registerClass:[HSQOrderDetailHeaderView class] forHeaderFooterViewReuseIdentifier:@"HSQOrderDetailHeaderView"];
    
    [tableView registerNib:[UINib nibWithNibName:@"HSQOrderDetailFooterView" bundle:nil] forHeaderFooterViewReuseIdentifier:@"HSQOrderDetailFooterView"];
    
    [self.view addSubview:tableView];
    
    self.tableView = tableView;
}

/**
 * @brief 请求订单详情的数据
 */
- (void)RequestDataForOrderDetails{
    
    [[HSQProgressHUDManger Manger] ShowLoadingDataFromeServer:@"" ToView:self.view IsClearColor:YES];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"token"] = [HSQAccountTool account].token;
    params[@"ordersId"] = self.ordersId;
    
    AFNetworkRequestTool *requestTool = [AFNetworkRequestTool shareRequestTool];
    
    [requestTool.manger POST:UrlAdress(KOrderDetailDataUrl) parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [[HSQProgressHUDManger Manger] DismissProgressHUD];
                
        HSQLog(@"==我的=%@",[NSString stringWithFormat:@"%@",responseObject[@"datas"]]);
        
        if ([responseObject[@"code"] integerValue] == 200)
        {
            self.dataDiction = responseObject[@"datas"];
            
            self.dataSource = [HSQShopCarGoodsTypeListModel mj_objectArrayWithKeyValuesArray:responseObject[@"datas"][@"ordersVo"][@"ordersGoodsVoList"]];
        }
        else
        {
            NSString *errorString = [NSString stringWithFormat:@"%@",responseObject[@"datas"][@"error"]];
            
            [[HSQProgressHUDManger Manger] ShowDisplayFailedToLoadData:errorString SuperView:self.view];
        }
        
        [self.tableView reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [[HSQProgressHUDManger Manger] ShowProgressHUDPromptText:@"网络出问题啦！" SupView:self.view];
    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return (self.dataDiction.allKeys.count == 0 ? 0 : 1);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section{
    
    NSString *adress = [NSString stringWithFormat:@"%@%@",self.dataDiction[@"ordersVo"][@"receiverAreaInfo"],self.dataDiction[@"ordersVo"][@"receiverAddress"]];
    
    CGSize AdressSize = [NSString SizeOfTheText:adress font:[UIFont systemFontOfSize:12.0] MaxSize:CGSizeMake(KScreenWidth - 43, MAXFLOAT)];
    
    return AdressSize.height + 150;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    NSString *adress = [NSString stringWithFormat:@"%@%@",self.dataDiction[@"ordersVo"][@"receiverAreaInfo"],self.dataDiction[@"ordersVo"][@"receiverAddress"]];
    
    CGSize AdressSize = [NSString SizeOfTheText:adress font:[UIFont systemFontOfSize:12.0] MaxSize:CGSizeMake(KScreenWidth - 43, MAXFLOAT)];
    
    return AdressSize.height + 150;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    HSQOrderDetailHeaderView *HeaderView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"HSQOrderDetailHeaderView"];
    
    HeaderView.OrderDataDiction = self.dataDiction;
    
    return HeaderView;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForFooterInSection:(NSInteger)section{
    
    return 500;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    NSString *orderState = [NSString stringWithFormat:@"%@",self.dataDiction[@"ordersVo"][@"ordersState"]];
    
    NSString *ordersStateName = [NSString stringWithFormat:@"%@",self.dataDiction[@"ordersVo"][@"ordersStateName"]];
    
    HSQLog(@"====%@===%@",orderState,ordersStateName);
    
    if (orderState.integerValue == 10) // 待支付
    {
        return 400;
    }
    else if (orderState.integerValue == 0)
    {
        return 380;
    }
    else if (orderState.integerValue == 20) // 代发货
    {
        return 430;
    }
    else if (orderState.integerValue == 30) // 已发货
    {
        return 480;
    }
    else if (orderState.integerValue == 40) // 待评价
    {
        return 480;
    }
    else
    {
        return 580;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    HSQOrderDetailFooterView *FooterView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"HSQOrderDetailFooterView"];
    
    FooterView.OrderDataDiction = self.dataDiction;
    
    FooterView.delegate = self;
    
    return FooterView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    HSQShopCarGoodsTypeListModel *model = self.dataSource[indexPath.row];
    
    CGSize NameSize = [NSString SizeOfTheText:model.goodsName font:[UIFont systemFontOfSize:12.0] MaxSize:CGSizeMake(KScreenWidth - 145, MAXFLOAT)];
    
     NSString *orderState = [NSString stringWithFormat:@"%@",self.dataDiction[@"ordersVo"][@"ordersState"]];
    
    NSString *ordersStateName = [NSString stringWithFormat:@"%@",self.dataDiction[@"ordersVo"][@"ordersStateName"]];
    
    if (orderState.integerValue == 10) // 待支付
    {
        return NameSize.height + 50;
    }
    else if (orderState.integerValue == 0)
    {
        return NameSize.height + 50;
    }
    else if (orderState.integerValue == 20) // 代发货
    {
        if ([ordersStateName isEqualToString:@"拼团失败"])
        {
             return NameSize.height + 50;
        }
        else
        {
             return NameSize.height + 90;
        }
    }
    else if (orderState.integerValue == 30) // 待收或者待取货
    {
        return NameSize.height + 90;
    }
    else if (orderState.integerValue == 40) // 待评价
    {
       return NameSize.height + 90;
    }
    else
    {
        return NameSize.height + 50;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HSQOrderDetailGoodsLisCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HSQOrderDetailGoodsLisCell" forIndexPath:indexPath];
    
    if (self.dataSource.count != 0)
    {
        cell.model = self.dataSource[indexPath.row];
    }
    
    cell.dataDiction = self.dataDiction;
    
    cell.delegate = self;

    return cell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
        

}

/**
 * @brief 取消订单
 */
- (void)ClickEventOfTheBottomButton:(UIButton *)sender{
    
    NSString *orderState = [NSString stringWithFormat:@"%@",self.dataDiction[@"ordersVo"][@"ordersState"]];
    
    if (orderState.integerValue == 10) // 待支付，点击就是取消订单
    {
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:@"确认取消订单？" preferredStyle:(UIAlertControllerStyleAlert)];
        
        UIAlertAction *Cancel_action = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:nil];
        
        UIAlertAction *delete_action = [UIAlertAction actionWithTitle:@"确认" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            
            [self CancelOrderNotifserver];
        }];
        
        [alertVC addAction:delete_action];
        
        [alertVC addAction:Cancel_action];
        
        [self presentViewController:alertVC animated:YES completion:nil];
    }
    else if (orderState.integerValue == 0) // 拼团失败
    {
        HSQLog(@"=====你点击了查看团详情");
    }
    else if (orderState.integerValue == 20) // 代发货
    {
        // 判断订单是否在退货中
        NSString *showRefundWaiting = [NSString stringWithFormat:@"%@",self.dataDiction[@"ordersVo"][@"showRefundWaiting"]];
        
        if (showRefundWaiting.integerValue == 0) // 不是
        {
            HSQLog(@"===订单退款");
            
            [self OrderARefund];
        }
    }
    else if (orderState.integerValue == 30) // 待收货或者待取货
    {
        [self ConfirmTheGoods];
    }
    else if (orderState.integerValue == 40) // 待评价
    {
        // 判断是否已经评价
        NSString *evaluationState = [NSString stringWithFormat:@"%@",self.dataDiction[@"ordersVo"][@"showEvaluationAppend"]];
        
        if (evaluationState.integerValue == 0) // 评价
        {
            HSQEvaluationOrderViewController *EvaluationOrderVC = [[HSQEvaluationOrderViewController alloc] init];
            
            EvaluationOrderVC.orderId = self.ordersId;
            
            EvaluationOrderVC.SelectFirstRateSuccessModel = ^(id success) {
                
                [self RequestDataForOrderDetails];
                
            };
            
            [self.navigationController pushViewController:EvaluationOrderVC animated:YES];
        }
        else // 追加评论
        {
            HSQZhuiJiaRateViewController *ZhuiJiaRateOrderVC = [[HSQZhuiJiaRateViewController alloc] init];
            
            ZhuiJiaRateOrderVC.orderId = self.ordersId;
            
            [self.navigationController pushViewController:ZhuiJiaRateOrderVC animated:YES];
        }
    }
    
}


/**
 * @brief 通知服务器，取消订单
 */
- (void)CancelOrderNotifserver{
    
    NSString *showMemberCancel = [NSString stringWithFormat:@"%@",self.dataDiction[@"ordersVo"][@"showMemberCancel"]];
    
    // 是否可以取消订单(1-是,0-否
    if (showMemberCancel.integerValue == 1)
    {
        HSQAccount *account = [HSQAccountTool account];
        
        [[HSQProgressHUDManger Manger] ShowLoadingDataFromeServer:@"" ToView:self.view IsClearColor:YES];
        
        NSDictionary *params = @{@"token":account.token,@"ordersId":self.ordersId};
        
        AFNetworkRequestTool *requestTool = [AFNetworkRequestTool shareRequestTool];
        
        [requestTool.manger POST:UrlAdress(KCancelNoPayMoneryOrderUrl) parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            HSQLog(@"==取消订单==%@",responseObject);
            [[HSQProgressHUDManger Manger] DismissProgressHUD];
            
            if ([responseObject[@"code"] integerValue] == 200)
            {
                if (self.OrderDetailTealSuccessModel) {
                    
                    self.OrderDetailTealSuccessModel(@"200");
                }
                
                [self.navigationController popViewControllerAnimated:YES];
            }
            else
            {
                NSString *errorString = [NSString stringWithFormat:@"%@",responseObject[@"datas"][@"error"]];
                
                [[HSQProgressHUDManger Manger] ShowDisplayFailedToLoadData:errorString SuperView:self.view];
            }
            
            [self.tableView reloadData];
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            [[HSQProgressHUDManger Manger] ShowProgressHUDPromptText:@"取消订单失败，请稍后重试" SupView:self.view];
            
        }];
    }
    else
    {
        [[HSQProgressHUDManger Manger] ShowProgressHUDPromptText:@"该订单不能被取消" SupView:self.view];
    }
}

/**
 * @brief 订单退款--全部商品
 */
- (void)OrderARefund{
    
    HSQGoodsRefundViewController *ComplaintsVC = [[HSQGoodsRefundViewController alloc] init];
    
    ComplaintsVC.Navtion_string = @"订单退款";
    
    ComplaintsVC.ordersId = self.ordersId;
    
    ComplaintsVC.source = @"200";
    
    [self.navigationController pushViewController:ComplaintsVC animated:YES];
}

/**
 * @brief 确认收货
 */
- (void)ConfirmTheGoods{
    
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:@"确认收到了货物吗？" preferredStyle:(UIAlertControllerStyleAlert)];
    
    UIAlertAction *Cancel_action = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:nil];
    
    UIAlertAction *delete_action = [UIAlertAction actionWithTitle:@"确认" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        
        [self NotifServerQRShouHuo];
    }];
    
    [alertVC addAction:delete_action];
    
    [alertVC addAction:Cancel_action];
    
    [self presentViewController:alertVC animated:YES completion:nil];
}

/**
 * @brief 通知服务器，确认收货
 */
- (void)NotifServerQRShouHuo{
    
    HSQAccount *account = [HSQAccountTool account];
    
    [[HSQProgressHUDManger Manger] ShowLoadingDataFromeServer:@"" ToView:self.view IsClearColor:YES];
    
    NSDictionary *params = @{@"token":account.token,@"ordersId":self.ordersId};
    
    AFNetworkRequestTool *requestTool = [AFNetworkRequestTool shareRequestTool];
    
    [requestTool.manger POST:UrlAdress(KOrderQRShouHuoUrl) parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        HSQLog(@"==确认收货==%@",responseObject);
        [[HSQProgressHUDManger Manger] DismissProgressHUD];
        
        if ([responseObject[@"code"] integerValue] == 200)
        {
            // 确认收货成功以后，发送消息
            [[NSNotificationCenter defaultCenter] postNotificationName:@"OrderListQRShouHuoSuccessNotif" object:self];
            
            [self.navigationController popViewControllerAnimated:YES];
        }
        else
        {
            NSString *errorString = [NSString stringWithFormat:@"%@",responseObject[@"datas"][@"error"]];
            
            [[HSQProgressHUDManger Manger] ShowDisplayFailedToLoadData:errorString SuperView:self.view];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [[HSQProgressHUDManger Manger] ShowProgressHUDPromptText:@"确认收货失败，请稍后重试" SupView:self.view];
        
    }];
    
}


/**
 * @brief 单个商品--投诉按钮的点击事件
 */
- (void)ComplaintsButtonClickEvent:(UIButton *)sender{
    
    HSQOrderDetailGoodsLisCell *cell = (HSQOrderDetailGoodsLisCell *)sender.superview.superview.superview;
    
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    HSQShopCarGoodsTypeListModel *model = self.dataSource[indexPath.row];
    
    if (model.complainId.integerValue > 0)  // 投诉中
    {
        HSQTuiGoodAndMoneryDetailViewController *detailVC = [[HSQTuiGoodAndMoneryDetailViewController alloc] init];
        
        detailVC.complainId = model.complainId;
        
        detailVC.Navtion_title = @"投诉详情";
        
        detailVC.Order_Type = @"300";
        
        [self.navigationController pushViewController:detailVC animated:YES];
    }
    else
    {
        HSQComplaintsViewController *ComplaintsVC = [[HSQComplaintsViewController alloc] init];
        
        ComplaintsVC.Goods_Id = model.ordersGoodsId;
        
        ComplaintsVC.ordersId = self.ordersId;
        
        [self.navigationController pushViewController:ComplaintsVC animated:YES];
    }
}

/**
 * @brief 单个商品--退货按钮的点击事件
 */
- (void)ClickEventOnTheReturnButton:(UIButton *)sender{
    
    HSQOrderDetailGoodsLisCell *cell = (HSQOrderDetailGoodsLisCell *)sender.superview.superview.superview;
    
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    HSQShopCarGoodsTypeListModel *model = self.dataSource[indexPath.row];
    
    if (model.refundType.integerValue == 1) // 查看退款
    {
        HSQTuiGoodAndMoneryDetailViewController *detailVC = [[HSQTuiGoodAndMoneryDetailViewController alloc] init];
        
        detailVC.complainId = [NSString stringWithFormat:@"%@",model.refundId];
        
        detailVC.Navtion_title = @"退款详情";
        
        detailVC.Order_Type = @"100";
        
        [self.navigationController pushViewController:detailVC animated:YES];
    }
    else if (model.refundType.integerValue == 2) // 查看退货
    {
        HSQTuiGoodAndMoneryDetailViewController *detailVC = [[HSQTuiGoodAndMoneryDetailViewController alloc] init];
        
        detailVC.complainId = [NSString stringWithFormat:@"%@",model.refundId];
        
        detailVC.Navtion_title = @"退货详情";
        
        detailVC.Order_Type = @"200";
        
        [self.navigationController pushViewController:detailVC animated:YES];
    }
    else // 退货
    {
        HSQTuiGoodsViewController *ReturnGoodsVC = [[HSQTuiGoodsViewController alloc] init];
        
        ReturnGoodsVC.Goods_Id = model.ordersGoodsId;
        
        ReturnGoodsVC.ordersId = self.ordersId;
                
        [self.navigationController pushViewController:ReturnGoodsVC animated:YES];
    }
}

/**
 * @brief 单个商品--退款按钮的点击事件
 */
- (void)RefundMoneryButtonClickAction:(UIButton *)sender{
    
    HSQOrderDetailGoodsLisCell *cell = (HSQOrderDetailGoodsLisCell *)sender.superview.superview.superview;
    
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    HSQShopCarGoodsTypeListModel *model = self.dataSource[indexPath.row];
    
    HSQTuiGoodsViewController *ComplaintsVC = [[HSQTuiGoodsViewController alloc] init];
        
    ComplaintsVC.ordersId = self.ordersId;
    
     ComplaintsVC.Goods_Id = model.ordersGoodsId;
    
    [self.navigationController pushViewController:ComplaintsVC animated:YES];
}























@end
