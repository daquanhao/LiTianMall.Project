//
//  HSQPlatformAuditViewController.h
//  LiTianDecoration
//
//  Created by administrator on 2018/6/12.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HSQPlatformAuditViewController : UIViewController

/**
 * @brief 来源
 */
@property (nonatomic, assign) NSInteger source;

/**
 * @brief 被拒绝的原因
 */
@property (nonatomic, copy) NSString *reason;

/**
 * @brief 重新提交的数据
 */
@property (nonatomic, strong) NSDictionary *distributorJoin;

@end
