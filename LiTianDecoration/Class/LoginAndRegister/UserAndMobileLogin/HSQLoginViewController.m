//
//  HSQLoginViewController.m
//  LiTianDecoration
//
//  Created by administrator on 2018/4/11.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import "HSQLoginViewController.h"
#import "HSQAccountTool.h"
#import "HSQRegisterViewController.h"
#import "HSQForgotPasswordViewController.h"
#import "MobileVerificationLoginViewController.h"

@interface HSQLoginViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIView *Line_View;

// 用户登录界面
@property (weak, nonatomic) IBOutlet UITextField *Account_TextField;
@property (weak, nonatomic) IBOutlet UITextField *PassWord_TextField;
@property (weak, nonatomic) IBOutlet UITextField *Code_TextField;
@property (weak, nonatomic) IBOutlet UIButton *CodeImage_Btn; // 验证码图片按钮

// 手机动态码登录界面
@property (weak, nonatomic) IBOutlet UITextField *Mobile_TextField;
@property (weak, nonatomic) IBOutlet UITextField *MobileCode_TextField;
@property (weak, nonatomic) IBOutlet UIButton *MobileLoginCode_Button;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *UserLoginView_Left;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *MobileLoginView_Left;

// 图片验证码的标示
@property (nonatomic, copy) NSString *captchaKey;

@end

@implementation HSQLoginViewController

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    // 1.获取图片验证码
    [self LoginCodeButtonImageFromeServer:self.CodeImage_Btn];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.view.backgroundColor = KViewBackGroupColor;
    
    self.navigationItem.title = @"登录";
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:(UIBarButtonItemStylePlain) target:self action:@selector(CancelBtnClick:)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"注册" style:(UIBarButtonItemStylePlain) target:self action:@selector(RegisterBtnClick:)];
}

/**
 * @brief 取消按钮的点击
 */
- (void)CancelBtnClick:(UIBarButtonItem *)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

/**
 * @brief 注册按钮的点击事件
 */
- (void)RegisterBtnClick:(UIBarButtonItem *)sender{
    
    HSQRegisterViewController *RegisterVC = [[HSQRegisterViewController alloc] init];
    
    [self.navigationController pushViewController:RegisterVC animated:YES];
}

/**
 * @brief 用户名按钮的点击事件
 */
- (IBAction)UserNameLoginClickAction:(UIButton *)sender {
    
    [UIView animateWithDuration:0.25 animations:^{
        
        self.Line_View.centerX = sender.centerX;
        
        self.UserLoginView_Left.constant = 0;
        
        self.MobileLoginView_Left.constant = KScreenWidth;
    }];
}

/**
 * @brief 手机动态码登录按钮的点击事件
 */
- (IBAction)MobileCodeButtonClickAction:(UIButton *)sender {
    
    // 1.获取图片验证码
     [self LoginCodeButtonImageFromeServer:self.MobileLoginCode_Button];
    
    [UIView animateWithDuration:0.25 animations:^{
        
        self.Line_View.centerX = sender.centerX;
        
        self.UserLoginView_Left.constant = -KScreenWidth;
        
        self.MobileLoginView_Left.constant = 0;
    }];
}

/**
 * @brief 用户登录--获取图片验证码的点击事件
 */
- (IBAction)GetImageCodeDataFromeServer:(UIButton *)sender {
    
    [self LoginCodeButtonImageFromeServer:self.CodeImage_Btn];
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

        HSQLog(@"==验证图图片==%@",responseObject);

        self.captchaKey = [NSString stringWithFormat:@"%@",responseObject[@"datas"][@"captchaKey"]];

        NSString *url = [NSString stringWithFormat:@"%@?&&captchaKey=%@&&clientType=%@",UrlAdress(KGetCodeImageUrl),self.captchaKey,@"ios"];

        [sender sd_setBackgroundImageWithURL:[NSURL URLWithString:url] forState:(UIControlStateNormal)];

        [sender sd_setBackgroundImageWithURL:[NSURL URLWithString:url] forState:(UIControlStateHighlighted)];

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {

    }];
}


/**
 * @brief 忘记密码
 */
