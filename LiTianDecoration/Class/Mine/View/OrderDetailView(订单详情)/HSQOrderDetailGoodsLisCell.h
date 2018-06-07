//
//  HSQOrderDetailGoodsLisCell.h
//  LiTianDecoration
//
//  Created by administrator on 2018/6/1.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HSQShopCarGoodsTypeListModel;

@protocol HSQOrderDetailGoodsLisCellDelegate <NSObject>

/** 投诉按钮的点击事件*/
- (void)ComplaintsButtonClickEvent:(UIButton *)sender;

/** 退货按钮的点击事件*/
- (void)ClickEventOnTheReturnButton:(UIButton *)sender;

/** 退款按钮的点击事件*/
- (void)RefundMoneryButtonClickAction:(UIButton *)sender;


@end

@interface HSQOrderDetailGoodsLisCell : UITableViewCell

/**
 * @brief 数据模型
 */
@property (nonatomic, strong) HSQShopCarGoodsTypeListModel *model;

/**
 * @brief 订单的状态
 */
@property (nonatomic, strong) NSDictionary *dataDiction;

/**
 * @brief 设置代理
 */
@property (nonatomic, weak) id<HSQOrderDetailGoodsLisCellDelegate>delegate;

/**
 * @brief 投诉按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *TouSu_Btn;

/**
 * @brief 退货按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *TuiHuo_Btn;

/**
 * @brief 退款按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *TuiKuang_Btn;








@end
