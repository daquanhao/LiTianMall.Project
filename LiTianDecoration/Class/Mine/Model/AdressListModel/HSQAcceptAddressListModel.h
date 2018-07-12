//
//  HSQAcceptAddressListModel.h
//  LiTianDecoration
//
//  Created by administrator on 2018/4/25.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HSQAcceptAddressListModel : NSObject

/** 收货的地址*/
@property (nonatomic, copy) NSString *adressName;

/** 收货的地址*/
@property (nonatomic, copy) NSString *areaInfo;

/** 收货的地址*/
@property (nonatomic, copy) NSString *address;

/** 收货的名字*/
@property (nonatomic, copy) NSString *realName;

/** 收货的手机号*/
@property (nonatomic, copy) NSString *mobPhone;

/** 是否作为默认收货地址（0否 1是）*/
@property (nonatomic, copy) NSString *isDefault;

/** 省级的id */
@property (nonatomic, copy) NSString *areaId1;

/** 市级的id */
@property (nonatomic, copy) NSString *areaId2;

/** 县级的id */
@property (nonatomic, copy) NSString *areaId;

/** 会员的id  */
@property (nonatomic, copy) NSString *memberId;

/** 地址的id  */
@property (nonatomic, copy) NSString *addressId;

/** 是否选中  */
@property (nonatomic, copy) NSString *Select_string;

@end
