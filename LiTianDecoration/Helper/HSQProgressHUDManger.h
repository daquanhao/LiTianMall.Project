//
//  HSQProgressHUDManger.h
//  LiTianDecoration
//
//  Created by administrator on 2018/4/16.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HSQProgressHUDManger : NSObject

/**
 * @brief 初始化一个单利
 */
+ (HSQProgressHUDManger *)Manger;

/**
 * @brief 只显示提示文字
 */
- (void)ShowProgressHUDPromptText:(NSString *)string SupView:(UIView *)SuperView;

/**
 * @brief 显示加载数据成功
 */
- (void)ShowLoadDataSuccessWithPlaceholderString:(NSString *)SuccessString SuperView:(UIView *)superView;

/**
 * @brief 显示加载数据失败
 */
- (void)ShowDisplayFailedToLoadData:(NSString *)ErrorString SuperView:(UIView *)superView;

/**
 * @brief 现在正在加载的等待框
 * param loadText 加载的提示文字
 * param SuperView 加载哪一个View上
 * param ClearColor 背景色是不是透明的
 */
- (void)ShowLoadingDataFromeServer:(NSString *)loadText ToView:(UIView *)SuperView IsClearColor:(BOOL)ClearColor;

/**
 * @brief 隐藏提示框
 */
- (void)DismissProgressHUD;

@end
