//
//  HSQShopCarManger.h
//  LiTianDecoration
//
//  Created by administrator on 2018/5/18.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HSQShopCarGoodsListModel;

@interface HSQShopCarManger : NSObject

/**
 * @brief 初始化单例
 */
+ (instancetype)sharedShopCarManger;

/**
 * @brief 将字典或者数组转化为JSON串
 * @param theData 要转化的数据
 */
- (NSString *)toJSONDataString:(id)theData;

/**
 * @brief 将字典转化为JSON串
 * @param theDataDiction 要转化的数据
 */
- (NSString *)toJSONDataStringWithDiction:(NSDictionary *)theDataDiction;

/**
 *  @brief 查询某个商品是否存在
 *  @param Goods_id 商品的ID
 */
- (BOOL)LoookUpGoodsIsExitWithGoods_id:(NSString *)Goods_id;

/**
 * @brief 根据商品的SKU查询商品的个数
 *  @param commond_id 商品的SKU
 */
- (NSMutableArray *)ChaXunGoodsCountWithCommondId:(NSString *)commond_id;

/**
 * @brief 添加商品的模型
 */
- (void)addGoodsModel:(HSQShopCarGoodsListModel *)GoodModel;

/**
 * @brief 根据商品的id取出商品的模型
 */
- (HSQShopCarGoodsListModel *)TakeOutTheModelOfTheProductAccordingToTheIdOfTheProduct:(NSString *)GoodsId;

/**
 * @brief 删除商品的模型
 */
- (void)deleteGoodsModel:(HSQShopCarGoodsListModel *)GoodModel;

/**
 * @brief 根据商品的SKU删除模型
 */
- (void)RemoveGoodsModel:(NSString *)commonId;

/**
 * @brief 更新商品的数据
 */
- (void)updatePGoodsModel:(HSQShopCarGoodsListModel *)GoodModel;

/**
 * @brief 取出数据库中所有的数据
 */
- (NSMutableArray *)getAllGoodsModel;

/**
 * @brief 清除所有的数据
 */
- (void)ClearAllDataFromeFMDB;

@end
