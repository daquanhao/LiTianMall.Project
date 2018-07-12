//
//  HSQGoodsDetailFrameModel.h
//  LiTianDecoration
//
//  Created by administrator on 2018/7/3.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HSQGoodsDetailFrameModel : NSObject

/**
 * @brief 初始化一个单利
 */
+ (HSQGoodsDetailFrameModel *)shareGoodsDetailFrameModel;

/**
 * @brief 根据商品的名字和描述返回高度
 */
- (CGFloat)HeightWithGoodsName:(NSString *)goodsName GoodsDescribe:(NSString *)goodsDescribe isOwnShop:(NSString *)isOwnShop;

/**
 * @brief 根据类型返回不同cell的高度
 */
- (CGFloat)CellHeightWithType:(NSString *)type GoodsName:(NSString *)goodsName GoodsDescribe:(NSString *)goodsDescribe;

@end
