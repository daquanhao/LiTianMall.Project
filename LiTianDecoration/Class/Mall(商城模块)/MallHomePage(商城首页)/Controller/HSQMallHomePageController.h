//
//  HSQMallHomePageController.h
//  LiTianDecoration
//
//  Created by administrator on 2018/5/8.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HSQMallHomePageController : UIViewController

/**
 * @brief 区分是从哪里进来的 100是从首页进入的   200是从支付成功界面进入的
 */
@property (nonatomic, copy) NSString *Index_Number;

@end
