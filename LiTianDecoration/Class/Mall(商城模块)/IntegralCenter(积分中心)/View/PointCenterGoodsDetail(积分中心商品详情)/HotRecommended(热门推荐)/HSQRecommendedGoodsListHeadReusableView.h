//
//  HSQRecommendedGoodsListHeadReusableView.h
//  LiTianDecoration
//
//  Created by administrator on 2018/6/21.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HSQRecommendedGoodsListHeadReusableViewDelegate <NSObject>

- (void)ClickEventsForRecommendationItems:(UIButton *)sender;

@end

@interface HSQRecommendedGoodsListHeadReusableView : UICollectionReusableView

/**
 * @brief 数据原数组
 */
@property (nonatomic, strong) NSMutableArray *dataSource;

/**
 * @brief 设置代理
 */
@property (nonatomic, weak) id<HSQRecommendedGoodsListHeadReusableViewDelegate>delegate;

@end
