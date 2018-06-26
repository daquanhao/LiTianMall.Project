//
//  HSQMobileRegisterViewController.h
//  LiTianDecoration
//
//  Created by administrator on 2018/4/28.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HSQMobileRegisterViewController : UIViewController

/**
 * @brief 用户的手机号
 */
@property (nonatomic, copy) NSString *PhoneString;

/**
 * @brief 短信的间隔时间
 */
@property (nonatomic, copy) NSString *SMS_IntervalTime;

/**
 * @brief 短信的有效时间
 */
@property (nonatomic, copy) NSString *SMS_ValidTime;


@end
