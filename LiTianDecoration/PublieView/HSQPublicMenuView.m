//
//  HSQPublicMenuView.m
//  LiTianDecoration
//
//  Created by administrator on 2018/4/13.
//  Copyright © 2018年 administrator. All rights reserved.
//

#define KShowCount 5

#define KLinecount 4

#import "HSQPublicMenuView.h"
#import "HSQLeftCategoryModel.h"

@interface HSQPublicMenuView ()

@property (nonatomic, strong) UIButton *Select_Btn;

@property (nonatomic, strong) UIButton *Right_Btn; // 右边的箭头按钮

@property (nonatomic, strong) UIView *indicatorView;  // 红色的指示器

@property (nonatomic, strong) UIScrollView *scrollerView;

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UIView *White_bgView;

@property (nonatomic, strong) UIButton *MenuSelect_Btn;

@property (nonatomic, assign) NSInteger index;

@property (nonatomic, assign) CGFloat MenuViewHeight;

@property (nonatomic, assign) NSInteger indexnumber;

@end

@implementation HSQPublicMenuView

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        // 1.右边的箭头按钮
        [self AddRightButton];
        
        // 2.创建底部的滚动视图
        [self SetUpScrollerView];
        
    }
    
    return self;
}


/**
 * @brief 右边的箭头按钮
 */
- (void)AddRightButton{
    
    UIButton *Right_Btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    
    [Right_Btn setImage:KImageName(@"123") forState:(UIControlStateNormal)];
    
    Right_Btn.frame = CGRectMake(KScreenWidth - self.frame.size.height, 0, self.frame.size.height, self.frame.size.height);
    
    [Right_Btn addTarget:self action:@selector(Right_BtnClickAction:) forControlEvents:(UIControlEventTouchUpInside)];
    
    [self addSubview:Right_Btn];
    
    self.Right_Btn = Right_Btn;
}

/**
 * @brief 创建底部的滚动视图
 */
- (void)SetUpScrollerView{
    
    UIScrollView *scrollerView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth - self.frame.size.height, self.frame.size.height)];
    
    scrollerView.showsVerticalScrollIndicator = NO;
    
    scrollerView.showsHorizontalScrollIndicator = NO;
    
    scrollerView.backgroundColor = [UIColor whiteColor];
    
    scrollerView.scrollEnabled = YES;
    
    [self addSubview:scrollerView];
    
    self.scrollerView = scrollerView;
    
    // 底部的红色指示器
    UIView *indicatorView = [[UIImageView alloc] init];
    
    indicatorView.backgroundColor = RGB(255, 83, 63);
    
    indicatorView.mj_h = 2;
    
    indicatorView.tag = -1;
    
    indicatorView.mj_y = scrollerView.mj_h - indicatorView.mj_h;
    
    self.indicatorView = indicatorView;
    
}

- (void)setDataSource:(NSMutableArray *)dataSource{
    
    _dataSource = dataSource;
    
    [self AddTitleButtonWithDataSource:dataSource];
    
    [self CreatMenuViewWithDataSource:dataSource];
}

/**
 * @brief 添加标题按钮
 */
