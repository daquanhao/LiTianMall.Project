//
//  HSQOrderDetailViewController.h
//  LiTianDecoration
//
//  Created by administrator on 2018/6/1.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HSQOrderDetailViewController : UIViewController

/**
 * @brief 订单的id
 */
@property (nonatomic, copy) NSString *ordersId;

/**
 * @brief 回调处理的结果
 */
@property (nonatomic,copy) void(^OrderDetailTealSuccessModel)(id success);

@end
