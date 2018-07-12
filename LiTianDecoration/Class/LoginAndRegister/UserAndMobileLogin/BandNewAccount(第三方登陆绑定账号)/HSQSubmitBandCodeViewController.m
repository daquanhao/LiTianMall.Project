//
//  HSQSubmitBandCodeViewController.m
//  LiTianDecoration
//
//  Created by administrator on 2018/6/28.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import "HSQSubmitBandCodeViewController.h"
#import "HSQAccountTool.h"

@interface HSQSubmitBandCodeViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *Placher_Label;

@property (weak, nonatomic) IBOutlet UITextField *smsAuthCode_TextField; // 短信动态码

@property (weak, nonatomic) IBOutlet UIButton *countdown_Button; // 倒计时

@property (weak, nonatomic) IBOutlet UITextField *Code_TextField;

@property (weak, nonatomic) IBOutlet UIButton *Code_Button;

@property (weak, nonatomic) IBOutlet UITextField *UserName_TextField;

@property (weak, nonatomic) IBOutlet UITextField *PassWord_TextField;

@property (weak, nonatomic) IBOutlet UITextField *QRPassWord_TextField;

@property (weak, nonatomic) IBOutlet UILabel *CodePlacher_Label;

@property (weak, nonatomic) IBOutlet UIImageView *CodeBg_ImageView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *TopMargin;

@property (strong, nonatomic) NSTimer *timer;

@property (assign, nonatomic) NSInteger secs;

@property (nonatomic, copy) NSString *captchaKey;

@end

@implementation HSQSubmitBandCodeViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.navigationItem.title = @"提交验证码";
    
    self.view.backgroundColor = KViewBackGroupColor;
    
    // 1.顶部的提示文字
    NSString *phoneString = [self.UserPhoneString stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
    
    NSString *Phone_Placher = [NSString stringWithFormat:@"短信已发送至%@需%@分钟内完成操作",phoneString,self.SMS_ValidTime];
    
    self.Placher_Label.text = Phone_Placher;
    
    // 隐藏图片验证码视图
    self.Code_Button.hidden = self.Code_TextField.hidden = self.CodePlacher_Label.hidden = self.CodeBg_ImageView.hidden = YES;
    
    self.TopMargin.constant = 1;
}

/**
 * @brief 动态码倒计时
 */
- (void)sendYZMWithTimer:(UIButton *)Countdown_Button scal:(NSInteger)scal{
    
    self.timer = [NSTimer sf_scheduledTimerWithTimeInterval:1.0 block:^{
        
        [self timerAction:Countdown_Button];
        
    } repeats:YES];
    
    _secs = scal;
    
    Countdown_Button.enabled = NO;
    
    NSString *string = [NSString stringWithFormat:@"(%ld)秒",(long)scal];
    
    [Countdown_Button setTitle:string forState:(UIControlStateDisabled)];
}

