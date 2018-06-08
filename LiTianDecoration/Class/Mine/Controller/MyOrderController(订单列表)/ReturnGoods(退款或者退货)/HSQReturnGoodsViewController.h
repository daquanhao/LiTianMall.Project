//
//  HSQReturnGoodsViewController.h
//  LiTianDecoration
//
//  Created by administrator on 2018/4/30.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HSQReturnGoodsViewController : UIViewController

/**
 * @brief 区分是从哪里进入的 100是从退款界面  200  退货界面  300 投诉界面
 */
@property (nonatomic, copy) NSString *index_Number;

@end
