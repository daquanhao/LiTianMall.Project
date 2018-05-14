//
//  HSQMallHomeHeadView.m
//  LiTianDecoration
//
//  Created by administrator on 2018/5/7.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import "HSQMallHomeHeadView.h"
#import "HSQMallHomeDataModel.h"

@interface HSQMallHomeHeadView ()<SDCycleScrollViewDelegate>

@property (nonatomic, strong) SDCycleScrollView *CycleScrollView;


@end

@implementation HSQMallHomeHeadView

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor clearColor];
        
        //  添加轮播视图
        [self AddTheRotationView];
    
    }
    
    return self;
}

/**
 * @brief 添加轮播视图
 */
- (void)AddTheRotationView{
    
    SDCycleScrollView *CycleScrollView = [[SDCycleScrollView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenWidth/2)];
    CycleScrollView.backgroundColor = [UIColor clearColor];
    CycleScrollView.pageDotColor = RGB(180, 180, 180);
    CycleScrollView.currentPageDotColor = [UIColor whiteColor];
    CycleScrollView.placeholderImage = [UIImage imageNamed:@"icon3"];
    CycleScrollView.delegate = self;
    [self addSubview:CycleScrollView];
    self.CycleScrollView = CycleScrollView;
}


/**
 * @brief SDCycleScrollViewDelegate
 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickCycleScrollView:didSelectItemAtIndex:)]) {
        
        [self.delegate didClickCycleScrollView:cycleScrollView didSelectItemAtIndex:index];
    }
}

/**
 * @brief 轮播图赋值
 */
- (void)setModel:(HSQMallHomeDataModel *)model{
    
    _model = model;
    
    NSMutableArray *banners = [NSMutableArray array];
    
    for (NSDictionary *diction in model.itemDataSource) {
        
        [banners addObject:diction[@"imageUrl"]];
    }
    
    self.CycleScrollView.imageURLStringsGroup = banners;
}
















@end
