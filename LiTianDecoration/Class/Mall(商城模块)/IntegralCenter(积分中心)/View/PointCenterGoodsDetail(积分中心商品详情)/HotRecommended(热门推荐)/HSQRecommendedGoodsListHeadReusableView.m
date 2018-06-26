//
//  HSQRecommendedGoodsListHeadReusableView.m
//  LiTianDecoration
//
//  Created by administrator on 2018/6/21.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import "HSQRecommendedGoodsListHeadReusableView.h"
#import "HSQRecommendedGoodsView.h"

@interface HSQRecommendedGoodsListHeadReusableView ()<HSQRecommendedGoodsViewDelegate>

@property (nonatomic, strong) HSQRecommendedGoodsView *RecommendedGoodsView;



@end

@implementation HSQRecommendedGoodsListHeadReusableView

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        HSQRecommendedGoodsView *RecommendedGoodsView = [[HSQRecommendedGoodsView alloc] init];
        
        RecommendedGoodsView.frame = CGRectMake(0, 0, KScreenWidth, ((KScreenWidth - 10) / 3 + 50) * 2 + 10);
        
        RecommendedGoodsView.delegate = self;
        
        [self addSubview:RecommendedGoodsView];
        
        self.RecommendedGoodsView = RecommendedGoodsView;
    }
    
    return self;
}

/**
 * @brief 数据源
 */
- (void)setDataSource:(NSMutableArray *)dataSource{
    
    _dataSource = dataSource;
    
    self.RecommendedGoodsView.dataSource = dataSource;
}

/**
 * @brief 推荐商品的点击
 */
- (void)recommendationGoodsButtonClickAction:(UIButton *)sender{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(ClickEventsForRecommendationItems:)]) {
        
        [self.delegate ClickEventsForRecommendationItems:sender];
    }
}


@end
