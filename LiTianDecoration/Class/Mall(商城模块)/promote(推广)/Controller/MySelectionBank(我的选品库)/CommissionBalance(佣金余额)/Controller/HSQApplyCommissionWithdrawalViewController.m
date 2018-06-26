//
//  HSQApplyCommissionWithdrawalViewController.m
//  LiTianDecoration
//
//  Created by administrator on 2018/6/15.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import "HSQApplyCommissionWithdrawalViewController.h"
#import "HSQShowDetailsViewController.h"
#import "HSQAccountTool.h"

@interface HSQApplyCommissionWithdrawalViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *AccountType_Label;

@property (weak, nonatomic) IBOutlet UILabel *payPerson_Label;

@property (weak, nonatomic) IBOutlet UILabel *bankAccountNumber_Label;

@property (weak, nonatomic) IBOutlet UILabel *BankName_Label;

@property (weak, nonatomic) IBOutlet UIImageView *BankName_BgImageView;

@property (weak, nonatomic) IBOutlet UILabel *BankPlacher_Label;

@property (weak, nonatomic) IBOutlet UITextField *Monery_TextField;

@property (weak, nonatomic) IBOutlet UITextField *PayPassWord_TextField;

@property (nonatomic, strong) NSDictionary *datas;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *TopMargin;

@property (weak, nonatomic) IBOutlet UILabel *PayCommission_Label; // 佣金金额

@end

@implementation HSQApplyCommissionWithdrawalViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.view.backgroundColor = KViewBackGroupColor;
    
    self.navigationItem.title = @"推广佣金提现";
    
    self.datas = [NSDictionary dictionary];
    
    // 获取推广会员的信息
    [self GetTheInformationOfPromotionMembers];
}

/**
 * @brief 获取推广会员的信息
 */
- (void)GetTheInformationOfPromotionMembers{
    
    [[HSQProgressHUDManger Manger] ShowLoadingDataFromeServer:@"" ToView:self.view IsClearColor:YES];
    
    NSDictionary *params = @{@"token":[HSQAccountTool account].token};
    
    AFNetworkRequestTool *requestTool = [AFNetworkRequestTool shareRequestTool];
    
    [requestTool.manger POST:UrlAdress(KInformationPromotionCommissionUrl) parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [[HSQProgressHUDManger Manger] DismissProgressHUD];
        
        self.datas = responseObject[@"datas"];
        
        if ([responseObject[@"code"] integerValue] == 200)
        {
            // 收款人姓名
            self.payPerson_Label.text = [NSString stringWithFormat:@"%@",responseObject[@"datas"][@"distributor"][@"payPerson"]];
            
            // 账户类型
            NSString *accountType = [NSString stringWithFormat:@"%@",responseObject[@"datas"][@"distributor"][@"accountType"]];
            
            if ([accountType isEqualToString:@"bank"]) // 银行
            {
                self.BankName_BgImageView.hidden = self.BankPlacher_Label.hidden = self.BankName_Label.hidden = NO;
                
                // 银行名称
                self.BankName_Label.text = [NSString stringWithFormat:@"%@",responseObject[@"datas"][@"distributor"][@"bankAccountName"]];
                
                self.TopMargin.constant = 1;
                
                self.AccountType_Label.text = @"银行";
            }
            else
            {
                self.BankName_BgImageView.hidden = self.BankPlacher_Label.hidden = self.BankName_Label.hidden = YES;
                
                self.TopMargin.constant = -40;
                
                self.AccountType_Label.text = @"支付宝";
            }

            // 收款账号
            self.bankAccountNumber_Label.text = [NSString stringWithFormat:@"%@",responseObject[@"datas"][@"distributor"][@"bankAccountNumber"]];
            
            // 佣金金额
            NSString *payCommission = [NSString stringWithFormat:@"%@",responseObject[@"datas"][@"distributor"][@"commissionAvailable"]];
                        
            self.PayCommission_Label.text = [NSString stringWithFormat:@"佣金金额\n¥%.2f",payCommission.floatValue];

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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 * @brief 确认提交
 */
- (IBAction)SubmitButtonClickAction:(UIButton *)sender {
    
    if (self.Monery_TextField.text.length == 0)
    {
        [[HSQProgressHUDManger Manger] ShowProgressHUDPromptText:@"请输入提现金额" SupView:self.view];
    }
    else if (self.PayPassWord_TextField.text.length == 0)
    {
        [[HSQProgressHUDManger Manger] ShowProgressHUDPromptText:@"请输入密码" SupView:self.view];
    }
    else
    {
        [[HSQProgressHUDManger Manger] ShowLoadingDataFromeServer:@"" ToView:self.view IsClearColor:YES];
        
        NSDictionary *params = @{@"token":[HSQAccountTool account].token,@"amount":self.Monery_TextField.text,@"payPwd":self.PayPassWord_TextField.text};
        
        AFNetworkRequestTool *requestTool = [AFNetworkRequestTool shareRequestTool];
        
        [requestTool.manger POST:UrlAdress(KSaveCommissionWithdrawalRecordsUrl) parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            [[HSQProgressHUDManger Manger] DismissProgressHUD];
            
            self.datas = responseObject[@"datas"];
            
            if ([responseObject[@"code"] integerValue] == 200)
            {
                [[HSQProgressHUDManger Manger] ShowProgressHUDPromptText:@"提现成功" SupView:self.view];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"WithdrawalSuccess" object:self];
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    
                    HSQShowDetailsViewController *ShowDetailsVC = [[HSQShowDetailsViewController alloc] init];
                    
                    ShowDetailsVC.cashId = [NSString stringWithFormat:@"%@",responseObject[@"datas"][@"cashId"]];
                    
                    ShowDetailsVC.source = 200;
                    
                    [self.navigationController pushViewController:ShowDetailsVC animated:YES];
                });
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
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    
    return YES;
}

-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}








@end
