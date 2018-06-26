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

@property (nonatomic, copy) NSString *mobileIsBind;  // 手机号是否绑定 0未绑定 1已绑定

@property (nonatomic, copy) NSString *emailIsBind;  // 邮箱是否绑定 0未绑定 1已绑定

@property (nonatomic, copy) NSString *payPwdIsExist;  // 是否已设置支付密码 0未设置 1已设置

@property (weak, nonatomic) IBOutlet UIView *BgView;

@property (nonatomic, strong) NSDictionary *datas;

@property (weak, nonatomic) IBOutlet UILabel *PhoneState_Label;

@end

@implementation HSQSetingViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.navigationItem.title = @"设置";
    
    self.view.backgroundColor = KViewBackGroupColor;
    
    self.datas = [NSDictionary dictionary];
  
    // 请求用户中心的数据
    [self requestUserCenterDataFromeserver];
}

/**
 * @brief 请求用户中心的数据
 */
- (void)requestUserCenterDataFromeserver{
    
    HSQAccount *account = [HSQAccountTool account];
    
    if (account.token.length == 0) return;
    
    [[HSQProgressHUDManger Manger] ShowLoadingDataFromeServer:@"" ToView:self.view IsClearColor:YES];
    
    NSDictionary *diction = @{@"token":account.token};
    
    AFNetworkRequestTool *RequestTool = [AFNetworkRequestTool shareRequestTool];
    
    [RequestTool.manger POST:UrlAdress(KUserCenterDataUrl) parameters:diction progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *responseObject) {
        
        HSQLog(@"=用户中心的数据==%@",responseObject);
        
        [[HSQProgressHUDManger Manger] DismissProgressHUD];
        
        self.BgView.hidden = YES;
        
        self.datas = responseObject[@"datas"];
        
        if ([responseObject[@"code"] integerValue] == 200)
        {
            // 手机是否绑定 1-已绑定，0-未绑定
            self.mobileIsBind = [NSString stringWithFormat:@"%@",responseObject[@"datas"][@"memberInfo"][@"mobileIsBind"]];
            
            if (self.mobileIsBind.integerValue == 0)
            {
                self.MobilePlacherLabel.text = @"未绑定";
            }
            else
            {
                NSString *Mobile = [NSString stringWithFormat:@"%@",responseObject[@"datas"][@"memberInfo"][@"mobile"]];
                NSString *phoneString = [Mobile stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
                self.MobilePlacherLabel.text = phoneString;
            }
            
            // 邮箱是否绑定 1-已绑定，0-未绑定
            self.emailIsBind = [NSString stringWithFormat:@"%@",responseObject[@"datas"][@"memberInfo"][@"emailIsBind"]];
            
            // 支付密码是否绑定 1-已绑定，0-未绑定
            self.payPwdIsExist = [NSString stringWithFormat:@"%@",responseObject[@"datas"][@"memberInfo"][@"payPwdIsExist"]];
            
            self.MobilePayLabel.text = (self.payPwdIsExist.integerValue == 0 ? @"未设置":@"");
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [[HSQProgressHUDManger Manger] ShowDisplayFailedToLoadData:KErrorPlacherString SuperView:self.view];
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
    
    if (self.mobileIsBind.integerValue == 0) // 未绑定手机，提示绑定手机
    {
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"设置支付密码需先绑定手机立即绑定手机吗？" message:nil preferredStyle:(UIAlertControllerStyleAlert)];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:nil];
        
        UIAlertAction *DeafulAction = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            
            HSQBandMobileViewController *BandMobileVC = [[HSQBandMobileViewController alloc] init];
            
            BandMobileVC.NavtionTitle = @"绑定手机";
            
            BandMobileVC.sendType = @"4";
            
            BandMobileVC.Source = 100;
            
            [self.navigationController pushViewController:BandMobileVC animated:YES];
        }];
        
        [alertVC addAction:cancelAction];
        
        [alertVC addAction:DeafulAction];
        
        [self presentViewController:alertVC animated:YES completion:nil];
    }
    else
    {
        HSQBandMobileViewController *BandMobileVC = [[HSQBandMobileViewController alloc] init];
        
        BandMobileVC.NavtionTitle = @"手机安全验证";
        
        BandMobileVC.sendType = @"5";
        
        BandMobileVC.Source = 100;
        
        BandMobileVC.MobileString = [NSString stringWithFormat:@"%@",self.datas[@"memberInfo"][@"mobile"]];
        
        [self.navigationController pushViewController:BandMobileVC animated:YES];
    }
}

