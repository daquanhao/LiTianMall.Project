//
//  HSQPointsOrdersListModel.h
//  LiTianDecoration
//
//  Created by administrator on 2018/6/22.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HSQPointsOrdersListModel : NSObject

/**商品名称 */
@property (nonatomic, copy) NSString *goodsName;

/**商品规格*/
@property (nonatomic, copy) NSString *goodsFullSpecs;

/**积分兑换订单状态 */
@property (nonatomic, copy) NSString *pointsOrdersState;

/**商品规格*/
@property (nonatomic, copy) NSString *unitName;

/**积分兑换订单状态文字*/
@property (nonatomic, copy) NSString *pointsOrdersStateText;

/**总消耗积分*/
@property (nonatomic, copy) NSString *totalPoints;

/**商品的SKU*/
@property (nonatomic, copy) NSString *commonId;

/**积分兑换订单编号*/
@property (nonatomic, copy) NSString *pointsOrdersId;

/**购买数量*/
@property (nonatomic, copy) NSString *buyNum;

/**商品的数量*/
@property (nonatomic, copy) NSString *imageSrc;

/**店铺的名字*/
@property (nonatomic, copy) NSString *storeName;

/**店铺的id*/
@property (nonatomic, copy) NSString *storeId;

/**兑换的积分*/
@property (nonatomic, copy) NSString *expendPoints;

/**订单的编号*/
@property (nonatomic, copy) NSString *pointsOrdersSn;

/** 下单时间*/
@property (nonatomic, copy) NSString *createTime;

/** 发货时间*/
@property (nonatomic, copy) NSString *sendTime;

/** 完成时间*/
@property (nonatomic, copy) NSString *finishTime;

/** 买家留言*/
@property (nonatomic, copy) NSString *receiverMessage;

/** 收货人姓名*/
@property (nonatomic, copy) NSString *receiverName;

/** 收货人地址*/
@property (nonatomic, copy) NSString *receiverAddress;

/** 省市县(区)内容*/
@property (nonatomic, copy) NSString *receiverAreaInfo;











@end
