//
//  HSQIntegralListViewController.h
//  LiTianDecoration
//
//  Created by administrator on 2018/4/28.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HSQIntegralListViewController : UIViewController

/** 会员的积分或者经验值*/
@property (nonatomic, copy) NSString *IntegralCount;

/** 会员的积分或者经验值的数据接口*/
@property (nonatomic, copy) NSString *DataUrl;

/** 导航栏的标题*/
@property (nonatomic, copy) NSString *Navtion_Title;

/** 头部的标题 */
@property (nonatomic, copy) NSString *Top_Title;



@end
