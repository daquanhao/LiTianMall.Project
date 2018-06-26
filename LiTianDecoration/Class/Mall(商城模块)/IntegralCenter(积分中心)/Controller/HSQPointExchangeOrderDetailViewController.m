//
//  HSQPointExchangeOrderDetailViewController.m
//  LiTianDecoration
//
//  Created by administrator on 2018/6/25.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import "HSQPointExchangeOrderDetailViewController.h"
#import "HSQAccountTool.h"
#import "HSQPointExchangeGoodsOrderListCell.h"
#import "HSQPointExchangeOrderDetailHeadView.h"
#import "HSQPointExchangeOrderDetailFooterView.h"
#import "HSQPointsOrdersListModel.h"
#import "HSQStoreDetailViewController.h"

@interface HSQPointExchangeOrderDetailViewController ()<UITableViewDelegate,UITableViewDataSource,HSQPointExchangeOrderDetailHeadViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, strong) NSMutableDictionary *pointsOrders;

@property (nonatomic, strong) UIButton *OrderState_Btn;

@end

@implementation HSQPointExchangeOrderDetailViewController

-(NSMutableArray *)dataSource{
    
    if (_dataSource == nil) {
        
        self.dataSource = [NSMutableArray array];
    }
    
    return _dataSource;
}


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.view.backgroundColor = KViewBackGroupColor;
    
    self.navigationItem.title = @"积分兑换详情";
    
    self.pointsOrders = [NSMutableDictionary dictionary];
    
    // 创建tableView
    [self CreatTableView];
    
    // 请求订单详情的数据
    [self RequestPointExxchangeDataForOrderDetails];
}

/**
 * @brief 创建tableView
 */
- (void)CreatTableView{
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - KSafeTopeHeight - KSafeBottomHeight - 44) style:(UITableViewStyleGrouped)];
    
    tableView.backgroundColor = [UIColor clearColor];
    
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    tableView.delegate = self;
    
    tableView.dataSource = self;
    
    [tableView registerClass:[HSQPointExchangeGoodsOrderListCell class] forCellReuseIdentifier:@"HSQPointExchangeGoodsOrderListCell"];
    
    [tableView registerNib:[UINib nibWithNibName:@"HSQPointExchangeOrderDetailHeadView" bundle:nil] forHeaderFooterViewReuseIdentifier:@"HSQPointExchangeOrderDetailHeadView"];

    [tableView registerNib:[UINib nibWithNibName:@"HSQPointExchangeOrderDetailFooterView" bundle:nil] forHeaderFooterViewReuseIdentifier:@"HSQPointExchangeOrderDetailFooterView"];
    
    [self.view addSubview:tableView];
    
    self.tableView = tableView;
    
    // 底部的按钮
    UIButton *OrderState_Btn = [UIButton buttonWithType:(UIButtonTypeSystem)];
    
    [OrderState_Btn setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    
    OrderState_Btn.titleLabel.font = [UIFont systemFontOfSize:14.0];
    
    [OrderState_Btn setBackgroundImage:[UIImage ReturnAPictureOfStretching:@"7D99DFED-F3B6-4DB1-9F77-E24CA867DD17"] forState:(UIControlStateNormal)];
    
    [OrderState_Btn addTarget:self action:@selector(OrderState_BtnClickAction:) forControlEvents:(UIControlEventTouchUpInside)];
    
    OrderState_Btn.frame = CGRectMake(KScreenWidth - 80 - 10, CGRectGetMaxY(tableView.frame) + 7, 80, 30);
    
    [self.view addSubview:OrderState_Btn];
    
    self.OrderState_Btn = OrderState_Btn;
}


/**
 * @brief 请求订单详情的数据
 */
