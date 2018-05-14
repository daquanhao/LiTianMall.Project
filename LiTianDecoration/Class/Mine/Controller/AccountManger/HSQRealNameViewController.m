
//
//  HSQRealNameViewController.m
//  LiTianDecoration
//
//  Created by administrator on 2018/4/18.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import "HSQRealNameViewController.h"
#import "HSQAccountTool.h"

@interface HSQRealNameViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *UserName_TextField;

@property (weak, nonatomic) IBOutlet UIButton *FinshButton;
@end

@implementation HSQRealNameViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.view.backgroundColor = KViewBackGroupColor;
    
    self.navigationItem.title = @"修改真实姓名";
    
    self.UserName_TextField.text = self.RealName_String.length == 0 ? nil : self.RealName_String;
    
    self.FinshButton.enabled = self.UserName_TextField.text.length == 0 ? NO : YES;
    
    // 监听输入框文字的改变
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(TextChange) name:UITextFieldTextDidChangeNotification object:self.UserName_TextField];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    
    return YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self.UserName_TextField resignFirstResponder];
}

- (void)TextChange{
    
     self.FinshButton.enabled = self.UserName_TextField.text.length == 0 ? NO : YES;
}

/**
 * @breif 确定按钮的点击事件
 */
- (IBAction)FinshButtonClickAction:(UIButton *)sender {
    
    if (self.UserName_TextField.text.length == 0)
    {
        [[HSQProgressHUDManger Manger] ShowProgressHUDPromptText:@"请输入您的真实的姓名" SupView:self.view];
    }
    else
    {
        [[HSQProgressHUDManger Manger] ShowLoadingDataFromeServer:@"" ToView:self.view IsClearColor:NO];
        
        NSDictionary *diction = @{@"token":[HSQAccountTool account].token,@"trueName":self.UserName_TextField.text};
        
        AFNetworkRequestTool *RequestTool = [AFNetworkRequestTool shareRequestTool];
        
        [RequestTool.manger POST:UrlAdress(KChangeTrueNameUrl) parameters:diction progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            [[HSQProgressHUDManger Manger] DismissProgressHUD];
            
            HSQLog(@"=只是姓名==%@",responseObject);
            
            if ([responseObject[@"code"] integerValue] == 200)
            {
                    if (self.RealNameBlock)
                    {
                        self.RealNameBlock(self.UserName_TextField.text);
                    }
            
                    [self.navigationController popViewControllerAnimated:YES];
            }
            else
            {
                NSString *errorString = [NSString stringWithFormat:@"%@",responseObject[@"datas"][@"error"]];
                
                [[HSQProgressHUDManger Manger] ShowDisplayFailedToLoadData:errorString SuperView:self.view];
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            HSQLog(@"%@",error.description);
            
            [[HSQProgressHUDManger Manger] ShowDisplayFailedToLoadData:@"数据修改失败" SuperView:self.view];
            
        }];
    }
}

-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
















@end
