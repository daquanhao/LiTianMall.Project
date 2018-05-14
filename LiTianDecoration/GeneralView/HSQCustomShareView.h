//
//  HSQCustomShareView.h
//  LiTianDecoration
//
//  Created by administrator on 2018/4/9.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HSQCustomShareViewDelegate <NSObject>

- (void)CustomShareButtonClickEvent:(UIButton *)sender;

@end

@interface HSQCustomShareView : UIView

/**
 * @brief 初始化分享界面
 */
- (void)showInView:(UIView *)superView contentArray:(NSArray *)contentArray;

/**
 * @brief 设置分享界面的代理
 */
@property (nonatomic, assign) id<HSQCustomShareViewDelegate>delegate;

@end
