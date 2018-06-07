//
//  HSQShopCarGoodsGuiGeDataView.h
//  LiTianDecoration
//
//  Created by administrator on 2018/5/21.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HSQShopCarGoodsTypeListModel;

@protocol HSQShopCarGoodsGuiGeDataViewDelegate <NSObject>

@optional

/** 加好按钮的点击事件*/
- (void)AddButtonInShopCarGoodsListCellClickAction:(UIButton *)sender;

/** 减号按钮的点击事件*/
- (void)JianHaoButtonInShopCarGoodsListCellClickAction:(UIButton *)sender;

/** 输入框的点击事件*/
- (void)ShopCarGoodsCountTextFieldInShopCarGoodsListCellClickAction:(UIButton *)sender;

/**小圆点的点击事件*/
- (void)LeftXiaoYuanDianButtonInShopCarGoodsListCellClickAction:(UIButton *)sender;

@end

@interface HSQShopCarGoodsGuiGeDataView : UIView

/**
 * @brief 数据模型
 */
@property (nonatomic, strong) HSQShopCarGoodsTypeListModel *model;


/**
 * @brief 设置代理
 */
@property (nonatomic, weak) id<HSQShopCarGoodsGuiGeDataViewDelegate>delegate;

@end
