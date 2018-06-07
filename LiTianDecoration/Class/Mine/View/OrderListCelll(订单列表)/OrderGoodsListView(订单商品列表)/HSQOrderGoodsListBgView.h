//
//  HSQOrderGoodsListBgView.h
//  LiTianDecoration
//
//  Created by administrator on 2018/5/26.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HSQOrderGoodsListBgView : UIView

/**
 * @brief 数据模型数组
 */
@property (nonatomic, strong) NSArray *OrderGoodsList_Array;

/**
 * @brief 根据数组返回view的尺寸
 */
+(CGSize)SizeWithDataModelArray:(NSArray *)dataSource;

@end
