//
//  HSQOrderListFirstCengModel.h
//  LiTianDecoration
//
//  Created by administrator on 2018/5/26.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import "JSONModel.h"

@interface HSQOrderListSecondCengModel : JSONModel

/** 商品列表*/
@property (nonatomic, strong) NSMutableArray<Optional>  *ordersGoodsVoList_array;

/** 订单状态(文字描述)*/
@property (nonatomic, strong) NSString<Optional>  *ordersStateName;

/** 店铺的id*/
@property (nonatomic, strong) NSString<Optional>  *storeId;

/** 拼团的人数*/
@property (nonatomic, strong) NSString<Optional>  *promotionTitle;

/**  订单类型*/
@property (nonatomic, strong) NSString<Optional>  *ordersTypeName;

/**  订单类型(0-普通订单,1-预定订单,2-拼团订单)*/
@property (nonatomic, strong) NSString<Optional>  *ordersType;

/** 店铺的名字*/
@property (nonatomic, strong) NSString<Optional>  *storeName;

/** 订单金额*/
@property (nonatomic, strong) NSString<Optional>  *ordersAmount;

/** 店铺运费*/
@property (nonatomic, strong) NSString<Optional>  *freightAmount;

/** 订单号*/
@property (nonatomic, strong) NSString<Optional>  *ordersSn;

/** 订单id*/
@property (nonatomic, strong) NSString<Optional>  *ordersId;

/** 是否处于退款退货中，0-否/1-是*/
@property (nonatomic, strong) NSString<Optional>  *showRefundWaiting;

/** 订单的状态*/
@property (nonatomic, strong) NSString<Optional>  *ordersState;

/** 支付单Id*/
@property (nonatomic, strong) NSString<Optional>  *payId;

/** 评价状态(0-未评价,1-已评价)*/
@property (nonatomic, strong) NSString<Optional>  *evaluationState;

/** 是否可以取消订单(1-是,0-否)*/
@property (nonatomic, strong) NSString<Optional>  *showMemberCancel;

/** 是否允许追评，0-否/1-是*/
@property (nonatomic, strong) NSString<Optional>  *showEvaluationAppend;

@end

@interface HSQOrderListFirstCengModel : JSONModel

/** 订单列表*/
@property (nonatomic, strong) NSMutableArray<Optional>  *ordersVoList;

/** 是否是拼团订单 1-是/0-否*/
@property (nonatomic, strong) NSString<Optional>  *isGroup;

/**  订单还须在线支付金额金额(扣除已经使用站内余额支付的部分)，当该金额>0时，出现支付按钮 */
@property (nonatomic, strong) NSString<Optional>  *ordersOnlineDiffAmount;

/** 支付单Id*/
@property (nonatomic, strong) NSString<Optional>  *payId;

/** 支付单号 */
@property (nonatomic, strong) NSString<Optional>  *paySn;

/** 是否是门店订单 1-是/0-否 */
@property (nonatomic, strong) NSString<Optional>  *isChain;



@end
