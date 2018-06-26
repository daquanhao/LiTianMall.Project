//
//  HSQRecommendGoodslListCell.m
//  LiTianDecoration
//
//  Created by administrator on 2018/5/10.
//  Copyright © 2018年 administrator. All rights reserved.
//

#define KNumber 6 // 一页显示多少个商品
#define KRows 3  // 一行显示几列

#import "HSQRecommendGoodslListCell.h"
#import "PublieTuiJianGoodsListView.h"

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
    leftBtn.enabled = NO;
    [leftBtn setTitleColor:RGB(150, 150, 150) forState:(UIControlStateNormal)];
    [leftBtn setTitleColor:RGB(238, 58, 68) forState:(UIControlStateDisabled)];
    leftBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
    leftBtn.frame = CGRectMake(0, 0, KScreenWidth/2, 50);
    [self.contentView addSubview:leftBtn];
    self.Left_Button = leftBtn;
    
    UIButton *Right_Button = [UIButton buttonWithType:(UIButtonTypeSystem)];
    [Right_Button setTitle:@"排行榜" forState:(UIControlStateNormal)];
    [Right_Button setTitle:@"排行榜" forState:(UIControlStateDisabled)];
    [Right_Button setTitleColor:RGB(150, 150, 150) forState:(UIControlStateNormal)];
    [Right_Button setTitleColor:RGB(238, 58, 68) forState:(UIControlStateDisabled)];
    Right_Button.titleLabel.font = [UIFont systemFontOfSize:14.0];
    Right_Button.frame = CGRectMake(KScreenWidth/2, 0, KScreenWidth/2, 50);
    [self.contentView addSubview:Right_Button];
    self.Right_Button = Right_Button;
    
    UIScrollView *scrollerView = [[UIScrollView alloc] init];
    scrollerView.showsVerticalScrollIndicator = NO;
    scrollerView.showsHorizontalScrollIndicator = NO;
    scrollerView.pagingEnabled = YES;
    scrollerView.delegate = self;
    [self.contentView addSubview:scrollerView];
    self.scrollerView = scrollerView;
    
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
    
    for (NSInteger i = 0; i < DataSource.count; i++) {
        
        // 计算商品的页数
        NSInteger PageCount = (DataSource.count + KNumber - 1) / KNumber;
        
        self.pageControl.hidden = (PageCount == 1 ? YES : NO);
        
        self.pageControl.numberOfPages = PageCount;
        
         self.scrollerView.contentSize = CGSizeMake(KScreenWidth * PageCount , 0);
        
        for (NSInteger i = 0; i < DataSource.count; i++) {
            
            NSDictionary *diction = DataSource[i];
            
            CGSize GoodsSize = CGSizeMake(KScreenWidth / KRows, KScreenWidth/2);

            NSInteger Page = i / KNumber;  // 表示第几页
            
            CGFloat GoodsX = (i % KRows) * GoodsSize.width + Page * KScreenWidth;
            
            CGFloat GoodsY =  ((i - Page * KNumber) / KRows)  * GoodsSize.height;
            
            PublieTuiJianGoodsListView *GoodsListView = [[PublieTuiJianGoodsListView alloc] initWithFrame:CGRectMake(GoodsX, GoodsY, GoodsSize.width, GoodsSize.height)];
            
            GoodsListView.dataDiction = diction;
            
            GoodsListView.delegate = self;
    
            [self.scrollerView addSubview:GoodsListView];
        }
        
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








- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];

    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

@end
