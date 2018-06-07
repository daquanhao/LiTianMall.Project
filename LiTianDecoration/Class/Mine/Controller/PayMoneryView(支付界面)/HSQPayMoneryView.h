//
//  HSQPayMoneryView.h
//  LiTianDecoration
//
//  Created by administrator on 2018/5/26.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HSQPayMoneryViewDelegate <NSObject>

/** 确认支付的按钮的点击事件*/
- (void)ConfirmTheClickEventOfThePayButton:(UIButton *)sender PassWord:(NSString *)PayPassWord;

@end

@interface HSQPayMoneryView : UIView

/**
 * @brief  初始化视图
 */
+ (instancetype)initPayMoneryView;

/**
 * @brief  显示视图
 */
- (void)ShowPayMoneryView;

/**
 * @brief 订单的支付数据
 */
@property (nonatomic, strong) NSDictionary *datas;

/**
 * @brief 设置代理
 */
@property (nonatomic, weak) id<HSQPayMoneryViewDelegate>delegate;

@end
