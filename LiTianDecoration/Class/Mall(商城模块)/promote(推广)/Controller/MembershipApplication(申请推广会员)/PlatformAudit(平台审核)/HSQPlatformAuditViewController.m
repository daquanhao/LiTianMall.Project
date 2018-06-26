//
//  HSQPlatformAuditViewController.m
//  LiTianDecoration
//
//  Created by administrator on 2018/6/12.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import "HSQPlatformAuditViewController.h"
#import "HSQAccountTool.h"

@interface HSQPlatformAuditViewController ()

@property (weak, nonatomic) IBOutlet UILabel *Placher_Label;

@property (weak, nonatomic) IBOutlet UIButton *SubmitBtn;

@end

@implementation HSQPlatformAuditViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.view.backgroundColor = KViewBackGroupColor;
    
    self.navigationItem.title = @"推广资格申请";
    
    self.Placher_Label.text = self.reason;
    
    self.SubmitBtn.hidden = (self.source == 100 ? YES : NO);
}

- (void)setDistributorJoin:(NSDictionary *)distributorJoin{
    
    _distributorJoin = distributorJoin;
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 * @brief 重新提交
 */
- (IBAction)ToResubmitButtonClickAction:(UIButton *)sender {
    
    [[HSQProgressHUDManger Manger] ShowLoadingDataFromeServer:@"" ToView:self.view IsClearColor:YES];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"token"] = [HSQAccountTool account].token;
    params[@"payPerson"] = self.distributorJoin[@"payPerson"];
    params[@"realName"] = self.distributorJoin[@"realName"];  // 申请时填写的真实姓名
    params[@"idCartNumber"] = self.distributorJoin[@"idCartNumber"];  // 身份证号
    params[@"idCartFrontImage"] = self.distributorJoin[@"idCartFrontImage"];
    params[@"idCartBackImage"] = self.distributorJoin[@"idCartBackImage"];
    params[@"idCartHandImage"] = self.distributorJoin[@"idCartHandImage"];
    params[@"bankAccountNumber"] = self.distributorJoin[@"bankAccountNumber"];
    params[@"bindPhone"] = self.distributorJoin[@"bindPhone"];
    params[@"bankAccountName"] = self.distributorJoin[@"bankAccountName"];
    params [@"accountType"] = self.distributorJoin[@"accountType"];
    
    HSQLog(@"==参数==%@",params);
    
    AFNetworkRequestTool *requestTool = [AFNetworkRequestTool shareRequestTool];
    
    [requestTool.manger POST:UrlAdress(KSaveApplyCertificationInfoUrl) parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [[HSQProgressHUDManger Manger] DismissProgressHUD];
        
        HSQLog(@"=提交的信息==%@",responseObject);
        
        if ([responseObject[@"code"] integerValue] == 200)
        {
            UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"数据审核中，请耐心等待" message:nil preferredStyle:(UIAlertControllerStyleAlert)];
            
            UIAlertAction *action03 = [UIAlertAction actionWithTitle:@"好的" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {
                
                [self.navigationController popViewControllerAnimated:YES];
            }];
            
            [alertVC addAction:action03];
            
            [self presentViewController:alertVC animated:YES completion:nil];
        }
        else
        {
            NSString *errorString = [NSString stringWithFormat:@"%@",responseObject[@"datas"][@"error"]];
            
            [[HSQProgressHUDManger Manger] ShowDisplayFailedToLoadData:errorString SuperView:self.view];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [[HSQProgressHUDManger Manger] ShowProgressHUDPromptText:KErrorPlacherString SupView:self.view];
    }];
}






















@end
