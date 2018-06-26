//
//  HSQBandMobileViewController.m
//  LiTianDecoration
//
//  Created by administrator on 2018/4/26.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import "HSQBandMobileViewController.h"
#import "HSQNextBandPhoneViewController.h"

@interface HSQBandMobileViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *Phone_TextField;

@property (weak, nonatomic) IBOutlet UITextField *Code_TextField;

@property (weak, nonatomic) IBOutlet UIButton *Code_Button;

@property (nonatomic, copy) NSString *captchaKey;

@property (weak, nonatomic) IBOutlet UILabel *BottomPlacher_Label; // 底部的提示标语

@property (weak, nonatomic) IBOutlet UIButton *BottomClick_Btn;

@end

@implementation HSQBandMobileViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.view.backgroundColor = KViewBackGroupColor;
    
    self.navigationItem.title = self.NavtionTitle;
    
    if (self.MobileString.length != 0)
    {
        NSString *phoneString = [self.MobileString stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
        
        self.Phone_TextField.text = phoneString;
    }
    
    // 隐藏底部提示标语
    if (self.Source == 500)
    {
        self.BottomPlacher_Label.hidden = NO;
        
        self.BottomPlacher_Label.text = @"请填写已经绑定过的手机号码。";
        
        self.BottomPlacher_Label.textAlignment = NSTextAlignmentCenter;
        
        [self.BottomClick_Btn setTitle:@"获取动态码" forState:(UIControlStateNormal)];
    }
    else if (self.Source == 200)
    {
        self.BottomPlacher_Label.hidden = NO;
    }
    else
    {
        self.BottomPlacher_Label.hidden = YES;
    }
    
    // 请求验证码的图片
    [self RegisterCodeButtonImageFromeServer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 * @brief 改变图片验证码的点击事件
 */
- (IBAction)ChangeButtonCodeClickAction:(UIButton *)sender {
    
    [self RegisterCodeButtonImageFromeServer];
}

/**
 * @brief 请求验证码的图片
 */
- (void)RegisterCodeButtonImageFromeServer{
    
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
        
        [[HSQProgressHUDManger Manger] ShowDisplayFailedToLoadData:KErrorPlacherString SuperView:self.view];
    }];
}

/**
 * @brief 下一步的点击事件
 */
- (IBAction)NextUpButtonClickAction:(UIButton *)sender {
    
    if (self.Phone_TextField.text.length == 0)
    {
        [[HSQProgressHUDManger Manger] ShowProgressHUDPromptText:@"请输入您的手机号" SupView:self.view];
    }
    else if (self.Phone_TextField.text.isPhone == NO && self.Source == 200)
    {
         [[HSQProgressHUDManger Manger] ShowProgressHUDPromptText:@"手机格式不正确" SupView:self.view];
    }
    else if (self.Code_TextField.text.length == 0)
    {
         [[HSQProgressHUDManger Manger] ShowProgressHUDPromptText:@"请输入图形验证码" SupView:self.view];
    }
    else
    {
        [self VerifyTheImageVerificationCode];
    }
}

/**
 * @brief 验证图片验证码
 */
- (void)VerifyTheImageVerificationCode{
    
    NSString *phone = (self.MobileString.length == 0 ? self.Phone_TextField.text : self.MobileString);
    
    [[HSQProgressHUDManger Manger] ShowLoadingDataFromeServer:@"" ToView:self.view IsClearColor:YES];

    NSDictionary *diction = @{@"mobile":phone,@"captchaVal":self.Code_TextField.text,@"sendType":self.sendType,@"captchaKey":self.captchaKey};
    
    AFNetworkRequestTool *RequestTool = [AFNetworkRequestTool shareRequestTool];

    [RequestTool.manger GET:UrlAdress(KValidationBtnCodeImageUrl) parameters:diction progress:^(NSProgress * _Nonnull uploadProgress) {

    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

        [[HSQProgressHUDManger Manger] DismissProgressHUD];

        HSQLog(@"===%@",responseObject);
        if ([responseObject[@"code"] integerValue] == 200)
        {
            HSQNextBandPhoneViewController *NextBandPhoneVC = [[HSQNextBandPhoneViewController alloc] init];
            
            NextBandPhoneVC.NavtionTitle =  (self.Source == 500 ? @"提交验证码":self.navigationItem.title);
            
            NextBandPhoneVC.authCodeValidTime = [NSString stringWithFormat:@"%@",responseObject[@"datas"][@"authCodeValidTime"]];
            
            NextBandPhoneVC.authCodeResendTime = [NSString stringWithFormat:@"%@",responseObject[@"datas"][@"authCodeResendTime"]];
            
            NextBandPhoneVC.UserMobile = phone;
            
            NextBandPhoneVC.Source = self.Source;
            
            NextBandPhoneVC.sendType = self.sendType;
            
            [self.navigationController pushViewController:NextBandPhoneVC animated:YES];
        }
        else
        {
            NSString *message = [NSString stringWithFormat:@"%@",responseObject[@"datas"][@"error"]];

            [[HSQProgressHUDManger Manger] ShowDisplayFailedToLoadData:message SuperView:self.view];
            
            [self RegisterCodeButtonImageFromeServer];
        }

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {

        [[HSQProgressHUDManger Manger] ShowDisplayFailedToLoadData:KErrorPlacherString SuperView:self.view];
    }];
}


/**
 * @brief UITextFieldDelegate
 */
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    
    return YES;
}


@end
