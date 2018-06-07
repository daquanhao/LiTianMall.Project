//
//  HSQCustomTextView.h
//  LiTianDecoration
//
//  Created by administrator on 2018/4/8.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HSQCustomTextView : UITextView

/**
 * @brief 提示文字
 */
@property (nonatomic, copy) NSString *placeholder;

/**
 * @brief 提示文字的颜色
 */
@property (nonatomic, strong) UIColor *placeholderColor;

@end
