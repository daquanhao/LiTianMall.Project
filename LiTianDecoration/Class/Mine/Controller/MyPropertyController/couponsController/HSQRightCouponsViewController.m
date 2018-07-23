//
//  HSQRightCouponsViewController.m
//  LiTianDecoration
//
//  Created by administrator on 2018/4/29.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import "HSQRightCouponsViewController.h"

@interface HSQRightCouponsViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *Placher_Label;

@property (weak, nonatomic) IBOutlet UILabel *SecondPlacherLabel;

@property (weak, nonatomic) IBOutlet UITextField *Name_TextField;

@property (weak, nonatomic) IBOutlet UITextField *Code_TextField;

@property (weak, nonatomic) IBOutlet UIButton *CodeImage_Button;

@property (nonatomic, copy) NSString *captchaKey;


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
    
    if (self.ID_Number.integerValue == 100)  // 店铺券
    {
        self.Placher_Label.text = @"请输入卡密领取优惠券";
        self.SecondPlacherLabel.text = @"领取优惠券后可以在购买商品下单时抵扣订单金额";
        self.Name_TextField.placeholder = @"请输入店铺优惠券卡密号";
    }
    else  // 平台券
    {
        self.Placher_Label.text = @"请输入平台红包卡密号码";
        self.SecondPlacherLabel.text = @"确认生效后可在购物车使用折扣现金支付";
        self.Name_TextField.placeholder = @"请输入平台红包卡密号";
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




@end
