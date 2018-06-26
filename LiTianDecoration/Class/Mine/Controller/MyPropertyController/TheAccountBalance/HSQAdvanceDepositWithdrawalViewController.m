//
//  HSQAdvanceDepositWithdrawalViewController.m
//  LiTianDecoration
//
//  Created by administrator on 2018/6/19.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import "HSQAdvanceDepositWithdrawalViewController.h"
#import "HSQMyAccountBalanceViewController.h"
#import "HSQAccountTool.h"

@interface HSQAdvanceDepositWithdrawalViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *Balance_Label; // 余额

@property (weak, nonatomic) IBOutlet UITextField *WithdrawalAmount_TextField; // 提现金额

@property (weak, nonatomic) IBOutlet UITextField *CollectingBank_Textfield; // 收款银行

@property (weak, nonatomic) IBOutlet UITextField *PaymentAccount_TextField; // 收款账号

@property (weak, nonatomic) IBOutlet UITextField *PaymentName_Textfield; // 收款人姓名

@property (weak, nonatomic) IBOutlet UITextField *PayPassWord_TextField; // 支付密码



@end

@implementation HSQAdvanceDepositWithdrawalViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.view.backgroundColor = KViewBackGroupColor;
    
    self.navigationItem.title = @"预存款提现";
    
    // 请求用户中心的数据
    [self requestUserCenterDataFromeserver];
}


/**
 * @brief 请求用户中心的数据
 */
- (void)requestUserCenterDataFromeserver{
        
    [[HSQProgressHUDManger Manger] ShowLoadingDataFromeServer:nil ToView:self.view IsClearColor:NO];
    
    NSDictionary *diction = @{@"token":[HSQAccountTool account].token};
    
    AFNetworkRequestTool *RequestTool = [AFNetworkRequestTool shareRequestTool];
    
    [RequestTool.manger POST:UrlAdress(KUserCenterDataUrl) parameters:diction progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *responseObject) {
        
        HSQLog(@"=用户中心的数据==%@",responseObject);
        
        [[HSQProgressHUDManger Manger] DismissProgressHUD];
        
        if ([responseObject[@"code"] integerValue] == 200)
        {
            NSString *predepositAvailable = [NSString stringWithFormat:@"%@",responseObject[@"datas"][@"memberInfo"][@"predepositAvailable"]];
            
            self.Balance_Label.text = [NSString stringWithFormat:@"¥%.2f",predepositAvailable.floatValue];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [[HSQProgressHUDManger Manger] ShowDisplayFailedToLoadData:@"网络出问题啦！" SuperView:self.view];
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 * @brief 提交
 */
- (IBAction)SubmitButtonClickAction:(UIButton *)sender {
  
    if (self.WithdrawalAmount_TextField.text.length == 0)
    {
        [[HSQProgressHUDManger Manger] ShowProgressHUDPromptText:@"请输入提现金额" SupView:self.view];
    }
    else if (self.CollectingBank_Textfield.text.length == 0)
    {
         [[HSQProgressHUDManger Manger] ShowProgressHUDPromptText:@"开户行名称或支付宝等虚拟方式" SupView:self.view];
    }
    else if (self.PaymentAccount_TextField.text.length == 0)
    {
        [[HSQProgressHUDManger Manger] ShowProgressHUDPromptText:@"银行卡号或支付宝等虚拟账号" SupView:self.view];
    }
    else if (self.PaymentName_Textfield.text.length == 0)
    {
        [[HSQProgressHUDManger Manger] ShowProgressHUDPromptText:@"收款账号的开户人姓名" SupView:self.view];
    }
    else if (self.PayPassWord_TextField.text.length == 0)
    {
        [[HSQProgressHUDManger Manger] ShowProgressHUDPromptText:@"请输入密码" SupView:self.view];
    }
    else
    {
        [[HSQProgressHUDManger Manger] ShowLoadingDataFromeServer:@"" ToView:self.view IsClearColor:YES];
        
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"token"] = [HSQAccountTool account].token;
        
        params[@"smsAuthCode"] = self.smsAuthCode;
        
        params[@"amount"] = self.WithdrawalAmount_TextField.text;
        
        params[@"receiveCompany"] = self.CollectingBank_Textfield.text;
        
        params[@"receiveAccount"] = self.PaymentAccount_TextField.text;
        
        params[@"receiveUser"] = self.PaymentName_Textfield.text;
        
        params[@"payPwd"] = self.PayPassWord_TextField.text;
        
        AFNetworkRequestTool *RequestTool = [AFNetworkRequestTool shareRequestTool];
        
        [RequestTool.manger POST:UrlAdress(KWithdrawalApplication) parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *responseObject) {
            
            HSQLog(@"=会员预存款提现申请==%@",responseObject);
            
            [[HSQProgressHUDManger Manger] DismissProgressHUD];
            
            if ([responseObject[@"code"] integerValue] == 200)
            {
                [[HSQProgressHUDManger Manger] ShowProgressHUDPromptText:@"提现成功" SupView:self.view];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"AdvanceWithdrawalSuccess" object:self];
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    
                    for (UIViewController *VC in self.navigationController.viewControllers) {
                        
                        if ([VC isKindOfClass:[HSQMyAccountBalanceViewController class]]) {
                            
                            [self.navigationController popToViewController:VC animated:YES];
                        }
                    }
                });
            }
            else
            {
                NSString *errorString = [NSString stringWithFormat:@"%@",responseObject[@"datas"][@"error"]];
                
                [[HSQProgressHUDManger Manger] ShowDisplayFailedToLoadData:errorString SuperView:self.view];
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            [[HSQProgressHUDManger Manger] ShowDisplayFailedToLoadData:KErrorPlacherString SuperView:self.view];
        }];
    }
}

/**
 * @brief return键盘点击
 */
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if (textField == self.WithdrawalAmount_TextField)
   {
       [self.CollectingBank_Textfield becomeFirstResponder];
    }
    else if (textField == self.CollectingBank_Textfield)
    {
        [self.PaymentAccount_TextField becomeFirstResponder];
    }
    else if (textField == self.PaymentAccount_TextField)
    {
        [self.PaymentName_Textfield becomeFirstResponder];
    }
    else if (textField == self.PaymentName_Textfield)
    {
        [self.PayPassWord_TextField becomeFirstResponder];
    }
    else if (textField == self.PayPassWord_TextField)
    {
        [self.PayPassWord_TextField resignFirstResponder];
    }

    return YES;
}

@end
