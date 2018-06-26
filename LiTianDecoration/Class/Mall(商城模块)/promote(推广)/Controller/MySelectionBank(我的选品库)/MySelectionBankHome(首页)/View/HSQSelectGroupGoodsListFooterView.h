//
//  HSQSelectGroupGoodsListFooterView.h
//  LiTianDecoration
//
//  Created by administrator on 2018/6/14.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HSQSelectGroupGoodsListFooterViewDelegate <NSObject>

/**
 * @brief 删除
 */
- (void)DeleteItemsFromTheInventory:(UIButton *)sender;

/**
 * @brief 移动
 */
- (void)MoveItemsFromTheInventory:(UIButton *)sender;

/**
 * @brief 立即推广
 */
- (void)ImmediatelyPromoteTheProductsInTheSelectionBank:(UIButton *)sender;

@end


@interface HSQSelectGroupGoodsListFooterView : UITableViewHeaderFooterView

/**
 * @brief 标记
 */
@property (nonatomic, assign) NSInteger section;

/**
 * @brief 设置代理
 */
@property (nonatomic, weak) id<HSQSelectGroupGoodsListFooterViewDelegate>delegate;

@end
