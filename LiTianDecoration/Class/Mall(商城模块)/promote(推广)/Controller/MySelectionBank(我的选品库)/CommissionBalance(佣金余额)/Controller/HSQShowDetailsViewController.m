
//
//  HSQShowDetailsViewController.m
//  LiTianDecoration
//
//  Created by administrator on 2018/6/15.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import "HSQShowDetailsViewController.h"
#import "HSQAccountTool.h"
#import "HSQShowDetailsTListCell.h"
#import "HSQCommissionHomeViewController.h"

@interface HSQShowDetailsViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, strong) NSDictionary *datas;

@end

@implementation HSQShowDetailsViewController

-(NSMutableArray *)dataSource{
    
    if (_dataSource == nil) {
        
        self.dataSource = [NSMutableArray arrayWithObjects:@"申请单号",@"提现金额",@"收款账户类型",@"收款账号",@"收款人姓名",@"创建时间",@"提现状态", nil];
    }
    
    return _dataSource;
}


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.view.backgroundColor = KViewBackGroupColor;
    
    self.navigationItem.title = @"提现详情";
    
    self.datas = [NSDictionary dictionary];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:KImageName(@"LeftBackIcon") style:(UIBarButtonItemStyleDone) target:self action:@selector(ItemBackClickAction:)];
    
    // 创建tableView
    [self CreatTableView];
    
    // 提现详情
    [self RequestShowDetailsDataFromeServer];
}

- (void)ItemBackClickAction:(UIBarButtonItem *)sender{
    
    if (self.source == 100)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else if (self.source == 200)
    {
        for (UIViewController *VC in self.navigationController.viewControllers) {
            
            if ([VC isKindOfClass:[HSQCommissionHomeViewController class]]) {
                
                [self.navigationController popToViewController:VC animated:YES];
            }
        }
    }
}

/**
 * @brief 创建tableView
 */
- (void)CreatTableView{
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - KSafeTopeHeight - KSafeBottomHeight) style:(UITableViewStylePlain)];
    
    tableView.backgroundColor = [UIColor clearColor];
    
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    tableView.delegate = self;
    
    tableView.dataSource = self;
    
    [tableView registerClass:[HSQShowDetailsTListCell class] forCellReuseIdentifier:@"HSQShowDetailsTListCell"];
    
    [self.view addSubview:tableView];
    
    self.tableView = tableView;
}


/**
 * @brief 提现详情
 */
- (void)RequestShowDetailsDataFromeServer{
    
    [[HSQProgressHUDManger Manger] ShowLoadingDataFromeServer:@"" ToView:self.view IsClearColor:YES];
    
    NSDictionary *params = @{@"token":[HSQAccountTool account].token,@"cashId":self.cashId};
    
    AFNetworkRequestTool *requestTool = [AFNetworkRequestTool shareRequestTool];
    
    [requestTool.manger POST:UrlAdress(KPromotionCommissionDetailDataUrl) parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        HSQLog(@"==推广佣金提现提现详情==%@",responseObject);
        
        [[HSQProgressHUDManger Manger] DismissProgressHUD];
                
        if ([responseObject[@"code"] integerValue] == 200)
        {
            self.datas = responseObject[@"datas"];
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
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
     return 50;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HSQShowDetailsTListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HSQShowDetailsTListCell" forIndexPath:indexPath];
    
    cell.StatePlacher_Label.text = self.dataSource[indexPath.row];
    
    if (self.datas.allKeys.count != 0)
    {
        if (indexPath.row == 0) // 申请单号
        {
            cell.State_Label.text = [NSString stringWithFormat:@"%@",self.datas[@"cashInfo"][@"cashSn"]];
        }
        else if (indexPath.row == 1) // 提现金额
        {
            NSString *amount = [NSString stringWithFormat:@"%@",self.datas[@"cashInfo"][@"amount"]];
            
            cell.State_Label.text = [NSString stringWithFormat:@"%.2f元",amount.floatValue];
        }
        else if (indexPath.row == 2) // 收款账户类型
        {
            NSString *accountType =  [NSString stringWithFormat:@"%@",self.datas[@"cashInfo"][@"accountType"]];
            
            cell.State_Label.text = ([accountType isEqualToString:@"bank"] ? @"银行":@"支付宝");
        }
        else if (indexPath.row == 3) // 收款账号
        {
            cell.State_Label.text =  [NSString stringWithFormat:@"%@",self.datas[@"cashInfo"][@"bankAccountNumber"]];
        }
        else if (indexPath.row == 4) // 收款人姓名
        {
            cell.State_Label.text =  [NSString stringWithFormat:@"%@",self.datas[@"cashInfo"][@"payPerson"]];
        }
        else if (indexPath.row == 5) // 创建时间
        {
            cell.State_Label.text =  [NSString stringWithFormat:@"%@",self.datas[@"cashInfo"][@"addTime"]];
        }
        else if (indexPath.row == 6) // 提现状态
        {
            cell.State_Label.text =  [NSString stringWithFormat:@"%@",self.datas[@"cashInfo"][@"stateText"]];
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    

}

















@end
