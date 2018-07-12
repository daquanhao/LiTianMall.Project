//
//  HSQGuiGeAndCouperView.h
//  LiTianDecoration
//
//  Created by administrator on 2018/5/10.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HSQGuiGeAndCouperViewDelegate <NSObject>

/**
 * @brief 领取优惠券
 */
- (void)ChooseGuiGeAndCoupter:(NSIndexPath *)indexPath templateId:(NSString *)templateId;

@end

@interface HSQGuiGeAndCouperView : UIView

/**
 * @brief 初始化视图
 */
+ (instancetype)initGuiGeAndCouperView;

/**
 * @brief  区分视图的类型 100代表 优惠券 200代表 规格
 */
@property (nonatomic, copy) NSString *TypeString;

/**
 * @brief 头部的标题
 */
@property (nonatomic, copy) NSString *placherString;

/**
 * @brief 店铺ID
 */
@property (nonatomic, copy) NSString *storeId;

/**
 * @brief 显示视图
 */
- (void)ShowGuiGeAndCouperView;

/**
 * @brief 隐藏视图
 */
- (void)dismissAdressView;

/**
 * @brief 设置代理
 */
@property (nonatomic, weak) id<HSQGuiGeAndCouperViewDelegate>delegate;

@end
