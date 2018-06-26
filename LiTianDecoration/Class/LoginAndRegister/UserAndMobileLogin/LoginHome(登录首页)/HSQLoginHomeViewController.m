//
//  HSQLoginHomeViewController.m
//  LiTianDecoration
//
//  Created by administrator on 2018/6/11.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import "HSQLoginHomeViewController.h"
#import "HSQRegisterViewController.h"  // 注册界面
#import "HSQUserAndMobileLoginViewController.h"
#import "HSQUserAccountLoginViewController.h"

@interface HSQLoginHomeViewController ()

@property (nonatomic, strong) NSDictionary *LoginState_Diction;  // 登录状态

@property (weak, nonatomic) IBOutlet UIButton *QQLogin_Button; // QQ登录按钮

@property (weak, nonatomic) IBOutlet UIButton *WeChatLogin_Button; // 微信登录按钮

@property (weak, nonatomic) IBOutlet UIButton *MiddenLogin_Button; // 中间的第三方登录

@end

@implementation HSQLoginHomeViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.view.backgroundColor = KViewBackGroupColor;
    
    self.navigationItem.title = @"登录";
    
    self.LoginState_Diction = [NSDictionary dictionary];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:(UIBarButtonItemStylePlain) target:self action:@selector(CancelBtnClick:)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"注册" style:(UIBarButtonItemStylePlain) target:self action:@selector(RegisterBtnClick:)];
    
    // 第三方账号及手机登录开关状态
    [self ThirdPartyAccountAndMobilePhoneLoginSwitchStatus];
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
 * @brief 第三方账号及手机登录开关状态
 */
- (void)ThirdPartyAccountAndMobilePhoneLoginSwitchStatus{
    
    [[HSQProgressHUDManger Manger] ShowLoadingDataFromeServer:@"" ToView:self.view IsClearColor:YES];
    
    AFNetworkRequestTool *mangerTool = [AFNetworkRequestTool shareRequestTool];
    
    [mangerTool.manger GET:UrlAdress(KLoginStateUrl) parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        HSQLog(@"==手机登录开关状态==%@",responseObject);
        [[HSQProgressHUDManger Manger] DismissProgressHUD];
        
        if ([responseObject[@"code"] integerValue] == 200)
        {
            self.LoginState_Diction = responseObject[@"datas"];
            
            // 微信登录是否开启  1–开启 0–未开启
            NSString *weixinLogin = [NSString stringWithFormat:@"%@",responseObject[@"datas"][@"weixinLogin"]];
            
            // QQ登录是否开启 1–开启 0–未开启
            NSString *qqLogin = [NSString stringWithFormat:@"%@",responseObject[@"datas"][@"qqLogin"]];
            
            // 手机验证码登录是否开启 1–开启 0–未开启
            NSString *smsLogin = [NSString stringWithFormat:@"%@",responseObject[@"datas"][@"smsLogin"]];
            
            if (smsLogin.integerValue == 0) // 手机动态码登录，没有开启
            {
                // 用户账号登录
                HSQUserAccountLoginViewController *UserAccountLoginVC = [[HSQUserAccountLoginViewController alloc] init];
                UserAccountLoginVC.view.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight - KSafeTopeHeight - KSafeBottomHeight - 150);
                [self addChildViewController:UserAccountLoginVC];
                [self.view addSubview:UserAccountLoginVC.view];
            }
            else
            {
                // 用户账号和手机动态码登录
                HSQUserAndMobileLoginViewController *UserAndMobileLoginVC = [[HSQUserAndMobileLoginViewController alloc] init];
                UserAndMobileLoginVC.view.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight - KSafeTopeHeight - KSafeBottomHeight - 150);
                [self addChildViewController:UserAndMobileLoginVC];
                [self.view addSubview:UserAndMobileLoginVC.view];
            }
            
            if (weixinLogin.integerValue == 1 && qqLogin.integerValue == 1) // 微信登录和QQ登录开启
            {
                self.WeChatLogin_Button.hidden = self.QQLogin_Button.hidden =  NO;
                self.MiddenLogin_Button.hidden = YES;
            }
            else if (weixinLogin.integerValue == 1 && qqLogin.integerValue == 0) // 只有微信登录
            {
                self.WeChatLogin_Button.hidden = self.QQLogin_Button.hidden =  YES;
                self.MiddenLogin_Button.hidden = NO;
                [self.MiddenLogin_Button setBackgroundImage:KImageName(@"sns_icon_7") forState:(UIControlStateNormal)];
            }
            else if (weixinLogin.integerValue == 0 && qqLogin.integerValue == 1) // 只有QQ登录
            {
                self.WeChatLogin_Button.hidden = self.QQLogin_Button.hidden =  YES;
                self.MiddenLogin_Button.hidden = NO;
                [self.MiddenLogin_Button setBackgroundImage:KImageName(@"88D2CB74-C4C7-4160-AE0D-2C8549694922") forState:(UIControlStateNormal)];
            }
            
        }
        else
        {
            self.WeChatLogin_Button.hidden = self.QQLogin_Button.hidden = self.MiddenLogin_Button.hidden = YES;
            
            // 用户账号登录
            HSQUserAccountLoginViewController *UserAccountLoginVC = [[HSQUserAccountLoginViewController alloc] init];
            UserAccountLoginVC.view.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight - KSafeTopeHeight - KSafeBottomHeight - 150);
            [self addChildViewController:UserAccountLoginVC];
            [self.view addSubview:UserAccountLoginVC.view];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [[HSQProgressHUDManger Manger] ShowProgressHUDPromptText:@"网络出问题啦！" SupView:self.view];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 * @brief QQ登录点击事件
 */
- (IBAction)QQLoginButtonClickAction:(UIButton *)sender {
    
    
}

/**
 * @brief 微信登录点击事件
 */
- (IBAction)WeiChatLoginButtonClickAction:(UIButton *)sender {
    
    
}

/**
 * @brief 中间登录点击事件
 */
- (IBAction)MiddenButtonClickAction:(UIButton *)sender {
    
    // 微信登录是否开启  1–开启 0–未开启
    NSString *weixinLogin = [NSString stringWithFormat:@"%@",self.LoginState_Diction[@"weixinLogin"]];
    
    // QQ登录是否开启 1–开启 0–未开启
    NSString *qqLogin = [NSString stringWithFormat:@"%@",self.LoginState_Diction[@"qqLogin"]];
    
    if (weixinLogin.integerValue == 0 && qqLogin.integerValue == 1) // 微信登录没有开启，只有QQ登录
    {
        HSQLog(@"===你点击了QQ登录");
    }
    else if (weixinLogin.integerValue == 1 && qqLogin.integerValue == 0) // 微信登录开启，没有QQ登录
    {
        HSQLog(@"===你点击微信登录");
    }
}





@end
