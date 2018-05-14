//
//  HSQCouponsHomeViewController.h
//  LiTianDecoration
//
//  Created by administrator on 2018/4/29.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HSQCouponsHomeViewController : UIViewController

/** 导航栏的标题*/
@property (nonatomic, copy) NSString *Navtion_Title;

/** 左边的头部标题*/
@property (nonatomic, copy) NSString *LeftTop_Title;

/** 右边的头部标题*/
@property (nonatomic, copy) NSString *RightTop_Title;

/** 区分是平台券，还是店铺券 100代表店铺券  200代表平台券*/
@property (nonatomic, copy) NSString *ID_Number;

@end
