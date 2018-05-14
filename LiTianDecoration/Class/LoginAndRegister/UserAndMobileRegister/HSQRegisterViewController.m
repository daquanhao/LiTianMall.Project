//
//  HSQRegisterViewController.m
//  LiTianDecoration
//
//  Created by administrator on 2018/4/11.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import "HSQRegisterViewController.h"
#import "HSQMobileRegisterViewController.h"
#import "HSQWebViewController.h"
#import "HSQAccountTool.h"

@interface HSQRegisterViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIButton *Normal_RegisterBtn; // 普通注册
@property (weak, nonatomic) IBOutlet UIButton *Mobile_RegisterBtn; // 手机注册

/** 普通用户注册*/
@property (weak, nonatomic) IBOutlet UIView *Line_View;
@property (weak, nonatomic) IBOutlet UITextField *UserName_TextField;
@property (weak, nonatomic) IBOutlet UITextField *PassWord_TextField;
@property (weak, nonatomic) IBOutlet UITextField *QRPassWord_TextField;
@property (weak, nonatomic) IBOutlet UITextField *Email_TextField;
@property (weak, nonatomic) IBOutlet UITextField *Code_TextField;
@property (weak, nonatomic) IBOutlet UIButton *Code_Burron;
@property (weak, nonatomic) IBOutlet UIButton *Register_Button;

/** 手机用户注册*/
@property (weak, nonatomic) IBOutlet UITextField *Mobile_TextField;
@property (weak, nonatomic) IBOutlet UITextField *MobileCode_TextField;
@property (weak, nonatomic) IBOutlet UIButton *MobileCode_Button;
@property (weak, nonatomic) IBOutlet UIButton *MobileRegisterActivity_Btn;
@property (weak, nonatomic) IBOutlet UIButton *GetCodeBtn;  // 获取动态码的按钮

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *Normal_LeftMargin;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *Mobile_LeftMargin;

@property (nonatomic, assign) CGFloat TextFielfSuper_Height;
@property (nonatomic, assign) CGFloat KeyBoard_Y;
@property (nonatomic, assign) CGFloat KeyBoard_Margin;

@property (nonatomic, copy) NSString *captchaKey;  // 验证码的标识

@end

@implementation HSQRegisterViewController

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    // 请求验证码的图片
    [self RegisterCodeButtonImageFromeServer:self.Code_Burron];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.view.backgroundColor = KViewBackGroupColor;
    
    self.navigationItem.title = @"会员注册";
    
    // 1.监听键盘的弹出或者消失
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(WillChange:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(WillDismissChange:) name:UIKeyboardWillHideNotification object:nil];

    
}

#pragma mark - 顶部--普通注册事件

- (IBAction)NormalUserRegisterClickAction:(UIButton *)sender {
    
    [UIView animateWithDuration:0.25 animations:^{
        
        self.Line_View.centerX = sender.centerX;
        
        self.Normal_LeftMargin.constant = 0;
        
        self.Mobile_LeftMargin.constant = KScreenWidth;
    }];
}

#pragma mark - 顶部--手机注册事件

- (IBAction)MobileUserRegisterClickAction:(UIButton *)sender {
    
    [self RegisterCodeButtonImageFromeServer:self.MobileCode_Button];
    
    [UIView animateWithDuration:0.25 animations:^{
        
        self.Line_View.centerX = sender.centerX;
        
        self.Normal_LeftMargin.constant = -KScreenWidth;
        
        self.Mobile_LeftMargin.constant = 0;
        
    }];
}

/**
 * @brief 普通注册--点击获取验证码
 */
- (IBAction)HuoQuCodeButtonClickAction:(UIButton *)sender {
    
    [self RegisterCodeButtonImageFromeServer:self.Code_Burron];
}

/**
 * @brief 普通注册--注册按钮的点击
 */
