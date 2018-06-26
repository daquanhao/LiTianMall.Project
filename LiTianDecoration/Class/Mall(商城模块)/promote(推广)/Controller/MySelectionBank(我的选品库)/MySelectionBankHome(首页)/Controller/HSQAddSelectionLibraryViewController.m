//
//  HSQAddSelectionLibraryViewController.m
//  LiTianDecoration
//
//  Created by administrator on 2018/6/14.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import "HSQAddSelectionLibraryViewController.h"
#import "HSQAccountTool.h"

@interface HSQAddSelectionLibraryViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *Name_TextField;


@end

@implementation HSQAddSelectionLibraryViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.view.backgroundColor = KViewBackGroupColor;
    
    self.navigationItem.title = @"新增选品库分组";
    
    if (self.distributorFavoritesName.length != 0)
    {
        self.Name_TextField.text = self.distributorFavoritesName;
    }
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 * @brief 保存名字
 */
- (IBAction)SaveNameBtnClickAction:(UIButton *)sender {
    
    if (self.Name_TextField.text.length == 0)
    {
        [[HSQProgressHUDManger Manger] ShowProgressHUDPromptText:@"请输入您的分组名称" SupView:self.view];
    }
    else
    {
        if (self.source == 100)
        {
            [self AddANewRepositoryName];
        }
        else if (self.source == 200)
        {
            [self ModifyTheLibraryName];
        }
    }
}

/**
 * @brief 添加新的选品库名字
 */
- (void)AddANewRepositoryName{
    
    [[HSQProgressHUDManger Manger] ShowLoadingDataFromeServer:@"" ToView:self.view IsClearColor:YES];
    
    NSDictionary *params = @{@"token":[HSQAccountTool account].token,@"distributorFavoritesName":self.Name_TextField.text};
    
    AFNetworkRequestTool *requestTool = [AFNetworkRequestTool shareRequestTool];
    
    [requestTool.manger POST:UrlAdress(KaddNewSelectLibraryUrl) parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [[HSQProgressHUDManger Manger] DismissProgressHUD];
        
        HSQLog(@"===保存名字==%@",responseObject);
        
        if ([responseObject[@"code"] integerValue] == 200)
        {
            
            if (self.TheCallbackNameBlock)
            {
                self.TheCallbackNameBlock(@"200");
            }
            
            [self.navigationController popViewControllerAnimated:YES];
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

/**
 * @brief 编辑选品库名字
 */
- (void)ModifyTheLibraryName{
    
    [[HSQProgressHUDManger Manger] ShowLoadingDataFromeServer:@"" ToView:self.view IsClearColor:YES];
    
    NSDictionary *params = @{@"token":[HSQAccountTool account].token,@"distributorFavoritesName":self.Name_TextField.text,@"distributorFavoritesId":self.distributorFavoritesId};
    
    AFNetworkRequestTool *requestTool = [AFNetworkRequestTool shareRequestTool];
    
    [requestTool.manger POST:UrlAdress(KEditSelectLibraryUrl) parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [[HSQProgressHUDManger Manger] DismissProgressHUD];
        
        HSQLog(@"===修改名字==%@",responseObject);
        
        if ([responseObject[@"code"] integerValue] == 200)
        {
            if (self.TheCallbackNameBlock)
            {
                self.TheCallbackNameBlock(self.Name_TextField.text);
            }
            
             [self.navigationController popViewControllerAnimated:YES];
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




- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    
    return YES;
}


@end
