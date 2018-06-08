//
//  HSQTuiGoodAndMoneryDetailViewController.h
//  LiTianDecoration
//
//  Created by administrator on 2018/6/4.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HSQTuiGoodAndMoneryDetailViewController : UIViewController

/**
 * @brief 投诉的id
 */
@property (nonatomic, copy) NSString *complainId;

/**
 * @brief 头部的标题
 */
@property (nonatomic, copy) NSString *Navtion_title;

/**
 * @brief 区分订单的类别，100代表 退款列表 200代表 退货列表  300代表 投诉列表
 */
@property (nonatomic, copy) NSString *Order_Type;

@end
