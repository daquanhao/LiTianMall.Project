//
//  HSQChangePassWordViewController.m
//  LiTianDecoration
//
//  Created by administrator on 2018/4/27.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import "HSQChangePassWordViewController.h"

@interface HSQChangePassWordViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *PassWord_TextField;

@property (weak, nonatomic) IBOutlet UITextField *AgrenPassWord_TextField;

@end

@implementation HSQChangePassWordViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.navigationItem.title = self.Navtion_Title;
    
    self.view.backgroundColor = KViewBackGroupColor;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 * @brief 提交按钮的点击事件
 */
- (IBAction)TheClickEventForTheSubmitButton:(UIButton *)sender {
    
    
}









/**
 * @brief UITextFieldDelegate
 */
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if (textField == self.PassWord_TextField)
    {
        [self.AgrenPassWord_TextField becomeFirstResponder];
    }
    else if (textField == self.AgrenPassWord_TextField)
    {
        [self.AgrenPassWord_TextField resignFirstResponder];
    }
    
    return YES;
}



@end
