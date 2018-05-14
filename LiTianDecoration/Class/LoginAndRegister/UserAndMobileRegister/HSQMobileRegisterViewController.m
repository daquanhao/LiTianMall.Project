//
//  HSQMobileRegisterViewController.m
//  LiTianDecoration
//
//  Created by administrator on 2018/4/28.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import "HSQMobileRegisterViewController.h"

@interface HSQMobileRegisterViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *TopPlacher_Label;

@property (weak, nonatomic) IBOutlet UITextField *SMS_TextField;

@property (weak, nonatomic) IBOutlet UITextField *PassWord_TextField;

@property (weak, nonatomic) IBOutlet UITextField *QRPassWord_TextField;

@property (weak, nonatomic) IBOutlet UIButton *Countdown_Button;

@property (weak, nonatomic) IBOutlet UIButton *CodeImageView_Button;

@property (weak, nonatomic) IBOutlet UITextField *Code_TextField;

@property (weak, nonatomic) IBOutlet UIView *Code_View;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *TopMargin;

@property (nonatomic, copy) NSString *captchaKey;

@property (strong, nonatomic) NSTimer *timer;

@property (assign, nonatomic) NSInteger secs;

@end

@implementation HSQMobileRegisterViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.view.backgroundColor = KViewBackGroupColor;
    
    self.navigationItem.title = @"提交验证码";
    
    // 顶部的提示文字
    NSString *phoneString = [self.PhoneString stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
    NSString *Phone_Placher = [NSString stringWithFormat:@"短信已发送至%@需%@分钟内完成操作",phoneString,self.SMS_ValidTime];
    self.TopPlacher_Label.text = Phone_Placher;
    
    // 隐藏或者显示图片验证码界面
    [self SMSCountdown:YES margin:-50 button:self.Countdown_Button scal:self.SMS_IntervalTime.integerValue];

}

/**
 * @brief 隐藏或者显示图片验证码界面
 */
- (void)SMSCountdown:(BOOL)hidden margin:(NSInteger)constant button:(UIButton *)time_Btn scal:(NSInteger)seconds{
    
    // 隐藏图片验证码界面
    [self.Code_View setHidden:hidden];
    
    // 设置密码界面顶部的间距
    self.TopMargin.constant = constant;
    
    // 短信时间倒计时
    [self sendYZMWithTimer:time_Btn scal:seconds];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 * @brief 获取图片验证码
 */
- (IBAction)GetCodeImageDataFromeServer:(UIButton *)sender {
    
    [self SubmitViewCodeButtonImageFromeServer:self.CodeImageView_Button];
}

/**
 * @brief 从服务器请求验证码的图片
 */
- (void)SubmitViewCodeButtonImageFromeServer:(UIButton *)sender{
    
    AFNetworkRequestTool *RequestTool = [AFNetworkRequestTool shareRequestTool];
    
    [RequestTool.manger GET:UrlAdress(KGetCodeBiaoShiUrl) parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        self.captchaKey = [NSString stringWithFormat:@"%@",responseObject[@"datas"][@"captchaKey"]];
        
        NSString *url = [NSString stringWithFormat:@"%@?&&captchaKey=%@&&clientType=%@",UrlAdress(KGetCodeImageUrl),self.captchaKey,KClientType];
        
        [sender sd_setBackgroundImageWithURL:[NSURL URLWithString:url] forState:(UIControlStateNormal)];
        
        [sender sd_setBackgroundImageWithURL:[NSURL URLWithString:url] forState:(UIControlStateHighlighted)];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}


/**
 * @brief 重新发送短信验证码
 */
- (IBAction)ResendTheVerificationCodeClickAction:(UIButton *)sender {
    
    if (self.Code_TextField.text.length == 0)
    {
        [[HSQProgressHUDManger Manger] ShowProgressHUDPromptText:@"请输入验证码" SupView:self.view];
    }
    else
    {
        
    }
}

/**
 * @brief 动态码倒计时
 */
- (void)sendYZMWithTimer:(UIButton *)Countdown_Button scal:(NSInteger)scal{
    
    self.timer = [NSTimer sf_scheduledTimerWithTimeInterval:1.0 block:^{
        
        [self timerAction:Countdown_Button];
        
    } repeats:YES];
    
    _secs = scal;
    
    self.Countdown_Button.enabled = NO;
    
    NSString *string = [NSString stringWithFormat:@"(%ld)秒",(long)scal];
    
    [self.Countdown_Button setTitle:string forState:(UIControlStateDisabled)];
}

- (void)timerAction:(UIButton *)Countdown_Button{
    
    _secs -- ;
    
    if (_secs == 0)
    {
         self.Countdown_Button.enabled = YES;
        
         [self.Countdown_Button setTitle:@"重发获取" forState:(UIControlStateNormal)];
        
        [self.Code_View setHidden:NO];
        
        self.TopMargin.constant =  2;
        
        [self.timer invalidate];
        
        [self SubmitViewCodeButtonImageFromeServer:self.CodeImageView_Button];
    }
    else
    {
         self.Countdown_Button.enabled = NO;
        
        NSString *string = [NSString stringWithFormat:@"(%2ld)秒",(long)_secs];
        
        [self.Countdown_Button setTitle:string forState:(UIControlStateDisabled)];
    }
}


/**
 * @brief 下一步
 */
- (IBAction)NextUpButtonClickAction:(UIButton *)sender {
}











#warning 验证图片验证码是否正确，正确后发送6位数字的短信验证码

/**
 * @brief 验证图片验证码是否正确，正确后发送6位数字的短信验证码
 * @param mobile 手机号
 * @param captchaKey 图片验证码标识
 * @param captchaVal 图片验证码值
 * @param sendType 发送类型（1表示注册 2表示登录 3表示找回密码 4表示绑定手机 5表示手机安全认证）
 */
- (void)GetSMSDynamicCodeAndVerifyImageVerificationCode:(NSString *)mobile captchaKey:(NSString *)captchaKey captchaVal:(NSString *)captchaVal sendType:(NSString *)sendType{
    
    NSDictionary *diction = @{@"mobile":mobile,@"captchaKey":captchaKey,@"captchaVal":captchaVal,@"sendType":sendType};
    
    AFNetworkRequestTool *RequestTool = [AFNetworkRequestTool shareRequestTool];
    
    [RequestTool.manger GET:UrlAdress(KValidationBtnCodeImageUrl) parameters:diction progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        HSQLog(@"==验证图片验证码=%@",responseObject);
        
        if ([responseObject[@"code"] integerValue] == 200)
        {
            NSString *time = [NSString stringWithFormat:@"%@",responseObject[@"datas"][@"authCodeResendTime"]];
            
            // 1.验证成功以后，隐藏图片验证码界面，进入时间倒计时
            [self SMSCountdown:YES margin:2 button:self.Countdown_Button scal:time.integerValue];
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




@end
