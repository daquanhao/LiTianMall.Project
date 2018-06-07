//
//  HSQShopCarGoodsTypeListModel.h
//  LiTianDecoration
//
//  Created by administrator on 2018/5/22.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HSQShopCarGoodsTypeListModel : NSObject

/** 商品的sku*/
@property (nonatomic, strong) NSString <Optional> *commonId;

/** 商品的规格*/
@property (nonatomic, strong) NSString <Optional> *goodsFullSpecs;

/** 商品的购买数量*/
@property (nonatomic, strong) NSString <Optional> *buyNum;

/** 商品的购买价格*/
@property (nonatomic, strong) NSString <Optional> *appPrice0;

/** 商品的购买单位*/
@property (nonatomic, strong) NSString <Optional> *unitName;

/** 商品的id*/
@property (nonatomic, strong) NSString <Optional> *goodsId;

/** 商品的名字*/
@property (nonatomic, strong) NSString <Optional> *goodsName;

/** 商品的库存*/
@property (nonatomic, strong) NSString <Optional> *goodsStorage;

/** 商品的选中状态*/
@property (nonatomic, strong) NSString <Optional> *IsSelect;

/** 商品的购物车id*/
@property (nonatomic, strong) NSString <Optional> *cartId;

/** 每种商品的总价格*/
@property (nonatomic, strong) NSString *itemAmount;

/** 每种商品的图片*/
@property (nonatomic, strong) NSString *imageSrc;

/** 每种商品的价格*/
@property (nonatomic, strong) NSString *goodsPrice;

/** 评论时选中的商品*/
@property (nonatomic, strong) NSMutableArray *Select_Arrays;

/** 评论时选中的商品的图片*/
@property (nonatomic, strong) NSMutableArray *SelectRateImage_Arrays;

/** 评论时选中的商品的图片的名字*/
@property (nonatomic, strong) NSMutableArray *SelectRateImageName_Arrays;

/** 评论的内容*/
@property (nonatomic, copy) NSString *RateContent_String;

/** 评论的星星个数*/
@property (nonatomic, copy) NSString *RateStarCount;

/** 商品的图片*/
@property (nonatomic, copy) NSString *goodsFullImage;

/** 已经评价的内容*/
@property (nonatomic, copy) NSString *evaluateContent;

/** 评价主表ID数组*/
@property (nonatomic, copy) NSString *evaluateId;

/**订单商品表主键*/
@property (nonatomic, copy) NSString *ordersGoodsId;

/**商品的投诉状态 当complainId>0时，商品为投诉中*/
@property (nonatomic, copy) NSString *complainId;

/** 商品是否处在退货退款中*/
@property (nonatomic, copy) NSString *refundType;

/** 是否处于退款退货中，0-否/1-是 */
@property (nonatomic, copy) NSString *showRefundWaiting;

/** 进入退款或者退货详情的id*/
@property (nonatomic, copy) NSString *refundId;


@end