/**
 * @brief 手机验证
 */
- (IBAction)PhoneVerificationButtonClickAction:(UIButton *)sender {
    
    HSQBandMobileViewController *BandMobileVC = [[HSQBandMobileViewController alloc] init];
    
    if (self.mobileIsBind.integerValue == 0) // 未绑定手机
    {
        BandMobileVC.NavtionTitle = @"绑定手机";
        
        BandMobileVC.sendType = @"4";
        
        BandMobileVC.Source = 200;
        
        BandMobileVC.MobileString = @"";
    }
    else  // 已绑定手机
    {
        BandMobileVC.NavtionTitle = @"手机安全验证";
        
        BandMobileVC.sendType = @"5";
        
        BandMobileVC.Source = 400;
        
        BandMobileVC.MobileString = [NSString stringWithFormat:@"%@",self.datas[@"memberInfo"][@"mobile"]];
    }
    
    [self.navigationController pushViewController:BandMobileVC animated:YES];
    

}

/**
 * @brief 修改支付密码
 */
- (IBAction)ChangeThePaymentPassword:(UIButton *)sender {
    
    if (self.mobileIsBind.integerValue == 0) // 未绑定手机，提示绑定手机
    {
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"设置支付密码需先绑定手机立即绑定手机吗？" message:nil preferredStyle:(UIAlertControllerStyleAlert)];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:nil];
        
        UIAlertAction *DeafulAction = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            
            HSQBandMobileViewController *BandMobileVC = [[HSQBandMobileViewController alloc] init];
            
            BandMobileVC.NavtionTitle = @"绑定手机";
            
            BandMobileVC.sendType = @"4";
            
            BandMobileVC.Source = 300;
            
            [self.navigationController pushViewController:BandMobileVC animated:YES];
        }];
        
        [alertVC addAction:cancelAction];
        
        [alertVC addAction:DeafulAction];
        
        [self presentViewController:alertVC animated:YES completion:nil];
    }
    else
    {
        HSQBandMobileViewController *BandMobileVC = [[HSQBandMobileViewController alloc] init];
        
        BandMobileVC.NavtionTitle = @"设置支付密码";
        
        BandMobileVC.sendType = @"5";
        
        BandMobileVC.Source = 300;
        
        BandMobileVC.MobileString = [NSString stringWithFormat:@"%@",self.datas[@"memberInfo"][@"mobile"]];
        
        [self.navigationController pushViewController:BandMobileVC animated:YES];
    }
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
        
        [[HSQProgressHUDManger Manger] ShowDisplayFailedToLoadData:@"网络出问题啦！" SuperView:self.view];
    }];
}














///**
// * @brief 清除图片缓存
// */
//- (IBAction)ClearPictureMemoryClickAction:(UIButton *)sender {
//
//    [[HSQProgressHUDManger Manger] ShowLoadingDataFromeServer:@"" ToView:self.view IsClearColor:NO];
//
//    //异步清除图片缓存 （磁盘中的）
//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//
//        [[SDImageCache sharedImageCache] clearDiskOnCompletion:^{
//
//            [[HSQProgressHUDManger Manger] DismissProgressHUD];
//
//            [[HSQProgressHUDManger Manger] ShowProgressHUDPromptText:@"图片缓存已被清除" SupView:self.view];
//        }];
//
//    });
//}



@end
