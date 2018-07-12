//
//  HSQGoodsRateImageView.h
//  LiTianDecoration
//
//  Created by administrator on 2018/5/12.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HSQGoodsRateImageView : UIView

@property (nonatomic, strong) NSArray *photos;

/**
 * @brief 根据图片个数计算相册的尺寸
 */
+ (CGSize)sizeWithCount:(NSUInteger)count;

@end
