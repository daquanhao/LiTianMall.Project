//
//  HSQShopCarGoodsGuiGeListView.h
//  LiTianDecoration
//
//  Created by administrator on 2018/5/21.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HSQShopCarGoodsGuiGeListViewDelegate <NSObject>

@optional

/** 加好按钮的点击事件*/
- (void)AddButtonInhopCarGoodsGuiGeListViewClickAction:(UIButton *)sender;

/** 减号按钮的点击事件*/
- (void)JianHaoButtonInhopCarGoodsGuiGeListViewClickAction:(UIButton *)sender;

/** 输入框的点击事件*/
- (void)ShopCarGoodsCountTextFieldInhopCarGoodsGuiGeListViewClickAction:(UIButton *)sender;

/**小圆点的点击事件*/
- (void)LeftXiaoYuanDianButtonInhopCarGoodsGuiGeListViewClickAction:(UIButton *)sender;

@end

@interface HSQShopCarGoodsGuiGeListView : UIView

@property (nonatomic, strong) NSArray *GuiGeData_Array;

/**
 * @brief 根据数组返回view的尺寸
 */
+(CGSize)SizeWithDataModelArray:(NSArray *)dataSource;

/**
 * @brief 设置代理
 */
@property (nonatomic, weak) id<HSQShopCarGoodsGuiGeListViewDelegate>delegate;


@end
