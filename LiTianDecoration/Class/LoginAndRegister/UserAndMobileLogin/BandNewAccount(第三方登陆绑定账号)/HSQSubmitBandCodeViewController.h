//
//  HSQSubmitBandCodeViewController.h
//  LiTianDecoration
//
//  Created by administrator on 2018/6/28.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HSQSubmitBandCodeViewController : UIViewController

/**
 * @brief 用户的手机号
 */
@property (nonatomic, copy) NSString *UserPhoneString;

/**
 * @brief 短信的间隔时间
 */
@property (nonatomic, copy) NSString *SMS_IntervalTime;

/**
 * @brief 短信的有效时间
 */
@property (nonatomic, copy) NSString *SMS_ValidTime;

/**
 * @brief 友盟返回的accessToken
 */
@property (nonatomic, copy) NSString *accessToken;

/**
 * @brief 友盟返回的openId
 */
@property (nonatomic, copy) NSString *openId;

/**
 * @brief 在腾讯开放平台申请应用的appId
 */
@property (nonatomic, copy) NSString *appId;

/**
 * @brief 来源 100是QQ绑定  200是微信绑定
 */
@property (nonatomic, assign) NSInteger Source;

@end
