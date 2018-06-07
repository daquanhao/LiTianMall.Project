//
//  HSQReturnGoodsListViewController.m
//  LiTianDecoration
//
//  Created by administrator on 2018/4/30.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import "HSQReturnGoodsListViewController.h"
#import "HSQAccountTool.h"
#import "HSQTuiGoodAndMoneryDetailViewController.h"
#import "HSQTuiMoneryListFooterView.h"
#import "HSQTuiMoneryListHeadView.h"
#import "HSQTuiMoneryListViewCell.h"

@interface HSQReturnGoodsListViewController ()<UITableViewDataSource,UITableViewDelegate,HSQTuiMoneryListFooterViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, assign) NSInteger currentPage; // 当前的页数

@property (nonatomic, strong) HSQNoDataView *noDataView;

@property (nonatomic, copy) NSString *totalPage; // 总页数

@property (nonatomic, strong) NSDictionary *dataDiction;

@end

@implementation HSQReturnGoodsListViewController

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
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:KImageName(@"LeftBackIcon") style:(UIBarButtonItemStylePlain) target:self action:@selector(BackItem:)];
    
    self.dataDiction = [NSDictionary dictionary];
    
    // 创建tableView
    [self CreatTableView];
    
    // 添加刷新控件
    [self AddRefreshControls];
}

/**
 * @brief 返回按钮的点击
 */
- (void)BackItem:(UIBarButtonItem *)sender{
    
    [self.navigationController popToRootViewControllerAnimated:YES];
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
    
    [tableView registerNib:[UINib nibWithNibName:@"HSQTuiMoneryListViewCell" bundle:nil] forCellReuseIdentifier:@"HSQTuiMoneryListViewCell"];

    [tableView registerNib:[UINib nibWithNibName:@"HSQTuiMoneryListFooterView" bundle:nil] forHeaderFooterViewReuseIdentifier:@"HSQTuiMoneryListFooterView"];

    [tableView registerClass:[HSQTuiMoneryListHeadView class] forHeaderFooterViewReuseIdentifier:@"HSQTuiMoneryListHeadView"];
    
    [self.view addSubview:tableView];
    
    self.tableView = tableView;
}


/**
 * @brief 添加刷新控件
 */
- (void)AddRefreshControls{
    
    // 1.下拉加载更多的数据
    self.tableView.mj_header  = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(LoadNewTouSuOrderListData)];
    
    [self.tableView.mj_header beginRefreshing];
    
    // 3.上啦加载更多的代码
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(LoadMoreTouSuOrderListData)];
}

/**
 * @brief 加载最新的投诉数据
 */
