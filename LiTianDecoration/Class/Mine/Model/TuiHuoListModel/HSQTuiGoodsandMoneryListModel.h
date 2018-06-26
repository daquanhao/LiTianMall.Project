//
//  HSQTuiGoodsandMoneryListModel.h
//  LiTianDecoration
//
//  Created by administrator on 2018/6/4.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HSQTuiGoodsandMoneryListModel : NSObject

/** 投诉Id */
@property (nonatomic, copy) NSString *complainId;

/** 是否可撤销投诉(1-是/0-否) */
@property (nonatomic, copy) NSString *showMemberClose;

/** 商品的名字 */
@property (nonatomic, copy) NSString *goodsName;

/** 规格 */
@property (nonatomic, copy) NSString *goodsFullSpecs;

/** 店铺的名字*/
@property (nonatomic, copy) NSString *accusedName;

/** 投诉状态 */
@property (nonatomic, copy) NSString *complainStateName;

/** 商品SPU编号 */
@property (nonatomic, copy) NSString *commonId;

/** 投诉的原因 */
@property (nonatomic, copy) NSString *subjectTitle;

/**投诉的id */
@property (nonatomic, copy) NSString *subjectId;

/** 订单id*/
@property (nonatomic, copy) NSString *ordersId;

/** 投诉的凭证 */
@property (nonatomic, strong) NSArray *accuserImagesList;

/** 商品的id*/
@property (nonatomic, copy) NSString *goodsId;

/** 订单中商品的id */
@property (nonatomic, copy) NSString *ordersGoodsId;

/** 投诉说明 */
@property (nonatomic, copy) NSString *accuserContent;

/** 商品的图片*/
@property (nonatomic, copy) NSString *imageSrc;

/** 创建的时间*/
@property (nonatomic, copy) NSString *accuserTime;

/**区分订单列表的状态 100代表退款  200 代表退货  300代表投诉*/
@property (nonatomic, copy) NSString *OrderListState;

/** 添加的时间*/
@property (nonatomic, copy) NSString *addTime;

@end
