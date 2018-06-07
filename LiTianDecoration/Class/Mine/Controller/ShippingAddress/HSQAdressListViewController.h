//
//  HSQAdressListViewController.h
//  LiTianDecoration
//
//  Created by administrator on 2018/4/25.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HSQAdressListViewController : UIViewController

/**
 * @brief 回调选中的地址
 */
@property (nonatomic,copy) void(^SelectAdressModel)(id success);

/**
 * @brief 判断是从哪里舔砖过来的
 */
@property (nonatomic, copy) NSString *Source;

@end
