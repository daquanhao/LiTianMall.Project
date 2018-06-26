//
//  HSQRedEnvelopeListDataModel.h
//  LiTianDecoration
//
//  Created by administrator on 2018/6/21.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HSQRedEnvelopeListDataModel : NSObject

/** 红包活动编号 */
@property (nonatomic, copy) NSString *templateId;

/** 红包名称 */
@property (nonatomic, copy) NSString *templateTitle;

/** 红包有效期结束时间 */
@property (nonatomic, copy) NSString *useEndTime;

/** 红包面额 */
@property (nonatomic, copy) NSString *templatePrice;

/** 红包试用时的订单限额 */
@property (nonatomic, copy) NSString *limitAmount;

/** 红包领取所需积分 */
@property (nonatomic, copy) NSString *expendPoints;

/** 模版可发放的红包总数 */
@property (nonatomic, copy) NSString *totalNum;

/** 模版已发放的红包数量 */
@property (nonatomic, copy) NSString *giveoutNum;

/** 领取红包限制的会员等级 */
@property (nonatomic, copy) NSString *limitMemberGradeLevel;

/** 领取红包限制的会员等级名称 */
@property (nonatomic, copy) NSString *limitMemberGradeName;

/** PC端是否可用 */
@property (nonatomic, copy) NSString *webUsable;

/** APP端是否可用（包括wap、ios、android） */
@property (nonatomic, copy) NSString *appUsable;

/**微信端是否可用 */
@property (nonatomic, copy) NSString *wechatUsable;

/** 客户端类型标识 */
@property (nonatomic, copy) NSString *usableClientType;

/** 客户端类型文本 */
@property (nonatomic, copy) NSString *usableClientTypeText;

/** 红包有效期结束时间 */
@property (nonatomic, copy) NSString *useEndTimeText;

/** 会员已经领取红包标记 */
@property (nonatomic, copy) NSString *hasReceived;







@end
