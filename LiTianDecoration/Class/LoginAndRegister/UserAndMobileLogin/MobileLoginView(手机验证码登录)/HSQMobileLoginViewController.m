//
//  HSQMobileLoginViewController.m
//  LiTianDecoration
//
//  Created by administrator on 2018/6/11.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import "HSQMobileLoginViewController.h"
#import "MobileVerificationLoginViewController.h"

@interface HSQMobileLoginViewController ()

@property (weak, nonatomic) IBOutlet UITextField *Mobile_TextField;

@property (weak, nonatomic) IBOutlet UITextField *MobileCode_TextField;

@property (weak, nonatomic) IBOutlet UIButton *MobileLoginCode_Button;

// 图片验证码的标示
@property (nonatomic, copy) NSString *captchaKey;

@end

@implementation HSQMobileLoginViewController

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    // 1.获取图片验证码
    [self LoginCodeButtonImageFromeServer:self.MobileLoginCode_Button];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.view.backgroundColor = KViewBackGroupColor;
}

/**
 * @brief 手机动态码登录--获取图片验证码的点击事件
 */
- (IBAction)PhoneLoginGetCodeImageData:(UIButton *)sender {
    
    [self LoginCodeButtonImageFromeServer:self.MobileLoginCode_Button];
}


/**
 * @brief 请求验证码的图片
 */
- (void)LoginCodeButtonImageFromeServer:(UIButton *)sender{
    
    AFNetworkRequestTool *mangerTool = [AFNetworkRequestTool shareRequestTool];
    
    [mangerTool.manger GET:UrlAdress(KGetCodeBiaoShiUrl) parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        self.captchaKey = [NSString stringWithFormat:@"%@",responseObject[@"datas"][@"captchaKey"]];
        
        NSString *url = [NSString stringWithFormat:@"%@?&&captchaKey=%@&&clientType=%@",UrlAdress(KGetCodeImageUrl),self.captchaKey,@"ios"];
        
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
 * @brief 获取动态验证码
 */
- (IBAction)UserNameBeginLoginBtnClickAction:(UIButton *)sender {
    
    if (self.Mobile_TextField.text.length == 0)
    {
        [[HSQProgressHUDManger Manger] ShowProgressHUDPromptText:@"请输入手机号" SupView:self.view];
    }
    else if (self.Mobile_TextField.text.isPhone == NO)
    {
        [[HSQProgressHUDManger Manger] ShowProgressHUDPromptText:@"手机格式不正确" SupView:self.view];
    }
    else if (self.MobileCode_TextField.text.length == 0)
    {
        [[HSQProgressHUDManger Manger] ShowProgressHUDPromptText:@"请输入验证码" SupView:self.view];
    }
    else
    {
        [self MobilePhoneDynamicCodeLogin];
    }
}

/**
 * @brief 手机动态码登录--验证图片验证码及发送短信
 */
- (void)MobilePhoneDynamicCodeLogin{
    
        [self GetSMSDynamicCodeAndVerifyImageVerificationCode:self.Mobile_TextField.text captchaKey:self.captchaKey captchaVal:self.MobileCode_TextField.text sendType:@"2"];
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
    
    AFNetworkRequestTool *mangerTool = [AFNetworkRequestTool shareRequestTool];
    
    [mangerTool.manger GET:UrlAdress(KValidationBtnCodeImageUrl) parameters:diction progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        HSQLog(@"==验证图片验证码=%@",responseObject);
        
        if ([responseObject[@"code"] integerValue] == 200)
        {
            // 动态码的重发间隔秒数
            NSString *authCodeResendTime = [NSString stringWithFormat:@"%@",responseObject[@"datas"][@"authCodeResendTime"]];
            
            // 动态码的有效时间（分钟）
            NSString *authCodeValidTime = [NSString stringWithFormat:@"%@",responseObject[@"datas"][@"authCodeValidTime"]];
            
            // 1.验证成功以后，跳转到输入短信验证码的界面
            MobileVerificationLoginViewController *MobileVerificaLoginVC = [[MobileVerificationLoginViewController alloc] init];
            
            MobileVerificaLoginVC.UserPhoneString = self.Mobile_TextField.text;
            
            MobileVerificaLoginVC.SMS_ValidTime = authCodeValidTime;
            
            MobileVerificaLoginVC.SMS_IntervalTime = authCodeResendTime;
            
            [self.navigationController pushViewController:MobileVerificaLoginVC animated:YES];
            
        }
        else
        {
            NSString *errorString = [NSString stringWithFormat:@"%@",responseObject[@"datas"][@"error"]];
            
            [[HSQProgressHUDManger Manger] ShowDisplayFailedToLoadData:errorString SuperView:self.view];
            
            [self LoginCodeButtonImageFromeServer:self.MobileLoginCode_Button];
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [[HSQProgressHUDManger Manger] ShowDisplayFailedToLoadData:KErrorPlacherString SuperView:self.view];
        
    }];
}






@end
