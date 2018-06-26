//
//  HSQNextBandPhoneViewController.m
//  LiTianDecoration
//
//  Created by administrator on 2018/4/26.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import "HSQNextBandPhoneViewController.h"
#import "HSQChangeLoginPassWordViewController.h"
#import "HSQAccountTool.h"
#import "HSQYanZhengMobileViewController.h"
#import "HSQLoginHomeViewController.h"
#import "HSQAdvanceDepositWithdrawalViewController.h" // 预存款提现

@interface HSQNextBandPhoneViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *Phone_Label;

@property (weak, nonatomic) IBOutlet UILabel *Countdown_Label;

@property (weak, nonatomic) IBOutlet UIButton *Resend_Btn;

@property (weak, nonatomic) IBOutlet UIButton *Code_Button;

@property (weak, nonatomic) IBOutlet UITextField *DynamicCode_TextField;

@property (weak, nonatomic) IBOutlet UITextField *Verification_TextField;

@property (weak, nonatomic) IBOutlet UIView *VerificationCode_View;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ButtonMargin;

@property (nonatomic, copy) NSString *captchaKey;

@property (strong, nonatomic) NSTimer *timer;

@property (assign, nonatomic) NSInteger secs;

@property (nonatomic, copy) NSString *WaitTime;

@property (weak, nonatomic) IBOutlet UIButton *Submit_Button; // 底部的按钮

@property (weak, nonatomic) IBOutlet UILabel *BottomPlacher_Label; // 底部提示标语

@property (weak, nonatomic) IBOutlet UITextField *PassWord_TextField;

@property (weak, nonatomic) IBOutlet UITextField *QRPassWord_TextField;

@property (weak, nonatomic) IBOutlet UIView *PassWord_BgView;

@property (weak, nonatomic) IBOutlet UIView *QRPassWord_BgView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *SetPwViewTopMargin;

@end

