//
//  HSQYanZhengMobileViewController.m
//  LiTianDecoration
//
//  Created by administrator on 2018/4/26.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import "HSQYanZhengMobileViewController.h"
#import "HSQNextBandPhoneViewController.h"

@interface HSQYanZhengMobileViewController ()

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
    
    HSQNextBandPhoneViewController *NextBandPhoneVC = [[HSQNextBandPhoneViewController alloc] init];
    
    NextBandPhoneVC.NavtionTitle = @"手机安全验证";
    
    NextBandPhoneVC.authCodeValidTime = @"10";
    
    NextBandPhoneVC.authCodeResendTime = @"60";
    
    NextBandPhoneVC.UserMobile = self.Phone_TextField.text;
    
    [self.navigationController pushViewController:NextBandPhoneVC animated:YES];
}







@end
