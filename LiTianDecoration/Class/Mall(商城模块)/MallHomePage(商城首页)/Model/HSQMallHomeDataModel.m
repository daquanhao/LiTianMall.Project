//
//  HSQMallHomeDataModel.m
//  LiTianDecoration
//
//  Created by administrator on 2018/5/7.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import "HSQMallHomeDataModel.h"

@implementation HSQMallHomeDataModel

- (NSArray *)itemDataSource{
    
    NSData *newData = [self.itemData dataUsingEncoding:NSUTF8StringEncoding];
    
    NSArray *childArray = [NSJSONSerialization JSONObjectWithData:newData options:NSJSONReadingMutableContainers error:nil];

    return childArray;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
    
}

@end
