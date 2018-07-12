//
//  HSQStoreClassListModel.m
//  LiTianDecoration
//
//  Created by administrator on 2018/6/27.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import "HSQStoreClassListModel.h"

@implementation HSQStoreClassListModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
    
}

+(NSDictionary *)mj_replacedKeyFromPropertyName{
    
    return @{@"StoreClass_id":@"id"};
}

@end