- (void)AddTitleButtonWithDataSource:(NSMutableArray *)title_array{
    
//    self.scrollerView.contentSize = CGSizeMake(title_array.count * self.scrollerView.size.width / KShowCount , self.frame.size.height);
    
    CGFloat contentW = 0;
    
    CGFloat ButtonX = 0;
    
    for (NSInteger i = 0; i < title_array.count; i++) {
        
        HSQLeftCategoryModel *model = title_array[i];
        
        UIButton *title_btn = [UIButton buttonWithType:(UIButtonTypeSystem)];
        
       [title_btn setTitle:model.categoryName forState:(UIControlStateNormal)];
        
        [title_btn setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
        
        [title_btn setTitleColor:[UIColor redColor] forState:(UIControlStateDisabled)];
        
        title_btn.titleLabel.font = [UIFont systemFontOfSize:KLabelFont(14.0, 12.0)];
        
        title_btn.tag = i;
        
//        title_btn.frame = CGRectMake(i * self.scrollerView.size.width / KShowCount, 0, self.scrollerView.size.width / KShowCount, self.scrollerView.size.height - self.indicatorView.size.height);
        
        CGSize Title_Size = [NSString SizeOfTheText:model.categoryName font:[UIFont systemFontOfSize:KLabelFont(14.0, 12.0)] MaxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
        
        if (i == 0)
        {
            ButtonX = 10;
        }
        else
        {
            HSQLeftCategoryModel *model = title_array[i - 1];
            
            CGSize Title_Size = [NSString SizeOfTheText:model.categoryName font:[UIFont systemFontOfSize:KLabelFont(14.0, 12.0)] MaxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
            
            ButtonX = ButtonX + Title_Size.width + 10;
        }
        
        title_btn.frame = CGRectMake(ButtonX, 0, Title_Size.width, self.scrollerView.size.height - self.indicatorView.size.height);
        
        [title_btn addTarget:self action:@selector(title_btnClickAction:) forControlEvents:(UIControlEventTouchUpInside)];
        
        [self.scrollerView addSubview:title_btn];
        
        if (i == 0)
        {
            [title_btn setEnabled:NO];
            
            self.Select_Btn = title_btn;
            
            // 让按钮内部的label根据文字内容来计算尺寸
            [title_btn.titleLabel sizeToFit];
            
            self.indicatorView.mj_w = title_btn.titleLabel.mj_w;
            
            self.indicatorView.centerX = title_btn.centerX;
        }
        
        HSQLeftCategoryModel *Max_model = title_array.lastObject;
        
        CGSize Max_Title_Size = [NSString SizeOfTheText:Max_model.categoryName font:[UIFont systemFontOfSize:KLabelFont(14.0, 12.0)] MaxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
        
        contentW = ButtonX + Max_Title_Size.width + 10;
    }
    
    
    
     self.scrollerView.contentSize = CGSizeMake(contentW, self.frame.size.height);
    
    [self.scrollerView addSubview:self.indicatorView];
}

/**
 * @brief 创建下拉菜单的视图
 */
- (void)CreatMenuViewWithDataSource:(NSMutableArray *)title_array{
    
    CGFloat bgView_Y = KSafeTopeHeight + self.frame.size.height;
    
    // 1.底部的半黑色透明视图
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, bgView_Y, KScreenWidth, KScreenHeight - bgView_Y - KSafeBottomHeight)];
    bgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
    [bgView setHidden:YES];
    bgView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(DismissMenuView)];
    [bgView addGestureRecognizer:tapGR];
    [[UIApplication sharedApplication].keyWindow addSubview:bgView];
    self.bgView = bgView;
    
    // 2.装有菜单按钮的视图
    UIView *White_bgView = [[UIView alloc] init];
    White_bgView.backgroundColor = KViewBackGroupColor;
    [White_bgView setHidden:YES];
    [bgView addSubview:White_bgView];
    
    for (NSInteger i = 0; i < title_array.count; i++) {
        
         HSQLeftCategoryModel *model = title_array[i];
        
        UIButton *title_btn = [UIButton buttonWithType:(UIButtonTypeSystem)];
        
        [title_btn setTitle:model.categoryName forState:(UIControlStateNormal)];
        
        [title_btn setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
        
        [title_btn setTitleColor:[UIColor redColor] forState:(UIControlStateDisabled)];
        
        title_btn.titleLabel.font = [UIFont systemFontOfSize:KLabelFont(14.0, 12.0)];
        
        title_btn.backgroundColor = [UIColor whiteColor];
        
        title_btn.layer.cornerRadius = 15;
        
        title_btn.clipsToBounds = YES;
        
        title_btn.tag = i;
        
        [title_btn addTarget:self action:@selector(MenuTitleBtnClickAction:) forControlEvents:(UIControlEventTouchUpInside)];
        
        NSInteger numer = i % KLinecount;
        
        NSInteger numer02 = i / KLinecount;
        
        CGFloat Btn_Margin = 20;
        CGFloat Btn_Top = 10;
        CGFloat Btn_W = (KScreenWidth - 5 * 20) / KLinecount;
        CGFloat Btn_H = 30;
        
        CGFloat Btn_X = Btn_Margin + (Btn_W + Btn_Margin) * numer;
        
        CGFloat Btn_Y = Btn_Top + (Btn_H + Btn_Top) *numer02 ;
        
        title_btn.frame = CGRectMake(Btn_X, Btn_Y, Btn_W, Btn_H);
        
        [White_bgView addSubview:title_btn];
        
        if (i == 0)
        {
            [title_btn setEnabled:NO];
            
             [title_btn.layer setBorderColor:[UIColor redColor].CGColor];
            
            self.MenuSelect_Btn = title_btn;
        }
    }
    
    CGFloat line_count = title_array.count / KLinecount + 1;
    
     self.MenuViewHeight = 10 + (30 + 10) * line_count;
    
    White_bgView.frame = CGRectMake(0, 0, KScreenWidth, self.MenuViewHeight);
    
    self.White_bgView = White_bgView;

}

/**
 * @brief 顶部按钮的点击事件
 */
- (void)title_btnClickAction:(UIButton *)sender{
    
    self.indexnumber = sender.tag;
    
    // 修改按钮状态
    self.Select_Btn.enabled = YES;
    
    sender.enabled = NO;
    
    self.Select_Btn = sender;
    
    // 动画
    [UIView animateWithDuration:0.25 animations:^{
        
        self.indicatorView.width = sender.titleLabel.mj_w;
        
        self.indicatorView.centerX = sender.centerX;
    }];
    
    //  计算按钮的位置
    [self calculateBtnPostion:sender];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(topButtonClickAction:)]) {
        
        [self.delegate topButtonClickAction:sender];
    }
}

