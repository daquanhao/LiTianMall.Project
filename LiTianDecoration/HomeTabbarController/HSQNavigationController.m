//
//  HSQNavigationController.m
//  LiTianDecoration
//
//  Created by administrator on 2018/4/9.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import "HSQNavigationController.h"

@interface HSQNavigationController ()

@end

@implementation HSQNavigationController

+ (void)initialize{
    
    // 设置整个项目所有item的主题样式
    UIBarButtonItem *item = [UIBarButtonItem appearance];
    
    // 设置普通状态
    // key：NS****AttributeName
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = [[UIColor blackColor] colorWithAlphaComponent:0.8];
    textAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:14.0];
    [item setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
    
    // 高亮状态
    NSMutableDictionary *Highlighted_TextAttrs = [NSMutableDictionary dictionary];
    Highlighted_TextAttrs[NSForegroundColorAttributeName] = [[UIColor blackColor] colorWithAlphaComponent:0.8];
    Highlighted_TextAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:14.0];
    [item setTitleTextAttributes:Highlighted_TextAttrs forState:UIControlStateHighlighted];
    
    // 设置不可用状态
    NSMutableDictionary *disableTextAttrs = [NSMutableDictionary dictionary];
    disableTextAttrs[NSForegroundColorAttributeName] = [UIColor grayColor];
    disableTextAttrs[NSFontAttributeName] = textAttrs[NSFontAttributeName];
    [item setTitleTextAttributes:disableTextAttrs forState:UIControlStateDisabled];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    // 1.设置导航栏上文字的颜色
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [[UIColor whiteColor] colorWithAlphaComponent:0.5], NSFontAttributeName : [UIFont systemFontOfSize:KLabelFont(16.0, 14.0)]}];

    // 2.设置导航栏的背景图
    [[UINavigationBar appearance] setBackgroundImage:[UIImage ImageWithColor:[UIColor colorWithRed:33/255.0 green:36/255.0 blue:46/255.0 alpha:1.0]] forBarMetrics:(UIBarMetricsDefault)];

    // 3.去掉底部的黑线
//    [[UINavigationBar appearance] setShadowImage:[UIImage new]];
  
}



/**
 * @brief 重写这个方法的目的: 能够拦截所有push进来的控制器
 * @param viewController 即将push进来的控制器
 */
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    
    if (self.viewControllers.count > 0) // 这时push进来的控制器viewController，不是第一个子控制器（不是根控制器）
    {
        // 1.自动隐藏tabbar
        viewController.hidesBottomBarWhenPushed = YES;
        
        // 2.设置导航栏上的按钮
        UIImage *LeftImage = [UIImage imageNamed:@"LeftBackIcon"];
        
        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:LeftImage style:(UIBarButtonItemStylePlain) target:self action:@selector(BackClick:)];
    }
    
    // 调用父类方法，切记写在 if 判断语句外面
     [super pushViewController:viewController animated:YES];
}

/**
 * @brief左边按钮的点击事件
 */
- (void)BackClick:(UIBarButtonItem *)item{
    
    [self popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
