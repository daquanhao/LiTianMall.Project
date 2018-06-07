//
//  HSQSendAdressModel.h
//  LiTianDecoration
//
//  Created by administrator on 2018/5/24.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HSQSendAdressModel : NSObject

/** 地址的名字*/
@property (nonatomic, copy) NSString *areaInfo;

/** 用户的名字*/
@property (nonatomic, copy) NSString *realName;

/** 用户的手机号*/
@property (nonatomic, copy) NSString *mobPhone;

/** 用户的详细地址*/
@property (nonatomic, copy) NSString *address;

/** 是否默认是地址*/
@property (nonatomic, copy) NSString *isDefault;

/** 用户id*/
@property (nonatomic, copy) NSString *memberId;

/** 地址是否存在*/
@property (nonatomic, copy) NSString *IsExit;

@end
