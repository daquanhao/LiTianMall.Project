//
//  HSQBandMobileViewController.h
//  LiTianDecoration
//
//  Created by administrator on 2018/4/26.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HSQBandMobileViewController : UIViewController

/**
 * @brief 验证的类型 1表示注册 2表示登录 3表示找回密码 4表示绑定手机 5表示手机安全认证
 */
@property (nonatomic, copy) NSString *sendType;

/**
 * @brief 导航栏的标题
 */
@property (nonatomic, copy) NSString *NavtionTitle;

/**
 * @brief 手机号
 */
@property (nonatomic, copy) NSString *MobileString;

/**
 * @brief 来源 100修改密码  200 绑定手机  300 修改支付密码  400修改绑定的手机 500 忘记密码 600预存款提现
 */
@property (nonatomic, assign) NSInteger Source;

@end
