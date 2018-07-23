//
//  HSQNextBandPhoneViewController.h
//  LiTianDecoration
//
//  Created by administrator on 2018/4/26.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HSQNextBandPhoneViewController : UIViewController

/** 动态码的有效时间（分钟） */
@property (nonatomic, copy) NSString *authCodeValidTime;

/** 动态码的重发间隔秒数 */
@property (nonatomic, copy) NSString *authCodeResendTime;

/** 导航栏的标示*/
@property (nonatomic, copy) NSString *NavtionTitle;

/** 用户的手机号*/
@property (nonatomic, copy) NSString *UserMobile;

@end
