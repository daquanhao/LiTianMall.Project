//
//  HSQPointExchangeOrderDetailHeadView.h
//  LiTianDecoration
//
//  Created by administrator on 2018/6/25.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HSQPointsOrdersListModel;

@protocol HSQPointExchangeOrderDetailHeadViewDelegate <NSObject>

- (void)JoinStoreDetailButtonClickAction:(UIButton *)sender;

@end

@interface HSQPointExchangeOrderDetailHeadView : UITableViewHeaderFooterView

/**
 * @brief 数据
 */
@property (nonatomic, strong) HSQPointsOrdersListModel *model;

/**
 * @brief 设置代理
 */
@property (nonatomic, weak) id <HSQPointExchangeOrderDetailHeadViewDelegate>delegate;

@end
