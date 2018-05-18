//
//  HSQParameterTool.h
//  LiTianDecoration
//
//  Created by administrator on 2018/5/15.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HSQParameterTool : NSObject

/**
 * @brief 初始化一个单利
 */
+ (HSQParameterTool *)shareParameterTool;

/**
 * @brief 店铺详情的参数
 */
- (NSMutableDictionary *)StoreDetailsOfTheParameter:(NSString *)storeId;

@end
