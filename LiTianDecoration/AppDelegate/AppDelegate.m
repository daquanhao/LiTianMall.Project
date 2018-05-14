//
//  AppDelegate.m
//  测试demo
//
//  Created by administrator on 2018/4/6.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import "AppDelegate.h"
#import "HSQHomeTabBarController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // 1.设置窗口的根视图控制器
    [self SetTheRootViewControllerForTheWindow];
    
    [self.window makeKeyAndVisible];
    
    return YES;
}

/**
 * @brief 设置窗口的根视图控制器
 */
- (void)SetTheRootViewControllerForTheWindow{
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    HSQHomeTabBarController *TabBarVC = [[HSQHomeTabBarController alloc] init];
    
    self.window.rootViewController = TabBarVC;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

/**
 * @brief 收到内存警告的时候，清除本地所有的图片
 */
- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application{
    
    SDWebImageManager *mgr = [SDWebImageManager sharedManager];
    
    // 1.取消下载
    [mgr cancelAll];
    
    // 2.清除内存中的所有图片
    [mgr.imageCache clearMemory];
}


@end
