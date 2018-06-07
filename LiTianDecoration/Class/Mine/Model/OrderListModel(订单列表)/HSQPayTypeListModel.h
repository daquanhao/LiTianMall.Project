//
//  HSQPayTypeListModel.h
//  LiTianDecoration
//
//  Created by administrator on 2018/5/28.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HSQPayTypeListModel : NSObject

/** 支付id*/
@property (nonatomic, copy) NSString *payId;

/** 应在线支付金额(如果是0，说明0元订单不用支付了) */
@property (nonatomic, copy) NSString *payAmount;

/** 允许使用预存款支付(1–允许，0–不允许)*/
@property (nonatomic, copy) NSString *allowPredeposit;

/** 支付方式列表*/
@property (nonatomic, strong) NSArray *paymentList;

/** 预存款可用金额 */
@property (nonatomic, copy) NSString *predepositAmount;

@end
