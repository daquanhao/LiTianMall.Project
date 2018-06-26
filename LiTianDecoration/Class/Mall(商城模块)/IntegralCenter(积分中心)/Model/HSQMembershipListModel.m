//
//  HSQMembershipListModel.m
//  LiTianDecoration
//
//  Created by administrator on 2018/6/21.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import "HSQMembershipListModel.h"

@implementation HSQMembershipListModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
    
}

- (NSString *)gradeName{
    
    if ([_gradeName isEqualToString:@"V0"])
    {
        return _gradeName;
    }
    else
    {
        return [NSString stringWithFormat:@"%@及以下",_gradeName];
    }
}

@end