- (void)RequestPointExxchangeDataForOrderDetails{
    
    [[HSQProgressHUDManger Manger] ShowLoadingDataFromeServer:@"" ToView:self.view IsClearColor:YES];
    
    NSDictionary *params = @{@"token":[HSQAccountTool account].token,@"pointsOrdersId":self.pointsOrdersId};
    
    AFNetworkRequestTool *requestTool = [AFNetworkRequestTool shareRequestTool];
    
    [requestTool.manger POST:UrlAdress(KPointExchangeOrderDetailUrl) parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [[HSQProgressHUDManger Manger] DismissProgressHUD];
        
        HSQLog(@"==我的=%@",[NSString stringWithFormat:@"%@",responseObject[@"datas"]]);
        
        if ([responseObject[@"code"] integerValue] == 200)
        {
            NSDictionary *pointsOrders = responseObject[@"datas"][@"pointsOrders"];
                        
            HSQPointsOrdersListModel *model = [[HSQPointsOrdersListModel alloc] init];
            
            [model setValuesForKeysWithDictionary:pointsOrders];
            
            [self.dataSource addObject:model];
            
             NSString *pointsOrdersState = [NSString stringWithFormat:@"%@",pointsOrders[@"pointsOrdersState"]];
            
            if (pointsOrdersState.integerValue == 10) //
            {
                self.OrderState_Btn.hidden = NO;
                
                [self.OrderState_Btn setTitle:@"取消订单" forState:(UIControlStateNormal)];
            }
            else if (pointsOrdersState.integerValue == 20)
            {
                self.OrderState_Btn.hidden = NO;
                
                [self.OrderState_Btn setTitle:@"确认收货" forState:(UIControlStateNormal)];
            }
            else
            {
                self.OrderState_Btn.hidden = YES;
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.dataSource.count;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section{
    
    HSQPointsOrdersListModel *model = self.dataSource[section];
    
    CGSize receiverMessage_size = [NSString SizeOfTheText:model.receiverMessage font:[UIFont systemFontOfSize:12.0] MaxSize:CGSizeMake(KScreenWidth - 110, MAXFLOAT)];
    
    return 190 + receiverMessage_size.height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    HSQPointsOrdersListModel *model = self.dataSource[section];
    
    CGSize receiverMessage_size = [NSString SizeOfTheText:model.receiverMessage font:[UIFont systemFontOfSize:12.0] MaxSize:CGSizeMake(KScreenWidth - 110, MAXFLOAT)];
    
    if (receiverMessage_size.height > 40)
    {
        return 190 + receiverMessage_size.height;
    }
    else
    {
        return 220;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    HSQPointExchangeOrderDetailHeadView *HeadView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"HSQPointExchangeOrderDetailHeadView"];
    
    HeadView.model = self.dataSource[section];
    
    HeadView.delegate = self;
    
    return HeadView;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForFooterInSection:(NSInteger)section{
    
     return 200;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 200;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    HSQPointExchangeOrderDetailFooterView *footerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"HSQPointExchangeOrderDetailFooterView"];
    
     footerView.model = self.dataSource[section];
    
    return footerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    HSQPointsOrdersListModel *model = self.dataSource[indexPath.row];
    
    return [self.tableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:[HSQPointExchangeGoodsOrderListCell class] contentViewWidth:KScreenWidth];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HSQPointExchangeGoodsOrderListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HSQPointExchangeGoodsOrderListCell" forIndexPath:indexPath];
    
    cell.model = self.dataSource[indexPath.row];
    
    // 此步设置用于实现cell的frame缓存，可以让tableview滑动更加流畅
    [cell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

}

/**
 * @brief 底部按钮的点击事件
 */
- (void)OrderState_BtnClickAction:(UIButton *)sender{
    
    // 积分兑换订单状态 0-已取消 10-新订单 20-已发货 30-已收货
    HSQPointsOrdersListModel *model = self.dataSource[0];
    
    NSString *title_string = @"";
    
    if (model.pointsOrdersState.integerValue == 20) // 确认收货
    {
        title_string = @"确认收到该货物？";
    }
    else if (model.pointsOrdersState.integerValue == 10) // 取消订单
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
    
    NSDictionary *params = @{@"token":[HSQAccountTool account].token,@"pointsOrdersId":self.pointsOrdersId};
    
    AFNetworkRequestTool *requestTool = [AFNetworkRequestTool shareRequestTool];
    
    [requestTool.manger POST:Url parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        HSQLog(@"==数据==%@",responseObject);
        
        [[HSQProgressHUDManger Manger] DismissProgressHUD];
        
        if ([responseObject[@"code"] integerValue] == 200)
        {
            [self.dataSource removeAllObjects];
            
            // 请求订单详情的数据
            [self RequestPointExxchangeDataForOrderDetails];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"OrderStateChangeSuccessNotif" object:self userInfo:@{@"pointsOrdersState":model.pointsOrdersState}];
            
        }
        else
        {
            NSString *errorString = [NSString stringWithFormat:@"%@",responseObject[@"datas"][@"error"]];
            
            [[HSQProgressHUDManger Manger] ShowDisplayFailedToLoadData:errorString SuperView:self.view];
        }
                
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [[HSQProgressHUDManger Manger] ShowProgressHUDPromptText:KErrorPlacherString SupView:self.view];
        
    }];
}

/**
 * @brief 进入店铺详情
 */
- (void)JoinStoreDetailButtonClickAction:(UIButton *)sender{
    
    HSQPointsOrdersListModel *model = self.dataSource[0];
    
    HSQStoreDetailViewController *StoreVC = [[HSQStoreDetailViewController alloc] init];
    
    StoreVC.storeId = model.storeId;
    
    [self.navigationController pushViewController:StoreVC animated:YES];
}


@end
