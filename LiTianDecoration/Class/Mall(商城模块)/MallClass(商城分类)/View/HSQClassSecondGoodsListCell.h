//
//  HSQClassSecondGoodsListCell.h
//  LiTianDecoration
//
//  Created by administrator on 2018/4/30.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import <UIKit/UIKit.h>

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

@end
