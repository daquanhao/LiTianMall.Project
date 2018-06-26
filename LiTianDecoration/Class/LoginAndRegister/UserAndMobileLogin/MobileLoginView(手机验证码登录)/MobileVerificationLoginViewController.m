//
//  MobileVerificationLoginViewController.m
//  LiTianDecoration
//
//  Created by administrator on 2018/4/28.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import "MobileVerificationLoginViewController.h"
#import "HSQAccountTool.h"

@interface MobileVerificationLoginViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *Placher_Label;

@property (weak, nonatomic) IBOutlet UITextField *SMS_TextField;

@property (weak, nonatomic) IBOutlet UITextField *Code_TextField;

@property (weak, nonatomic) IBOutlet UIButton *CodeImage_Button;

@property (weak, nonatomic) IBOutlet UIButton *SMSCountDown_Btn;

@property (weak, nonatomic) IBOutlet UIView *Code_View;

@property (strong, nonatomic) NSTimer *timer;

@property (assign, nonatomic) NSInteger secs;

@property (nonatomic, copy) NSString *captchaKey;

@end

@implementation MobileVerificationLoginViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.view.backgroundColor = KViewBackGroupColor;
    
    self.navigationItem.title = @"提交动态码";
    
    // 1.顶部的提示文字
    NSString *phoneString = [self.UserPhoneString stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
    
    NSString *Phone_Placher = [NSString stringWithFormat:@"短信已发送至%@需%@分钟内完成操作",phoneString,self.SMS_ValidTime];
    
    self.Placher_Label.text = Phone_Placher;
    
    // 隐藏或者显示图片验证码界面
    [self SMSCountdown:YES margin:-45 button:self.SMSCountDown_Btn scal:self.SMS_IntervalTime.integerValue];
    
}

/**
 * @brief 隐藏或者显示图片验证码界面
 */
- (void)SMSCountdown:(BOOL)hidden margin:(NSInteger)constant button:(UIButton *)time_Btn scal:(NSInteger)seconds{
    
    // 隐藏图片验证码界面
    [self.Code_View setHidden:hidden];
    
    // 短信时间倒计时
    [self sendYZMWithTimer:time_Btn scal:seconds];
}

/**
 * @brief 动态码倒计时
 */
- (void)sendYZMWithTimer:(UIButton *)Countdown_Button scal:(NSInteger)scal{
    
    self.timer = [NSTimer sf_scheduledTimerWithTimeInterval:1.0 block:^{
        
        [self timerAction:Countdown_Button];
        
    } repeats:YES];
    
    _secs = scal;
    
    self.SMSCountDown_Btn.enabled = NO;
    
    NSString *string = [NSString stringWithFormat:@"(%ld)秒",(long)scal];
    
    [self.SMSCountDown_Btn setTitle:string forState:(UIControlStateDisabled)];
}

- (void)timerAction:(UIButton *)Countdown_Button{
    
    _secs -- ;
    
    if (_secs == 0)
    {
        self.SMSCountDown_Btn.enabled = YES;
        
        [self.SMSCountDown_Btn setTitle:@"重发获取" forState:(UIControlStateNormal)];
        
        [self.Code_View setHidden:NO];
                
        [self.timer invalidate];
        
        [self SubmitViewCodeButtonImageFromeServer:self.CodeImage_Button];
    }
    else
    {
        self.SMSCountDown_Btn.enabled = NO;
        
        NSString *string = [NSString stringWithFormat:@"(%2ld)秒",(long)_secs];
        
        [self.SMSCountDown_Btn setTitle:string forState:(UIControlStateDisabled)];
    }
}

/**
 * @brief 从服务器请求验证码的图片
 */
