//
//  HSQPayMonerySuccessViewController.h
//  LiTianDecoration
//
//  Created by administrator on 2018/6/6.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HSQPayMonerySuccessViewController : UIViewController

/**
 * @brief 支付的id
 */
@property (nonatomic, copy) NSString *payId;

/**
 * @brief 支付是否成功的标示
 */
@property (nonatomic, copy) NSString *Code;

/**
 * @brief 来源
 */
@property (nonatomic, copy) NSString *Source;

@end
