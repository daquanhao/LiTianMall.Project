//
//  HSQAccount.m
//  LiTianDecoration
//
//  Created by administrator on 2018/4/19.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import "HSQAccount.h"

@implementation HSQAccount

+ (instancetype)accountWithDict:(NSDictionary *)dict
{

    HSQAccount *account = [[self alloc] init];
    
    account.token = dict[@"datas"][@"token"];
    
    account.memberId = [NSString stringWithFormat:@"%@",dict[@"datas"][@"memberId"]];
    
    account.memberName = dict[@"datas"][@"memberName"];
    
    return account;
}

/**
 *  当一个对象要归档进沙盒中时，就会调用这个方法
 *  目的：在这个方法中说明这个对象的哪些属性要存进沙盒
 */
- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.token forKey:@"token"];
    
    [encoder encodeObject:self.memberId forKey:@"memberId"];
    
    [encoder encodeObject:self.memberName forKey:@"memberName"];
}

/**
 *  当从沙盒中解档一个对象时（从沙盒中加载一个对象时），就会调用这个方法
 *  目的：在这个方法中说明沙盒中的属性该怎么解析（需要取出哪些属性）
 */
- (id)initWithCoder:(NSCoder *)decoder
{
    if (self = [super init]) {
        
        self.token = [decoder decodeObjectForKey:@"token"];
        
        self.memberId = [decoder decodeObjectForKey:@"memberId"];
        
        self.memberName = [decoder decodeObjectForKey:@"memberName"];
    }
    return self;
}

@end
