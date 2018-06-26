//
//  HSQRecommendedGoodsView.m
//  LiTianDecoration
//
//  Created by administrator on 2018/6/21.
//  Copyright © 2018年 administrator. All rights reserved.
//

#define HWStatusPhotoW KScreenWidth / 3

#define HWStatusPhotoH ((KScreenWidth - 10) / 3 + 50) - 5

#define KNumber 6 // 一页显示多少个商品

#define KRows 3  // 一行显示几列

#import "HSQRecommendedGoodsView.h"
#import "HSQRecommendedGoodsListView.h"
#import "HSQPointsExchangeGoodsListModel.h"

@interface HSQRecommendedGoodsView ()<UIScrollViewDelegate>

@property (nonatomic, weak) UIScrollView *contentView;

@property (nonatomic, strong) UIPageControl *pageControl;

@property (nonatomic, strong) UIButton *Bg_Button;

@end

@implementation HSQRecommendedGoodsView

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        // 设置底布滚动控制器
        UIScrollView *contentView = [[UIScrollView alloc] init];
        
        contentView.showsVerticalScrollIndicator = NO;
        
        contentView.showsHorizontalScrollIndicator = NO;
                
        contentView.delegate = self;
        
        contentView.pagingEnabled = YES;
        
        contentView.frame = CGRectMake(0, 0, KScreenWidth, ((KScreenWidth - 10) / 3 + 50) * 2 - 10);
                
        [self addSubview:contentView];
        
        self.contentView = contentView;
        
        // 分页控制器
        UIPageControl *PageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(contentView.frame), KScreenWidth, 10)];
        
        PageControl.backgroundColor = [UIColor orangeColor];
        
        PageControl.currentPageIndicatorTintColor = [UIColor blackColor];
        
        PageControl.pageIndicatorTintColor = RGB(180, 180, 180);
        
        PageControl.currentPage = 0;
        
        [self.contentView addSubview:PageControl];
        
        self.pageControl = PageControl;
    }
    
    return self;
}


/**
 * @brief 数据原数组
 */
- (void)setDataSource:(NSMutableArray *)dataSource{
    
    _dataSource = dataSource;
    
    // 计算商品的页数
    NSInteger PageCount = (dataSource.count + KNumber - 1) / KNumber;
    
    self.pageControl.hidden = (PageCount == 1 ? YES : NO);
    
    self.pageControl.numberOfPages = PageCount;
    
    self.contentView.contentSize = CGSizeMake(KScreenWidth * PageCount , 0);
    
    for (NSInteger i = 0; i < dataSource.count; i++) {
        
        HSQPointsExchangeGoodsListModel *model = dataSource[i];
        
        CGSize GoodsSize = CGSizeMake(HWStatusPhotoW, HWStatusPhotoH);
        
        NSInteger Page = i / KNumber;  // 表示第几页
        
        CGFloat GoodsX = (i % KRows) * GoodsSize.width + Page * KScreenWidth;
        
        CGFloat GoodsY =  ((i - Page * KNumber) / KRows)  * GoodsSize.height;
        
        HSQRecommendedGoodsListView *GoodsListView = [[HSQRecommendedGoodsListView alloc] initWithFrame:CGRectMake(GoodsX, GoodsY, GoodsSize.width, GoodsSize.height)];
        
        GoodsListView.model = model;
        
        [self.contentView addSubview:GoodsListView];
        
        // 按钮
        UIButton *Bg_Button = [UIButton buttonWithType:(UIButtonTypeSystem)];
        
        [Bg_Button addTarget:self action:@selector(Bg_ButtonClickAction:) forControlEvents:(UIControlEventTouchUpInside)];
        
        Bg_Button.frame = CGRectMake(GoodsX, GoodsY, GoodsSize.width, GoodsSize.height);
        
        Bg_Button.tag = i;
        
        [self addSubview:Bg_Button];
        
        self.Bg_Button = Bg_Button;
    }
}

/**
 * @brief UIScrollViewDelegate
 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    NSInteger number = scrollView.contentOffset.x / KScreenWidth;
    
    self.pageControl.currentPage = number;
    
}

/**
 * @brief 按钮的点击事件
 */
- (void)Bg_ButtonClickAction:(UIButton *)sender{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(recommendationGoodsButtonClickAction:)]) {
        
        [self.delegate recommendationGoodsButtonClickAction:sender];
    }
}





@end
