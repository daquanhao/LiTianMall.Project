//
//  HSQSelecttheInvoiceViewController.h
//  LiTianDecoration
//
//  Created by administrator on 2018/6/5.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HSQSelecttheInvoiceViewController : UIViewController

/**
 * @brief 选中的发票
 */
@property (nonatomic, strong) NSMutableDictionary *FaPiaoDiction;

/**
 * @brief 回调选中的地址
 */
@property (nonatomic,copy) void(^SelectFaPiaoDataBlock)(id success);

@end
