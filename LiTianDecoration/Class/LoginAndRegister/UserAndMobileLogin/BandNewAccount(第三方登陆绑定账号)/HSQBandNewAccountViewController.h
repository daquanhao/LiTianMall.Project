//
//  HSQBandNewAccountViewController.h
//  LiTianDecoration
//
//  Created by administrator on 2018/6/28.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HSQBandNewAccountViewController : UIViewController

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
 * @brief 来源 100 代表是QQ登录  200代表是微信登录
 */
@property (nonatomic, assign) NSInteger Source;

@end
