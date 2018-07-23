//
//  MobileVerificationLoginViewController.h
//  LiTianDecoration
//
//  Created by administrator on 2018/4/28.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MobileVerificationLoginViewController : UIViewController

/** 用户的手机号*/
@property (nonatomic, copy) NSString *UserPhoneString;

/** 短信的间隔时间*/
@property (nonatomic, copy) NSString *SMS_IntervalTime;

/** 短信的有效时间*/
@property (nonatomic, copy) NSString *SMS_ValidTime;

@end
