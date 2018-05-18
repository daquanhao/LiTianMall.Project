//
//  AFNetworkRequestTool.h
//  LiTianDecoration
//
//  Created by administrator on 2018/4/9.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AFNetworkRequestTool : NSObject

/**
 * @brief 初始化一个单利
 */
+ (AFNetworkRequestTool *)shareRequestTool;

@property (nonatomic, weak) AFHTTPSessionManager *manger;




@end
