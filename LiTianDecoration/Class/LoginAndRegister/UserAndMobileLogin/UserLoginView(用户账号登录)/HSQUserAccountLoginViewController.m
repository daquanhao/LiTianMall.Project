//
//  HSQUserAccountLoginViewController.m
//  LiTianDecoration
//
//  Created by administrator on 2018/6/11.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import "HSQUserAccountLoginViewController.h"
#import "HSQBandMobileViewController.h"
#import "HSQAccountTool.h"

@interface HSQUserAccountLoginViewController ()

@property (weak, nonatomic) IBOutlet UITextField *Account_TextField;

@property (weak, nonatomic) IBOutlet UITextField *PassWord_TextField;

@property (weak, nonatomic) IBOutlet UITextField *Code_TextField;

@property (weak, nonatomic) IBOutlet UIButton *CodeImage_Btn; // 验证码图片按钮

@property (nonatomic, copy) NSString *captchaKey; // 图片验证码的标示

@end

@implementation HSQUserAccountLoginViewController

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    // 1.获取图片验证码
    [self LoginCodeButtonImageFromeServer:self.CodeImage_Btn];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.view.backgroundColor = KViewBackGroupColor;
}

/**
 * @brief 用户登录--获取图片验证码的点击事件
 */
- (IBAction)GetImageCodeDataFromeServer:(UIButton *)sender {
    
    [self LoginCodeButtonImageFromeServer:self.CodeImage_Btn];
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
    
    HSQBandMobileViewController *BandMobileVC = [[HSQBandMobileViewController alloc] init];
    
    BandMobileVC.NavtionTitle = @"找回密码";
    
    BandMobileVC.sendType = @"3";
    
    BandMobileVC.Source = 500;
    
    [self.navigationController pushViewController:BandMobileVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/**
 * @brief 登录
 */
- (IBAction)UserNameBeginLoginBtnClickAction:(UIButton *)sender {
    
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

/**
 * @brief 账号密码登录
 */
- (void)AccountAndPassWordLogin{
    
    [[HSQProgressHUDManger Manger] ShowLoadingDataFromeServer:@"" ToView:self.view IsClearColor:YES];
    
    NSDictionary *params = @{@"memberName":self.Account_TextField.text,@"password":self.PassWord_TextField.text,@"captchaKey":self.captchaKey,@"captchaVal":self.Code_TextField.text,@"clientType":KClientType};
    
    AFNetworkRequestTool *mangerTool = [AFNetworkRequestTool shareRequestTool];
    
    [mangerTool.manger POST:UrlAdress(KNormalLoginUrl) parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
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
        
        [[HSQProgressHUDManger Manger] ShowProgressHUDPromptText:KErrorPlacherString SupView:self.view];
    }];
}

/**
 * @brief 键盘return键的点击
 */
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
    
    return YES;
}

@end
