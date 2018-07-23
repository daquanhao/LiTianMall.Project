//
//  HSQPublicMenuView.h
//  LiTianDecoration
//
//  Created by administrator on 2018/4/13.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HSQPublicMenuViewDelegate <NSObject>

@optional

/** 顶部按钮的点击事件 **/
- (void)topButtonClickAction:(UIButton *)sender;

/** 下拉菜单里按钮的点击事件 **/
- (void)MenuButtonClickAction:(UIButton *)sender;

@end

@interface HSQPublicMenuView : UIView

/**
 * @brief 标题的数据源数据
 */
@property (nonatomic, strong) NSMutableArray *dataSource;

/**
 * @brief 设置代理
 */
@property (nonatomic, weak) id<HSQPublicMenuViewDelegate>delegate;

/**
 * @brief 显示菜单式图
 */
- (void)ShowMenuView;

/**
 * @brief 隐藏菜单式图
 */
- (void)DismissMenuView;



@end