/**
 * @brief 下拉菜单中按钮的点击事件
 */
- (void)MenuTitleBtnClickAction:(UIButton *)sender{
    
    self.indexnumber = sender.tag;
    
    // 修改按钮状态
    self.MenuSelect_Btn.enabled = YES;
    sender.enabled = NO;
    self.MenuSelect_Btn = sender;
    
    [self title_btnClickAction:self.scrollerView.subviews[self.indexnumber]];
    
    [self DismissMenuView];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(MenuButtonClickAction:)]) {
        
        [self.delegate MenuButtonClickAction:sender];
    }
}

/**
 * @brief 顶部右边按钮的点击事件
 */
- (void)Right_BtnClickAction:(UIButton *)sender{
    
    if (self.White_bgView.hidden == NO)
    {
        [self DismissMenuView];
    }
    else
    {
        [self ShowMenuView];
        
        UIButton *btn = (UIButton *)self.White_bgView.subviews[self.indexnumber];
        
        self.MenuSelect_Btn.enabled = YES;
        
        btn.enabled = NO;
        
        self.MenuSelect_Btn = btn;
    }
    
    self.Right_Btn.selected = !sender.isSelected;

}

/**
 * @brief 计算按钮的位置
 * @param sender 顶部的按钮
 */
- (void)calculateBtnPostion:(UIButton *)sender{
    
    CGFloat width = CGRectGetWidth(self.scrollerView.frame) / 2;
    
    CGFloat offsetX = 0;
    
    if (CGRectGetMidX(sender.frame) <= width)
    {
        offsetX = 0;
    }
    else if (CGRectGetMidX(sender.frame) + width >= self.scrollerView.contentSize.width)
    {
        offsetX = self.scrollerView.contentSize.width - CGRectGetWidth(self.scrollerView.frame);
    }
    else
    {
        offsetX = CGRectGetMidX(sender.frame)-CGRectGetWidth(self.scrollerView.frame)/2;
    }
    // 滚动
    CGPoint offset = self.scrollerView.contentOffset;
    
    offset.x = offsetX;
    
    [self.scrollerView setContentOffset:offset animated:YES];\
    
}

/**
 * @brief 显示菜单式图
 */
- (void)ShowMenuView{
    
    [UIView animateWithDuration:5 animations:^{
        
        self.bgView.hidden = self.White_bgView.hidden = NO;
        
    }];
}

/**
 * @brief 隐藏菜单式图
 */
- (void)DismissMenuView{
    
    [UIView animateWithDuration:5 animations:^{
        
        self.bgView.hidden = self.White_bgView.hidden = YES;
    }];
}






@end
