//
//  HSQClassMessageDetailListViewController.m
//  LiTianDecoration
//
//  Created by administrator on 2018/6/20.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import "HSQClassMessageDetailListViewController.h"
#import "HSQMessgaeDetailDataListCell.h"
#import "HSQAccountTool.h"
#import "HSQClassMessageListModel.h"
#import "HSQOrderDetailViewController.h"
#import "HSQMyAccountBalanceViewController.h"
#import "HSQCommissionHomeViewController.h"
#import "HSQTuiGoodAndMoneryDetailViewController.h"
#import "HSQMessageDetailListHeaderView.h"
#import "HSQMyStoreCollectionFooterView.h"

@interface HSQClassMessageDetailListViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, assign) NSInteger currentPage; // 当前的页数

@property (nonatomic, copy) NSString *totalPage; // 总页数

@end

@implementation HSQClassMessageDetailListViewController

-(NSMutableArray *)dataSource{
    
    if (_dataSource == nil) {
        
        self.dataSource = [NSMutableArray array];
    }
    
    return _dataSource;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.navigationItem.title = @"通知消息";
    
    self.view.backgroundColor = KViewBackGroupColor;
    
    // 创建tableView
    [self CreatTableView];
    
    // 添加刷新控件
    [self AddMessageTableViewRefreshControls];
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
    
    [tableView registerClass:[HSQMessgaeDetailDataListCell class] forCellReuseIdentifier:@"HSQMessgaeDetailDataListCell"];
    
    [tableView registerClass:[HSQMessageDetailListHeaderView class] forHeaderFooterViewReuseIdentifier:@"HSQMessageDetailListHeaderView"];
    
    [tableView registerClass:[HSQMyStoreCollectionFooterView class] forHeaderFooterViewReuseIdentifier:@"HSQMyStoreCollectionFooterView"];
    
    [self.view addSubview:tableView];
    
    self.tableView = tableView;
}

/**
 * @brief 添加刷新控件
 */
- (void)AddMessageTableViewRefreshControls{
    
    // 1.下拉加载更多的数据
    self.tableView.mj_header  = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(LoadNewMessageListData)];
    
    [self.tableView.mj_header beginRefreshing];
    
    // 3.上啦加载更多的代码
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(LoadMoreMessageListData)];
}

/**
 * @brief 加载最新的消息数据
 */
