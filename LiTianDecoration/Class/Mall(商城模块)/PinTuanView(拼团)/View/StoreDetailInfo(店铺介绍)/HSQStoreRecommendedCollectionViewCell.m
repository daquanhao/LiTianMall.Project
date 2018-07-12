//
//  HSQStoreRecommendedCollectionViewCell.m
//  LiTianDecoration
//
//  Created by administrator on 2018/5/15.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import "HSQStoreRecommendedCollectionViewCell.h"
#import "HSQTuiJianGoodsListView.h"

@interface HSQStoreRecommendedCollectionViewCell ()<UIScrollViewDelegate,HSQTuiJianGoodsListViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *TitleViews;

@property (nonatomic, weak) UIImageView *indicatorView; // 标签栏底部的红色指示器

@property (nonatomic, weak) UIButton *selectedButton; // 当前选中的按钮

@property (weak, nonatomic) IBOutlet UIScrollView *ScrollerView;

@property (nonatomic, strong)  HSQTuiJianGoodsListView *FirstView;

@property (nonatomic, strong)  HSQTuiJianGoodsListView *SecondView;


@end

@implementation HSQStoreRecommendedCollectionViewCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    self.ScrollerView.pagingEnabled = YES;
    
    self.ScrollerView.delegate = self;
    
    // 设置顶部标题栏
    [self setupTopTitlesView];
    
    // 添加滚动视图的子视图
    [self AddASubviewOfTheScrollView];
    
}

/**
 * @brief 设置顶部标题栏
 */
- (void)setupTopTitlesView{
    
    NSArray *array = @[@"收藏排行",@"销量排行"];
    
    self.ScrollerView.contentSize = CGSizeMake(KScreenWidth * array.count, 0);
    
    // 底部的红色指示器
    UIImageView *indicatorView = [[UIImageView alloc] init];
    indicatorView.backgroundColor = RGB(255, 83, 63);
    indicatorView.mj_h = 2;
    indicatorView.tag = -1;
    indicatorView.mj_y = self.TitleViews.mj_h - indicatorView.mj_h;
    self.indicatorView = indicatorView;
    
    // 内部的子标签
    CGFloat width = KScreenWidth / array.count;
    CGFloat height = self.TitleViews.mj_h;
    for (NSInteger i = 0; i < array.count; i++) {
        
        UIButton *button = [UIButton buttonWithType:(UIButtonTypeCustom)];
        button.tag = i;
        button.mj_h = height;
        button.mj_w = width;
        button.mj_x = i * width;
        
        [button setTitle:array[i] forState:UIControlStateNormal];
                
        [button setTitleColor:RGB(131, 131, 131) forState:UIControlStateNormal];
        
        [button setTitleColor:RGB(255, 83, 63) forState:UIControlStateDisabled];
        
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        
        button.tag = i;
        
        [button addTarget:self action:@selector(titleClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.TitleViews addSubview:button];
        
        // 默认点击了第一个按钮
        if (i == 0)
        {
            button.enabled = NO;
            self.selectedButton = button;
            [button.titleLabel sizeToFit]; // 让按钮内部的label根据文字内容来计算尺寸
            self.indicatorView.mj_w = button.titleLabel.mj_w;
            self.indicatorView.centerX = button.centerX;
        }
    }
    
    [self.TitleViews addSubview:indicatorView];
}

/**
 * @brief 添加滚动视图的子视图
 */
- (void)AddASubviewOfTheScrollView{
    
    HSQTuiJianGoodsListView *FirstView = [[HSQTuiJianGoodsListView alloc] initTuiJianGoodsListView];
    FirstView.backgroundColor = [UIColor whiteColor];
    FirstView.delegate = self;
    [self.ScrollerView addSubview:FirstView];
    self.FirstView = FirstView;
    
    HSQTuiJianGoodsListView *SecondView = [[HSQTuiJianGoodsListView alloc] initTuiJianGoodsListView];
    SecondView.backgroundColor = [UIColor whiteColor];
    SecondView.delegate = self;
    [self.ScrollerView addSubview:SecondView];
    self.SecondView = SecondView;
    
    self.FirstView.sd_layout.leftSpaceToView(self.ScrollerView, 0).topSpaceToView(self.ScrollerView, 0).widthIs(KScreenWidth).heightIs(KScreenWidth*0.6);
    
    self.SecondView.sd_layout.leftSpaceToView(self.ScrollerView, KScreenWidth).topSpaceToView(self.ScrollerView, 0).widthIs(KScreenWidth).heightIs(KScreenWidth*0.6);
    
}

/**
 * @brief 顶部按钮的点击事件
 */
- (void)titleClick:(UIButton *)button{
    
    // 修改按钮状态
    self.selectedButton.enabled = YES;
    
    button.enabled = NO;
    
    self.selectedButton = button;
    
    // 动画
    [UIView animateWithDuration:0.25 animations:^{
        
        self.indicatorView.width = button.titleLabel.mj_w;
        
        self.indicatorView.centerX = button.centerX;
        
    }];
    
    // 滚动
    CGPoint offset = self.ScrollerView.contentOffset;
    
    offset.x = button.tag * KScreenWidth;
    
    [self.ScrollerView setContentOffset:offset animated:YES];
    
}

#pragma mark - <UIScrollViewDelegate>
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    // 点击按钮
    NSInteger index = scrollView.contentOffset.x / KScreenWidth;
    
    [self titleClick:self.TitleViews.subviews[index]];
}

/**
 * @brief 接收上一个界面的数据
 */
- (void)setDataDiction:(NSDictionary *)dataDiction{
    
    _dataDiction = dataDiction;
    
    // 收藏排行
    NSArray *collectdesc = dataDiction[@"storeRankList"][@"collectdesc"];
    self.FirstView.data_Array = collectdesc;
    
    // 销量排行
    NSArray *salenumdesc = dataDiction[@"storeRankList"][@"salenumdesc"];
    self.SecondView.data_Array = salenumdesc;
}

/**
 * @brief 店铺排行榜按钮的点击事件
 */
- (void)ClickOnTheStoreRankingItems:(UIButton *)sender Commid:(NSString *)commid{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(ShopRankingListOfGoodsClickAction:commid:)]) {
        
        [self.delegate ShopRankingListOfGoodsClickAction:sender commid:commid];
    }
}






@end
