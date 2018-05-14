//
//  UIImage+HSQImage.h
//  LiTianDecoration
//
//  Created by administrator on 2018/4/9.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (HSQImage)

/**
 * @brief 通过一个颜色返回一张图片
 */
+ (instancetype)ImageWithColor:(UIColor *)color;

/**
 * @brief 将照片平铺的拉伸
 */
+(instancetype)ReturnAPictureOfStretching:(NSString *)imageName;

@end
