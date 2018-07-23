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

/** 为你推荐商品的点击*/
- (void)RecommendGoodslListButtonClickAction:(UIButton *)sender goodID:(NSString *)commonId;

@end

@interface HSQRecommendGoodslListCell : UITableViewCell

@property (nonatomic, strong) NSMutableArray *DataSource;

@property (nonatomic, weak) id<HSQRecommendGoodslListCellDelegate>delegate;

@end
