//
//  HSQChangeLoginPassWordViewController.h
//  LiTianDecoration
//
//  Created by administrator on 2018/6/13.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HSQChangeLoginPassWordViewController : UIViewController

/**
 * @brief 导航条的标题
 */
@property (nonatomic, copy) NSString *Navtion_title;

/**
 * @brief 短信动态码
 */
@property (nonatomic, copy) NSString *smsAuthCode;

/**
 * @brief 来源 100 代表修改登录密码  200设置支付密码
 */
@property (nonatomic, assign) NSInteger source;

@end
