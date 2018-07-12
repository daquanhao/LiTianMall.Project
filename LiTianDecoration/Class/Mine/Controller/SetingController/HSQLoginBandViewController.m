//
//  HSQLoginBandViewController.m
//  LiTianDecoration
//
//  Created by administrator on 2018/4/25.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import "HSQLoginBandViewController.h"
#import "HSQAccountTool.h"

@interface HSQLoginBandViewController ()

@property (weak, nonatomic) IBOutlet UILabel *WeChatBand_Label;

@property (weak, nonatomic) IBOutlet UILabel *QQBand_Label;

@property (weak, nonatomic) IBOutlet UILabel *Placher_Label;

@property (nonatomic, copy) NSString *weixinUserInfo;

@property (nonatomic, copy) NSString *qqUserInfo;

@property (weak, nonatomic) IBOutlet UIImageView *WeiXin_ImageView;

@property (weak, nonatomic) IBOutlet UIImageView *QQ_ImageView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *First_Margin;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *Second_Margin;

@end

@implementation HSQLoginBandViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.view.backgroundColor = KViewBackGroupColor;
    
    self.navigationItem.title = @"登录绑定";
    
    NSMutableParagraphStyle  *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    
    [paragraphStyle  setLineSpacing:8];  // 设置行间距
    
    NSMutableAttributedString  *setString = [[NSMutableAttributedString alloc] initWithString:self.Placher_Label.text];
    
    [setString  addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [self.Placher_Label.text length])];
    
    [self.Placher_Label  setAttributedText:setString];
    
     self.weixinUserInfo = [NSString stringWithFormat:@"%@",self.UserInfo_Diction[@"memberInfo"][@"weixinUserInfo"]];
    
    self.qqUserInfo = [NSString stringWithFormat:@"%@",self.UserInfo_Diction[@"memberInfo"][@"qqUserInfo"]];
    
    if (self.weixinUserInfo.length == 0)
    {
        self.WeChatBand_Label.text = @"未绑定";
        
        self.First_Margin.constant = 10;
        
        self.WeiXin_ImageView.hidden = YES;
    }
    else
    {
        self.WeChatBand_Label.text = @"已绑定，去解绑";
        
        self.First_Margin.constant = 23;
        
        self.WeiXin_ImageView.hidden = NO;
    }
    
    if (self.qqUserInfo.length == 0)
    {
        self.QQBand_Label.text = @"未绑定";
        
        self.Second_Margin.constant = 10;
        
        self.QQ_ImageView.hidden = YES;
    }
    else
    {
        self.QQBand_Label.text = @"已绑定，去解绑";
        
        self.Second_Margin.constant = 23;
        
        self.QQ_ImageView.hidden = NO;
    }
    
    HSQLog(@"===%@===%@===%@",self.weixinUserInfo,self.qqUserInfo,self.UserInfo_Diction);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 * @brief 解绑微信
 */
- (IBAction)UnbindTheWeChatButtonClickEvent:(UIButton *)sender {
    
    if (self.weixinUserInfo.length != 0){
        
        [self NotifServerUnbundling:UrlAdress(KUnbindWeiXin) Message:@"解绑微信后将不可再使用微信进行登录，确认解绑吗？" Source:100];
    }
}

/**
 * @brief 解绑QQ
 */
- (IBAction)UnbindTheQQButtonClickEvent:(UIButton *)sender {
    
    if (self.qqUserInfo.length != 0){
        
        [self NotifServerUnbundling:UrlAdress(KUnbindQQ) Message:@"解绑QQ后将不可再使用QQ进行登录，确认解绑吗？" Source:200];
    }
}

/**
 * @brief 解绑
 */
- (void)NotifServerUnbundling:(NSString *)RequestUrl Message:(NSString *)message Source:(NSInteger)source{
    
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:(UIAlertControllerStyleAlert)];
    
    UIAlertAction *Cancel_action = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:nil];
    
    UIAlertAction *delete_action = [UIAlertAction actionWithTitle:@"确认" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        
        [[HSQProgressHUDManger Manger] ShowLoadingDataFromeServer:nil ToView:self.view IsClearColor:NO];
        
        NSDictionary *diction = @{@"token":[HSQAccountTool account].token};
        
        AFNetworkRequestTool *RequestTool = [AFNetworkRequestTool shareRequestTool];
        
        [RequestTool.manger POST:RequestUrl parameters:diction progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *responseObject) {
            
            HSQLog(@"=解绑的数据==%@",responseObject);
            
            [[HSQProgressHUDManger Manger] DismissProgressHUD];
            
            if ([responseObject[@"code"] integerValue] == 200)
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"UnbindSuccessful" object:self];
                
                [[HSQProgressHUDManger Manger] ShowProgressHUDPromptText:@"解绑成功" SupView:self.view];
                
                if (source == 100)
                {
                    self.weixinUserInfo = @"";
                    
                    self.WeChatBand_Label.text = @"未绑定";
                    
                    self.First_Margin.constant = 10;
                    
                    self.WeiXin_ImageView.hidden = YES;
                }
                else
                {
                    self.qqUserInfo = @"";
                    
                    self.QQBand_Label.text = @"未绑定";
                    
                    self.Second_Margin.constant = 10;
                    
                    self.QQ_ImageView.hidden = YES;
                }
            }
            else
            {
                NSString *errorString = [NSString stringWithFormat:@"%@",responseObject[@"datas"][@"error"]];
                
                [[HSQProgressHUDManger Manger] ShowDisplayFailedToLoadData:errorString SuperView:self.view];
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            [[HSQProgressHUDManger Manger] ShowDisplayFailedToLoadData:KErrorPlacherString SuperView:self.view];
        }];
    }];
    
    [alertVC addAction:delete_action];
    
    [alertVC addAction:Cancel_action];
    
    [self presentViewController:alertVC animated:YES completion:nil];
}

















@end
