//
//  HSQAcceptAddressListModel.m
//  LiTianDecoration
//
//  Created by administrator on 2018/4/25.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import "HSQAcceptAddressListModel.h"

@implementation HSQAcceptAddressListModel

- (NSString *)adressName{
    
    return [NSString stringWithFormat:@"%@%@",self.areaInfo,self.address];
}

@end
