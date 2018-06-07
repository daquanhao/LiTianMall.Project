//
//  HSQTuiGoodsAndMoneryListCell.h
//  LiTianDecoration
//
//  Created by administrator on 2018/6/4.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HSQTuiGoodsandMoneryListModel;

@protocol HSQTuiGoodsAndMoneryListCellDelegate <NSObject>

@optional

- (void)RightBtnWithCellClickAction:(UIButton *)sender;

- (void)LeftBtnWithCellClickAction:(UIButton *)sender;

@end

@interface HSQTuiGoodsAndMoneryListCell : UITableViewCell

/**
 * @brief 数据模型
 */
@property (nonatomic, strong) HSQTuiGoodsandMoneryListModel *model;

/**
 * @brief 设置代理
 */
@property (nonatomic, weak) id<HSQTuiGoodsAndMoneryListCellDelegate>delegate;

@end
