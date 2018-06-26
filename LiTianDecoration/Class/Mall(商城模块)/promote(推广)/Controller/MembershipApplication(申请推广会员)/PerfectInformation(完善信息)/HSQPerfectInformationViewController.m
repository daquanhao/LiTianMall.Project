//
//  HSQPerfectInformationViewController.m
//  LiTianDecoration
//
//  Created by administrator on 2018/6/11.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import "HSQPerfectInformationViewController.h"
#import "HSQPromotionAgreementViewController.h"
#import "HSQRealNameAuthenticaViewController.h"   // 实名认证
#import "HSQAccountTool.h"

@interface HSQPerfectInformationViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIButton *NickName_Button; // 会员名字

@property (weak, nonatomic) IBOutlet UITextField *Phone_TextField; // 会员的手机号

@property (weak, nonatomic) IBOutlet UIButton *Bank_Button; // 银行卡

@property (weak, nonatomic) IBOutlet UIButton *ALiPay_Button; // 支付宝

@property (weak, nonatomic) IBOutlet UITextField *PayeeName_TextField; // 收款人姓名

@property (weak, nonatomic) IBOutlet UITextField *PayeeAccount_TextField;

@property (weak, nonatomic) IBOutlet UITextField *BankName_TextField; // 银行名称

@property (weak, nonatomic) IBOutlet UIView *BankBgView; // 银行的背景图

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *TopMargin; // 间距

@property (nonatomic, assign) NSInteger PaymentType;  // 收款类型

@property (nonatomic, strong) NSMutableDictionary *CertificationDiction;  // 认证信息

@property (nonatomic, strong) NSMutableArray *IDNumberImage_Array; // 装有身份证照的数组

@property (nonatomic, strong) NSMutableArray *IDNumberImageName_Array; // 装有身份证照名字的数组

@end

@implementation HSQPerfectInformationViewController

- (NSMutableArray *)IDNumberImage_Array{
    
    if (_IDNumberImage_Array == nil) {
        
        self.IDNumberImage_Array = [NSMutableArray arrayWithObjects:@"123",@"123",@"123", nil];
    }
    
    return _IDNumberImage_Array;
}

- (NSMutableArray *)IDNumberImageName_Array{
    
    if (_IDNumberImageName_Array == nil) {
        
        self.IDNumberImageName_Array = [NSMutableArray array];
    }
    
    return _IDNumberImageName_Array;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.view.backgroundColor = KViewBackGroupColor;
    
    self.navigationItem.title = @"推广资格申请";
    
    self.PaymentType = 1;
    
    self.CertificationDiction = [NSMutableDictionary dictionary];
    
    NSString *UserName = [NSString stringWithFormat:@"%@",[HSQAccountTool account].memberName];
    
    NSString *memberName = [NSString stringWithFormat:@"%@(提交实名认证)",UserName];
    
    NSMutableAttributedString *attribe = [[NSMutableAttributedString alloc] initWithString:memberName];
    
    [attribe addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:NSMakeRange(UserName.length, memberName.length - UserName.length)];
    
    [attribe addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, UserName.length)];
    
    [self.NickName_Button setAttributedTitle:attribe forState:(UIControlStateNormal)];
    
}



/**
 * @brief 提交实名认证
 */
- (IBAction)SubmitRealNameAuthentication:(UIButton *)sender {
    
    HSQRealNameAuthenticaViewController *RealNameAuthenticaVC = [[HSQRealNameAuthenticaViewController alloc] init];
    
    RealNameAuthenticaVC.CertificationDiction = self.CertificationDiction;
    
    RealNameAuthenticaVC.SelectNameCertificationDataBlock = ^(NSMutableDictionary *params) {
        
        self.CertificationDiction = params;
        
        [self.IDNumberImage_Array replaceObjectAtIndex:0 withObject:params[@"idCartFrontImage"]];  // 正面照
        
        [self.IDNumberImage_Array replaceObjectAtIndex:1 withObject:params[@"idCartBackImage"]]; // 反面照
        
        [self.IDNumberImage_Array replaceObjectAtIndex:2 withObject:params[@"naidCartHandImageme"]]; // 手持身份证照
    };
    
    HSQLog(@"==认证信息=%@",self.CertificationDiction);
    
    [self.navigationController pushViewController:RealNameAuthenticaVC animated:YES];
}

