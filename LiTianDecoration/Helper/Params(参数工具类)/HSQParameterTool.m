//
//  HSQParameterTool.m
//  LiTianDecoration
//
//  Created by administrator on 2018/5/15.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import "HSQParameterTool.h"
#import "HSQAccountTool.h"

@implementation HSQParameterTool

/**
 * @brief 初始化一个单利
 */
+ (HSQParameterTool *)shareParameterTool{
    
    static HSQParameterTool *Single = nil;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        Single = [[HSQParameterTool alloc] init];
        
    });
    
    return Single;
}

/**
 * @brief 店铺详情的参数
 */
- (NSMutableDictionary *)StoreDetailsOfTheParameter:(NSString *)storeId{
    
    NSMutableDictionary *Params = [NSMutableDictionary dictionary];
    
    Params[@"storeId"] = storeId;
    
    HSQAccount *account = [HSQAccountTool account];
    
    if (account.token.length != 0)
    {
        Params[@"token"] = account.token;
    }
    
    return Params;
    
}

@end
