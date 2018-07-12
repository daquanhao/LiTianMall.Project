//
//  HSQGoodsDetailFrameModel.m
//  LiTianDecoration
//
//  Created by administrator on 2018/7/3.
//  Copyright © 2018年 administrator. All rights reserved.
//

#define KBanner @"banner" // 头部的轮播
#define Kname @"name" // 商品的名字
#define KCouponRedemption @"CouponRedemption" // 领券
#define KSalesPromotion @"SalesPromotion" // 促销
#define KTheSelected @"TheSelected" // 已选

#import "HSQGoodsDetailFrameModel.h"

@implementation HSQGoodsDetailFrameModel

/**
 * @brief 初始化一个单利
 */
+ (HSQGoodsDetailFrameModel *)shareGoodsDetailFrameModel{
    
    static HSQGoodsDetailFrameModel *Single = nil;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        Single = [[HSQGoodsDetailFrameModel alloc] init];
        
    });
    
    return Single;
}

/**
 * @brief 根据商品的名字和描述返回高度
 */
- (CGFloat)HeightWithGoodsName:(NSString *)goodsName GoodsDescribe:(NSString *)goodsDescribe isOwnShop:(NSString *)isOwnShop{
    
    CGFloat MaxWidth = (isOwnShop.integerValue == 0 ? KScreenWidth - 20 : KScreenWidth - 60);
    
    CGSize goodsName_size = [NSString SizeOfTheText:goodsName font:[UIFont systemFontOfSize:14.0] MaxSize:CGSizeMake(MaxWidth, MAXFLOAT)];
    
    CGSize goodsDescribe_size = [NSString SizeOfTheText:goodsDescribe font:[UIFont systemFontOfSize:12.0] MaxSize:CGSizeMake(KScreenWidth - 20, MAXFLOAT)];
    
    return 10 + goodsName_size.height + 10 + goodsDescribe_size.height + 5;
}

/**
 * @brief 根据类型返回不同cell的高度
 */
- (CGFloat)CellHeightWithType:(NSString *)type GoodsName:(NSString *)goodsName GoodsDescribe:(NSString *)goodsDescribe;{
    
    if ([type isEqualToString:KBanner]) // 头部轮播
    {
        return KScreenWidth;
    }
    else if ([type isEqualToString:Kname]) // 商品的名字
    {
        CGSize goodsName_size = [NSString SizeOfTheText:goodsName font:[UIFont systemFontOfSize:14.0] MaxSize:CGSizeMake(KScreenWidth - 40, MAXFLOAT)];
        
        CGSize goodsDescribe_size = [NSString SizeOfTheText:goodsDescribe font:[UIFont systemFontOfSize:12.0] MaxSize:CGSizeMake(KScreenWidth - 20, MAXFLOAT)];
        
        return 10 + goodsName_size.height + 10 + goodsDescribe_size.height + 10 + 20 + 5;
    }
    else if ([type isEqualToString:KCouponRedemption]) // 领券
    {
        return 50;
    }
    else if ([type isEqualToString:KSalesPromotion]) // 促销
    {
        return 50;
    }
    else if ([type isEqualToString:KTheSelected]) // 已选
    {
        return 50;
    }
    else
    {
        return 100;
    }
}












@end
