//
//  HSQMessageReceiveModel.h
//  LiTianDecoration
//
//  Created by administrator on 2018/4/26.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import "JSONModel.h"

@interface HSQMessageListModel : JSONModel

/** 消息模板编码 */
@property (nonatomic, copy) NSString *tplCode;

/** 消息模板名称 */
@property (nonatomic, copy) NSString *tplName;

/** 是否接收消息 1是 0否 */
@property (nonatomic, copy) NSString *isReceive;

@end

@interface HSQMessageReceiveModel : JSONModel

/** 消息id*/
@property (nonatomic, copy) NSString <Optional> *message_id;

/** 消息id*/
@property (nonatomic, copy) NSString <Optional> *memberMessage;

/** 消息id*/
@property (nonatomic, strong) NSMutableArray <HSQMessageListModel *> *messageTemplateCommonList;

/** 消息id*/
@property (nonatomic, copy) NSString <Optional> *messageUnreadCount;

/** 消息的名字*/
@property (nonatomic, copy) NSString <Optional> *name;

/** 消息id*/
@property (nonatomic, copy) NSString <Optional> *storeMessage;

@end
