//
//  HSQToPromoteListCell.h
//  LiTianDecoration
//
//  Created by administrator on 2018/4/13.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HSQGoodsDataListModel;

@protocol HSQToPromoteListCellDelegate <NSObject>

/**
 * @brief 列表上立即选取按钮的点击
 */
- (void)AtOnceSelectButtonWithCellList:(UIButton *)sender;

/**
 * @brief 背景视图上立即选取按钮的点击
 */
- (void)AtOnceSelectButtonWithBgViewClickAction:(UIButton *)sender;

/**
 * @brief 背景视图上立即分享按钮的点击
 */
- (void)AtOnceShareButtonWithBgViewClickAction:(UIButton *)sender;

@end

@interface HSQToPromoteListCell : UITableViewCell

@property (nonatomic, weak) id <HSQToPromoteListCellDelegate>delegate;

@property (nonatomic, assign) BOOL IsHiddenBgView;

@property (nonatomic, strong) UILabel *YongJin_Label;  // 商品的佣金

@property (nonatomic, strong) HSQGoodsDataListModel *model;

@end
