
//  HSQAdressListViewController.m
//  LiTianDecoration
//
//  Created by administrator on 2018/4/25.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import "HSQAdressListViewController.h"
#import "HSQNewAdressViewController.h"
#import "HSQAccountTool.h"
#import "HSQAdressListCell.h"
#import "HSQAcceptAddressListModel.h"
#import "HSQAdressListFooterView.h"


@interface HSQAdressListViewController ()<UITableViewDelegate,UITableViewDataSource,HSQAdressListFooterViewDelegate,HSQAdressListCellDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, strong) HSQNoDataView *NoDataView;

@end

@implementation HSQAdressListViewController

-(NSMutableArray *)dataSource{
    
    if (_dataSource == nil) {
        
        self.dataSource = [NSMutableArray array];
    }
    
    return _dataSource;
}

-(HSQNoDataView *)NoDataView{
    
    if (_NoDataView == nil) {
        
        self.NoDataView = [[HSQNoDataView alloc] initWithTitle:@"亲，暂无地址额" imageName:@"123" height:50 TopMargin:0];
    }
    
    return _NoDataView;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.navigationItem.title = @"地址管理";
    
    self.view.backgroundColor = KViewBackGroupColor;
    
    // 添加右边的添加按钮
    [self SetUpRightItem];
    
    // 创建tableView
    [self SetUpTableView];
    
    // 请求地址列表数据
    [self RequestAdressListDataFromeServer];
}

/**
 * @brief 添加右边的添加按钮
 */
- (void)SetUpRightItem{
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"添加" style:(UIBarButtonItemStylePlain) target:self action:@selector(AddNewAdressAction:)];
    
    self.navigationItem.rightBarButtonItem = item;
}

/**
 * @brief 创建tableView
 */
- (void)SetUpTableView{
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - KSafeTopeHeight - KSafeBottomHeight) style:(UITableViewStylePlain)];
    
    tableView.backgroundColor = [UIColor clearColor];
    
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    tableView.delegate = self;
    
    tableView.dataSource = self;
    
    [tableView registerClass:[HSQAdressListCell class] forCellReuseIdentifier:@"HSQAdressListCell"];
    
    [tableView registerClass:[HSQAdressListFooterView class] forHeaderFooterViewReuseIdentifier:@"HSQAdressListFooterView"];
    
    [self.view addSubview:tableView];
    
    self.tableView = tableView;
}

/**
 * 请求地址列表数据
 */
- (void)RequestAdressListDataFromeServer{
    
    // 1.下拉加载更多的数据
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(RequestAdressListData)];
    
    // 2.自动改变透明度
    self.tableView.mj_header.automaticallyChangeAlpha = YES;
    
    [self.tableView.mj_header beginRefreshing];
}

/**
 * 加载最新的地址列表数据
 */
- (void)RequestAdressListData{
    
    NSDictionary *diction = @{@"token":[HSQAccountTool account].token};
    
    AFNetworkRequestTool *RequestTool = [AFNetworkRequestTool shareRequestTool];
    
    [RequestTool.manger POST:UrlAdress(KadressListUrl) parameters:diction progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        HSQLog(@"===%@",responseObject);
        if ([responseObject[@"code"] integerValue] == 200)
        {
            self.dataSource = [HSQAcceptAddressListModel mj_objectArrayWithKeyValuesArray:responseObject[@"datas"][@"addressList"]];
        }
        else
        {
            NSString *errorString = [NSString stringWithFormat:@"%@",responseObject[@"datas"][@"error"]];
            
            [[HSQProgressHUDManger Manger] ShowDisplayFailedToLoadData:errorString SuperView:self.view];
        }
        
        if (self.dataSource.count == 0)
        {
            [self.view addSubview:self.NoDataView];
        }
        
        [self.tableView reloadData];
        
        [self.tableView.mj_header endRefreshing];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
         [self.tableView.mj_header endRefreshing];
        
        [self.view addSubview:self.NoDataView];
        
        [[HSQProgressHUDManger Manger] ShowDisplayFailedToLoadData:KErrorPlacherString SuperView:self.view];
    }];
}

/**
 * @brief 添加新的地址的点击事件
 */
