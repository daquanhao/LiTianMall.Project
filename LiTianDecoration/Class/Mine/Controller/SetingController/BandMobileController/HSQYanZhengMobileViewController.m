//
//  HSQYanZhengMobileViewController.m
//  LiTianDecoration
//
//  Created by administrator on 2018/4/26.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import "HSQYanZhengMobileViewController.h"
#import "HSQNextBandPhoneViewController.h"
#import "HSQAccountTool.h"

@interface HSQYanZhengMobileViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *Phone_TextField;

@property (weak, nonatomic) IBOutlet UITextField *ImageCode_TextField;

@property (weak, nonatomic) IBOutlet UIButton *Code_Button;

@property (nonatomic, copy) NSString *captchaKey;

@end

@implementation HSQYanZhengMobileViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.navigationItem.title = self.Navtion_Title;
    
    self.view.backgroundColor = KViewBackGroupColor;
    
    self.Phone_TextField.text = self.MobileString;
    
    // 请求验证码的图片
    [self RegisterCodeButtonImageFromeServer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 * @brief 请求图片验证码
 */
- (IBAction)RequestTheImageVerificationCodeData:(UIButton *)sender {
    
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
        
        [[HSQProgressHUDManger Manger] ShowDisplayFailedToLoadData:@"数据加载失败" SuperView:self.view];
    }];
}


/**
 * @brief 下一步的点击事件
 */
- (IBAction)NextButtonClickAction:(UIButton *)sender {
    
    if (self.Phone_TextField.text.length == 0)
    {
        [[HSQProgressHUDManger Manger] ShowProgressHUDPromptText:@"请输入您的手机号" SupView:self.view];
    }
    else if (self.Phone_TextField.text.isPhone == NO)
    {
        [[HSQProgressHUDManger Manger] ShowProgressHUDPromptText:@"手机格式不正确" SupView:self.view];
    }
    else if (self.ImageCode_TextField.text.length == 0)
    {
        [[HSQProgressHUDManger Manger] ShowProgressHUDPromptText:@"请输入图形验证码" SupView:self.view];
    }
    else
    {
        [self VerifyThatTheImageVerificationCodeIsCorrectAndSendMessageVerificationCode];
    }
}

/**
 * @brief 验证手机是否绑定过
 */
- (void)VerifyThatThePhoneIsBound{
    
    [[HSQProgressHUDManger Manger] ShowLoadingDataFromeServer:@"" ToView:self.view IsClearColor:YES];
    
    NSDictionary *diction = @{@"token":[HSQAccountTool account].token};
    
    AFNetworkRequestTool *RequestTool = [AFNetworkRequestTool shareRequestTool];
    
    [RequestTool.manger POST:UrlAdress(KLookMobileBandStateUrl) parameters:diction progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [[HSQProgressHUDManger Manger] DismissProgressHUD];
        
        HSQLog(@"==查看手机绑定状态=%@",responseObject);
        if ([responseObject[@"code"] integerValue] == 200)
        {
            // 1-已绑定，0-未绑定
            NSString *state = [NSString stringWithFormat:@"%@",responseObject[@"datas"][@"state"]];
            
            if (state.integerValue == 0)
            {
                [self VerifyThatTheImageVerificationCodeIsCorrectAndSendMessageVerificationCode];
            }
            else
            {
                [[HSQProgressHUDManger Manger] ShowProgressHUDPromptText:@"当前手机号已被绑定，请更换其他手机号" SupView:self.view];
                
                [self RegisterCodeButtonImageFromeServer];
            }
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
 * @brief 验证图片验证码是否正确，并发送短信验证码
 */
- (void)VerifyThatTheImageVerificationCodeIsCorrectAndSendMessageVerificationCode{
    
    [[HSQProgressHUDManger Manger] ShowLoadingDataFromeServer:@"" ToView:self.view IsClearColor:YES];
    
    NSDictionary *diction = @{@"mobile":self.Phone_TextField.text,@"captchaVal":self.ImageCode_TextField.text,@"sendType":self.sendType,@"captchaKey":self.captchaKey};
    
    HSQLog(@"==手机验证码==%@",diction);
    
    AFNetworkRequestTool *RequestTool = [AFNetworkRequestTool shareRequestTool];
    
    [RequestTool.manger GET:UrlAdress(KValidationBtnCodeImageUrl) parameters:diction progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [[HSQProgressHUDManger Manger] DismissProgressHUD];
        
        HSQLog(@"==发送短信验证码=%@",responseObject);
        if ([responseObject[@"code"] integerValue] == 200)
        {
            HSQNextBandPhoneViewController *NextBandPhoneVC = [[HSQNextBandPhoneViewController alloc] init];
            
            NextBandPhoneVC.NavtionTitle = self.navigationItem.title;
            
            NextBandPhoneVC.authCodeValidTime = [NSString stringWithFormat:@"%@",responseObject[@"datas"][@"authCodeValidTime"]];
            
            NextBandPhoneVC.authCodeResendTime = [NSString stringWithFormat:@"%@",responseObject[@"datas"][@"authCodeResendTime"]];
            
            NextBandPhoneVC.UserMobile = self.Phone_TextField.text;
            
            NextBandPhoneVC.Source = 200;
            
            NextBandPhoneVC.sendType = self.sendType;
            
            NextBandPhoneVC.oldSmsAuthCode = self.oldSmsAuthCode;
            
            NextBandPhoneVC.IsPhoneBand = self.IsPhoneBand;
            
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

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if (textField == self.Phone_TextField)
    {
        [self.ImageCode_TextField becomeFirstResponder];
    }
    else if (textField == self.ImageCode_TextField)
    {
        [self.ImageCode_TextField resignFirstResponder];
    }
    
    return YES;
}


@end