- (IBAction)NormalUserRegisterButtonClickAction:(UIButton *)sender {
    
    if (self.Normal_LeftMargin.constant == 0)  // 表明是普通用户注册
    {
        if (self.UserName_TextField.text.length == 0)
        {
            [[HSQProgressHUDManger Manger] ShowProgressHUDPromptText:@"请输入6-20位字符" SupView:self.view];
        }
        if ([self.UserName_TextField.text isPureInt:self.UserName_TextField.text] == YES)
        {
            [[HSQProgressHUDManger Manger] ShowProgressHUDPromptText:@"用户名不能为纯数字" SupView:self.view];
        }
        else if (self.PassWord_TextField.text.length == 0)
        {
            [[HSQProgressHUDManger Manger] ShowProgressHUDPromptText:@"请输入6-20位密码" SupView:self.view];
        }
        else if (self.PassWord_TextField.text.length < 6)
        {
            [[HSQProgressHUDManger Manger] ShowProgressHUDPromptText:@"密码至少为6位" SupView:self.view];
        }
        else if (self.QRPassWord_TextField.text.length == 0)
        {
            [[HSQProgressHUDManger Manger] ShowProgressHUDPromptText:@"请再次输入密码" SupView:self.view];
        }
        else if (![self.QRPassWord_TextField.text isEqualToString:self.PassWord_TextField.text])
        {
            [[HSQProgressHUDManger Manger] ShowProgressHUDPromptText:@"密码与确认密码不符" SupView:self.view];
        }
        else if (self.Email_TextField.text.length == 0)
        {
            [[HSQProgressHUDManger Manger] ShowProgressHUDPromptText:@"请输入您的常用邮箱" SupView:self.view];
        }
        else if ([self.Email_TextField.text isValidateEmail:self.Email_TextField.text] == NO)
        {
            [[HSQProgressHUDManger Manger] ShowProgressHUDPromptText:@"邮箱格式不正确" SupView:self.view];
        }
        else if (self.Code_TextField.text.length == 0)
        {
            [[HSQProgressHUDManger Manger] ShowProgressHUDPromptText:@"请输入验证码" SupView:self.view];
        }
        else
        {
            [self NormalUserRegisterNotifServer];
        }
    }
}

/**
 * @brief 普通注册--通知服务器我要注册
 */
- (void)NormalUserRegisterNotifServer{
    
    NSMutableDictionary *diction = [NSMutableDictionary dictionary];
    diction[@"memberName"] = self.UserName_TextField.text;
    diction[@"password"] = self.PassWord_TextField.text;
    diction[@"password_confirm"] = self.QRPassWord_TextField.text;
    diction[@"email"] = self.Email_TextField.text;
    diction[@"captchaKey"] = self.captchaKey;
    diction[@"captchaVal"] = self.Code_TextField.text;
    diction[@"clientType"] = KClientType;
    
    AFNetworkRequestTool *RequestTool = [AFNetworkRequestTool shareRequestTool];
    
    [RequestTool.manger POST:UrlAdress(KNormalRegisterUrl) parameters:diction progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        HSQLog(@"=注册数据=%@",responseObject);
        [[HSQProgressHUDManger Manger] DismissProgressHUD];
        
        if ([responseObject[@"code"] integerValue] == 200)
        {
            [[HSQProgressHUDManger Manger] ShowLoadDataSuccessWithPlaceholderString:@"注册成功" SuperView:self.view];
            
            [self.navigationController popViewControllerAnimated:YES];
        }
        else
        {
            NSString *errorString = [NSString stringWithFormat:@"%@",responseObject[@"datas"][@"error"]];
            
            [[HSQProgressHUDManger Manger] ShowDisplayFailedToLoadData:errorString SuperView:self.view];
            
            // 重新请求验证码
            [self RegisterCodeButtonImageFromeServer:self.Code_Burron];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [[HSQProgressHUDManger Manger] ShowProgressHUDPromptText:@"数据加载错误" SupView:self.view];
    }];
}


/**
 * @brief 手机注册--点击获取验证码
 */
- (IBAction)PhoneRegisterGetCodeImageViewDataFromeServer:(UIButton *)sender {
    
    [self PhoneRegisterGetCodeImageViewDataFromeServer:self.MobileCode_Button];
}

/**
 * @brief 手机注册--获取动态码
 */
