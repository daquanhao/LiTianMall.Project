//
//  HSQCommissionWithdrawaLlisModel.h
//  LiTianDecoration
//
//  Created by administrator on 2018/6/15.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HSQCommissionWithdrawaLlisModel : NSObject

/** 佣金提现id*/
@property (nonatomic, copy) NSString *cashId;

/** 提现编号*/
@property (nonatomic, copy) NSString *cashSn;

/** 提现金额*/
@property (nonatomic, copy) NSString *amount;

/** 添加时间*/
@property (nonatomic, copy) NSString *addTime;

/** （状态 0未处理 1提现成功 2提现失败）*/
@property (nonatomic, copy) NSString *state;

/** 操作审核的管理员编号*/
@property (nonatomic, copy) NSString *adminId;

/** 操作审核的管理员 */
@property (nonatomic, copy) NSString *adminName;

/** 拒绝提现理由*/
@property (nonatomic, copy) NSString *refuseReason;

/** 状态文本*/
@property (nonatomic, copy) NSString *stateText;

/******************************************** 佣金金额  ***********************************/
 
 /** 状态文本*/
@property (nonatomic, copy) NSString *description_string;

/**冻结金额变更*/
@property (nonatomic, copy) NSString *freezeAmount;

/** 日志id*/
@property (nonatomic, copy) NSString *logId;

/** 推广会员id*/
@property (nonatomic, copy) NSString *distributorId;

/** 操作阶段 */
@property (nonatomic, copy) NSString *operationStage;

/** 可用金额变更*/
@property (nonatomic, copy) NSString *availableAmount;


@end