@implementation HSQNextBandPhoneViewController

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
    [self.timer invalidate];
    
    self.timer = nil;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];

    self.view.backgroundColor = KViewBackGroupColor;
    
    self.navigationItem.title = self.NavtionTitle;
    
    NSString *phoneString = [self.UserMobile stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
    
    NSString *Phone_Placher = [NSString stringWithFormat:@"短信已发送至%@需%@分钟内完成操作",phoneString,self.authCodeValidTime];
    
    self.Phone_Label.text = Phone_Placher;
    
    // 动态码倒计时
    [self sendYZMWithTimer:self.Countdown_Label scal:self.authCodeResendTime.integerValue];
    
    [self.VerificationCode_View setHidden:YES];
    
    if (self.Source == 400 || self.Source == 100 || self.Source == 300) // 修改绑定的手机，修改登录密码，设置支付密码
    {
        [self.Submit_Button setTitle:@"下一步" forState:(UIControlStateNormal)];
    }
    else
    {
        [self.Submit_Button setTitle:@"确认提交" forState:(UIControlStateNormal)];
    }
    
    if (self.Source == 500) // 忘记密码
    {
        self.PassWord_BgView.hidden = self.QRPassWord_BgView.hidden = NO;
        
        self.SetPwViewTopMargin.constant = -50;
    }
    else
    {
        self.PassWord_BgView.hidden = self.QRPassWord_BgView.hidden = YES;
        
        self.ButtonMargin.constant = -self.VerificationCode_View.mj_h + 20;
    }
    
    // 隐藏底部提示标语
    self.BottomPlacher_Label.hidden = (self.Source == 200 ? NO : YES);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 * @brief 动态码倒计时
 */
- (void)sendYZMWithTimer:(UILabel *)Countdown_Label scal:(NSInteger)scal{
    
    self.timer = [NSTimer sf_scheduledTimerWithTimeInterval:1.0 block:^{
        
        [self timerAction:Countdown_Label];
        
    } repeats:YES];
    
    _secs = scal;
        
    NSString *string = [NSString stringWithFormat:@"重发动态码\n等待((%ld))秒后",(long)scal];
    
    self.Countdown_Label.text = string;
}

- (void)timerAction:(UILabel *)Countdown_Label{
    
    _secs -- ;
    
    if (_secs == 0)
    {
        [self.Countdown_Label setHidden:YES];
        
        [self.VerificationCode_View setHidden:NO];
        
        self.ButtonMargin.constant =  20;
        
         self.SetPwViewTopMargin.constant = 5;
        
        [self.timer invalidate];
        
        [self RequestImageVerificationCodeFromServer];
    }
    else
    {
         [self.Countdown_Label setHidden:NO];
        
        NSString *string = [NSString stringWithFormat:@"重发动态码\n等待((%2ld))秒后",(long)_secs];
        
        self.Countdown_Label.text = string;
    }
}

/**
 * @brief 重发动态码的点击事件
 */
- (IBAction)ReplayDynamicCodeClickEvent:(UIButton *)sender {
    
    if (self.Verification_TextField.text.length == 0)
    {
        [[HSQProgressHUDManger Manger] ShowProgressHUDPromptText:@"请输入验证码" SupView:self.view];
    }
    else
    {
        [self VerifyTheImageVerificationCode];
    }
}

/**
 * @brief 验证图片验证码，并发送短信动态码
 */
- (void)VerifyTheImageVerificationCode{
    
    [[HSQProgressHUDManger Manger] ShowLoadingDataFromeServer:@"" ToView:self.view IsClearColor:YES];
    
    NSDictionary *diction = @{@"mobile":self.UserMobile,@"captchaVal":self.Verification_TextField.text,@"sendType":self.sendType,@"captchaKey":self.captchaKey};
        
    AFNetworkRequestTool *RequestTool = [AFNetworkRequestTool shareRequestTool];
    
    [RequestTool.manger GET:UrlAdress(KValidationBtnCodeImageUrl) parameters:diction progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [[HSQProgressHUDManger Manger] DismissProgressHUD];
        
        HSQLog(@"===%@",responseObject);
        if ([responseObject[@"code"] integerValue] == 200)
        {
            NSString *authCodeValidTime = [NSString stringWithFormat:@"%@",responseObject[@"datas"][@"authCodeValidTime"]];
            
            NSString *authCodeResendTime = [NSString stringWithFormat:@"%@",responseObject[@"datas"][@"authCodeResendTime"]];
            
             [self.VerificationCode_View setHidden:YES];
            
            if (self.Source == 500) // 忘记密码
            {
                self.PassWord_BgView.hidden = self.QRPassWord_BgView.hidden = NO;
                
                self.SetPwViewTopMargin.constant = -55;
            }
            else
            {
                self.PassWord_BgView.hidden = self.QRPassWord_BgView.hidden = YES;
                
                self.ButtonMargin.constant = -self.VerificationCode_View.mj_h + 20;
            }
            
            NSString *phoneString = [self.UserMobile stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
            
            NSString *Phone_Placher = [NSString stringWithFormat:@"短信已发送至%@需%@分钟内完成操作",phoneString,authCodeValidTime];
            
            self.Phone_Label.text = Phone_Placher;
            
            // 时间倒计时
            [self sendYZMWithTimer:self.Countdown_Label scal:authCodeResendTime.integerValue];
        }
        else
        {
            NSString *message = [NSString stringWithFormat:@"%@",responseObject[@"datas"][@"error"]];
            
            [[HSQProgressHUDManger Manger] ShowDisplayFailedToLoadData:message SuperView:self.view];
            
            [self RequestImageVerificationCodeFromServer];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [[HSQProgressHUDManger Manger] ShowDisplayFailedToLoadData:KErrorPlacherString SuperView:self.view];
    }];
}

/**
 * @brief 获取图形验证码的点击事件
 */
- (IBAction)GetsTheGraphicalVerificationCode:(UIButton *)sender {
    
    [self RequestImageVerificationCodeFromServer];
}

/**
 * @brief 从服务器请求图片验证码
 */
- (void)RequestImageVerificationCodeFromServer{
    
    [[HSQProgressHUDManger Manger] ShowLoadingDataFromeServer:@"" ToView:self.view IsClearColor:YES];
    
    AFNetworkRequestTool *RequestTool = [AFNetworkRequestTool shareRequestTool];
    
    [RequestTool.manger GET:UrlAdress(KGetCodeBiaoShiUrl) parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [[HSQProgressHUDManger Manger] DismissProgressHUD];
        
        self.captchaKey = [NSString stringWithFormat:@"%@",responseObject[@"datas"][@"captchaKey"]];
        
        NSString *url = [NSString stringWithFormat:@"%@?&&captchaKey=%@&&clientType=%@",UrlAdress(KGetCodeImageUrl),self.captchaKey,KClientType];
        
        [self.Code_Button sd_setBackgroundImageWithURL:[NSURL URLWithString:url] forState:UIControlStateNormal];
        
        [self.Code_Button sd_setBackgroundImageWithURL:[NSURL URLWithString:url] forState:UIControlStateHighlighted];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
       [[HSQProgressHUDManger Manger] ShowDisplayFailedToLoadData:KErrorPlacherString SuperView:self.view];
    }];
}

/**
 * @brief 如果是绑定手机是：确认提交  其他的是：下一步
 */
- (IBAction)ConfirmTheSubmittedClickEvent:(UIButton *)sender {
    
    if (self.DynamicCode_TextField.text.length == 0)
    {
        [[HSQProgressHUDManger Manger] ShowProgressHUDPromptText:@"请输入短信动态码" SupView:self.view];
    }
    else if (self.Source == 500) // 忘记密码
    {
        [self MobilePhoneToRetrievePassword];
    }
    else
    {
        [[HSQProgressHUDManger Manger] ShowLoadingDataFromeServer:@"" ToView:self.view IsClearColor:YES];
        
        NSDictionary *diction = @{@"mobile":self.UserMobile,@"smsAuthCode":self.DynamicCode_TextField.text,@"sendType":self.sendType};
        
        HSQLog(@"=zidiancanshu==%@",diction);
        
        AFNetworkRequestTool *RequestTool = [AFNetworkRequestTool shareRequestTool];
        
        [RequestTool.manger GET:UrlAdress(KVaildationSMSUrl) parameters:diction progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            [[HSQProgressHUDManger Manger] DismissProgressHUD];
            
            HSQLog(@"===确认提交===%@",responseObject);
            if ([responseObject[@"code"] integerValue] == 200)
            {
                if (self.Source == 100) // 修改登录密码
                {
                    HSQChangeLoginPassWordViewController *ChangePassWordVC = [[HSQChangeLoginPassWordViewController alloc] init];
                    
                    ChangePassWordVC.Navtion_title = @"修改登录密码";
                    
                    ChangePassWordVC.source = 100;
                    
                    ChangePassWordVC.smsAuthCode = self.DynamicCode_TextField.text;
                    
                    [self.navigationController pushViewController:ChangePassWordVC animated:YES];
                }
                else if (self.Source == 200) // 绑定手机
                {
                    [self UploadTheBoundPhoneToTheServer];
                }
                else if (self.Source == 300) // 设置支付密码
                {
                    HSQChangeLoginPassWordViewController *ChangePassWordVC = [[HSQChangeLoginPassWordViewController alloc] init];
                    
                    ChangePassWordVC.Navtion_title = @"设置支付密码";
                    
                    ChangePassWordVC.source = 200;
                    
                    ChangePassWordVC.smsAuthCode = self.DynamicCode_TextField.text;
                    
                    [self.navigationController pushViewController:ChangePassWordVC animated:YES];
                }
                else if (self.Source == 400) // 修改绑定的手机
                {
                    HSQYanZhengMobileViewController *YanZhengMobileVC = [[HSQYanZhengMobileViewController alloc] init];
                    
                    YanZhengMobileVC.Navtion_Title = @"绑定手机";
                    
                    YanZhengMobileVC.sendType = @"4";
                    
                    YanZhengMobileVC.IsPhoneBand = 100;
                    
                    YanZhengMobileVC.oldSmsAuthCode = self.DynamicCode_TextField.text;
                    
                    [self.navigationController pushViewController:YanZhengMobileVC animated:YES];
                }
                else if (self.Source == 600) // 预存款提现
                {
                    HSQAdvanceDepositWithdrawalViewController *AdvanceDepositWithdrawalVC = [[HSQAdvanceDepositWithdrawalViewController alloc] init];
                    
                    AdvanceDepositWithdrawalVC.smsAuthCode = self.DynamicCode_TextField.text;
                    
                    [self.navigationController pushViewController:AdvanceDepositWithdrawalVC animated:YES];
                }
            }
            else
            {
                NSString *message = [NSString stringWithFormat:@"%@",responseObject[@"datas"][@"error"]];
                
                [[HSQProgressHUDManger Manger] ShowDisplayFailedToLoadData:message SuperView:self.view];
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            [[HSQProgressHUDManger Manger] ShowDisplayFailedToLoadData:KErrorPlacherString SuperView:self.view];
        }];
    }
}

/**
 * @breif 将绑定的手机上传至服务器
 */
- (void)UploadTheBoundPhoneToTheServer{
    
    [[HSQProgressHUDManger Manger] ShowLoadingDataFromeServer:@"" ToView:self.view IsClearColor:YES];
    
     NSMutableDictionary *params = [NSMutableDictionary dictionary];
     params[@"token"] = [HSQAccountTool account].token;
    params[@"newMemberMobile"] = self.UserMobile;
    params[@"newSmsAuthCode"] = self.DynamicCode_TextField.text;
    
    if (self.IsPhoneBand == 100) // 修改绑定的手机
    {
        params[@"oldSmsAuthCode"] = self.oldSmsAuthCode;
    }
    
    HSQLog(@"=绑定手机==%@",params);
    
    AFNetworkRequestTool *RequestTool = [AFNetworkRequestTool shareRequestTool];
    
    [RequestTool.manger POST:UrlAdress(KBandPhoneUrl) parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [[HSQProgressHUDManger Manger] DismissProgressHUD];
        
        HSQLog(@"===绑定手机===%@",responseObject);
        if ([responseObject[@"code"] integerValue] == 200)
        {
            [[HSQProgressHUDManger Manger] ShowProgressHUDPromptText:@"手机绑定成功" SupView:self.view];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [self.navigationController popToRootViewControllerAnimated:YES];
            });
        }
        else
        {
            NSString *message = [NSString stringWithFormat:@"%@",responseObject[@"datas"][@"error"]];
            
            [[HSQProgressHUDManger Manger] ShowDisplayFailedToLoadData:message SuperView:self.view];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
        [[HSQProgressHUDManger Manger] ShowDisplayFailedToLoadData:KErrorPlacherString SuperView:self.view];
    }];
}

