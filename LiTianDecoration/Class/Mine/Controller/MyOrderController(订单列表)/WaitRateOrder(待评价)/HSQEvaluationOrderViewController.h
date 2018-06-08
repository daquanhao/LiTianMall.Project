//
//  HSQEvaluationOrderViewController.h
//  LiTianDecoration
//
//  Created by administrator on 2018/5/28.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HSQEvaluationOrderViewController : UIViewController

/**
 * @brief 订单的id
 */
@property (nonatomic, copy) NSString *orderId;

/**
 * @brief 回调评论完成的结果
 */
@property (nonatomic,copy) void(^SelectFirstRateSuccessModel)(id success);


@end
