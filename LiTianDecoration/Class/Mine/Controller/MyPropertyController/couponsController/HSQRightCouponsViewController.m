//
//  HSQRightCouponsViewController.m
//  LiTianDecoration
//
//  Created by administrator on 2018/4/29.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import "HSQRightCouponsViewController.h"
#import "HSQAccountTool.h"

@interface HSQRightCouponsViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *Placher_Label;

@property (weak, nonatomic) IBOutlet UILabel *SecondPlacherLabel;

@property (weak, nonatomic) IBOutlet UITextField *Name_TextField;

@property (weak, nonatomic) IBOutlet UITextField *Code_TextField;

@property (weak, nonatomic) IBOutlet UIButton *CodeImage_Button;

@property (nonatomic, copy) NSString *captchaKey;

@property (weak, nonatomic) IBOutlet UILabel *LeftPlacher_Label;

@end

@implementation HSQRightCouponsViewController

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [self LoginCodeButtonImageFromeServer:self.CodeImage_Button];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.view.backgroundColor = KViewBackGroupColor;
    
    // 1.提示标语
    [self setUpPlacherString];
}

/**
 * @brief 提示标语
 */
- (void)setUpPlacherString{
    
    if (self.Source == 100)  // 店铺券
    {
        self.Placher_Label.text = @"请输入卡密领取优惠券";
        
        self.SecondPlacherLabel.text = @"领取优惠券后可以在购买商品下单时抵扣订单金额";
        
        self.Name_TextField.placeholder = @"请输入店铺优惠券卡密号";
        
        self.LeftPlacher_Label.text = @"卡密：";
    }
    else  // 平台券
    {
        self.Placher_Label.text = @"请输入平台红包卡密号码";
        
        self.SecondPlacherLabel.text = @"确认生效后可在购物车使用折扣现金支付";
        
        self.Name_TextField.placeholder = @"请输入平台红包卡密号";
        
        self.LeftPlacher_Label.text = @"红包卡密:";
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 * @brief 重新获取验证码图片的点击事件
 */
- (IBAction)CodeImageBtnClickAction:(UIButton *)sender {
    
    [self LoginCodeButtonImageFromeServer:self.CodeImage_Button];
}

/**
 * @brief 请求验证码的图片
 */
- (void)LoginCodeButtonImageFromeServer:(UIButton *)sender{
    
    AFNetworkRequestTool *RequestTool = [AFNetworkRequestTool shareRequestTool];
    
    [RequestTool.manger GET:UrlAdress(KGetCodeBiaoShiUrl) parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
        self.captchaKey = [NSString stringWithFormat:@"%@",responseObject[@"datas"][@"captchaKey"]];
        
        NSString *url = [NSString stringWithFormat:@"%@?&&captchaKey=%@&&clientType=%@",UrlAdress(KGetCodeImageUrl),self.captchaKey,@"ios"];
        
        [sender sd_setBackgroundImageWithURL:[NSURL URLWithString:url] forState:(UIControlStateNormal)];
        
        [sender sd_setBackgroundImageWithURL:[NSURL URLWithString:url] forState:(UIControlStateHighlighted)];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

/**
 * @brief 确认提交的点击事件
 */
- (IBAction)ConfirmToSubmitButtonClickAction:(UIButton *)sender {
    
    if (self.Name_TextField.text.length == 0)
    {
        [[HSQProgressHUDManger Manger] ShowProgressHUDPromptText:@"请输入卡密码" SupView:self.view];
    }
    else if (self.Code_TextField.text.length == 0)
    {
        [[HSQProgressHUDManger Manger] ShowProgressHUDPromptText:@"请输入验证码" SupView:self.view];
    }
    else
    {
        if (self.Source == 200)
        {
            [self GetRedEnvelopeWithYourCardNumber];
        }
        else if (self.Source == 100)
        {
            [self GetCouponsWithYourCardPassword];
        }
    }
}

/**
 * @brief 通过卡密码领取红包
 */

- (void)GetRedEnvelopeWithYourCardNumber{
    
    [[HSQProgressHUDManger Manger] ShowLoadingDataFromeServer:nil ToView:self.view IsClearColor:NO];
    
    NSDictionary *params = @{@"token":[HSQAccountTool account].token,@"pwdCode":self.Name_TextField.text,@"captchaVal":self.Code_TextField.text,@"captchaKey":self.captchaKey};
    
    AFNetworkRequestTool *RequestTool = [AFNetworkRequestTool shareRequestTool];
    
    [RequestTool.manger POST:UrlAdress(KreceivesredenvelopesPWDUrl) parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *responseObject) {
        
        HSQLog(@"=通过卡密码领取红包==%@",responseObject);
        
        [[HSQProgressHUDManger Manger] DismissProgressHUD];
        
        if ([responseObject[@"code"] integerValue] == 200)
        {
            [[HSQProgressHUDManger Manger] ShowProgressHUDPromptText:@"领取成功！" SupView:self.view];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"RedEnvelopeWasSuccessfullyReceivedNotif" object:self];
        }
        else
        {
            NSString *errorString = [NSString stringWithFormat:@"%@",responseObject[@"datas"][@"error"]];
            
            [[HSQProgressHUDManger Manger] ShowDisplayFailedToLoadData:errorString SuperView:self.view];
        }

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [[HSQProgressHUDManger Manger] ShowDisplayFailedToLoadData:KErrorPlacherString SuperView:self.view];
    }];
    
}

/**
 * @brief 通过卡密码领取优惠券
 */
- (void)GetCouponsWithYourCardPassword{
    
    [[HSQProgressHUDManger Manger] ShowLoadingDataFromeServer:nil ToView:self.view IsClearColor:NO];
    
    NSDictionary *params = @{@"token":[HSQAccountTool account].token,@"pwdCode":self.Name_TextField.text,@"captchaVal":self.Code_TextField.text,@"captchaKey":self.captchaKey};
    
    AFNetworkRequestTool *RequestTool = [AFNetworkRequestTool shareRequestTool];
    
    [RequestTool.manger POST:UrlAdress(KGetVoucherpwdUrl) parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *responseObject) {
        
        HSQLog(@"=通过卡密码领取优惠券==%@",responseObject);
        
        [[HSQProgressHUDManger Manger] DismissProgressHUD];
        
        if ([responseObject[@"code"] integerValue] == 200)
        {
            [[HSQProgressHUDManger Manger] ShowProgressHUDPromptText:@"领取成功！" SupView:self.view];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"VoucherWasSuccessfullyReceivedNotif" object:self];
        }
        else
        {
            NSString *errorString = [NSString stringWithFormat:@"%@",responseObject[@"datas"][@"error"]];
            
            [[HSQProgressHUDManger Manger] ShowDisplayFailedToLoadData:errorString SuperView:self.view];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [[HSQProgressHUDManger Manger] ShowDisplayFailedToLoadData:KErrorPlacherString SuperView:self.view];
    }];
}







- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if (textField == self.Name_TextField)
    {
        [self.Code_TextField becomeFirstResponder];
    }
    else if (textField == self.Code_TextField)
    {
        [self.Code_TextField resignFirstResponder];
    }
    
    return YES;
}

- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}




@end
