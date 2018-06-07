//
//  HSQMallShopCarViewController.h
//  LiTianDecoration
//
//  Created by administrator on 2018/5/8.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HSQMallShopCarViewController : UIViewController

/**
 * @brief 区分是从哪里进来的 100来自订单，200来自商品详情
 */
@property (nonatomic, copy) NSString *source;

@end
