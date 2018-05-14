//
//  HSQAccountTool.m
//  LiTianDecoration
//
//  Created by administrator on 2018/4/19.
//  Copyright © 2018年 administrator. All rights reserved.
//

// 账号的存储路径
#define HWAccountPath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"account.archive"]

#import "HSQAccountTool.h"

@implementation HSQAccountTool

/**
 *  存储账号信息
 *
 *  @param account 账号模型
 */
+ (void)saveAccount:(HSQAccount *)account
{
    // 自定义对象的存储必须用NSKeyedArchiver，不再有什么writeToFile方法
    [NSKeyedArchiver archiveRootObject:account toFile:HWAccountPath];
    
    
}

/**
 *  删除账号信息
 *
 *  @param account 账号模型
 */
+ (void)DeleteAccount:(HSQAccount *)account{
    
    NSFileManager *manger = [NSFileManager defaultManager];
    
    [manger removeItemAtPath:HWAccountPath error:nil];
    
    account.token = nil;
    
    account.memberId = nil;
    
    account.memberName = nil;
    
}


/**
 *  返回账号信息
 *
 *  @return 账号模型（如果账号过期，返回nil）
 */
+ (HSQAccount *)account
{
    // 加载模型
    HSQAccount *account = [NSKeyedUnarchiver unarchiveObjectWithFile:HWAccountPath];
    
    return account;
}

@end
