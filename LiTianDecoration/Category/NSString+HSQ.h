//
//  NSString+HSQ.h
//  LiTianDecoration
//
//  Created by administrator on 2018/4/9.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (HSQ)

/**
 * @brief 判断文字是否是手机号
 */
- (BOOL)isPhone;


/**
 * @brief 验证邮箱
 */
-(BOOL)isValidateEmail:(NSString*)email;

/**
 * @brief 判断输入的是否是纯数字
 */
- (BOOL)isPureInt:(NSString *)string;

/**
 * @brief 将大于10000的文字转换成带有万字的字符串
 */
+ (NSString *)ReturnsAStringWithAThousandWords:(NSString *)string;

/**
 * @brief 计算文字的大小
 */
+ (CGSize)SizeOfTheText:(NSString *)text font:(UIFont *)font MaxSize:(CGSize)maxSize;

/**
 * @brief 将时间戳转化为时间格式类
 * @param time 时间戳 例如：18902827642
 * @param type 时间的类型 例如：YYYY年mm月dd日
 */
+ (NSString *)stringWithTheTimeStamp:(NSString *)time TimeType:(NSString *)type;

/**
 * @brief 将时间格式类转化为时间戳 时间的样式要保持一致 @"2018年04月10日 14:20" 和 @"YYYY年MM月dd日 HH:mm"
 * @param string 时间 例如：2018年04月09日
 * @param type 时间的类型 例如：YYYY年mm月dd日
 */
+ (NSString *)timeStampWithString:(NSString *)string TimeType:(NSString *)type;

/**
 * @brief 改变字符串指定位置的颜色
 */
+ (NSMutableAttributedString *)attributedStringWithString:(NSString *)text Color:(UIColor *)color range:(NSRange)rang;

/**
 * @brief 改变字符串指定位置的大小
 */
+ (NSMutableAttributedString *)attributedStringWithString:(NSString *)text font:(UIFont *)font range:(NSRange)rang;

/**
 * @brief 改变字符串指定位置的大小或者颜色
 * @param colorRang 颜色的范围
 * @param fontRang  大小的范围
 */
+ (NSMutableAttributedString *)attributedStringWithString:(NSString *)text font:(UIFont *)font  color:(UIColor *)color  ColorRange:(NSRange)colorRang FontRang:(NSRange)fontRang;









@end
