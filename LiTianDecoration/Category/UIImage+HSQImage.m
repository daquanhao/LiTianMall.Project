//
//  UIImage+HSQImage.m
//  LiTianDecoration
//
//  Created by administrator on 2018/4/9.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import "UIImage+HSQImage.h"

@implementation UIImage (HSQImage)

/**
 * @brief 通过一个颜色返回一张图片
 */
+ (instancetype)ImageWithColor:(UIColor *)color{
    
    //宽高 1.0只要有值就够了
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    
    //在这个范围内开启一段上下文
    UIGraphicsBeginImageContext(rect.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //在这段上下文中获取到颜色UIColor
    CGContextSetFillColorWithColor(context, [color CGColor]);
    
    //用这个颜色填充这个上下文
    CGContextFillRect(context, rect);
    
    //从这段上下文中获取Image属性,,,结束
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    // 关闭上下文
    UIGraphicsEndImageContext();
    
    return image;
}

/**
 * @brief 将图片拉伸
 */
+(instancetype)ReturnAPictureOfStretching:(NSString *)imageName{
    
    UIImage *imageSt = [UIImage imageNamed:imageName];
    
    CGFloat top = 25; // 顶端盖高度
    
    CGFloat bottom = 25 ; // 底端盖高度
    
    CGFloat left = 10; // 左端盖宽度
    
    CGFloat right = 10; // 右端盖宽度
    
    UIEdgeInsets insets = UIEdgeInsetsMake(top, left, bottom, right);
    
    // 指定为拉伸模式，伸缩后重新赋值
    return [imageSt resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
}









@end