- (void)LoadNewMessageListData{
    
    [[HSQProgressHUDManger Manger] ShowLoadingDataFromeServer:@"" ToView:self.view IsClearColor:YES];
    
    // 0.清空数组
    [self.dataSource removeAllObjects];
    
    // 结束上啦
    [self.tableView.mj_footer endRefreshing];
    
    self.currentPage = 1;
    
    NSDictionary *params = @{@"token":[HSQAccountTool account].token,@"page":@(self.currentPage),@"tplClass":self.tplClass};
    
    AFNetworkRequestTool *requestTool = [AFNetworkRequestTool shareRequestTool];
    
    [requestTool.manger POST:UrlAdress(KMessageListUrl) parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [[HSQProgressHUDManger Manger] DismissProgressHUD];
        
        HSQLog(@"===订单数据===%@",responseObject);
        
        self.totalPage = [NSString stringWithFormat:@"%@",responseObject[@"datas"][@"pageEntity"][@"totalPage"]];
        
        if ([responseObject[@"code"] integerValue] == 200)
        {
            for (NSDictionary *diction in responseObject[@"datas"][@"memberMessageList"]) {
                
                HSQClassMessageListModel *model = [[HSQClassMessageListModel alloc] init];
                
                [model setValuesForKeysWithDictionary:diction];
                
                [self.dataSource addObject:model];
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
        
        // 结束刷新
        [self.tableView.mj_header endRefreshing];
        
        // 提示数据请求失败
        [[HSQProgressHUDManger Manger] ShowProgressHUDPromptText:KErrorPlacherString SupView:self.view];
    }];
}

/**
 * @brief 加载更多的消息数据
 */
- (void)LoadMoreMessageListData{
    
    [self.tableView.mj_header endRefreshing];
        
    NSDictionary *params = @{@"token":[HSQAccountTool account].token,@"page":@(++self.currentPage),@"tplClass":self.tplClass};
    
    AFNetworkRequestTool *requestTool = [AFNetworkRequestTool shareRequestTool];
    
    [requestTool.manger POST:UrlAdress(KMessageListUrl) parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [[HSQProgressHUDManger Manger] DismissProgressHUD];
        
        HSQLog(@"===加载更多订单数据===%@",responseObject);
        
        if ([responseObject[@"code"] integerValue] == 200)
        {
            for (NSDictionary *diction in responseObject[@"datas"][@"memberMessageList"]) {
                
                HSQClassMessageListModel *model = [[HSQClassMessageListModel alloc] init];
                
                [model setValuesForKeysWithDictionary:diction];
                
                [self.dataSource addObject:model];
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
    
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section{
    
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 40;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    HSQMessageDetailListHeaderView *HeaderView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"HSQMessageDetailListHeaderView"];
    
    HSQClassMessageListModel *model = self.dataSource[section];
    
    HeaderView.MessageTime_Label.textAlignment = NSTextAlignmentCenter;
    
    HeaderView.MessageTime_Label.text = model.addTime;
    
    return HeaderView;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForFooterInSection:(NSInteger)section{
    
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    HSQMyStoreCollectionFooterView *FooterView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"HSQMyStoreCollectionFooterView"];
    
    return FooterView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    HSQClassMessageListModel *model = self.dataSource[indexPath.section];
    
    return [self.tableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:[HSQMessgaeDetailDataListCell class] contentViewWidth:KScreenWidth] + 5;
    
//    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
//
//    paraStyle.lineSpacing = 8;
//
//    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:14.0], NSParagraphStyleAttributeName:paraStyle, NSKernAttributeName:@1.0f};
//
//    CGSize size = [model.messageContent boundingRectWithSize:CGSizeMake(KScreenWidth - 30, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
//
//    return size.height + 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HSQMessgaeDetailDataListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HSQMessgaeDetailDataListCell" forIndexPath:indexPath];
    
    if (self.dataSource.count != 0)
    {
        cell.model = self.dataSource[indexPath.section];
    }
    
    // 此步设置用于实现cell的frame缓存，可以让tableview滑动更加流畅
    [cell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    HSQClassMessageListModel *model = self.dataSource[indexPath.row];
    
    if ([model.tplCode isEqualToString:@"memberOrdersCancel"] || [model.tplCode isEqualToString:@"memberOrdersEvaluateExplain"] || [model.tplCode isEqualToString:@"memberOrdersModifyFreight"] || [model.tplCode isEqualToString:@"memberOrdersPay"] || [model.tplCode isEqualToString:@"memberOrdersReceive"] || [model.tplCode isEqualToString:@"memberOrdersSend"])  // 跳转到订单详情
    {
        HSQOrderDetailViewController *OrderDetailVC = [[HSQOrderDetailViewController alloc] init];
        
        OrderDetailVC.ordersId = model.sn;
        
        OrderDetailVC.OrderDetailTealSuccessModel = ^(id success) {
            
            [self.tableView.mj_header beginRefreshing];
        };
        
        [self.navigationController pushViewController:OrderDetailVC animated:YES];
    }
   else if ([model.tplCode isEqualToString:@"memberPredepositCashFail"] || [model.tplCode isEqualToString:@"memberPredepositChange"])  // 跳转余额体现列表
    {
        HSQMyAccountBalanceViewController *MyAccountBalanceVC = [[HSQMyAccountBalanceViewController alloc] init];
        
        [self.navigationController pushViewController:MyAccountBalanceVC animated:YES];
    }
   else if ([model.tplCode isEqualToString:@"distributorCommissionCashSuccess"] || [model.tplCode isEqualToString:@"distributorCommissionCashFail"] || [model.tplCode isEqualToString:@"distributorCommissionChange"])  // 跳转到佣金余额提现
   {
       HSQCommissionHomeViewController *CommissionHomeVC = [[HSQCommissionHomeViewController alloc] init];
       
       [self.navigationController pushViewController:CommissionHomeVC animated:YES];
   }
   else if ([model.tplCode isEqualToString:@"memberRefundUpdate"])  // 跳转到退款详情
   {
       HSQTuiGoodAndMoneryDetailViewController *detailVC = [[HSQTuiGoodAndMoneryDetailViewController alloc] init];
       
       detailVC.complainId = model.sn;
       
       detailVC.Navtion_title = @"退货详情";
       
       detailVC.Order_Type = @"200";
       
       [self.navigationController pushViewController:detailVC animated:YES];
   }
   else if ([model.tplCode isEqualToString:@"memberArrivalNotice"])  // 商品详情
   {
       HSQLog(@"===商品详情");
   }
   else if ([model.tplCode isEqualToString:@"memberTrysApplayWinningNotice"])  // 跳转到会员试用列表
   {
       HSQLog(@"===跳转到会员试用列表");
   }
   else if ([model.tplCode isEqualToString:@"memberChainOrdersCancel"] || [model.tplCode isEqualToString:@"memberChainOrdersPay"])  // 跳转到门店订单详情
   {
       HSQLog(@"===跳转到门店订单详情");
   }
    
}



















@end
