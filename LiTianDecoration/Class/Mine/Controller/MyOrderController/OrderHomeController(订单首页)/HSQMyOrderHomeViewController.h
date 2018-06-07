//
//  HSQMyOrderHomeViewController.h
//  LiTianDecoration
//
//  Created by administrator on 2018/4/29.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HSQMyOrderHomeViewController : UIViewController

/** 区分是从哪里跳转进来的*/
@property (nonatomic, copy) NSString *indexNumber;

/**
 * @brief 区分是从我的界面进入的，还是从提交订单界面进入的 100是从提交订单界面进入的  200是从我的界面进入的
 */
@property (nonatomic, copy) NSString *JumpType_string;

@end
