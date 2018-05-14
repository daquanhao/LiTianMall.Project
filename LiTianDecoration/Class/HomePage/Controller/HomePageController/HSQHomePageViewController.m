//
//  HSQHomePageViewController.m
//  LiTianDecoration
//
//  Created by administrator on 2018/4/9.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import "HSQHomePageViewController.h"
#import "MallHomeViewController.h"
#import "HSQMallHomePageController.h"

@interface HSQHomePageViewController ()


@end

@implementation HSQHomePageViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.view.backgroundColor = KViewBackGroupColor;

    self.navigationItem.title = @"首页";
    
    [self AddBtn];
}

- (void)AddBtn{
    
    UIButton *CenterBtn = [UIButton buttonWithType:(UIButtonTypeSystem)];
    [CenterBtn setTitle:@"进入商城" forState:(UIControlStateNormal)];
    CenterBtn.backgroundColor = [UIColor orangeColor];
    CenterBtn.frame = CGRectMake(self.view.centerX - 100, self.view.centerY-50, 200, 100);
    [CenterBtn addTarget:self action:@selector(centerBtnClickAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:CenterBtn];
}

- (void)centerBtnClickAction:(UIButton *)sender{
    
    HSQMallHomePageController *mallHomeVC = [[HSQMallHomePageController alloc] init];
    
    [self.navigationController pushViewController:mallHomeVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    

}












@end
