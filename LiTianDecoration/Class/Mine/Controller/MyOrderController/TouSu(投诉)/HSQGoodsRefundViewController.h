//
//  HSQGoodsRefundViewController.h
//  LiTianDecoration
//
//  Created by administrator on 2018/6/7.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HSQGoodsRefundViewController : UIViewController

/**
 * @brief 标题
 */
@property (nonatomic, copy) NSString *Navtion_string;

/**
 * @brief 订单号
 */
@property (nonatomic, copy) NSString *ordersId;

/**
 * @brief 商品的id
 */
@property (nonatomic, copy) NSString *Goods_Id;

/**
 * @brief 来源 100代表单个商品退款  200代表订单退款
 */
@property (nonatomic, copy) NSString *source;

@end
