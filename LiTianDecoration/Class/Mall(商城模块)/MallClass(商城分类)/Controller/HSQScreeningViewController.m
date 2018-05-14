//
//  HSQScreeningViewController.m
//  LiTianDecoration
//
//  Created by administrator on 2018/5/3.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import "HSQScreeningViewController.h"

@interface HSQScreeningViewController ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *BottomLayOut;

@end

@implementation HSQScreeningViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.view.backgroundColor = KViewBackGroupColor;
    
    self.navigationItem.title  = @"商品筛选";
    
    self.BottomLayOut.constant = KSafeBottomHeight;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





















@end
