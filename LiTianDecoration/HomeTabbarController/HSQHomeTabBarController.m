//
//  HSQHomeTabBarController.m
//  LiTianDecoration
//
//  Created by administrator on 2018/4/9.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import "HSQHomeTabBarController.h"
#import "HSQHomePageViewController.h" // 首页
#import "HSQClassViewController.h"   // 分类
#import "DiscoverViewController.h"    // 发现
#import "HSQMineViewController.h"  // 我的

@interface HSQHomeTabBarController ()

@end

@implementation HSQHomeTabBarController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    // 1.添加子视图控制器
    [self SetUpChildControllerToTabBarController];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 * @brief 添加子视图控制器
 */
- (void)SetUpChildControllerToTabBarController{
    
    // 1.首页
    HSQHomePageViewController *HomePageVC = [[HSQHomePageViewController alloc] init];
    [self SetupChildVC:HomePageVC Title:@"首页" NormalImage:@"HomePage_Normal" SelectImage:@"HomePage_Select"];
    
    // 2.分类
    HSQClassViewController *ClassVC = [[HSQClassViewController alloc] init];
    [self SetupChildVC:ClassVC Title:@"设计案例" NormalImage:@"HomePage_Normal" SelectImage:@"HomePage_Select"];
    
    // 3.发现
    DiscoverViewController *DiscoverVC = [[DiscoverViewController alloc] init];
    [self SetupChildVC:DiscoverVC Title:@"家具讲堂" NormalImage:@"discover_Normal" SelectImage:@"discover_Select"];
    
    // 4.购物车
    HSQHomePageViewController *ShopCarVC = [[HSQHomePageViewController alloc] init];
    [self SetupChildVC:ShopCarVC Title:@"在施工地" NormalImage:@"HomePage_Normal" SelectImage:@"HomePage_Select"];
    
    // 5.我的
    HSQMineViewController *MineVC = [[HSQMineViewController alloc] init];
    [self SetupChildVC:MineVC Title:@"我的" NormalImage:@"HomePage_Normal" SelectImage:@"HomePage_Select"];
}

/**
 * @brief 初始化子视图控制器
 */
- (void)SetupChildVC:(UIViewController *)ChildVC Title:(NSString *)title NormalImage:(NSString *)NormalName SelectImage:(NSString *)SelectName{
    
    //1.设置tabbar的标题
    ChildVC.title = title;

    // 2.设置tabbar的文字及图片
    ChildVC.tabBarItem.image = [[UIImage imageNamed:NormalName] imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)];

    ChildVC.tabBarItem.selectedImage = [[UIImage imageNamed:SelectName] imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)];

    // 3.改变tabbar上选择时，文字的颜色
    [ChildVC.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName : [[UIColor whiteColor] colorWithAlphaComponent:0.5]} forState:(UIControlStateNormal)];

    [ChildVC.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithRed:220/255.0 green:82/255.0 blue:38/255.0 alpha:1.0]} forState:(UIControlStateSelected)];
    
    // 4.设置tabbar的背景图片
    [self.tabBar setBackgroundImage:[UIImage ImageWithColor:[UIColor colorWithRed:33/255.0 green:36/255.0 blue:46/255.0 alpha:1.0]]];
    
    // 5.将视图包装成导航视图
    HSQNavigationController *NavigationVC = [[HSQNavigationController alloc] initWithRootViewController:ChildVC];

    [self addChildViewController:NavigationVC];
    
}










@end
