//
//  HSQCustomNavBar.h
//  测试demo
//
//  Created by administrator on 2018/4/10.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HSQCustomNavBarDelegate <NSObject>

- (void)LookUpTheDataInTheMessageList:(UIButton *)sender;

@end

@interface HSQCustomNavBar : UIView

/**
 * @brief 初始化导航栏
 */
+ (instancetype)InitializeTheNavigationBar;

/**
 * @brief 导航栏的标题
 */
@property (nonatomic, copy) NSString *title;

/**
 * @brief 导航栏的标题的颜色
 */
@property (nonatomic, strong) UIColor *titleColor;

/**
 * @brief 导航栏的标题的字体大小
 */
@property (nonatomic, strong) UIFont *titleFont;

/**
 * @brief 导航栏左边的item的图片名字
 */
@property (nonatomic, copy) NSString *Left_imageName;

/**
 * @brief 导航栏右边的item的图片名字
 */
@property (nonatomic, copy) NSString *Right_imageName;

/**
 * @brief 设置代理
 */
@property (nonatomic, weak) id<HSQCustomNavBarDelegate>delegate;




@end
