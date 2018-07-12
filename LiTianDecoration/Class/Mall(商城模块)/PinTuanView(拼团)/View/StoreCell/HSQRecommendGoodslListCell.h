//
//  HSQRecommendGoodslListCell.h
//  LiTianDecoration
//
//  Created by administrator on 2018/5/10.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HSQRecommendGoodslListCellDelegate <NSObject>

@optional

/**
 * @brief 为你推荐商品的点击
 */
- (void)RecommendGoodslListButtonClickAction:(UIButton *)sender goodID:(NSString *)commonId;

/**
 * @brief 为你推荐或者排行榜按钮的点击
 */
- (void)RecommendOrRankButtonClickForYou:(UIButton *)sender;

@end

@interface HSQRecommendGoodslListCell : UITableViewCell

/**
 * @brief 数据
 */
@property (nonatomic, strong) NSMutableArray *DataSource;

/**
 * @brief 选中的第几个
 */
@property (nonatomic, assign) NSInteger Select_Index;

/**
 * @brief 设置代理
 */
@property (nonatomic, weak) id<HSQRecommendGoodslListCellDelegate>delegate;

@end
