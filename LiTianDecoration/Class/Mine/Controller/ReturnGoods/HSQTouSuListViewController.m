//
//  HSQTouSuListViewController.m
//  LiTianDecoration
//
//  Created by administrator on 2018/6/4.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import "HSQTouSuListViewController.h"
#import "HSQAccountTool.h"
#import "HSQTuiGoodsandMoneryListModel.h"
#import "HSQTuiGoodsAndMoneryListCell.h"
#import "HSQTuiGoodAndMoneryDetailViewController.h"

@interface HSQTouSuListViewController ()<UITableViewDataSource,UITableViewDelegate,HSQTuiGoodsAndMoneryListCellDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, assign) NSInteger currentPage; // 当前的页数

@property (nonatomic, strong) HSQNoDataView *noDataView;

@property (nonatomic, copy) NSString *totalPage; // 总页数

@end

@implementation HSQTouSuListViewController

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
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - KSafeTopeHeight - KSafeBottomHeight - 50) style:(UITableViewStylePlain)];
    
    tableView.backgroundColor = [UIColor clearColor];
    
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    tableView.delegate = self;

    tableView.dataSource = self;
    
    [tableView registerNib:[UINib nibWithNibName:@"HSQTuiGoodsAndMoneryListCell" bundle:nil] forCellReuseIdentifier:@"HSQTuiGoodsAndMoneryListCell"];
    
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
    
    [requestTool.manger POST:UrlAdress(KTouSuLieBiaoUrl) parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [[HSQProgressHUDManger Manger] DismissProgressHUD];
        
        HSQLog(@"===投诉列表===%@",responseObject);
        
        self.totalPage = [NSString stringWithFormat:@"%@",responseObject[@"datas"][@"pageEntity"][@"totalPage"]];
        
        if ([responseObject[@"code"] integerValue] == 200)
        {
            // 取出商品的数据
            NSArray *array = responseObject[@"datas"][@"complainList"];
            
            for (NSDictionary *dataDiction in array) {
                
                HSQTuiGoodsandMoneryListModel *model = [[HSQTuiGoodsandMoneryListModel alloc] init];
                model.OrderListState = @"300";
                [model setValuesForKeysWithDictionary:dataDiction];
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
    
    [requestTool.manger POST:UrlAdress(KTouSuLieBiaoUrl) parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [[HSQProgressHUDManger Manger] DismissProgressHUD];
        
        HSQLog(@"===加载更多订单数据===%@",responseObject);
        
        if ([responseObject[@"code"] integerValue] == 200)
        {
            // 取出商品的数据
            NSArray *array = responseObject[@"datas"][@"complainList"];
            
            for (NSDictionary *dataDiction in array) {
                
                HSQTuiGoodsandMoneryListModel *model = [[HSQTuiGoodsandMoneryListModel alloc] init];
                model.OrderListState = @"300";
                [model setValuesForKeysWithDictionary:dataDiction];
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
        [[HSQProgressHUDManger Manger] ShowProgressHUDPromptText:@"网络出现问题" SupView:self.view];
    }];
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
    
    return 200;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 200;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HSQTuiGoodsAndMoneryListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HSQTuiGoodsAndMoneryListCell" forIndexPath:indexPath];
    
    if (self.dataSource.count != 0)
    {
        cell.model = self.dataSource[indexPath.row];
    }
    
    cell.delegate = self;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    HSQTuiGoodsandMoneryListModel *model = self.dataSource[indexPath.row];
    
    HSQLog(@"==投诉id=%@",model.complainId);
    
    HSQTuiGoodAndMoneryDetailViewController *detailVC = [[HSQTuiGoodAndMoneryDetailViewController alloc] init];
    
    detailVC.complainId = model.complainId;
    
    detailVC.Navtion_title = @"投诉详情";
    
    detailVC.Order_Type = @"300";
    
    [self.navigationController pushViewController:detailVC animated:YES];
}

/**
 * @brief 投诉详情的点击
 */
- (void)RightBtnWithCellClickAction:(UIButton *)sender{
    
    HSQTuiGoodsAndMoneryListCell *cell = (HSQTuiGoodsAndMoneryListCell *)sender.superview.superview.superview;
    
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    HSQTuiGoodsandMoneryListModel *model = self.dataSource[indexPath.row];
    
    HSQTuiGoodAndMoneryDetailViewController *detailVC = [[HSQTuiGoodAndMoneryDetailViewController alloc] init];
    
    detailVC.complainId = model.complainId;
    
    detailVC.Order_Type = @"300";
    
    [self.navigationController pushViewController:detailVC animated:YES];
    
    
}

/**
 * @brief 撤销投诉的点击
 */
-(void)LeftBtnWithCellClickAction:(UIButton *)sender{
    
    HSQTuiGoodsAndMoneryListCell *cell = (HSQTuiGoodsAndMoneryListCell *)sender.superview.superview.superview;
    
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:@"确认撤销吗？" preferredStyle:(UIAlertControllerStyleAlert)];
    
    UIAlertAction *Cancel_action = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:nil];
    
    UIAlertAction *delete_action = [UIAlertAction actionWithTitle:@"确认" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        
        [self InformTheServerThatIwantToWithdrawMyComplaint:indexPath];
    }];
    
    [alertVC addAction:delete_action];
    
    [alertVC addAction:Cancel_action];
    
    [self presentViewController:alertVC animated:YES completion:nil];
}

/**
 * @brief 通知服务器，我要撤销投诉
 */
- (void)InformTheServerThatIwantToWithdrawMyComplaint:(NSIndexPath *)indexPath{
    
    HSQTuiGoodsandMoneryListModel *model = self.dataSource[indexPath.row];
    
    HSQLog(@"==投诉id=%@",model.complainId);
    
    NSDictionary *params = @{@"token":[HSQAccountTool account].token,@"complainId":model.complainId};
    
    AFNetworkRequestTool *requestTool = [AFNetworkRequestTool shareRequestTool];
    
    [requestTool.manger POST:UrlAdress(KCheXiaoTouSuUrl) parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if ([responseObject[@"code"] integerValue] == 200)
        {
            model.showMemberClose = @"0";
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





































@end
