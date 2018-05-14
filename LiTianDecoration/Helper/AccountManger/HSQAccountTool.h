//
//  HSQAccountTool.h
//  LiTianDecoration
//
//  Created by administrator on 2018/4/19.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HSQAccount.h"

@interface HSQAccountTool : NSObject

/**
 *  存储账号信息
 *
 *  @param account 账号模型
 */
+ (void)saveAccount:(HSQAccount *)account;

/**
 *  删除账号信息
 *
 *  @param account 账号模型
 */
+ (void)DeleteAccount:(HSQAccount *)account;

/**
 *  返回账号信息
 *
 *  @return 账号模型（如果账号过期，返回nil）
 */
+ (HSQAccount *)account;

@end