- (void)SubmitViewCodeButtonImageFromeServer:(UIButton *)sender{
    
    AFNetworkRequestTool *manger = [AFNetworkRequestTool shareRequestTool];
    
    [manger.manger GET:UrlAdress(KGetCodeBiaoShiUrl) parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        self.captchaKey = [NSString stringWithFormat:@"%@",responseObject[@"datas"][@"captchaKey"]];
        
        NSString *url = [NSString stringWithFormat:@"%@?&&captchaKey=%@&&clientType=%@",UrlAdress(KGetCodeImageUrl),self.captchaKey,KClientType];
        
        [sender sd_setBackgroundImageWithURL:[NSURL URLWithString:url] forState:(UIControlStateNormal)];
        
        [sender sd_setBackgroundImageWithURL:[NSURL URLWithString:url] forState:(UIControlStateHighlighted)];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 * @brief 重新获取验证码
 */
- (IBAction)RetrieveTheSMSVerificationCode:(UIButton *)sender {
    
    if (self.Code_TextField.text.length == 0)
    {
        [[HSQProgressHUDManger Manger] ShowProgressHUDPromptText:@"请输入验证码" SupView:self.view];
    }
    else
    {
        [self GetSMSDynamicCodeAndVerifyImageVerificationCode:self.UserPhoneString captchaKey:self.captchaKey captchaVal:self.Code_TextField.text sendType:@"2"];
    }
}

/**
 * @brief 验证图片验证码是否正确，正确后发送6位数字的短信验证码
 * @param mobile 手机号
 * @param captchaKey 图片验证码标识
 * @param captchaVal 图片验证码值
 * @param sendType 发送类型（1表示注册 2表示登录 3表示找回密码 4表示绑定手机 5表示手机安全认证）
 */
- (void)GetSMSDynamicCodeAndVerifyImageVerificationCode:(NSString *)mobile captchaKey:(NSString *)captchaKey captchaVal:(NSString *)captchaVal sendType:(NSString *)sendType{
    
    NSDictionary *diction = @{@"mobile":mobile,@"captchaKey":captchaKey,@"captchaVal":captchaVal,@"sendType":sendType};
    
    AFNetworkRequestTool *manger = [AFNetworkRequestTool shareRequestTool];
    
    [manger.manger GET:UrlAdress(KValidationBtnCodeImageUrl) parameters:diction progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        HSQLog(@"==验证图片验证码=%@",responseObject);
        
        if ([responseObject[@"code"] integerValue] == 200)
        {
            // 动态码的重发间隔秒数
            NSString *authCodeResendTime = [NSString stringWithFormat:@"%@",responseObject[@"datas"][@"authCodeResendTime"]];
            
            // 1.验证成功以后，隐藏或者显示图片验证码界面
            [self SMSCountdown:YES margin:-45 button:self.SMSCountDown_Btn scal:authCodeResendTime.integerValue];
            
        }
        else
        {
            NSString *errorString = [NSString stringWithFormat:@"%@",responseObject[@"datas"][@"error"]];
            
            [[HSQProgressHUDManger Manger] ShowDisplayFailedToLoadData:errorString SuperView:self.view];
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [[HSQProgressHUDManger Manger] ShowDisplayFailedToLoadData:@"验证失败" SuperView:self.view];
        
    }];
}


/**
 * @brief 重新获取图片验证码
 */
- (IBAction)RequestAnImageVerificationCodeClickEvent:(UIButton *)sender {
    
    [self SubmitViewCodeButtonImageFromeServer:self.CodeImage_Button];
}

/**
 * @brief 登录
 */
- (IBAction)LoginButtonClickAction:(UIButton *)sender {
    
    if (self.SMS_TextField.text.length == 0)
    {
        [[HSQProgressHUDManger Manger] ShowProgressHUDPromptText:@"请输入6位短信动态码" SupView:self.view];
    }
    else
    {
        NSMutableDictionary *diction = [NSMutableDictionary dictionary];
        
        diction[@"mobile"] = self.UserPhoneString;
        
        diction[@"smsAuthCode"] = self.SMS_TextField.text;
        
        diction[@"clientType"] = KClientType;
        
        AFNetworkRequestTool *manger = [AFNetworkRequestTool shareRequestTool];
        
        [manger.manger POST:UrlAdress(KMobileLoginUrl) parameters:diction progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            HSQLog(@"=手机登录数据数据=%@",responseObject);
            
            [[HSQProgressHUDManger Manger] DismissProgressHUD];
            
            if ([responseObject[@"code"] integerValue] == 200)
            {
                [[HSQProgressHUDManger Manger] ShowLoadDataSuccessWithPlaceholderString:@"登录成功" SuperView:self.view];
                
                // 储存账号信息
                HSQAccount *account = [HSQAccount accountWithDict:responseObject];
                
                [HSQAccountTool saveAccount:account];
                
                // 发送登录的消息
                [[NSNotificationCenter defaultCenter] postNotificationName:@"UserDidLoginSuccessNotif" object:self];
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    
                    [self.navigationController popToRootViewControllerAnimated:YES];
                    
                });
            }
            else
            {
                NSString *errorString = [NSString stringWithFormat:@"%@",responseObject[@"datas"][@"error"]];
                
                [[HSQProgressHUDManger Manger] ShowDisplayFailedToLoadData:errorString SuperView:self.view];
                
                // 重新请求验证码
                [self SubmitViewCodeButtonImageFromeServer:self.CodeImage_Button];
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            [[HSQProgressHUDManger Manger] ShowProgressHUDPromptText:KErrorPlacherString SupView:self.view];
        }];
    }
}








- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    
    return YES;
}


@end
