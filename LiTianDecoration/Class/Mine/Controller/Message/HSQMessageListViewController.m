//
//  HSQMessageListViewController.m
//  LiTianDecoration
//
//  Created by administrator on 2018/4/27.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import "HSQMessageListViewController.h"
#import "HSQMessageSetViewController.h"

@interface HSQMessageListViewController ()

@end

@implementation HSQMessageListViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.navigationItem.title = @"消息列表";
    
    self.view.backgroundColor = KViewBackGroupColor;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:KImageName(@"123") style:(UIBarButtonItemStylePlain) target:self action:@selector(RightItemClickAction:)];

}

/**
 * @brief 设置消息
 */
- (void)RightItemClickAction:(UIBarButtonItem *)sender{
    
    HSQMessageSetViewController *MessageSetVC = [[HSQMessageSetViewController alloc] init];
    
    [self.navigationController pushViewController:MessageSetVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


















@end
