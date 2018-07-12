//
//  HSQCountdownView.h
//  LiTianDecoration
//
//  Created by administrator on 2018/5/14.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HSQCountdownView : UIView

- (HSQCountdownView *)initCountdownViewWithXIB;

/**
 * @brief 拼团的数据
 */
@property (nonatomic, strong) NSDictionary *dataDiction;

/**
 * @brief 限时折扣的数据
 */
@property (nonatomic, strong) NSDictionary *discount_diction;

/**
 * @brief 倒计时--天数
 */
@property (weak, nonatomic) IBOutlet UILabel *dayLabel;

/**
 * @brief 倒计时--小时
 */
@property (weak, nonatomic) IBOutlet UILabel *hourLabel;

/**
 * @brief 倒计时--分钟
 */
@property (weak, nonatomic) IBOutlet UILabel *minuteLabel;

/**
 * @brief 倒计时--秒数
 */
@property (weak, nonatomic) IBOutlet UILabel *secondLabel;

@end
