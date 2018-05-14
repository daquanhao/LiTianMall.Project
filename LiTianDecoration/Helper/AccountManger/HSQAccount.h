//
//  HSQAccount.h
//  LiTianDecoration
//
//  Created by administrator on 2018/4/19.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HSQAccount : NSObject

/**　string    用于调用token，接口获取授权后的token。*/
@property (nonatomic, copy) NSString *token;

/**　string    当前用户的UID。*/
@property (nonatomic, copy) NSString *memberId;

/** 用户的昵称 */
@property (nonatomic, copy) NSString *memberName;

+ (instancetype)accountWithDict:(NSDictionary *)dict;

@end
