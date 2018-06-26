//
//  HSQPointsExchangeGoodsListModel.h
//  LiTianDecoration
//
//  Created by administrator on 2018/6/21.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HSQPointsExchangeGoodsListModel : NSObject

/** 积分商品编号 */
@property (nonatomic, copy) NSString *pointsGoodsId;

/** 所需积分 */
@property (nonatomic, copy) NSString *expendPoints;

/** 领取积分商品限制的会员等级 */
@property (nonatomic, copy) NSString *limitMemberGradeLevel;

/**领取积分商品限制的会员等级名称 */
@property (nonatomic, copy) NSString *limitMemberGradeName;

/**商品SPU编号 */
@property (nonatomic, copy) NSString *commonId;

/**商品名称 */
@property (nonatomic, copy) NSString *goodsName;

/** 图片路径 */
@property (nonatomic, copy) NSString *imageSrc;

/**商品价格*/
@property (nonatomic, copy) NSString *webPriceMin;

/**  商品价格 */
@property (nonatomic, copy) NSString *appPriceMin;

/**商品价格*/
@property (nonatomic, copy) NSString *wechatPriceMin;

/****************************** 积分商品详情 *********************/









@end
