//
//  HSQMessageReceiveModel.m
//  LiTianDecoration
//
//  Created by administrator on 2018/4/26.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import "HSQMessageReceiveModel.h"

@implementation HSQMessageListModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
    
}


@end

@implementation HSQMessageReceiveModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    
    return @{@"message_id":@"id"};
}

@end
