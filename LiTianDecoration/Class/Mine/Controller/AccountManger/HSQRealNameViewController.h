//
//  HSQRealNameViewController.h
//  LiTianDecoration
//
//  Created by administrator on 2018/4/18.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^UserRealNameBlock)(id string);

@interface HSQRealNameViewController : UIViewController

@property (nonatomic, copy) UserRealNameBlock RealNameBlock;

/**
 * @breif 用户的真实姓名
 */
@property (nonatomic, copy) NSString *RealName_String;

@end
