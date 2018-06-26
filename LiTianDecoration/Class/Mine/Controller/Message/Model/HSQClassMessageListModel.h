//
//  HSQClassMessageListModel.h
//  LiTianDecoration
//
//  Created by administrator on 2018/6/20.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HSQClassMessageListModel : NSObject

/** 消息的名字*/
@property (nonatomic, copy) NSString *name;

/** 未读消息数量*/
@property (nonatomic, copy) NSString *messageUnreadCount;

/** 消息体*/
@property (nonatomic, strong) NSDictionary *memberMessage;

/** 消息的名字*/
@property (nonatomic, copy) NSString *storeMessage;

/** 消息的id*/
@property (nonatomic, copy) NSString *messageId;

/** 分类消息的id*/
@property (nonatomic, copy) NSString *ClassMessage_id;

/** 未读消息数量*/
@property (nonatomic, copy) NSString *isRead;

/** 消息模板编码*/
@property (nonatomic, copy) NSString *tplCode;

/** 消息的图片 */
@property (nonatomic, copy) NSString *messageUrl;

/** 特定数据编号 （用于跳转链接的Id） */
@property (nonatomic, copy) NSString *sn;

/** 消息的时间*/
@property (nonatomic, copy) NSString *addTime;

/** 用户的id*/
@property (nonatomic, copy) NSString *memberId;

/** 消息内容*/
@property (nonatomic, copy) NSString *messageContent;

/** 分类消息的id */
@property (nonatomic, copy) NSString *tplClass;


/**************************************** 消息详情列表  ***********************************/











@end
