//
//  HSQAvailableToPayTypeView.h
//  LiTianDecoration
//
//  Created by administrator on 2018/6/6.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HSQAvailableToPayTypeViewDelegate <NSObject>

/** 稍后支付按钮的点击事件*/
- (void)TheClickEventOfThePayButtonLater:(UIButton *)sender;

/** 确认支付按钮的点击事件*/
- (void)ConfirmTheClickEventOfThePaymentButton:(UIButton *)sender PassWord:(NSString *)PayPassWord;

@end

@interface HSQAvailableToPayTypeView : UIView

/**
 * @brief 设置代理
 */
@property (nonatomic, weak) id<HSQAvailableToPayTypeViewDelegate>delegate;

/**
 * @brief 支付方式的数据
 */
@property (nonatomic, strong) NSDictionary *datas;

@end