- (void)LoadNewTouSuOrderListData{
    
    [[HSQProgressHUDManger Manger] ShowLoadingDataFromeServer:@"" ToView:self.view IsClearColor:YES];
    
    // 0.清空数组
    [self.dataSource removeAllObjects];
    
    // 结束上啦
    [self.tableView.mj_footer endRefreshing];
    
    self.currentPage = 1;
    
    NSDictionary *params = @{@"token":[HSQAccountTool account].token,@"page":@(self.currentPage)};
    
    AFNetworkRequestTool *requestTool = [AFNetworkRequestTool shareRequestTool];
    
    [requestTool.manger POST:UrlAdress(KTuiHuoListUrl) parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [[HSQProgressHUDManger Manger] DismissProgressHUD];
        
        HSQLog(@"===退货列表===%@",responseObject);
        
        self.totalPage = [NSString stringWithFormat:@"%@",responseObject[@"datas"][@"pageEntity"][@"totalPage"]];
        
        if ([responseObject[@"code"] integerValue] == 200)
        {
            // 取出商品的数据
            for (NSDictionary *diction in responseObject[@"datas"][@"refundItemVoList"]) {
                
                [self.dataSource addObject:diction];
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
        
        [self.tableView addSubview:self.noDataView];
        
        // 提示数据请求失败
        [[HSQProgressHUDManger Manger] ShowProgressHUDPromptText:@"网络出现问题" SupView:self.view];
    }];
}

/**
 * @brief 加载更多的投诉数据
 */
- (void)LoadMoreTouSuOrderListData{
    
    [self.tableView.mj_header endRefreshing];
    
    NSDictionary *params = @{@"token":[HSQAccountTool account].token,@"page":@(++self.currentPage)};
    
    AFNetworkRequestTool *requestTool = [AFNetworkRequestTool shareRequestTool];
    
    [requestTool.manger POST:UrlAdress(KTuiHuoListUrl) parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [[HSQProgressHUDManger Manger] DismissProgressHUD];
        
        HSQLog(@"===加载更多订单数据===%@",responseObject);
        
        if ([responseObject[@"code"] integerValue] == 200)
        {
            // 取出商品的数据
            for (NSDictionary *diction in responseObject[@"datas"][@"refundItemVoList"]) {
                
                [self.dataSource addObject:diction];
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
    
    NSDictionary *diction = self.dataSource[section];
    
    NSArray *array = diction[@"ordersGoodsVoList"];
    
    return array.count;
}


- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section{
    
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 50;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    HSQTuiMoneryListHeadView *HeaderView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"HSQTuiMoneryListHeadView"];
    
    HeaderView.Placher_Label.hidden = YES;
    
    NSDictionary *diction = self.dataSource[section];
    
    HeaderView.StoreName_Label.text = [NSString stringWithFormat:@"%@",diction[@"storeName"]];
    
    // 平台处理状态
    NSString *refundState = [NSString stringWithFormat:@"%@",diction[@"refundState"]];
    
    if (refundState.integerValue == 1) // 未处理
    {
        HeaderView.OrderState_Label.text = [NSString stringWithFormat:@"商家%@",diction[@"sellerStateText"]];
    }
    else if (refundState.integerValue == 2) // 商家同意，平台待处理
    {
        HeaderView.OrderState_Label.text = [NSString stringWithFormat:@"商家%@",diction[@"sellerStateText"]];
    }
    else if (refundState.integerValue == 3) // 平台同意
    {
        HeaderView.OrderState_Label.text = @"已退款";
    }
    
    return HeaderView;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForFooterInSection:(NSInteger)section{
    
    return 140;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 140;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    HSQTuiMoneryListFooterView *FooterView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"HSQTuiMoneryListFooterView"];
    
    FooterView.section = section;
    
    NSDictionary *diction = self.dataSource[section];
    
    FooterView.CreatTime_Label.text = [NSString stringWithFormat:@"%@",diction[@"addTime"]];
    
    //退款金额
    NSString *refundAmount = [NSString stringWithFormat:@"%@",diction[@"refundAmount"]];
    
    NSString *monery = [NSString stringWithFormat:@"¥%.2f",refundAmount.floatValue];
    
    NSString *totalMonery = [NSString stringWithFormat:@"退款金额：%@",monery];
    
    NSMutableAttributedString *attribe = [[NSMutableAttributedString alloc] initWithString:totalMonery];
    
    [attribe addAttribute:NSForegroundColorAttributeName value:RGB(238, 68, 68) range:NSMakeRange(5, monery.length)];
    
    FooterView.OrderMonery_Label.attributedText = attribe;
    
    // 退货数量
    NSString *goodsNum = [NSString stringWithFormat:@"%@",diction[@"goodsNum"]];
    
    NSString *unitName = [NSString stringWithFormat:@"%@",diction[@"ordersGoodsVoList"][0][@"unitName"]];
    
    NSString *goodsCount = [NSString stringWithFormat:@"退货数量：%@%@",goodsNum,unitName];
    
    NSMutableAttributedString *attribe02 = [[NSMutableAttributedString alloc] initWithString:goodsCount];
    
    [attribe02 addAttribute:NSForegroundColorAttributeName value:RGB(238, 68, 68) range:NSMakeRange(5, goodsNum.length)];
    
    FooterView.TuiHuoCount_Label.attributedText = attribe02;
    
    FooterView.delegate = self;
    
    [FooterView.TuiKuanDetail_Btn setTitle:@"退货详情" forState:(UIControlStateNormal)];
    
    return FooterView;
}


- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 70;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 70;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HSQTuiMoneryListViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HSQTuiMoneryListViewCell" forIndexPath:indexPath];
    
    NSDictionary *FirstDiction = self.dataSource[indexPath.section];
    
    NSArray *array = FirstDiction[@"ordersGoodsVoList"];
    
    NSDictionary *secondDiction = array[indexPath.row];
    
    [cell.GoodsImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",secondDiction[@"imageSrc"]]] placeholderImage:KGoodsPlacherImage];
    
    cell.GoodsName_Label.text = [NSString stringWithFormat:@"%@",secondDiction[@"goodsName"]];
    
    cell.GoodsGuiGe_Label.text = [NSString stringWithFormat:@"%@",secondDiction[@"goodsFullSpecs"]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary *diction = self.dataSource[indexPath.section];
    
    HSQTuiGoodAndMoneryDetailViewController *detailVC = [[HSQTuiGoodAndMoneryDetailViewController alloc] init];
    
    detailVC.complainId = [NSString stringWithFormat:@"%@",diction[@"refundId"]];
    
    detailVC.Navtion_title = @"退货详情";
    
    detailVC.Order_Type = @"200";
    
    [self.navigationController pushViewController:detailVC animated:YES];
}

/**
 * @brief 退款详情的点击
 */
- (void)RefundDetailsButtonClickEvent:(UIButton *)sender{
    
    HSQTuiMoneryListFooterView *footerView = (HSQTuiMoneryListFooterView *)sender.superview.superview;
    
    NSInteger second = footerView.section;
    
    NSDictionary *diction = self.dataSource[second];
    
    HSQTuiGoodAndMoneryDetailViewController *detailVC = [[HSQTuiGoodAndMoneryDetailViewController alloc] init];
    
    detailVC.complainId = [NSString stringWithFormat:@"%@",diction[@"refundId"]];
    
    detailVC.Navtion_title = @"退货详情";
    
    detailVC.Order_Type = @"200";
    
    [self.navigationController pushViewController:detailVC animated:YES];
    
}


@end