/**
 * @brief 银行
 */
- (IBAction)BankButtonClickAction:(UIButton *)sender {
    
    [self.view endEditing:YES];
    
    [UIView animateWithDuration:0.25 animations:^{
        
        [self.ALiPay_Button setSelected:NO];
        
        [self.Bank_Button setSelected:YES];
        
        self.BankBgView.hidden = NO;
        
        self.TopMargin.constant = 10;
        
    }];
    
    self.PaymentType = 1;
    
    self.PayeeAccount_TextField.returnKeyType = UIReturnKeyNext;
}

/**
 * @brief 支付宝
 */
- (IBAction)AliPayButtonClickAction:(UIButton *)sender {
    
    [self.view endEditing:YES];
    
    [UIView animateWithDuration:0.25 animations:^{
        
        [self.ALiPay_Button setSelected:YES];
        
        [self.Bank_Button setSelected:NO];
        
        self.BankBgView.hidden = YES;
        
        self.TopMargin.constant = - 45;
        
    }];
    
    self.PaymentType = 2;
    
    self.PayeeAccount_TextField.returnKeyType = UIReturnKeyDone;
}

/**
 * @brief 查看服务协议
 */
- (IBAction)TheServiceAgreementBtnClickAction:(UIButton *)sender {
  
    HSQPromotionAgreementViewController *PromotionAgreementVC = [[HSQPromotionAgreementViewController alloc] init];

    [self.navigationController pushViewController:PromotionAgreementVC animated:YES];
}


- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    
    
}

/**
 * @brief 确认提交
 */
- (IBAction)ConfirmToSubmitBtnClickAction:(UIButton *)sender {
    
    if (self.CertificationDiction.allKeys.count == 0)
    {
        [[HSQProgressHUDManger Manger] ShowProgressHUDPromptText:@"请先提交实名认证" SupView:self.view];
    }
    else if (self.Phone_TextField.text.length == 0)
    {
        [[HSQProgressHUDManger Manger] ShowProgressHUDPromptText:@"请输入手机号" SupView:self.view];
    }
    else if (self.Phone_TextField.text.isPhone == NO)
    {
        [[HSQProgressHUDManger Manger] ShowProgressHUDPromptText:@"手机格式不正确" SupView:self.view];
    }
    else if (self.PayeeName_TextField.text.length == 0)
    {
         [[HSQProgressHUDManger Manger] ShowProgressHUDPromptText:@"请输入收款人姓名" SupView:self.view];
    }
    else if (self.PayeeAccount_TextField.text.length == 0)
    {
        [[HSQProgressHUDManger Manger] ShowProgressHUDPromptText:@"请输入收款人账号" SupView:self.view];
    }
    else if (self.PaymentType == 1 && self.BankName_TextField.text.length == 0)
    {
        [[HSQProgressHUDManger Manger] ShowProgressHUDPromptText:@"请输入开户行支行名称" SupView:self.view];
    }
    else
    {        
        // 1.第一步：现将身份证照上传至服务器
        [self NowAploadYourIdCardToTheServer];
    }
}

/**
 * @brief 现将身份证照上传至服务器
 */
- (void)NowAploadYourIdCardToTheServer{
    
    [self.IDNumberImageName_Array removeAllObjects];
    
    for (NSInteger i = 0; i < self.IDNumberImage_Array.count; i++) {
        
            UIImage *iconimage = self.IDNumberImage_Array[i];
            
            NSDictionary *params = @{@"token":[HSQAccountTool account].token,@"file":iconimage};
            
            NSData *data = UIImageJPEGRepresentation(iconimage, 0.001f);
            
            NSString *fileName = [NSString stringWithFormat:@"img%ld.png",i+1];
            
            // 1.现将图片批量上传至服务器
            AFNetworkRequestTool *requestTool = [AFNetworkRequestTool shareRequestTool];
            
            [requestTool.manger POST:UrlAdress(KUpLoadPictureUrl) parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
                
                [formData appendPartWithFileData:data  name:@"file"fileName:fileName mimeType:@"image/jpg/png/jpeg"];
                
            } progress:^(NSProgress * _Nonnull uploadProgress) {
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                HSQLog(@"=====%@",responseObject);
                if ([responseObject[@"code"] integerValue] == 200)
                {
                    NSString *name = [NSString stringWithFormat:@"%@",responseObject[@"datas"][@"name"]];
                    
                    [self.IDNumberImageName_Array addObject:name];
                    
                    if (self.IDNumberImageName_Array.count == self.IDNumberImage_Array.count) // 图片全部上传完成
                    {
                        // 2.会员申请推广资格认证保存
                        [self SubmitCompleteInformationToTheServer];
                        
                    }
                }
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
                [[HSQProgressHUDManger Manger] ShowProgressHUDPromptText:@"网络出问题啦" SupView:self.view];
                
            }];
        }
}

