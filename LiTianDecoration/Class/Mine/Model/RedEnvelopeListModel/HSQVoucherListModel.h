//
//  HSQVoucherListModel.h
//  LiTianDecoration
//
//  Created by administrator on 2018/6/27.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HSQVoucherListModel : NSObject

@property (nonatomic, copy) NSString *voucherId;

@property (nonatomic, copy) NSString *voucherCode;

@property (nonatomic, copy) NSString *templateId;

@property (nonatomic, copy) NSString *voucherTitle;

@property (nonatomic, copy) NSString *templateTitle;

@property (nonatomic, copy) NSString *voucherDescribe;

@property (nonatomic, copy) NSString *price;

@property (nonatomic, copy) NSString *limitAmount;

@property (nonatomic, copy) NSString *storeId;

@property (nonatomic, copy) NSString *storeName;

@property (nonatomic, copy) NSString *templatePrice;

@property (nonatomic, copy) NSString *voucherStateText;

/** 1卡密优惠券 2免费优惠券 3购后优惠券 */
@property (nonatomic, copy) NSString *type;

@property (nonatomic, copy) NSString *startTimeText;

@property (nonatomic, copy) NSString *endTimeText;

@property (nonatomic, copy) NSString *useEndTimeText;

/**  0-未用,1-已用,2-作废 */
@property (nonatomic, copy) NSString *voucherState;

/**  会员是否已领取 0未领取 1已领取 */
@property (nonatomic, copy) NSString *memberIsReceive;

@property (nonatomic, copy) NSString *voucherUsableClientTypeText;

/** 店铺的信息*/
@property (nonatomic, strong) NSDictionary *store;






@end
