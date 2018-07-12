//
//  MVGoodsDetailCommentListViewCell.h
//  LiTianDecoration
//
//  Created by administrator on 2018/7/5.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HSQGoodsRateListModel;

@interface MVGoodsDetailCommentListViewCell : UITableViewCell

/**
 * @brief 数据模型
 */
@property (nonatomic, strong) HSQGoodsRateListModel *model;

/**
 * @brief cell的高度
 */
@property (nonatomic, assign) CGFloat CellHeight;

@end
