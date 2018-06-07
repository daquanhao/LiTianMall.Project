//
//  HSQOrderGoodsListCell.h
//  LiTianDecoration
//
//  Created by administrator on 2018/5/26.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HSQOrderListSecondCengModel;

@protocol HSQOrderGoodsListCellDelegate <NSObject>

@optional

/**
 * @brief 删除订单
 */
- (void)DeleteOrderButtonClickAction:(UIButton *)sender;

/**
 * @brief 进入店铺
 */
- (void)JoinStoreButtonClickAction:(UIButton *)sender;

/**
 * @brief 取消订单，再次购买，确认收货三种情况的点击事件
 */
- (void)OrderCancelBtnClickAction:(UIButton *)sender;

/**
 * @brief 评价订单
 */
- (void)EvaluationOfTheOrderButtonClickAction:(UIButton *)sender;

@end

@interface HSQOrderGoodsListCell : UITableViewCell

/**
 * @brief 数据模型
 */
@property (nonatomic, strong) HSQOrderListSecondCengModel *model;

/**
 * @brief 设置代理
 */
@property (nonatomic, weak) id<HSQOrderGoodsListCellDelegate>delegate;

@end
