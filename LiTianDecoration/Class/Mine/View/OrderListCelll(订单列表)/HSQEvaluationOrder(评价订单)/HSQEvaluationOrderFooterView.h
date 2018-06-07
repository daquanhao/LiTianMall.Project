//
//  HSQEvaluationOrderFooterView.h
//  LiTianDecoration
//
//  Created by administrator on 2018/5/28.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HSQEvaluationOrderFooterViewDelegate <NSObject>

@optional

/**
 * @brief 提交评价的按钮点击
 */
- (void)SubmitOrderRateContentButtonClickAction:(UIButton *)sender;

/**
 * @brief 商品描述星星的点击事件
 */
- (void)TheProductDescribesTheStarClickEvent:(UIButton *)sender StarCount:(NSInteger)Count;

/**
 * @brief 商品服务态度星星的点击事件
 */
- (void)CommodityServiceAttitudeStarClickEvent:(UIButton *)sender StarCount:(NSInteger)count;

/**
 * @brief 商品发货速度星星的点击事件
 */
- (void)ProductDeliverySpeedStarClickEvent:(UIButton *)sender StarCount:(NSInteger)count;

@end

@interface HSQEvaluationOrderFooterView : UITableViewHeaderFooterView

/**
 * @brief 设置代理
 */
@property (nonatomic, weak) id<HSQEvaluationOrderFooterViewDelegate>delegate;

/**
 * @brief 描述相符界面
 */
@property (weak, nonatomic) IBOutlet UIView *First_View;

/**
 * @brief 服务态度界面
 */
@property (weak, nonatomic) IBOutlet UIView *SecondView;

/**
 * @brief 发货速度界面
 */
@property (weak, nonatomic) IBOutlet UIView *Third_View;

@end
