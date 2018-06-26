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

/**
 * @brief 发送类型 1表示注册 2表示登录 3表示找回密码 4表示绑定手机 5表示手机安全认证
 */
@property (nonatomic, copy) NSString *sendType;

/**
 * @brief 来源 100修改密码  200 绑定手机  300 修改支付密码  400修改绑定的手机
 */
@property (nonatomic, assign) NSInteger Source;

/**
 * @brief 手机是否绑定过
 */
@property (nonatomic, assign) NSInteger IsPhoneBand;

/**
 * @brief 已绑定的手机短信动态码
 */
@property (nonatomic, copy) NSString *oldSmsAuthCode;

@end
