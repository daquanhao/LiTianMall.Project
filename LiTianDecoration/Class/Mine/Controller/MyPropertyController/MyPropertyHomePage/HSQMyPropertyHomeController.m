//
//  HSQMyPropertyHomeController.m
//  LiTianDecoration
//
//  Created by administrator on 2018/4/28.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import "HSQMyPropertyHomeController.h"
#import "HSQMyPropertyHomeListCell.h"
#import "MyPropertyListModel.h"
#import "HSQAccountTool.h"
#import "HSQIntegralListViewController.h"
#import "HSQMyAccountBalanceViewController.h"
#import "HSQCouponsHomeViewController.h"
#import "HSQMemberPrizeViewController.h"

@interface HSQMyPropertyHomeController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, strong) NSDictionary *dataDiction;

@end

@implementation HSQMyPropertyHomeController

- (NSMutableArray *)dataSource{
    
    if (_dataSource == nil) {
        
        self.dataSource = [NSMutableArray array];
    }
    
    return _dataSource;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.view.backgroundColor = KViewBackGroupColor;
    
    self.navigationItem.title = @"我的财产";
    
    self.dataDiction = [NSDictionary dictionary];
    
    // 1.创建tableView
    [self CreatTableView];
    
    // 2.添加数据
    [self AddDataToTableView];
    
    // 3.请求我的财产的数据
    [self RequestMineMoneryDataFromeServer];
}

/**
 * @brief 创建tableView
 */
- (void)CreatTableView{
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - KSafeTopeHeight) style:(UITableViewStylePlain)];
    
    tableView.backgroundColor = [UIColor clearColor];
    
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    tableView.dataSource = self;
    
    tableView.delegate = self;
    
    [tableView setContentInset:UIEdgeInsetsMake(10, 0, 0, 0)];
    
    [self.view addSubview:tableView];
    
    self.tableView = tableView;
}

/**
 * @brief 添加数据
 */
- (void)AddDataToTableView{
    
    MyPropertyListModel *model01 = [[MyPropertyListModel alloc] init];
    model01.Title = @"账户余额";
    model01.describe_string = @"预存款账户余额，充值及提现明细";
    [self.dataSource addObject:model01];
    
    MyPropertyListModel *model02 = [[MyPropertyListModel alloc] init];
    model02.Title = @"店铺券";
    model02.describe_string = @"店铺券使用情况以及卡密领取店铺券操作";
    [self.dataSource addObject:model02];
    
    MyPropertyListModel *model03 = [[MyPropertyListModel alloc] init];
    model03.Title = @"平台券";
    model03.describe_string = @"平台红包使用情况以及卡密领取店铺券操作";
    [self.dataSource addObject:model03];
    
    MyPropertyListModel *model04 = [[MyPropertyListModel alloc] init];
    model04.Title = @"会员经验值";
    model04.describe_string = @"会员经验值获取日志";
    [self.dataSource addObject:model04];
    
    MyPropertyListModel *model05 = [[MyPropertyListModel alloc] init];
    model05.Title = @"会员积分";
    model05.describe_string = @"会员积分获取及消费日志";
    [self.dataSource addObject:model05];
    
    MyPropertyListModel *model06 = [[MyPropertyListModel alloc] init];
    model06.Title = @"会员奖品";
    model06.describe_string = @"会员参加商城活动获得的奖品";
    [self.dataSource addObject:model06];

}

/**
 * @brief 请求数据KMineMoneryUrl
 */
