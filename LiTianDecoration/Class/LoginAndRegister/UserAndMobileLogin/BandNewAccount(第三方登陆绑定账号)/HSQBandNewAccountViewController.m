//
//  HSQBandNewAccountViewController.m
//  LiTianDecoration
//
//  Created by administrator on 2018/6/28.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import "HSQBandNewAccountViewController.h"
#import "HSQSubmitBandCodeViewController.h"
#import "HSQAccountTool.h"

@interface HSQBandNewAccountViewController ()<UITextFieldDelegate>

// 顶部的所有标签
@property (nonatomic, weak) UIView *titlesView;

// 标签栏底部的红色指示器
@property (nonatomic, weak) UIImageView *indicatorView;

// 当前选中的按钮
@property (nonatomic, weak) UIButton *selectedButton;

@property (nonatomic, copy) NSString *captchaKey; // 图片验证码的标示

@property (nonatomic, assign) NSInteger BandType;  // 0代表注册新账号并绑定 1代表 绑定已有账号

@property (weak, nonatomic) IBOutlet UILabel *First_PlacherLabel;

@property (weak, nonatomic) IBOutlet UILabel *Second_PlacherLabel;

@property (weak, nonatomic) IBOutlet UITextField *First_TextField;

@property (weak, nonatomic) IBOutlet UITextField *Second_TextField;

@property (weak, nonatomic) IBOutlet UIButton *Code_Button; // 验证码按钮

@property (weak, nonatomic) IBOutlet UIButton *ClickButton; // 底部的按钮

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *RightMargin;
@end

@implementation HSQBandNewAccountViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.view.backgroundColor = KViewBackGroupColor;
    
    self.navigationItem.title = @"绑定账号";
    
    self.BandType = 0;
    
    // 设置顶部标题栏
    [self setupTopTitlesView];
    
     [self LoginCodeButtonImageFromeServer:self.Code_Button];
    
}

/**
 * @brief 设置顶部标题栏
 */
