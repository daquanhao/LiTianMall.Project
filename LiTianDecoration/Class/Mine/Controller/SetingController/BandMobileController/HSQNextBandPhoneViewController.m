//
//  HSQNextBandPhoneViewController.m
//  LiTianDecoration
//
//  Created by administrator on 2018/4/26.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import "HSQNextBandPhoneViewController.h"
#import "HSQChangePassWordViewController.h"

@interface HSQNextBandPhoneViewController ()

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
    
    self.ButtonMargin.constant = -self.VerificationCode_View.mj_h + 20;
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
        [self.VerificationCode_View setHidden:YES];
        
        self.ButtonMargin.constant = -self.VerificationCode_View.mj_h + 20;
        
        // 时间倒计时
        [self sendYZMWithTimer:self.Countdown_Label scal:60];
    }
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
        
        [[HSQProgressHUDManger Manger] ShowDisplayFailedToLoadData:@"数据加载失败" SuperView:self.view];
    }];
}

/**
 * @brief 确认提交
 */
- (IBAction)ConfirmTheSubmittedClickEvent:(UIButton *)sender {
    
    HSQChangePassWordViewController *ChangePassWordVC = [[HSQChangePassWordViewController alloc] init];
    
    ChangePassWordVC.Navtion_Title = @"修改登录密码";
    
    [self.navigationController pushViewController:ChangePassWordVC animated:YES];
}

















@end