- (void)AddNewAdressAction:(UIBarButtonItem *)sender{
    
    HSQNewAdressViewController *NewAdressVC = [[HSQNewAdressViewController alloc] init];
    
    NewAdressVC.Adress_Url = UrlAdress(KAddNewAdressUrl);
    
    NewAdressVC.addNewAdressSuccess = ^(NSString *string){
        
        [self.tableView.mj_header beginRefreshing];
    };
    
    [self.navigationController pushViewController:NewAdressVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate,UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return (self.dataSource.count == 0 ? 0 : 1);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    self.NoDataView.hidden = (self.dataSource.count != 0);
    
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 100;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    HSQAcceptAddressListModel *model = self.dataSource[indexPath.row];
    
    return [self.tableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:[HSQAdressListCell class] contentViewWidth:KScreenWidth] + 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 60;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    HSQAdressListFooterView *FooterView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"HSQAdressListFooterView"];
    
    FooterView.delegate = self;
    
    return FooterView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    HSQAdressListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HSQAdressListCell" forIndexPath:indexPath];
    
    if (self.dataSource.count != 0)
    {
        cell.model = self.dataSource[indexPath.row];
    }
    
    cell.delegate = self;

    ////// 此步设置用于实现cell的frame缓存，可以让tableview滑动更加流畅 //////
    [cell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.Source.integerValue == 100) // 提交订单界面
    {
        HSQAcceptAddressListModel *model = self.dataSource[indexPath.row];
        
        if (self.SelectAdressModel) {
            
            self.SelectAdressModel(model);
        }
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - HSQAdressListCellDelegate
- (void)DeleteTheClickEventOfTheReceivingAddress:(UIButton *)sender{
    
    HSQAdressListCell *cell = (HSQAdressListCell *)sender.superview.superview;
    
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    HSQAcceptAddressListModel *model = self.dataSource[indexPath.row];
    
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"确认要删除此收货地址吗？" preferredStyle:(UIAlertControllerStyleAlert)];
    
    UIAlertAction *Cancel_Action = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:nil];
    
    UIAlertAction *Defaul_Action = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        
        [self NotifyTheServerToDeleteTheReceivingAddress:model];
        
    }];
    
    [alertVC addAction:Cancel_Action];
    
    [alertVC addAction:Defaul_Action];
    
    [self presentViewController:alertVC animated:YES completion:nil];
    
}

- (void)EditTheClickEventOfTheReceivingAddress:(UIButton *)sender{
    
    HSQAdressListCell *cell = (HSQAdressListCell *)sender.superview.superview;
    
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    HSQAcceptAddressListModel *model = self.dataSource[indexPath.row];
    
    HSQNewAdressViewController *NewAdressVC = [[HSQNewAdressViewController alloc] init];
    
    NewAdressVC.model = model;
    
    NewAdressVC.Adress_Url = UrlAdress(kEditAdressListUrl);
    
    NewAdressVC.addNewAdressSuccess = ^(NSString *string){
        
        [self.tableView.mj_header beginRefreshing];
    };
    
    [self.navigationController pushViewController:NewAdressVC animated:YES];
}

/**
 * @brief 通知服务器删除收货地址
 */
- (void)NotifyTheServerToDeleteTheReceivingAddress:(HSQAcceptAddressListModel *)model{
    
    [[HSQProgressHUDManger Manger] ShowLoadingDataFromeServer:@"" ToView:self.view IsClearColor:YES];
    
    NSDictionary *diction = @{@"token":[HSQAccountTool account].token,@"addressId":model.addressId};
    
    AFNetworkRequestTool *RequestTool = [AFNetworkRequestTool shareRequestTool];
    
    [RequestTool.manger POST:UrlAdress(kDeleteAdressListUrl) parameters:diction progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        HSQLog(@"====%@",responseObject);
        [[HSQProgressHUDManger Manger] DismissProgressHUD];
        
        if ([responseObject[@"code"] integerValue] == 200)
        {
            [self.dataSource removeObject:model];
        }
        else
        {
            NSString *errorString = [NSString stringWithFormat:@"%@",responseObject[@"datas"][@"error"]];
            
            [[HSQProgressHUDManger Manger] ShowDisplayFailedToLoadData:errorString SuperView:self.view];
        }
        
        [self.tableView reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [[HSQProgressHUDManger Manger] ShowDisplayFailedToLoadData:@"地址删除失败！" SuperView:self.view];
        
    }];
}

#pragma mark - HSQAdressListFooterViewDelegate

- (void)AddNewAdressWithFooterView:(UIButton *)sender{
    
    HSQNewAdressViewController *NewAdressVC = [[HSQNewAdressViewController alloc] init];
    
    NewAdressVC.Adress_Url = UrlAdress(KAddNewAdressUrl);
    
    NewAdressVC.addNewAdressSuccess = ^(NSString *string){
        
        [self.tableView.mj_header beginRefreshing];
    };
    
    [self.navigationController pushViewController:NewAdressVC animated:YES];
}












@end