- (IBAction)MobileRegisterHuoQuDongTaiMaClick:(UIButton *)sender {
    
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
#warning TODO 在此验证输入的图片验证码是否正确，然后发送短信验证码
        HSQMobileRegisterViewController *MobileRegisterVC = [[HSQMobileRegisterViewController alloc] init];
        
        MobileRegisterVC.PhoneString = self.Mobile_TextField.text;
        
        MobileRegisterVC.SMS_ValidTime = @"10";
        
        MobileRegisterVC.SMS_IntervalTime = @"60";
        
        [self.navigationController pushViewController:MobileRegisterVC animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

/**
 * @brief 请求验证码的图片
 */
- (void)RegisterCodeButtonImageFromeServer:(UIButton *)sender{
    
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
 *@brief 查看用户的注册协议
 */
- (IBAction)LookUpUserRegisterClickAction:(UIButton *)sender {
    
    HSQWebViewController *webView = [[HSQWebViewController alloc] init];
        
    webView.Url = UrlAdress(KUserRegisterUrl);
    
    [self.navigationController pushViewController:webView animated:YES];
}















#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    // 获取一个视图在另外一个视图上的相对位置,  convertRect：目标的尺寸  toView：相对于那个视图的
    CGRect  rectInSuperview = [self.view convertRect:textField.superview.frame toView:textField.superview.superview.superview];
    
    self.TextFielfSuper_Height = rectInSuperview.origin.y + textField.superview.mj_h + 5 + KSafeTopeHeight + 55;
    
    if (self.view.transform.ty < 0)
    {
        [UIView animateWithDuration:0.25 animations:^{
            
            self.view.transform = CGAffineTransformMakeTranslation(0, self.KeyBoard_Margin);
        }];
    }
    
    return YES;
}

- (void)WillChange:(NSNotification *)notif{
    
    NSDictionary *keyboardInfo = notif.userInfo;
    
    CGRect keyboardFrame = [keyboardInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    CGFloat animationDuration = [keyboardInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    self.KeyBoard_Y = keyboardFrame.origin.y;
    
    [self ShowKeyBoardAnimate:animationDuration];
    
}

- (void)WillDismissChange:(NSNotification *)notif{
    
    NSDictionary *keyboardInfo = notif.userInfo;
    
    CGFloat animationDuration = [keyboardInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    [UIView animateWithDuration:animationDuration animations:^{
        
        self.view.transform = CGAffineTransformIdentity;
        
    }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if (textField == self.UserName_TextField)
    {
        [self.PassWord_TextField becomeFirstResponder];
    }
    else if (textField == self.PassWord_TextField)
    {
        [self.QRPassWord_TextField becomeFirstResponder];
    }
    else if (textField == self.QRPassWord_TextField)
    {
        [self.Email_TextField becomeFirstResponder];
    }
    else if (textField == self.Email_TextField)
    {
        [self.Code_TextField becomeFirstResponder];
    }
    else if (textField == self.Code_TextField)
    {
        [self.Code_TextField resignFirstResponder];
    }
    else if (textField == self.Mobile_TextField)
    {
        [self.MobileCode_TextField becomeFirstResponder];
    }
    else if (textField == self.MobileCode_TextField)
    {
        [self.MobileCode_TextField resignFirstResponder];
    }
    
    if (self.Code_TextField.isFirstResponder == YES)
    {
        [self ShowKeyBoardAnimate:0.25f];
    }
    
    return YES;
}

- (void)ShowKeyBoardAnimate:(CGFloat)animationDuration{
    
    if (self.KeyBoard_Y < self.TextFielfSuper_Height) {

        [UIView animateWithDuration:animationDuration animations:^{

            self.view.transform = CGAffineTransformMakeTranslation(0, self.KeyBoard_Y - self.TextFielfSuper_Height);
            
        }completion:^(BOOL finished) {
            
            self.KeyBoard_Margin = self.view.transform.ty + 55;
        }];
    }
}

- (void)dealloc{
    
    [[NSNotificationCenter  defaultCenter] removeObserver:self];
}






@end
