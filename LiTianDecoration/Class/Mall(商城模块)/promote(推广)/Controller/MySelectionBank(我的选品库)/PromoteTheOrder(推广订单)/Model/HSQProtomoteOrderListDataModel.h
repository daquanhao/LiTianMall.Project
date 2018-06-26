//
//  HSQProtomoteOrderListDataModel.h
//  LiTianDecoration
//
//  Created by administrator on 2018/6/18.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HSQProtomoteOrderListDataModel : NSObject

/**推广单号 */
@property (nonatomic, copy) NSString *distributionOrdersId;

/**推广单状态 */
@property (nonatomic, copy) NSString *distributionOrdersTypeText;

/**商品图片url地址 */
@property (nonatomic, copy) NSString *imageSrc;

/** 商品名称 */
@property (nonatomic, copy) NSString *goodsName;

/**商品全规格 */
@property (nonatomic, copy) NSString *goodsFullSpecs;

/**店铺名称 */
@property (nonatomic, copy) NSString *storeName;

/**商品价格 */
@property (nonatomic, copy) NSString *goodsPrice;

/**购买数量 */
@property (nonatomic, copy) NSString *buyNum;

/**商品单位名称 */
@property (nonatomic, copy) NSString *unitName;

/**佣金比例 */
@property (nonatomic, copy) NSString *commissionRate;

/**商品订单状态 */
@property (nonatomic, copy) NSString *ordersStateText;

/**商品订单金额 */
@property (nonatomic, copy) NSString *goodsPayAmount;

/**佣金 */
@property (nonatomic, copy) NSString *commission;



@end