- (IBAction)ForgetPassWordButtonClickAction:(UIButton *)sender {
    
    HSQForgotPasswordViewController *ForgotPassWordVC = [[HSQForgotPasswordViewController alloc] init];
    
    ForgotPassWordVC.NavtionTitle = @"忘记密码";
    
    [self.navigationController pushViewController:ForgotPassWordVC animated:YES];
}

/**
 * @brief 登录
 */
- (IBAction)UserNameBeginLoginBtnClickAction:(UIButton *)sender {
    
    if (self.UserLoginView_Left.constant == 0)  // 用户登录
    {
        if (self.Account_TextField.text.length == 0)
        {
            [[HSQProgressHUDManger Manger] ShowProgressHUDPromptText:@"请输入用户名/手机号/邮箱" SupView:self.view];
        }
        else if (self.PassWord_TextField.text.length == 0)
        {
            [[HSQProgressHUDManger Manger] ShowProgressHUDPromptText:@"请输入登录密码" SupView:self.view];
        }
        else if (self.Code_TextField.text.length == 0)
        {
            [[HSQProgressHUDManger Manger] ShowProgressHUDPromptText:@"请输入验证码" SupView:self.view];
        }
        else
        {
            [self AccountAndPassWordLogin];
        }
    }
    else   // 手机动态码登录
    {
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
}

/**
 * @brief 账号密码登录
 */
- (void)AccountAndPassWordLogin{
    
    NSMutableDictionary *diction = [NSMutableDictionary dictionary];
    diction[@"memberName"] = self.Account_TextField.text;
    diction[@"password"] = self.PassWord_TextField.text;
    diction[@"captchaKey"] = self.captchaKey;
    diction[@"captchaVal"] = self.Code_TextField.text;
    diction[@"clientType"] = KClientType;
    
    AFNetworkRequestTool *mangerTool = [AFNetworkRequestTool shareRequestTool];
    
    [mangerTool.manger POST:UrlAdress(KNormalLoginUrl) parameters:diction progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        HSQLog(@"=登录数据数据=%@",responseObject);
        
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
                                
                [self.navigationController popViewControllerAnimated:YES];
            });
        }
        else
        {
            NSString *errorString = [NSString stringWithFormat:@"%@",responseObject[@"datas"][@"error"]];
            
            [[HSQProgressHUDManger Manger] ShowDisplayFailedToLoadData:errorString SuperView:self.view];
            
            // 重新请求验证码
            [self LoginCodeButtonImageFromeServer:self.CodeImage_Btn];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        // 重新请求验证码
        [self LoginCodeButtonImageFromeServer:self.CodeImage_Btn];
        
        [[HSQProgressHUDManger Manger] ShowProgressHUDPromptText:@"数据加载错误" SupView:self.view];
    }];
}

/**
 * @brief 手机动态码登录--验证图片验证码及发送短信
 */
- (void)MobilePhoneDynamicCodeLogin{
    
//    [self GetSMSDynamicCodeAndVerifyImageVerificationCode:self.Mobile_TextField.text captchaKey:self.captchaKey captchaVal:self.MobileCode_TextField.text sendType:@"2"];
    
    MobileVerificationLoginViewController *MobileVerificaLoginVC = [[MobileVerificationLoginViewController alloc] init];
    
    MobileVerificaLoginVC.UserPhoneString = self.Mobile_TextField.text;
    
    MobileVerificaLoginVC.SMS_ValidTime = @"20";
    
    MobileVerificaLoginVC.SMS_IntervalTime = @"20";
    
    [self.navigationController pushViewController:MobileVerificaLoginVC animated:YES];
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
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [[HSQProgressHUDManger Manger] ShowDisplayFailedToLoadData:@"验证失败" SuperView:self.view];
        
    }];
}





- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];

}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if (textField == self.Account_TextField)
    {
        [self.PassWord_TextField becomeFirstResponder];
    }
    else if (textField == self.PassWord_TextField)
    {
        [self.Code_TextField becomeFirstResponder];
    }
    else if (textField == self.Code_TextField)
    {
        [self.Code_TextField resignFirstResponder];
    }
    else if (textField == self.Mobile_TextField)
    {
        [self.Mobile_TextField becomeFirstResponder];
    }
    else if (textField == self.MobileCode_TextField)
    {
        [self.MobileCode_TextField resignFirstResponder];
    }
    
    return YES;
}



@end
