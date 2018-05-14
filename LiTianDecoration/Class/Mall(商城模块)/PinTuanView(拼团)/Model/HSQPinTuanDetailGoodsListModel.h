//
//  HSQPinTuanDetailGoodsListModel.h
//  LiTianDecoration
//
//  Created by administrator on 2018/5/9.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HSQPinTuanDetailGoodsListModel : NSObject

/** 商品SKU编号*/
@property (nonatomic, copy) NSString *goodsId;

/** 商品SPU*/
@property (nonatomic, copy) NSString *commonId;

/** 规格*/
@property (nonatomic, copy) NSString *goodsSpecs;

/** 规格(例“红色；L”) 显示使用这个*/
@property (nonatomic, copy) NSString *goodsSpecString;

/**完整规格*/
@property (nonatomic, copy) NSString *goodsFullSpecs;

/**所选规格值编号(例：列 “1,2,3,4”)*/
@property (nonatomic, copy) NSString *specValueIds;

/**APP端起购价0*/
@property (nonatomic, copy) NSString *appPrice0;

/**APP端促销进行状态*/
@property (nonatomic, copy) NSString *appUsable;

/**  int 活动类型（0-没有参加活动 ，1限时折扣, 2全款预售，3定金预售）*/
@property (nonatomic, copy) NSString *promotionType;

/** 活动类型文字*/
@property (nonatomic, copy) NSString *promotionTypeText;

/** 活动标题*/
@property (nonatomic, copy) NSString *promotionTitle;

/**  商品货号*/
@property (nonatomic, copy) NSString *goodsSerial;

/** 颜色规格值编号*/
@property (nonatomic, copy) NSString *colorId;

/** 库存*/
@property (nonatomic, copy) NSString *goodsStorage;

/** 图片名称*/
@property (nonatomic, copy) NSString *imageName;

/**  图片路径*/
@property (nonatomic, copy) NSString *imageSrc;

/** 是否是拼团商品  0 不是 1 是*/
@property (nonatomic, copy) NSString *isGroup;

/**  拼团价格*/
@property (nonatomic, copy) NSString *groupPrice;

/**  优惠券使用时的订单限额*/
@property (nonatomic, copy) NSString *limitAmount;

@end
