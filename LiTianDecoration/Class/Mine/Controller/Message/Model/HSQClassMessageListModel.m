//
//  HSQClassMessageListModel.m
//  LiTianDecoration
//
//  Created by administrator on 2018/6/20.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import "HSQClassMessageListModel.h"

@implementation HSQClassMessageListModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
    
}

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    
    return @{
             
             @"messageId":@"memberMessage.messageId",
             
             @"isRead":@"memberMessage.isRead",
             
             @"tplCode":@"memberMessage.tplCode",
             
             @"messageUrl":@"memberMessage.messageUrl",
             
             @"sn":@"memberMessage.sn",
             
             @"addTime":@"memberMessage.addTime",
             
             @"memberId":@"memberMessage.memberId",
             
             @"messageContent":@"memberMessage.messageContent",
             
             @"messageUrl":@"memberMessage.messageUrl",
             
             @"tplClass":@"memberMessage.tplClass",
             
             @"id":@"ClassMessage_id",
             
             };
}



@end
