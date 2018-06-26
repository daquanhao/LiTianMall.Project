//
//  HSQPointCenterGoodsDetailBannerReusableView.m
//  LiTianDecoration
//
//  Created by administrator on 2018/6/21.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import "HSQPointCenterGoodsDetailBannerReusableView.h"

@interface HSQPointCenterGoodsDetailBannerReusableView ()<SDCycleScrollViewDelegate>

@property (nonatomic, strong) SDCycleScrollView *CycleScrollView;

@property (nonatomic, strong) UILabel *countLabel;

@property (nonatomic, strong) UIView *BgView;


@end

@implementation HSQPointCenterGoodsDetailBannerReusableView

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        UIView *bgView = [[UIView alloc] init];
        
        bgView.backgroundColor = [UIColor whiteColor];
        
        [self addSubview:bgView];
        
        self.BgView = bgView;
        
        // 添加轮播视图
        SDCycleScrollView *CycleScrollView = [[SDCycleScrollView alloc] init];
        
        CycleScrollView.backgroundColor = [UIColor clearColor];
        
        CycleScrollView.pageDotColor = RGB(180, 180, 180);
        
        CycleScrollView.currentPageDotColor = [UIColor whiteColor];
        
        CycleScrollView.placeholderImage = KGoodsPlacherImage;
        
        CycleScrollView.delegate = self;
        
        CycleScrollView.autoScroll = NO;
        
        CycleScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleNone;
        
        [self addSubview:CycleScrollView];
        
        self.CycleScrollView = CycleScrollView;
        
        // 添加计数的label
        UILabel *countLabel = [[UILabel alloc] init];
        
        countLabel.backgroundColor = [UIColor orangeColor];
        
        countLabel.textColor = [UIColor whiteColor];
        
        countLabel.font = [UIFont systemFontOfSize:14];
        
        countLabel.textAlignment = NSTextAlignmentCenter;
        
        [self addSubview:countLabel];
        
        self.countLabel = countLabel;
        
        // 添加轮播视图
        self.BgView.sd_layout.topSpaceToView(self, 0).bottomSpaceToView(self, 0).leftSpaceToView(self, 0).rightSpaceToView(self, 0);
        
        self.CycleScrollView.sd_layout.topSpaceToView(self, 10).bottomSpaceToView(self, 10).leftSpaceToView(self, 10).rightSpaceToView(self, 10);
        
        // 添加计数的label
        self.countLabel.sd_layout.rightSpaceToView(self, 20).bottomSpaceToView(self, 20).widthIs(40).heightEqualToWidth();
        
        [self.countLabel setSd_cornerRadiusFromWidthRatio:@(0.5)];
    }
    
    return self;
}

/**
 * @brief 轮播图数组
 */
-(void)setBanners:(NSMutableArray *)Banners{
    
    _Banners = Banners;
        
    self.CycleScrollView.imageURLStringsGroup = Banners;
    
    self.countLabel.text = [NSString stringWithFormat:@"1/%lu",(unsigned long)Banners.count];
}

/**
 * @brief 轮播视图的点击事件
 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index{
    
    NSInteger countIndex = index + 1;
    
    self.countLabel.text = [NSString stringWithFormat:@"%ld/%lu",(long)countIndex,(unsigned long)self.Banners.count];
}


@end
