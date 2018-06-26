//
//  HSQYanZhengMobileViewController.h
//  LiTianDecoration
//
//  Created by administrator on 2018/4/26.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HSQYanZhengMobileViewController : UIViewController

/**
* @brief 导航条的标题
*/
@property (nonatomic, copy) NSString *Navtion_Title;

/**
 * @brief 手机号
 */
@property (nonatomic, copy) NSString *MobileString;

/**
 * @brief （1表示注册 2表示登录 3表示找回密码 4表示绑定手机 5表示手机安全认证）
 */
@property (nonatomic, copy) NSString *sendType;

/**
 * @brief 手机是否绑定过
 */
@property (nonatomic, assign) NSInteger IsPhoneBand;

/**
 * @brief 已绑定的手机短信动态码
 */
@property (nonatomic, copy) NSString *oldSmsAuthCode;

@end
