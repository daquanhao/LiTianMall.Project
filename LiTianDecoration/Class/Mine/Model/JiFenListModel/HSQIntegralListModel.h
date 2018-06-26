//
//  HSQIntegralListModel.h
//  LiTianDecoration
//
//  Created by administrator on 2018/4/28.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HSQIntegralListModel : NSObject

/*************************** 积分记录 ***********************/

/** 日志序号*/
@property (nonatomic, copy) NSString *logId;

/** 会员ID*/
@property (nonatomic, copy) NSString *memberId;

/** 积分负数表示扣除，正数表示增加*/
@property (nonatomic, copy) NSString *points;

/** 添加时间*/
@property (nonatomic, copy) NSString *addTime;

/** 操作描述*/
@property (nonatomic, copy) NSString *descriptionString;

/** 操作阶段*/
@property (nonatomic, copy) NSString *operationStage;

/** 操作阶段文本*/
@property (nonatomic, copy) NSString *operationStageText;


/*************************** 账户余额 ***********************/
/** 冻结金额变更*/
@property (nonatomic, copy) NSString *freezeAmount;

/**  可用金额变更*/
@property (nonatomic, copy) NSString * availableAmount;


@end
