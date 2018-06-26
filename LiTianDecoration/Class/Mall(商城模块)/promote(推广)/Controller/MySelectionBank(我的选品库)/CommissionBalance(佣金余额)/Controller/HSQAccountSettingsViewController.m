//
//  HSQAccountSettingsViewController.m
//  LiTianDecoration
//
//  Created by administrator on 2018/6/15.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import "HSQAccountSettingsViewController.h"
#import "HSQAccountTool.h"

@interface HSQAccountSettingsViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *Name_Label;

@property (weak, nonatomic) IBOutlet UILabel *PhoneNumber_Label;

@property (weak, nonatomic) IBOutlet UILabel *IDNumber_Label;

@property (weak, nonatomic) IBOutlet UIButton *Bank_Button;

@property (weak, nonatomic) IBOutlet UIButton *ALiPay_Button;

@property (weak, nonatomic) IBOutlet UILabel *PayeeName_Label; // 收款人姓名

@property (weak, nonatomic) IBOutlet UITextField *PayeeAccount_TextField; // 收款人账号

@property (weak, nonatomic) IBOutlet UITextField *BankName_TextField; // 银行名称

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *TopMargin;

@property (weak, nonatomic) IBOutlet UIView *BgView; // 银行名称背景图

@property (nonatomic, copy) NSString *accountType;  // 账户类型

@property (nonatomic, strong) NSDictionary *datas;

@end

@implementation HSQAccountSettingsViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.view.backgroundColor = KViewBackGroupColor;
    
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
    
    [requestTool.manger POST:UrlAdress(KGetPromotionMemberInformationUrl) parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        HSQLog(@"====%@",responseObject);
        
        [[HSQProgressHUDManger Manger] DismissProgressHUD];
        
        self.datas = responseObject[@"datas"];
        
        if ([responseObject[@"code"] integerValue] == 200)
        {
            // 姓名
            self.Name_Label.text = [NSString stringWithFormat:@"%@",responseObject[@"datas"][@"distributor"][@"memberName"]];
            
            // 手机号
            self.PhoneNumber_Label.text = [NSString stringWithFormat:@"%@",responseObject[@"datas"][@"distributor"][@"bindPhone"]];
            
            // 身份证号
            self.IDNumber_Label.text = [NSString stringWithFormat:@"%@",responseObject[@"datas"][@"distributor"][@"idCartNumber"]];
            
            // 收款人姓名
            self.PayeeName_Label.text = [NSString stringWithFormat:@"%@",responseObject[@"datas"][@"distributor"][@"payPerson"]];
            
            // 收款账号
            self.PayeeAccount_TextField.text = [NSString stringWithFormat:@"%@",responseObject[@"datas"][@"distributor"][@"bankAccountNumber"]];
            
            // 账户类型
            NSString *accountType = [NSString stringWithFormat:@"%@",responseObject[@"datas"][@"distributor"][@"accountType"]];
            
            self.accountType = accountType;
            
            if ([accountType isEqualToString:@"bank"]) // 银行
            {
                self.BgView.hidden = NO;
                
                // 银行名称
                self.IDNumber_Label.text = [NSString stringWithFormat:@"%@",responseObject[@"datas"][@"distributor"][@"bankAccountName"]];
                
               self.Bank_Button.selected = YES;
                
                self.ALiPay_Button.selected = NO;
                
                self.TopMargin.constant = 60;
            }
            else
            {
                self.BgView.hidden = YES;
                
                self.Bank_Button.selected = NO;
                
                self.ALiPay_Button.selected = YES;
                
                self.TopMargin.constant = 20;
            }
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
 * @brief 选择银行
 */
- (IBAction)ChooseBankTypeBtnClickAction:(UIButton *)sender {
    
    [UIView animateWithDuration:0.25 animations:^{
        
        self.BgView.hidden = NO;
        
        self.Bank_Button.selected = YES;
        
        self.ALiPay_Button.selected = NO;
        
        self.TopMargin.constant = 60;
        
        self.accountType = @"bank";
    }];
}

/**
 * @brief 选择支付宝
 */
- (IBAction)ChooseALiPayBtnClickAction:(UIButton *)sender {
    
    [UIView animateWithDuration:0.25 animations:^{
        
        self.BgView.hidden = YES;
        
        self.Bank_Button.selected = NO;
        
        self.ALiPay_Button.selected = YES;
        
        self.TopMargin.constant = 20;
        
        self.accountType = @"alipay";
    }];
}

/**
 * @brief 保存修改
 */
- (IBAction)SaveAndChangeBnClickAction:(UIButton *)sender {
    
    if ([self.accountType isEqualToString:@"bank"] && self.BankName_TextField.text.length == 0) // 银行
    {
        [[HSQProgressHUDManger Manger] ShowProgressHUDPromptText:@"请输入开户行名称" SupView:self.view];
    }
    else
    {
        [[HSQProgressHUDManger Manger] ShowLoadingDataFromeServer:@"" ToView:self.view IsClearColor:YES];
        
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        
        params[@"token"] = [HSQAccountTool account].token;
        
        params[@"payPerson"] =  [NSString stringWithFormat:@"%@",self.datas[@"distributor"][@"payPerson"]];
        
        params[@"realName"] = [NSString stringWithFormat:@"%@",self.datas[@"distributor"][@"realName"]];  // 申请时填写的真实姓名
        
        params[@"idCartNumber"] = [NSString stringWithFormat:@"%@",self.datas[@"distributor"][@"idCartNumber"]];  // 身份证号
        
        params[@"idCartFrontImage"] = [NSString stringWithFormat:@"%@",self.datas[@"distributor"][@"idCartFrontImage"]];
        
        params[@"idCartBackImage"] = [NSString stringWithFormat:@"%@",self.datas[@"distributor"][@"idCartBackImage"]];
        
        params[@"idCartHandImage"] = [NSString stringWithFormat:@"%@",self.datas[@"distributor"][@"idCartHandImage"]];
        
        params[@"bankAccountNumber"] = self.PayeeAccount_TextField.text;
        
        params[@"bindPhone"] = [NSString stringWithFormat:@"%@",self.datas[@"distributor"][@"bindPhone"]];
        
        if ([self.accountType isEqualToString:@"bank"]) // 银行
        {
            params[@"bankAccountName"] = self.BankName_TextField.text;
            
            params [@"accountType"] = @"bank";
        }
        else
        {
            params[@"bankAccountName"] = @"";
            
            params [@"accountType"] = @"alipay";
        }
        
        AFNetworkRequestTool *requestTool = [AFNetworkRequestTool shareRequestTool];
        
        [requestTool.manger POST:UrlAdress(KSaveApplyCertificationInfoUrl) parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            [[HSQProgressHUDManger Manger] DismissProgressHUD];
            
            HSQLog(@"=提交的信息==%@",responseObject);
            
            if ([responseObject[@"code"] integerValue] == 200)
            {
                [[HSQProgressHUDManger Manger] ShowProgressHUDPromptText:@"保存成功" SupView:self.view];
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

@end
