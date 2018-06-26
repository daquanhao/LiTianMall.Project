//
//  HSQPointsGoodsListViewCell.h
//  LiTianDecoration
//
//  Created by administrator on 2018/6/21.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HSQPointsExchangeGoodsListModel;

@interface HSQPointsGoodsListViewCell : UICollectionViewCell

/**
 * @brief 数据模型
 */
@property (nonatomic, strong) HSQPointsExchangeGoodsListModel *model;

@end