/**
 * @brief 手机找回密码
 */
- (void)MobilePhoneToRetrievePassword{
    
    if (self.PassWord_TextField.text.length == 0)
    {
        [[HSQProgressHUDManger Manger] ShowProgressHUDPromptText:@"请输入密码" SupView:self.view];
    }
    else if (self.QRPassWord_TextField.text.length == 0)
    {
        [[HSQProgressHUDManger Manger] ShowProgressHUDPromptText:@"请再次输入密码" SupView:self.view];
    }
    else if (![self.PassWord_TextField.text isEqualToString:self.QRPassWord_TextField.text])
    {
        [[HSQProgressHUDManger Manger] ShowProgressHUDPromptText:@"两次输入的密码不一致" SupView:self.view];
    }
    else
    {
        [[HSQProgressHUDManger Manger] ShowLoadingDataFromeServer:@"" ToView:self.view IsClearColor:YES];
        
        NSDictionary *diction = @{@"mobile":self.UserMobile,@"smsAuthCode":self.DynamicCode_TextField.text,@"memberPwd":self.PassWord_TextField.text,@"memberPwdRepeat":self.QRPassWord_TextField.text};
        
        HSQLog(@"=zidiancanshu==%@",diction);
        
        AFNetworkRequestTool *RequestTool = [AFNetworkRequestTool shareRequestTool];
        
        [RequestTool.manger POST:UrlAdress(KMobilForgetPassWordUrl) parameters:diction progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            [[HSQProgressHUDManger Manger] DismissProgressHUD];
            
            HSQLog(@"===忘记密码===%@",responseObject);
            if ([responseObject[@"code"] integerValue] == 200)
            {
                [[HSQProgressHUDManger Manger] ShowProgressHUDPromptText:@"密码修改成功" SupView:self.view];
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    
                    for (UIViewController *VC in self.navigationController.viewControllers) {
                        
                        if ([VC isKindOfClass:[HSQLoginHomeViewController class]]) {
                            
                            [self.navigationController popToViewController:VC animated:YES];
                        }
                    }
                });
            }
            else
            {
                NSString *message = [NSString stringWithFormat:@"%@",responseObject[@"datas"][@"error"]];
                
                [[HSQProgressHUDManger Manger] ShowDisplayFailedToLoadData:message SuperView:self.view];
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            [[HSQProgressHUDManger Manger] ShowDisplayFailedToLoadData:KErrorPlacherString SuperView:self.view];
        }];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    
    return YES;
}












@end
