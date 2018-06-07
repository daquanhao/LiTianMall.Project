//
//  HSQPayMonerySuccessViewController.m
//  LiTianDecoration
//
//  Created by administrator on 2018/6/6.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import "HSQPayMonerySuccessViewController.h"
#import "HSQAccountTool.h"
#import "HSQMallHomePageController.h"

@interface HSQPayMonerySuccessViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *Placher_ImageView; // 支付是否成功的提示图

@property (weak, nonatomic) IBOutlet UILabel *Placher_Label; // 支付是否成功的提示语

@property (weak, nonatomic) IBOutlet UILabel *PayMonery_Label; // 支付的钱数

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *TopMargin;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *View_Height;

@end

@implementation HSQPayMonerySuccessViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.view.backgroundColor = KViewBackGroupColor;
    
    self.navigationItem.title = @"操作提示";
    
    if (self.Code.length != 0) // 说明支付失败啦
    {
        // 支付成功的提示图片
        self.Placher_ImageView.image = KImageName(@"3-1P106112Q1-51");
        
        //支付是否成功的提示语
        self.Placher_Label.text = @"订单支付失败";
        
        // 支付金额
        self.PayMonery_Label.text = @"";
    }
    else
    {
        [self RequestPaymentSuccessInterfaceDataWithPayId:self.payId];
    }
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:(UIBarButtonItemStylePlain) target:self action:@selector(leftBarButtonItemClick:)];
}

- (void)leftBarButtonItemClick:(UIBarButtonItem *)sender{
    
    
}

/**
 * @brief 请求支付成功界面的数据
 */
- (void)RequestPaymentSuccessInterfaceDataWithPayId:(NSString *)payid{
    
    [[HSQProgressHUDManger Manger] ShowLoadingDataFromeServer:@"" ToView:self.view IsClearColor:YES];
    
    NSDictionary *params = @{@"token":[HSQAccountTool account].token,@"payId":payid};
    
    AFNetworkRequestTool *requestTool = [AFNetworkRequestTool shareRequestTool];
    
    [requestTool.manger POST:UrlAdress(KBuyGoodsSuccessfulDataUrl) parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [[HSQProgressHUDManger Manger] DismissProgressHUD];
        
        HSQLog(@"==支付成功==%@",responseObject);
        
        if ([responseObject[@"code"] integerValue] == 200)
        {
            // 支付成功的提示图片
            self.Placher_ImageView.image = KImageName(@"123");
            
            //支付是否成功的提示语
            self.Placher_Label.text = @"订单支付成功";
            
            // 支付金额
            NSString *monery = [NSString stringWithFormat:@"%@",responseObject[@"datas"][@"ordersOnlinePayAmount"]];
            self.PayMonery_Label.text = [NSString stringWithFormat:@"¥%.2f",monery.floatValue];
        }
        else
        {
            // 支付成功的提示图片
            self.Placher_ImageView.image = KImageName(@"3-1P106112Q1-51");
            
            //支付是否成功的提示语
            self.Placher_Label.text = @"订单支付失败";
            
            // 支付金额
            self.PayMonery_Label.text = @"";
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [[HSQProgressHUDManger Manger] ShowDisplayFailedToLoadData:@"网络出问题啦！" SuperView:self.view];
        
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 * @brief 继续逛逛的按钮点击事件
 */
- (IBAction)ClickTheButtonClickEventToContinueBrowsing:(UIButton *)sender {
    
    HSQMallHomePageController *mallHomeVC = [[HSQMallHomePageController alloc] init];
    
    mallHomeVC.Index_Number = @"200";
    
    [self.navigationController pushViewController:mallHomeVC animated:YES];
}

/**
 * @brief 查看订单的按钮点击事件
 */
- (IBAction)ViewTheOrderButtonClickEvent:(UIButton *)sender {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"LookUpOrderNotif" object:self];
    
    [self.navigationController popViewControllerAnimated:YES];
    
    
}













@end
