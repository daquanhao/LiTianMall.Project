//
//  HSQGoodsDataListModel.h
//  LiTianDecoration
//
//  Created by administrator on 2018/6/8.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HSQGoodsDataListModel : NSObject

/** 商品SPU详情*/
@property (nonatomic, strong) NSDictionary *goodsCommon;

/** 关注编号*/
@property (nonatomic, copy) NSString *favoritesId;

/**  店铺编码*/
@property (nonatomic, copy) NSString *storeId;

/**  商品的SKU*/
@property (nonatomic, copy) NSString *commonId;

/** 关注时间*/
@property (nonatomic, copy) NSString *addTime;

/** 商品关注时价格*/
@property (nonatomic, copy) NSString *favGoodsPrice;

/**  是否展开*/
@property (nonatomic, assign) NSInteger IsOpen;

/**  是否是编辑状态*/
@property (nonatomic, copy) NSString *IsEditState;

/**  是否是选中状态*/
@property (nonatomic, copy) NSString *IsSelectState;

/** 布局标示*/
@property (nonatomic, assign) BOOL isGrid;

/**  销量*/
@property (nonatomic, copy) NSString *goodsSaleNum;

/**  单位*/
@property (nonatomic, copy) NSString *unitName;

/**  好评率*/
@property (nonatomic, copy) NSString *goodsRate;

/**  是否自营店铺(0-否 1-是) */
@property (nonatomic, copy) NSString *isOwnShop;

/**  店铺描述评分 1~5 */
@property (nonatomic, copy) NSString *storeDesEval;

/**  店铺描述评分 low-低 equal-平 high-高 */
@property (nonatomic, copy) NSString *desEvalArrow;

/** 店铺服务评分 1~5 */
@property (nonatomic, copy) NSString *storeServiceEval;

/**  店铺服务评分 low-低 equal-平 high-高*/
@property (nonatomic, copy) NSString *serviceEvalArrow;

/**  店铺发货速度评分 1~5*/
@property (nonatomic, copy) NSString *storeDeliveryEval;

/**  店铺发货速度评分 low-低 equal-平 high-高 */
@property (nonatomic, copy) NSString *deliveryEvalArrow;

/** 是否显示收藏界面*/
@property (nonatomic, assign) NSInteger IsShowCollectionView;

/** 是否收藏*/
@property (nonatomic, copy) NSString *isExist;


/******************************* 推广分佣的数据 ************************************/
/**  推广佣金比例*/
@property (nonatomic, copy) NSString *commissionRate;

/**  app端推广佣金*/
@property (nonatomic, copy) NSString *appCommission;

/** 商品的价格*/
@property (nonatomic, copy) NSString *appPrice0;

/**  商品名称*/
@property (nonatomic, copy) NSString *goodsName;

/**  商品的图片*/
@property (nonatomic, copy) NSString *imageSrc;

/**  活动类型文字 */
@property (nonatomic, copy) NSString *promotionTypeText;

/**  活动类型 */
@property (nonatomic, copy) NSString *promotionType;

/**  商品所在店铺的名字 */
@property (nonatomic, copy) NSString *storeName;

/**  商品推广数量 */
@property (nonatomic, copy) NSString *distributionCount;

/**  推广商品id */
@property (nonatomic, copy) NSString *distributorGoodsId;

/**  推广商品的价格 */
@property (nonatomic, copy) NSString *appPriceMin;

/**  是否推荐 */
@property (nonatomic, copy) NSString *isCommend;

/**  是否加入选品库 */
@property (nonatomic, assign) NSInteger IsJoinLibrary;


@end
