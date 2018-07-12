//
//  PublieTuiJianGoodsListView.h
//  LiTianDecoration
//
//  Created by administrator on 2018/5/11.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HSQGoodsDataListModel;

@protocol PublieTuiJianGoodsListViewDelegate <NSObject>

@optional

/**
 * @brief 为你推荐商品的点击
 */
- (void)TuiJianGoodsListClickAction:(UIButton *)sender commonId:(NSString *)GoodsId;

@end

@interface PublieTuiJianGoodsListView : UIView

/**
 * @brief 数据模型
 */
@property (nonatomic, strong) HSQGoodsDataListModel *model;

/**
 * @brief 设置代理
 */
@property (nonatomic, weak) id<PublieTuiJianGoodsListViewDelegate>delegate;

@end
