//
//  HSQHomePageViewController.m
//  LiTianDecoration
//
//  Created by administrator on 2018/4/9.
//  Copyright © 2018年 administrator. All rights reserved.
//

#define KNumber 6 // 一页显示多少个商品

#define KRows 3  // 一行显示几列

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
    
//    NSInteger total = 21;
//    
//     NSInteger PageCount = (total + KNumber - 1) / KNumber;
//    
//    HSQLog(@"====页数==%ld",(long)PageCount);
//    
//    
//    for (NSInteger i = 0; i < total; i ++) {
//        
//         CGFloat GoodsY =  ((i - (i / 6) * 6) / KRows)  * 300;
//        
//        HSQLog(@"====%ld====%ld==%ld",(long)i,(long)(i / KRows),(long)GoodsY);
//    }
    
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
    
    mallHomeVC.Index_Number = @"100";
    
    [self.navigationController pushViewController:mallHomeVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    

}












@end