- (void)setupTopTitlesView{
    
    NSArray *array = @[@"注册新账号并绑定",@"绑定已有账号"];
    
    // 标签栏整体
    UIView *titlesView = [[UIView alloc] init];
    titlesView.backgroundColor = [UIColor whiteColor];
    titlesView.mj_w = [UIScreen mainScreen].bounds.size.width;
    titlesView.mj_h = 50;
    titlesView.mj_y = 0;
    [self.view addSubview:titlesView];
    self.titlesView = titlesView;
    
    // 底部的红色指示器
    UIImageView *indicatorView = [[UIImageView alloc] init];
    indicatorView.backgroundColor = RGB(255, 83, 63);
    indicatorView.mj_h = 2;
    indicatorView.tag = -1;
    indicatorView.mj_y = titlesView.mj_h - indicatorView.mj_h;
    self.indicatorView = indicatorView;
    
    // 内部的子标签
    CGFloat width = titlesView.mj_w / array.count;
    
    CGFloat height = titlesView.mj_h;
    
    for (NSInteger i = 0; i < array.count; i++) {
        
        UIButton *button = [UIButton buttonWithType:(UIButtonTypeCustom)];
        button.tag = i;
        button.mj_h = height;
        button.mj_w = width;
        button.mj_x = i * width;
        
        [button setTitle:array[i] forState:UIControlStateNormal];
        
        [button setTitleColor:RGB(131, 131, 131) forState:UIControlStateNormal];
        
        [button setTitleColor:RGB(255, 83, 63) forState:UIControlStateDisabled];
        
        button.titleLabel.font = [UIFont systemFontOfSize:14.0];
        
        [button addTarget:self action:@selector(titleClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [titlesView addSubview:button];
        
        // 默认点击了第一个按钮
        if (i == 0)
        {
            button.enabled = NO;
            
            self.selectedButton = button;
            
            // 让按钮内部的label根据文字内容来计算尺寸
            [button.titleLabel sizeToFit];
            
            self.indicatorView.mj_w = button.titleLabel.mj_w;
            
            self.indicatorView.centerX = button.centerX;
        }
        
        // 让按钮内部的label根据文字内容来计算尺寸
        [button.titleLabel sizeToFit];
    }
    
    [titlesView addSubview:indicatorView];
}

/**
 * @brief 顶部按钮的点击事件
 */
- (void)titleClick:(UIButton *)button{
    
    // 修改按钮状态
    self.selectedButton.enabled = YES;
    
    button.enabled = NO;
    
    self.selectedButton = button;
    
    // 动画
    [UIView animateWithDuration:0.25 animations:^{
        
        self.indicatorView.width = button.titleLabel.mj_w;
        
        self.indicatorView.centerX = button.centerX;
    }];
    
    self.BandType = button.tag;
    
    // 改变提示文字
    if (self.BandType == 0)
    {
        self.First_PlacherLabel.text = @"手机号：";
        
        self.Second_PlacherLabel.text = @"验证码：";
        
        self.First_TextField.placeholder = @"请输入手机号";
        
        self.Second_TextField.placeholder = @"请输入验证码";
        
        [self.ClickButton setTitle:@"获取动态码" forState:(UIControlStateNormal)];
        
        self.Code_Button.hidden = NO;
        
        self.RightMargin.constant = 10;
        
        self.Second_TextField.secureTextEntry = NO;
    }
    else
    {
        self.First_PlacherLabel.text = @"账号：";
        
        self.Second_PlacherLabel.text = @"密码：";
        
        self.First_TextField.placeholder = @"手机号/会员名/邮箱";
        
        self.Second_TextField.placeholder = @"请输入密码";
        
        [self.ClickButton setTitle:@"立即绑定" forState:(UIControlStateNormal)];
        
        self.Code_Button.hidden = YES;
        
        self.RightMargin.constant = -100;
        
        self.Second_TextField.secureTextEntry = YES;
    }
}

/**
 * @brief 请求验证码的图片的按钮的点击事件
 */
- (IBAction)RequestCodeImageViewBtnClickAction:(UIButton *)sender {
    
    [self LoginCodeButtonImageFromeServer:self.Code_Button];
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
 * @brief 底部按钮的点击
 */
- (IBAction)BottomButtonClickAction:(UIButton *)sender {
    
    if (self.First_TextField.text.length == 0)
    {
        NSString *placher_string = (self.BandType == 0 ? @"请输入手机号" : @"手机号/会员名/邮箱");
        
        [[HSQProgressHUDManger Manger] ShowProgressHUDPromptText:placher_string SupView:self.view];
    }
    else if (self.Second_TextField.text.length == 0)
    {
        NSString *placher_string = (self.BandType == 0 ? @"请输入验证码" : @"请输入密码");
        
        [[HSQProgressHUDManger Manger] ShowProgressHUDPromptText:placher_string SupView:self.view];
    }
    else
    {
        if (self.BandType == 0) // 绑定新账号
        {
            // 获取短信验证码
            [self GetSMSDynamicCodeAndVerifyImageVerificationCode:self.First_TextField.text captchaKey:self.captchaKey captchaVal:self.Second_TextField.text sendType:@"4"];
            
        }
        else // 绑定已有账号
        {
            if (self.Source == 100) // QQ绑定已有账号
            {
                NSDictionary *params = @{@"accessToken":self.accessToken,@"openId":self.openId,@"appId":self.appId,@"memberName":self.First_TextField.text,@"memberPwd":self.Second_TextField.text,@"clientType":KClientType};
                
                [self AppLoginIsBoundToAnExistingAccount:UrlAdress(KQQBandAccountUrl) Parmas:params];
            }
            else // 微信绑定已有账号
            {
                NSDictionary *params = @{@"accessToken":self.accessToken,@"openId":self.openId,@"memberName":self.First_TextField.text,@"memberPwd":self.Second_TextField.text,@"clientType":KClientType};
                
                [self AppLoginIsBoundToAnExistingAccount:UrlAdress(KWeiChatBandAccountUrl) Parmas:params];
            }
        }
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
            HSQSubmitBandCodeViewController *MobileVerificaLoginVC = [[HSQSubmitBandCodeViewController alloc] init];
            
            MobileVerificaLoginVC.UserPhoneString = self.First_TextField.text;
            
            MobileVerificaLoginVC.SMS_ValidTime = authCodeValidTime;
            
            MobileVerificaLoginVC.SMS_IntervalTime = authCodeResendTime;
            
            MobileVerificaLoginVC.Source = self.Source;
            
            MobileVerificaLoginVC.accessToken = self.accessToken;
            
            MobileVerificaLoginVC.openId = self.openId;
            
            MobileVerificaLoginVC.appId = self.appId;
            
            [self.navigationController pushViewController:MobileVerificaLoginVC animated:YES];
            
        }
        else
        {
            NSString *errorString = [NSString stringWithFormat:@"%@",responseObject[@"datas"][@"error"]];
            
            [[HSQProgressHUDManger Manger] ShowDisplayFailedToLoadData:errorString SuperView:self.view];
            
             [self LoginCodeButtonImageFromeServer:self.Code_Button];
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [[HSQProgressHUDManger Manger] ShowDisplayFailedToLoadData:KErrorPlacherString SuperView:self.view];
        
    }];
}

/**
 * @brief App登录绑定已有账号
 */
- (void)AppLoginIsBoundToAnExistingAccount:(NSString *)RequestUrl Parmas:(NSDictionary *)params{
    
    HSQLog(@"=====%@===%@",RequestUrl,params);
    
    [[HSQProgressHUDManger Manger] ShowLoadingDataFromeServer:@"" ToView:self.view IsClearColor:YES];
    
    AFNetworkRequestTool *mangerTool = [AFNetworkRequestTool shareRequestTool];
    
    [mangerTool.manger POST:RequestUrl parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        HSQLog(@"=App登录绑定已有账号=%@",responseObject);
        
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
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        HSQLog(@"===%@",error.description);
        
        [[HSQProgressHUDManger Manger] ShowDisplayFailedToLoadData:KErrorPlacherString SuperView:self.view];
    }];
}

/**
 * @brief 点击return键盘
 */
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if (textField == self.First_TextField)
    {
        [self.Second_TextField becomeFirstResponder];
    }
    else if (textField == self.Second_TextField)
    {
        [self.Second_TextField resignFirstResponder];
    }
    
    return YES;
}




@end
