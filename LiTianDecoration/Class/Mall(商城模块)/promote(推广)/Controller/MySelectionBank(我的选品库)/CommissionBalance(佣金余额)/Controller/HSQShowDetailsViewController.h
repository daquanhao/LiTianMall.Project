//
//  HSQShowDetailsViewController.h
//  LiTianDecoration
//
//  Created by administrator on 2018/6/15.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HSQShowDetailsViewController : UIViewController

/**
 * @brief 提现ID
 */
@property (nonatomic, copy) NSString *cashId;

/**
 * @brief 来源 100来源于提现列表  200 申请提现界面
 */
@property (nonatomic, assign) NSInteger source;

@end