- (void)RequestMineMoneryDataFromeServer{
    
    [[HSQProgressHUDManger Manger] ShowLoadingDataFromeServer:@"" ToView:self.view IsClearColor:YES];
    
    NSDictionary *diction = @{@"token":[HSQAccountTool account].token};
    
    AFNetworkRequestTool *RequestTool = [AFNetworkRequestTool shareRequestTool];
    
    [RequestTool.manger POST:UrlAdress(KMineMoneryUrl) parameters:diction progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        HSQLog(@"==%@",responseObject);
        [[HSQProgressHUDManger Manger] DismissProgressHUD];
        
        if ([responseObject[@"code"] integerValue] == 200)
        {
            self.dataDiction = responseObject[@"datas"];
        }
        else
        {
            NSString *errorString = [NSString stringWithFormat:@"%@",responseObject[@"datas"][@"error"]];
            
            [[HSQProgressHUDManger Manger] ShowDisplayFailedToLoadData:errorString SuperView:self.view];
        }
        
        [self.tableView reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [[HSQProgressHUDManger Manger] ShowDisplayFailedToLoadData:@"我的财产数据加载失败" SuperView:self.view];
        
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate,UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 75;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 75;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    HSQMyPropertyHomeListCell *cell = [HSQMyPropertyHomeListCell HSQMyPropertyHomeListCellWithXIB];
    
    if (self.dataSource.count != 0)
    {
        cell.model = self.dataSource[indexPath.row];
    }
    
    [cell SetValueWithDiction:self.dataDiction indexPath:indexPath];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0) // 账户余额
    {
        HSQMyAccountBalanceViewController *MyAccountBalanceVC = [[HSQMyAccountBalanceViewController alloc] init];
        
        [self.navigationController pushViewController:MyAccountBalanceVC animated:YES];
    }
    else if (indexPath.row == 1) // 店铺券
    {
        HSQCouponsHomeViewController *CouponsHomeVC = [[HSQCouponsHomeViewController alloc] init];
        
        CouponsHomeVC.Navtion_Title = @"优惠券";
        
        CouponsHomeVC.LeftTop_Title = @"我的优惠券";
        
        CouponsHomeVC.RightTop_Title = @"领取优惠券";
        
        CouponsHomeVC.ID_Number = @"100";
        
        [self.navigationController pushViewController:CouponsHomeVC animated:YES];
    }
    else if (indexPath.row == 2) // 平台券
    {
        HSQCouponsHomeViewController *CouponsHomeVC = [[HSQCouponsHomeViewController alloc] init];
        
        CouponsHomeVC.Navtion_Title = @"红包";
        
        CouponsHomeVC.LeftTop_Title = @"我的红包";
        
        CouponsHomeVC.RightTop_Title = @"领取红包";
        
        CouponsHomeVC.ID_Number = @"200";
        
        [self.navigationController pushViewController:CouponsHomeVC animated:YES];
    }
    else if (indexPath.row == 3) // 会员经验值
    {
        HSQIntegralListViewController *IntegralListVC = [[HSQIntegralListViewController alloc] init];
        
        IntegralListVC.IntegralCount = [NSString stringWithFormat:@"%@",self.dataDiction[@"expPoints"]];
        
        IntegralListVC.Navtion_Title = @"经验值明细";
        
        IntegralListVC.DataUrl = UrlAdress(KExperienceValueUrl);
        
        IntegralListVC.Top_Title = @"我的经验值";
        
        [self.navigationController pushViewController:IntegralListVC animated:YES];
    }
    else if (indexPath.row == 4) // 会员积分
    {
        HSQIntegralListViewController *IntegralListVC = [[HSQIntegralListViewController alloc] init];
        
        IntegralListVC.IntegralCount = [NSString stringWithFormat:@"%@",self.dataDiction[@"points"]];
        
        IntegralListVC.Navtion_Title = @"积分明细";
        
        IntegralListVC.Top_Title = @"我的积分";
        
        IntegralListVC.DataUrl = UrlAdress(KIntegralListCell);
        
        [self.navigationController pushViewController:IntegralListVC animated:YES];
    }
    else if (indexPath.row == 5) // 会员奖品
    {
        HSQMemberPrizeViewController *MemberPrizeVC = [[HSQMemberPrizeViewController alloc] init];
        
        [self.navigationController pushViewController:MemberPrizeVC animated:YES];
    }
}











@end
