//
//  HSQPointExchangeGoodsHeadView.h
//  LiTianDecoration
//
//  Created by administrator on 2018/6/25.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HSQPointsOrdersListModel;

@protocol HSQPointExchangeGoodsHeadViewDelegate <NSObject>

- (void)JoinGoodsInStoreHomePageWithBtnClickAction:(UIButton *)sender;

@end

@interface HSQPointExchangeGoodsHeadView : UITableViewHeaderFooterView

/**
 * @brief 数据模型
 */
@property (nonatomic, strong) HSQPointsOrdersListModel *model;

/**
 * @brief 设置代理
 */
@property (nonatomic, weak) id<HSQPointExchangeGoodsHeadViewDelegate> delegate;

/**
 * @brief 店铺的分区
 */
@property (nonatomic, assign) NSInteger section;


@end
