//
//  HSQStoreDetailDataTool.h
//  LiTianDecoration
//
//  Created by administrator on 2018/5/16.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HSQStoreDetailHomeHeadReusableView,HSQStoreDetailHeadTitleReusableView;

@interface HSQStoreDetailDataTool : NSObject

/**
 * @brief 初始化一个单利
 */
+ (HSQStoreDetailDataTool *)shareStoreDetailDataTool;

/**
 * @brief 根据标示返回店铺首页，全部商品，商品上新，店铺活动模块的分区数
 * @params ModelType 1.代表店铺首页 2.代表全部商品 3.商品上新 4.代表店铺活动
 */
- (NSInteger)ReturnCollectionSection:(NSString *)ModelType Array:(NSArray *)dataSource ZheKouArray:(NSArray *)ZheKouSource;

/**
 * @brief 根据标示返回店铺首页，全部商品，商品上新，店铺活动模块每个分区的items
 * @params ModelType 1.代表店铺首页 2.代表全部商品 3.商品上新 4.代表店铺活动
 */
- (NSInteger)numberOfItemsInSection:(NSInteger)section dataSource:(NSArray *)array  SecondArray:(NSArray *)SecondArr modelType:(NSString *)ModelType;

/**
 * @brief 根据标示返回店铺首页，全部商品，商品上新，店铺活动模块每个分区的尺寸
 * @params ModelType 1.代表店铺首页 2.代表全部商品 3.商品上新 4.代表店铺活动
 */
- (CGSize)referenceSizeForHeaderInSection:(NSInteger)section modelType:(NSString *)ModelType;

/**
 * @brief 根据标示返回店铺首页，全部商品，商品上新，店铺活动模块每个分区的items的尺寸
 * @params ModelType 1.代表店铺首页 2.代表全部商品 3.商品上新 4.代表店铺活动
 */
- (CGSize)sizeForItemAtIndexPath:(NSIndexPath *)indexPath modelType:(NSString *)ModelType;


















@end
