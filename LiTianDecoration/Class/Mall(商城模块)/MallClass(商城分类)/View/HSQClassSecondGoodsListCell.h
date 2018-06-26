//
//  HSQClassSecondGoodsListCell.h
//  LiTianDecoration
//
//  Created by administrator on 2018/4/30.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HSQGoodsDataListModel;

@protocol HSQClassSecondGoodsListCellDelegate <NSObject>

@optional

- (void)ExpandViewButtonClickAction:(UIButton *)sender;

- (void)JoinStoreDetailButtonClickAction:(UIButton *)sender;

- (void)StoreClosingScoreButtonClickAction:(UIButton *)sender;

- (void)StoreGoodsCollectionButtonClickAction:(UIButton *)sender;

@end

@interface HSQClassSecondGoodsListCell : UICollectionViewCell

/**
 *  0：列表视图，1：格子视图
 */
@property (nonatomic, assign) BOOL isGrid;

/**
 * @brief 商品的数据
 */
@property (nonatomic, strong) NSDictionary *dataDiction;

/**
 * @brief 右边按钮的标题
 */
@property (nonatomic, strong) UIButton *DiscountBtn;

/**
 * @brief 数据模型
 */
@property (nonatomic, strong) HSQGoodsDataListModel *model;

/**
 * @brief 设置代理
 */
@property (nonatomic, weak) id<HSQClassSecondGoodsListCellDelegate>delegate;

@end