- (void)timerAction:(UIButton *)Countdown_Button{
    
    _secs -- ;
    
    if (_secs == 0)
    {
        Countdown_Button.enabled = YES;
        
        [Countdown_Button setTitle:@"重发获取" forState:(UIControlStateNormal)];
        
         self.Code_Button.hidden = self.Code_TextField.hidden = self.CodePlacher_Label.hidden = self.CodeBg_ImageView.hidden = NO;
        
        self.TopMargin.constant = 47;
        
        [self.timer invalidate];
        
        [self SubmitViewCodeButtonImageFromeServer:self.Code_Button];
    }
    else
    {
        Countdown_Button.enabled = NO;
        
        NSString *string = [NSString stringWithFormat:@"(%2ld)秒",(long)_secs];
        
        [Countdown_Button setTitle:string forState:(UIControlStateDisabled)];
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

/**
 * @brief 重新获取短信验证码
 */
- (IBAction)RetrieveTheMessageVerificationCode:(UIButton *)sender {
    
    if (self.Code_TextField.text.length == 0)
    {
        [[HSQProgressHUDManger Manger] ShowProgressHUDPromptText:@"请输入验证码" SupView:self.view];
    }
    else
    {
        [self GetSMSDynamicCodeAndVerifyImageVerificationCode:self.UserPhoneString captchaKey:self.captchaKey captchaVal:self.Code_TextField.text sendType:@"4"];
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
            // 动态码的有效时间（分钟）
            NSString *authCodeValidTime = [NSString stringWithFormat:@"%@",responseObject[@"datas"][@"authCodeValidTime"]];
            
            // 1.顶部的提示文字
            NSString *phoneString = [self.UserPhoneString stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
            
            NSString *Phone_Placher = [NSString stringWithFormat:@"短信已发送至%@需%@分钟内完成操作",phoneString,authCodeValidTime];
            
            self.Placher_Label.text = Phone_Placher;
            
            // 动态码的重发间隔秒数
            NSString *authCodeResendTime = [NSString stringWithFormat:@"%@",responseObject[@"datas"][@"authCodeResendTime"]];
            
            // 1.验证成功以后，隐藏或者显示图片验证码界面
            self.Code_Button.hidden = self.Code_TextField.hidden = self.CodePlacher_Label.hidden = self.CodeBg_ImageView.hidden = YES;
            
            self.TopMargin.constant = 1;
            
            // 短信时间倒计时
            [self sendYZMWithTimer:self.countdown_Button scal:authCodeResendTime.integerValue];
            
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 * @brief 立即绑定的点击
 */
- (IBAction)AtOnceBandButtonClickAction:(UIButton *)sender {
    
    if (self.smsAuthCode_TextField.text.length == 0)
    {
        [[HSQProgressHUDManger Manger] ShowProgressHUDPromptText:@"请输入短信动态码" SupView:self.view];
    }
    else if (self.Code_TextField.hidden == NO && self.Code_TextField.text.length == 0)
    {
        [[HSQProgressHUDManger Manger] ShowProgressHUDPromptText:@"请输入验证码" SupView:self.view];
    }
    else if (self.UserName_TextField.text.length == 0)
    {
        [[HSQProgressHUDManger Manger] ShowProgressHUDPromptText:@"请输入用户名" SupView:self.view];
    }
    else if (self.PassWord_TextField.text.length == 0)
    {
        [[HSQProgressHUDManger Manger] ShowProgressHUDPromptText:@"请输入密码" SupView:self.view];
    }
    else if (self.QRPassWord_TextField.text.length == 0)
    {
        [[HSQProgressHUDManger Manger] ShowProgressHUDPromptText:@"请再次输入密码" SupView:self.view];
    }
    else
    {
        if (self.Source == 100) // QQ绑定新的账号
        {
            NSDictionary *params = @{@"accessToken":self.accessToken,@"openId":self.openId,@"appId":self.appId,@"mobile":self.UserPhoneString,
                                                          @"authCode":self.smsAuthCode_TextField.text,@"memberPwd":self.PassWord_TextField.text,@"repeatMemberPwd":self.QRPassWord_TextField.text,@"clientType":KClientType
                                                         };
            
            [self AppLoginIsBoundToAnExistingAccount:UrlAdress(KQQBandNewAccountUrl) Parmas:params];
        }
        else // 微信绑定已有账号
        {
            NSDictionary *params = @{@"accessToken":self.accessToken,@"openId":self.openId,@"mobile":self.UserPhoneString,
                                                          @"authCode":self.smsAuthCode_TextField.text,@"memberPwd":self.PassWord_TextField.text,@"repeatMemberPwd":self.QRPassWord_TextField.text,@"clientType":KClientType
                                     };
            
            [self AppLoginIsBoundToAnExistingAccount:UrlAdress(KWeChatBandNewAccountUrl) Parmas:params];
        }
    }    
}

/**
 * @brief App登录绑定已有账号
 */
- (void)AppLoginIsBoundToAnExistingAccount:(NSString *)RequestUrl Parmas:(NSDictionary *)params{
    
    [[HSQProgressHUDManger Manger] ShowLoadingDataFromeServer:@"" ToView:self.view IsClearColor:YES];
    
    AFNetworkRequestTool *mangerTool = [AFNetworkRequestTool shareRequestTool];
    
    [mangerTool.manger POST:RequestUrl parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        HSQLog(@"=App登录绑定新的账号=%@",responseObject);
        
        [[HSQProgressHUDManger Manger] DismissProgressHUD];
        
        if ([responseObject[@"code"] integerValue] == 200)
        {
            [[HSQProgressHUDManger Manger] ShowLoadDataSuccessWithPlaceholderString:@"绑定成功" SuperView:self.view];
            
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
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [[HSQProgressHUDManger Manger] ShowProgressHUDPromptText:KErrorPlacherString SupView:self.view];
    }];
}


















- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    
    return YES;
}







@end
