//
//  HSQStoreRecommendedCollectionViewCell.h
//  LiTianDecoration
//
//  Created by administrator on 2018/5/15.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HSQStoreRecommendedCollectionViewCellDelegate <NSObject>

- (void)ShopRankingListOfGoodsClickAction:(UIButton *)sender commid:(NSString *)commid;

@end

@interface HSQStoreRecommendedCollectionViewCell : UICollectionViewCell

/**
 * @brief 接收上一个界面的数据
 */
@property (nonatomic, strong) NSDictionary *dataDiction;

/**
 * @brief 设置代理
 */
@property (nonatomic, weak) id<HSQStoreRecommendedCollectionViewCellDelegate>delegate;

@end
