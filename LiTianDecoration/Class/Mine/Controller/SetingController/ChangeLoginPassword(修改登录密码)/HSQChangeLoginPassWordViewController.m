//
//  HSQChangeLoginPassWordViewController.m
//  LiTianDecoration
//
//  Created by administrator on 2018/6/13.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import "HSQChangeLoginPassWordViewController.h"
#import "HSQSetingViewController.h"
#import "HSQAccountTool.h"

@interface HSQChangeLoginPassWordViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *PassWord_TextField;

@property (weak, nonatomic) IBOutlet UITextField *QRPassWord_TextField;

@property (weak, nonatomic) IBOutlet UILabel *TopPlacher_Label;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *TopMargin;

@end

@implementation HSQChangeLoginPassWordViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.view.backgroundColor = KViewBackGroupColor;
    
    self.navigationItem.title = self.Navtion_title;
    
    if (self.source == 100) // 修改登录密码
    {
        self.TopPlacher_Label.hidden = YES;
        
        self.TopMargin.constant = 0;
    }
    else
    {
        self.TopPlacher_Label.hidden = NO;
        
        self.TopMargin.constant = 40;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 * @brief 确认提交
 */
- (IBAction)ConfirmToSubmitButtonClickAction:(UIButton *)sender {
    
    if (self.PassWord_TextField.text.length == 0)
    {
        [[HSQProgressHUDManger Manger] ShowProgressHUDPromptText:@"请输入密码" SupView:self.view];
    }
    else if (self.QRPassWord_TextField.text.length == 0)
    {
        [[HSQProgressHUDManger Manger] ShowProgressHUDPromptText:@"请再次输入密码" SupView:self.view];
    }
    else if (![self.PassWord_TextField.text isEqualToString:self.QRPassWord_TextField.text])
    {
        [[HSQProgressHUDManger Manger] ShowProgressHUDPromptText:@"两次输入的密码不一致" SupView:self.view];
    }
    else
    {
        if (self.source == 100) // 修改登录密码
        {
            [self ChangeLoginPassWordToServer];
        }
        else if (self.source == 200) // 设置支付密码
        {
            [self SetPaymentPassword];
        }
    }
}

/**
 * @brief 修改登录密码
 */
- (void)ChangeLoginPassWordToServer{
    
    [[HSQProgressHUDManger Manger] ShowLoadingDataFromeServer:@"" ToView:self.view IsClearColor:YES];
    
    NSDictionary *diction = @{@"token":[HSQAccountTool account].token,@"memberPwd":self.PassWord_TextField.text,@"memberPwdRepeat":self.QRPassWord_TextField.text,@"smsAuthCode":self.smsAuthCode};
    
    AFNetworkRequestTool *RequestTool = [AFNetworkRequestTool shareRequestTool];
    
    [RequestTool.manger POST:UrlAdress(KChangeLoginPassWordUrl) parameters:diction progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [[HSQProgressHUDManger Manger] DismissProgressHUD];
        
        HSQLog(@"==修改登录密码=%@",responseObject);
        
        if ([responseObject[@"code"] integerValue] == 200)
        {
            [[HSQProgressHUDManger Manger] ShowProgressHUDPromptText:@"密码修改成功" SupView:self.view];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                for (UIViewController *VC in self.navigationController.viewControllers) {
                    
                    if ([VC isKindOfClass:[HSQSetingViewController class]]) {
                        
                        [self.navigationController popToViewController:VC animated:YES];
                    }
                }
            });
        }
        else
        {
            NSString *message = [NSString stringWithFormat:@"%@",responseObject[@"datas"][@"error"]];
            
            [[HSQProgressHUDManger Manger] ShowDisplayFailedToLoadData:message SuperView:self.view];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [[HSQProgressHUDManger Manger] ShowDisplayFailedToLoadData:KErrorPlacherString SuperView:self.view];
        
    }];
}

/**
 * @brief 设置支付密码
 */
- (void)SetPaymentPassword{
    
    [[HSQProgressHUDManger Manger] ShowLoadingDataFromeServer:@"" ToView:self.view IsClearColor:YES];
    
    NSDictionary *diction = @{@"token":[HSQAccountTool account].token,@"payPwd":self.PassWord_TextField.text,@"payPwdRepeat":self.QRPassWord_TextField.text,@"smsAuthCode":self.smsAuthCode};
    
    HSQLog(@"=====支付密码参数%@",diction);
    
    AFNetworkRequestTool *RequestTool = [AFNetworkRequestTool shareRequestTool];
    
    [RequestTool.manger POST:UrlAdress(KChangePaymentPasswordsUrl) parameters:diction progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [[HSQProgressHUDManger Manger] DismissProgressHUD];
        
        HSQLog(@"==设置支付密码=%@",responseObject);
        
        if ([responseObject[@"code"] integerValue] == 200)
        {
            [[HSQProgressHUDManger Manger] ShowProgressHUDPromptText:@"支付密码设置成功" SupView:self.view];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                for (UIViewController *VC in self.navigationController.viewControllers) {
                    
                    if ([VC isKindOfClass:[HSQSetingViewController class]]) {
                        
                        [self.navigationController popToViewController:VC animated:YES];
                    }
                }
            });
        }
        else
        {
            NSString *message = [NSString stringWithFormat:@"%@",responseObject[@"datas"][@"error"]];
            
            [[HSQProgressHUDManger Manger] ShowDisplayFailedToLoadData:message SuperView:self.view];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [[HSQProgressHUDManger Manger] ShowDisplayFailedToLoadData:KErrorPlacherString SuperView:self.view];
        
    }];
}







/**
 * @brief 键盘return键的点击
 */
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if (textField == self.PassWord_TextField)
    {
        [self.QRPassWord_TextField becomeFirstResponder];
    }
    else if (textField == self.QRPassWord_TextField)
    {
         [self.QRPassWord_TextField resignFirstResponder];
    }
    
    return YES;
}




@end