/**
 * @brief 将完善的信息提交至服务器
 */
- (void)SubmitCompleteInformationToTheServer{
    
    [[HSQProgressHUDManger Manger] ShowLoadingDataFromeServer:@"" ToView:self.view IsClearColor:YES];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"token"] = [HSQAccountTool account].token;
    params[@"payPerson"] = self.PayeeName_TextField.text;
    params[@"realName"] = [NSString stringWithFormat:@"%@",self.CertificationDiction[@"name"]];  // 申请时填写的真实姓名
    params[@"idCartNumber"] = [NSString stringWithFormat:@"%@",self.CertificationDiction[@"IDNumber"]];  // 身份证号
    params[@"idCartFrontImage"] = [NSString stringWithFormat:@"%@",self.IDNumberImageName_Array[0]];
    params[@"idCartBackImage"] = [NSString stringWithFormat:@"%@",self.IDNumberImageName_Array[1]];
    params[@"idCartHandImage"] = [NSString stringWithFormat:@"%@",self.IDNumberImageName_Array[2]];
    params[@"bankAccountNumber"] = self.PayeeAccount_TextField.text;
    params[@"bindPhone"] = self.Phone_TextField.text;
    if (self.PaymentType == 1) // 银行
    {
        params[@"bankAccountName"] = self.BankName_TextField.text;
        params [@"accountType"] = @"bank";
    }
    else
    {
        params[@"bankAccountName"] = @"";
        params [@"accountType"] = @"alipay";
    }
    
    HSQLog(@"==参数==%@",params);
    
    AFNetworkRequestTool *requestTool = [AFNetworkRequestTool shareRequestTool];
    
    [requestTool.manger POST:UrlAdress(KSaveApplyCertificationInfoUrl) parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [[HSQProgressHUDManger Manger] DismissProgressHUD];
        
        HSQLog(@"=提交的信息==%@",responseObject);
        
        if ([responseObject[@"code"] integerValue] == 200)
        {
            UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"数据审核中，请耐心等待" message:nil preferredStyle:(UIAlertControllerStyleAlert)];
            
            UIAlertAction *action03 = [UIAlertAction actionWithTitle:@"好的" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {
                
                [self.navigationController popViewControllerAnimated:YES];
            }];

            [alertVC addAction:action03];
            
            [self presentViewController:alertVC animated:YES completion:nil];
        }
        else
        {
            NSString *errorString = [NSString stringWithFormat:@"%@",responseObject[@"datas"][@"error"]];
            
            [[HSQProgressHUDManger Manger] ShowDisplayFailedToLoadData:errorString SuperView:self.view];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [[HSQProgressHUDManger Manger] ShowProgressHUDPromptText:@"网络出问题啦！" SupView:self.view];
    }];
    
}














/**
 * @brief 键盘return键的点击
 */
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if (self.PaymentType == 1)
    {
        if (textField == self.Phone_TextField)
        {
            [self.PayeeName_TextField becomeFirstResponder];
        }
        else if (textField == self.PayeeName_TextField)
        {
            [self.PayeeAccount_TextField becomeFirstResponder];
        }
        else if (textField == self.PayeeAccount_TextField)
        {
            [self.BankName_TextField becomeFirstResponder];
        }
        else if (textField == self.BankName_TextField)
        {
            [self.BankName_TextField resignFirstResponder];
        }
    }
    else
    {
        if (textField == self.Phone_TextField)
        {
            [self.PayeeName_TextField becomeFirstResponder];
        }
        else if (textField == self.PayeeName_TextField)
        {
            [self.PayeeAccount_TextField becomeFirstResponder];
        }
        else if (textField == self.PayeeAccount_TextField)
        {
            [self.PayeeAccount_TextField resignFirstResponder];
        }
    }
    
    return YES;
}

@end
