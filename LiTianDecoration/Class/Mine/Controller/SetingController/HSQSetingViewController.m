//
//  HSQSetingViewController.m
//  LiTianDecoration
//
//  Created by administrator on 2018/4/20.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import "HSQSetingViewController.h"
#import "HSQAccountTool.h"
#import "HSQBandMobileViewController.h"
#import "HSQYanZhengMobileViewController.h"

@interface HSQSetingViewController ()

@property (weak, nonatomic) IBOutlet UILabel *MobilePlacherLabel;

@property (weak, nonatomic) IBOutlet UILabel *MobilePayLabel;

@property (nonatomic, copy) NSString *state;


@end

@implementation HSQSetingViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.navigationItem.title = @"设置";
    
    self.view.backgroundColor = KViewBackGroupColor;
    
    // 验证手机是否绑定
    [self VerifyThatThePhoneIsBinding];
    
}

/**
 * @brief 验证手机是否绑定
 */
- (void)VerifyThatThePhoneIsBinding{
    
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
            self.state = [NSString stringWithFormat:@"%@",responseObject[@"datas"][@"state"]];
        }
        else
        {
            NSString *message = [NSString stringWithFormat:@"%@",responseObject[@"datas"][@"error"]];
            
            [[HSQProgressHUDManger Manger] ShowDisplayFailedToLoadData:message SuperView:self.view];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [[HSQProgressHUDManger Manger] ShowDisplayFailedToLoadData:@"状态查看失败" SuperView:self.view];
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 * @brief 修改登录密码
 */
- (IBAction)ChangeLoginPassWordClickAction:(UIButton *)sender {
    
    if (self.state.integerValue == 0) // 未绑定手机
    {
        HSQBandMobileViewController *BandMobileVC = [[HSQBandMobileViewController alloc] init];
        
        BandMobileVC.NavtionTitle = @"绑定手机";
        
        BandMobileVC.sendType = @"4";
        
        [self.navigationController pushViewController:BandMobileVC animated:YES];
    }
    else  // 已绑定手机
    {
        HSQYanZhengMobileViewController *YanZhengVC = [[HSQYanZhengMobileViewController alloc] init];
        
        YanZhengVC.Navtion_Title = @"手机安全验证";
        
        [self.navigationController pushViewController:YanZhengVC animated:YES];
    }
}

/**
 * @brief 手机验证
 */
- (IBAction)PhoneVerificationButtonClickAction:(UIButton *)sender {
    
    if (self.state.integerValue == 0) // 未绑定手机
    {
        HSQBandMobileViewController *BandMobileVC = [[HSQBandMobileViewController alloc] init];
        
        BandMobileVC.NavtionTitle = @"绑定手机";
        
        BandMobileVC.sendType = @"4";
        
        [self.navigationController pushViewController:BandMobileVC animated:YES];
    }
    else  // 已绑定手机
    {
        HSQYanZhengMobileViewController *YanZhengVC = [[HSQYanZhengMobileViewController alloc] init];
        
        YanZhengVC.Navtion_Title = @"手机安全验证";
        
        [self.navigationController pushViewController:YanZhengVC animated:YES];
    }
}

/**
 * @brief 修改支付密码
 */
- (IBAction)ChangeThePaymentPassword:(UIButton *)sender {
    
    
}

/**
 * @brief 清除图片缓存
 */
- (IBAction)ClearPictureMemoryClickAction:(UIButton *)sender {
    
    [[HSQProgressHUDManger Manger] ShowLoadingDataFromeServer:@"" ToView:self.view IsClearColor:NO];
    
    //异步清除图片缓存 （磁盘中的）
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        [[SDImageCache sharedImageCache] clearDiskOnCompletion:^{
            
            [[HSQProgressHUDManger Manger] DismissProgressHUD];

            [[HSQProgressHUDManger Manger] ShowProgressHUDPromptText:@"图片缓存已被清除" SupView:self.view];
        }];
        
    });
}

/**
 * @brief 退出登录的点击
 */
- (IBAction)ExitLoginClickAction:(UIButton *)sender {
    
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"您确定要退出吗?" message:nil preferredStyle:(UIAlertControllerStyleAlert)];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:nil];
    
    UIAlertAction *DeafulAction = [UIAlertAction actionWithTitle:@"退出" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        
        [self NotifiesTheServerThatIwantToLogOut];
    }];
    
    [alertVC addAction:cancelAction];
    [alertVC addAction:DeafulAction];
    
    [self presentViewController:alertVC animated:YES completion:nil];
}

/**
 * @brief 通知服务器,我要退出登录
 */
- (void)NotifiesTheServerThatIwantToLogOut{
    
    HSQAccount *account = [HSQAccountTool account];
    
    [[HSQProgressHUDManger Manger] ShowLoadingDataFromeServer:nil ToView:self.view IsClearColor:NO];
    
    NSDictionary *diction = @{@"token":account.token};
    
    AFNetworkRequestTool *RequestTool = [AFNetworkRequestTool shareRequestTool];
    
    [RequestTool.manger POST:UrlAdress(KLoginOutUrl) parameters:diction progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        HSQLog(@"=退出登录的数据==%@",responseObject);
        
        [[HSQProgressHUDManger Manger] DismissProgressHUD];
        
        if ([responseObject[@"code"] integerValue] == 200)
        {
           // 1.发送退出登录的消息
            [[NSNotificationCenter defaultCenter] postNotificationName:@"UserLoginOutSuccessful" object:self];
            
            // 2.清除本地参数的储存
            [HSQAccountTool DeleteAccount:account];
            
            // 3.返回上层界面
            [self.navigationController popViewControllerAnimated:YES];
        }
        else
        {
            NSString *errorString = [NSString stringWithFormat:@"%@",responseObject[@"datas"][@"error"]];
            
            [[HSQProgressHUDManger Manger] ShowDisplayFailedToLoadData:errorString SuperView:self.view];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        HSQLog(@"==%@",error.description);
        
        [[HSQProgressHUDManger Manger] ShowDisplayFailedToLoadData:@"退出登录失败" SuperView:self.view];
    }];
}


















@end
