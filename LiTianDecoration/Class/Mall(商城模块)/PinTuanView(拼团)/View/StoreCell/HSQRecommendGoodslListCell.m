//
//  HSQRecommendGoodslListCell.m
//  LiTianDecoration
//
//  Created by administrator on 2018/5/10.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import "HSQRecommendGoodslListCell.h"
#import "PublieTuiJianGoodsListView.h"
#import "HSQGoodsDataListModel.h"

@interface HSQRecommendGoodslListCell ()<UIScrollViewDelegate,PublieTuiJianGoodsListViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollerView;

@property (nonatomic, strong) UIPageControl *pageControl;

@property (nonatomic, strong) UIButton *Left_Button;

@property (nonatomic, strong) UIButton *Right_Button;

@property (nonatomic, strong) PublieTuiJianGoodsListView *GoodsListView;

@end

@implementation HSQRecommendGoodslListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        // 添加滚动式图
        [self AddScrollerView];
        
    }
    
    return self;
}

/**
 * @brief 添加滚动式图
 */
- (void)AddScrollerView{
    
    UIButton *leftBtn = [UIButton buttonWithType:(UIButtonTypeSystem)];
    [leftBtn setTitle:@"为你推荐" forState:(UIControlStateNormal)];
    [leftBtn setTitle:@"为你推荐" forState:(UIControlStateDisabled)];
    [leftBtn setTitleColor:RGB(150, 150, 150) forState:(UIControlStateNormal)];
    [leftBtn setTitleColor:RGB(238, 58, 68) forState:(UIControlStateDisabled)];
    leftBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
    leftBtn.frame = CGRectMake(0, 0, KScreenWidth/2, 45);
    leftBtn.tag = 101;
    [leftBtn addTarget:self action:@selector(RecommendToYouBtnClickAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.contentView addSubview:leftBtn];
    self.Left_Button = leftBtn;
    
    UIButton *Right_Button = [UIButton buttonWithType:(UIButtonTypeSystem)];
    [Right_Button setTitle:@"排行榜" forState:(UIControlStateNormal)];
    [Right_Button setTitle:@"排行榜" forState:(UIControlStateDisabled)];
    [Right_Button setTitleColor:RGB(150, 150, 150) forState:(UIControlStateNormal)];
    [Right_Button setTitleColor:RGB(238, 58, 68) forState:(UIControlStateDisabled)];
    Right_Button.titleLabel.font = [UIFont systemFontOfSize:14.0];
    Right_Button.frame = CGRectMake(CGRectGetMaxX(leftBtn.frame), 0, leftBtn.mj_w, leftBtn.mj_h);
    Right_Button.tag = 102;
    [Right_Button addTarget:self action:@selector(RecommendToYouBtnClickAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.contentView addSubview:Right_Button];
    self.Right_Button = Right_Button;
    
    // 底部的滚动式图
    UIScrollView *scrollerView = [[UIScrollView alloc] init];
    scrollerView.showsVerticalScrollIndicator = NO;
    scrollerView.showsHorizontalScrollIndicator = NO;
    scrollerView.pagingEnabled = YES;
    scrollerView.delegate = self;
    [self.contentView addSubview:scrollerView];
    self.scrollerView = scrollerView;
    
    // 分页控制器
    UIPageControl *PageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(scrollerView.frame), KScreenWidth, 20)];
    PageControl.backgroundColor = [UIColor orangeColor];
    PageControl.currentPageIndicatorTintColor = [UIColor blackColor];
    PageControl.pageIndicatorTintColor = RGB(180, 180, 180);
    PageControl.currentPage = 0;
    [self.contentView addSubview:PageControl];
    self.pageControl = PageControl;

    self.scrollerView.sd_layout.leftSpaceToView(self.contentView, 0).topSpaceToView(self.contentView, 50).rightSpaceToView(self.contentView, 0).bottomSpaceToView(self.contentView, 20);
    
    self.pageControl.sd_layout.leftSpaceToView(self.contentView, 0).topSpaceToView(self.scrollerView, 0).rightSpaceToView(self.contentView, 0).bottomSpaceToView(self.contentView, 0);
}

/**
 * @brief 添加推荐商品的列数视图
 */
- (void)setDataSource:(NSMutableArray *)DataSource{
    
    _DataSource = DataSource;
    
    // 计算商品的页数
    NSInteger PageCount = (DataSource.count + KRecommendNumber - 1) / KRecommendNumber;

    self.pageControl.hidden = (PageCount == 1 ? YES : NO);

    self.pageControl.numberOfPages = PageCount;

     self.scrollerView.contentSize = CGSizeMake(KScreenWidth * PageCount , 0);

    // 创建足够数量的图片控件
    while (self.scrollerView.subviews.count < DataSource.count) {
        
        PublieTuiJianGoodsListView *GoodsListView = [[PublieTuiJianGoodsListView alloc] init];
        
        GoodsListView.delegate = self;
        
        [self.scrollerView addSubview:GoodsListView];
    }
    
    // 遍历所有的图片控件，设置图片
    for (int i = 0; i < self.scrollerView.subviews.count; i++)
    {
        PublieTuiJianGoodsListView *GoodsListView = self.scrollerView.subviews[i];
        
        if (i < DataSource.count) { // 显示
            
            GoodsListView.model = DataSource[i];
            
            GoodsListView.hidden = NO;
        }
        else // 隐藏
        {
            GoodsListView.hidden = YES;
        }
    }
}

- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    // 设置图片的尺寸和位置
    NSUInteger photosCount = self.DataSource.count;
    
    for (int i = 0; i < photosCount; i++) {
        
        PublieTuiJianGoodsListView *GoodsListView = self.scrollerView.subviews[i];
        
        CGSize GoodsSize = CGSizeMake(KScreenWidth / KRecommendRows, KScreenWidth/2);

        NSInteger Page = i / KRecommendNumber;  // 表示第几页

        CGFloat GoodsX = (i % KRecommendRows) * GoodsSize.width + Page * KScreenWidth;

        CGFloat GoodsY =  ((i - Page * KRecommendNumber) / KRecommendRows)  * GoodsSize.height;

        GoodsListView.frame = CGRectMake(GoodsX, GoodsY, GoodsSize.width, GoodsSize.height);
        
    }
}

/**
 * @brief 为你推荐商品的点击
 */
- (void)TuiJianGoodsListClickAction:(UIButton *)sender commonId:(NSString *)GoodsId{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(RecommendGoodslListButtonClickAction:goodID:)]) {
        
        [self.delegate RecommendGoodslListButtonClickAction:sender goodID:GoodsId];
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
 * @brief 为你推荐或者排行榜按钮的点击
 */
- (void)RecommendToYouBtnClickAction:(UIButton *)sender{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(RecommendOrRankButtonClickForYou:)]) {
        
        [self.delegate RecommendOrRankButtonClickForYou:sender];
    }
}

/**
 * @brief 选中的第几个
 */
- (void)setSelect_Index:(NSInteger)Select_Index{
    
    _Select_Index = Select_Index;
    
    if (Select_Index == 101)
    {
        self.Left_Button.enabled = NO;
        
        self.Right_Button.enabled = YES;
        
    }
    else
    {
        self.Left_Button.enabled = YES;
        
        self.Right_Button.enabled = NO;
    }
}



- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];

    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

@end
