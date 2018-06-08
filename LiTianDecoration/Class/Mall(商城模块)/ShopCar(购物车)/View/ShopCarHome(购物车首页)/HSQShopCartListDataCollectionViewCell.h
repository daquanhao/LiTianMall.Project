//
//  HSQShopCartListDataCollectionViewCell.h
//  LiTianDecoration
//
//  Created by administrator on 2018/5/21.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HSQShopCarVCSecondGoodsDataModel;

@protocol HSQShopCartListDataCollectionViewCellDelegate <NSObject>

@optional

/** 左边小圆圈的点击事件 */
- (void)LeftXiaoYuanQuanButtonClickAction:(UIButton *)sender;

/** 加好按钮的点击事件*/
- (void)AddButtonInShopCartListDataCollectionViewCellClickAction:(UIButton *)sender;

/** 减号按钮的点击事件*/
- (void)JianHaoButtonInShopCartListDataCollectionViewCellClickAction:(UIButton *)sender;

/** 输入框的点击事件*/
- (void)ShopCarGoodsCountTextFieldInShopCartListDataCollectionViewCellClickAction:(UIButton *)sender;

/**小圆点的点击事件*/
- (void)LeftXiaoYuanDianButtonInShopCartListDataCollectionViewCellClickAction:(UIButton *)sender;

@end

@interface HSQShopCartListDataCollectionViewCell : UICollectionViewCell

@property (nonatomic, weak) id <HSQShopCartListDataCollectionViewCellDelegate>delegate;

/**
 * @brief 数据模型
 */
@property (nonatomic, strong) HSQShopCarVCSecondGoodsDataModel *SecondModel;


@end
