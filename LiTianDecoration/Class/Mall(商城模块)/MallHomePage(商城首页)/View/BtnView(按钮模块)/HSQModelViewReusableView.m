//
//  HSQModelViewReusableView.m
//  LiTianDecoration
//
//  Created by administrator on 2018/5/7.
//  Copyright © 2018年 administrator. All rights reserved.
//

#define PageCount 10  // 一页显示多少个模块

#define KNumber 10 // 一页显示多少个商品

#define KRows 5  // 一行显示几列

#define KScrollerViewHeight KScreenWidth * 0.4

#import "HSQModelViewReusableView.h"
#import "HSQMallHomeDataModel.h"
#import "HSQCustomButton.h"

@interface HSQModelViewReusableView ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollerView;

@property (nonatomic, strong) UIPageControl *pageControl;

@end

@implementation HSQModelViewReusableView

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor purpleColor];
        
        // 1.添加滚动式图
        [self AddScrollerView];
        
    }
    return self;
}

/**
 * @brief 添加滚动式图
 */
- (void)AddScrollerView{
    
    UIScrollView *scrollerView = [[UIScrollView alloc] initWithFrame:self.bounds];
    scrollerView.backgroundColor = [UIColor whiteColor];
    scrollerView.showsVerticalScrollIndicator = NO;
    scrollerView.showsHorizontalScrollIndicator = NO;
    scrollerView.pagingEnabled = YES;
    scrollerView.delegate = self;
    [self addSubview:scrollerView];
    self.scrollerView = scrollerView;
    
    UIPageControl *PageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, self.mj_h - 20, KScreenWidth, 20)];
    PageControl.backgroundColor = [UIColor whiteColor];
    PageControl.currentPageIndicatorTintColor = [UIColor blackColor];
    PageControl.pageIndicatorTintColor = RGB(180, 180, 180);
    PageControl.currentPage = 0;
    [self addSubview:PageControl];
    self.pageControl = PageControl;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    NSInteger index = scrollView.contentOffset.x / KScreenWidth;
    
    self.pageControl.currentPage = index;
}


/**
 * @brief 接受外界的数据
 */
- (void)setModel:(HSQMallHomeDataModel *)model{
    
    _model = model;
    
    NSInteger countPage = model.itemDataSource.count;
    
    // 计算页数
    NSInteger count = (countPage+ PageCount - 1) / PageCount;
    
    self.pageControl.hidden = (count == 1 ? YES : NO);
    
    self.pageControl.numberOfPages = count;
    
    self.scrollerView.contentSize = CGSizeMake(KScreenWidth * count , self.mj_h);
    
    for (NSInteger i = 0; i < countPage; i++) {
        
        NSDictionary *diction = model.itemDataSource[i];
        
        HSQCustomButton *btn = [HSQCustomButton buttonWithType:(UIButtonTypeCustom)];
        
        btn.mj_size = CGSizeMake(KScreenWidth / KRows, KScreenWidth / KRows);
        
        NSInteger Page = i / KNumber;  // 表示第几页
        
        btn.mj_x = (i % KRows) * btn.mj_size.width + Page * KScreenWidth;
        
        btn.mj_y =  ((i - Page * KNumber) / KRows)  * btn.mj_size.height;
        
        btn.tag = i + 190;
        
        [btn setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
        
        btn.alignmentType = Button_AlignmentStatusTop;
        
        btn.titleLabel.font = [UIFont systemFontOfSize:12.0];
        
        [btn sd_setBackgroundImageWithURL:[NSURL URLWithString:diction[@"imageUrl"]] forState:(UIControlStateNormal)];
//        [btn setTitle:diction[@"type"] forState:(UIControlStateNormal)];
        
        [btn addTarget:self action:@selector(CustomButtonClickAction:) forControlEvents:(UIControlEventTouchUpInside)];
        
        [self.scrollerView addSubview:btn];
    }
}

/**
 * @brief 按钮的点击事件
 */
- (void)CustomButtonClickAction:(UIButton *)sender{
    
    NSDictionary *diction = self.model.itemDataSource[sender.tag - 190];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(HeadModelViewClickAction:type:)]) {
        
        [self.delegate HeadModelViewClickAction:sender type:diction[@"type"]];
    }
}














@end
