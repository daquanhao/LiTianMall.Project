//
//  CircleView.h
//  YKL
//
//  Created by Apple on 15/12/7.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XLCircleProgress : UIView

//百分比
@property (assign,nonatomic) float progress;

/**
 * @brief 线宽
 */
@property (assign,nonatomic) CGFloat lineWidth;

/**
 * @brief 提示文字的颜色
 */
@property (nonatomic, strong) UIColor *PlacherColor;

/**
 * @brief 提示文字的大小
 */
@property (nonatomic, strong) UIFont *PlacherFont;

@end
