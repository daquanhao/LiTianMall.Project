//
//  HSQTopNavtionView.m
//  LiTianDecoration
//
//  Created by administrator on 2018/4/29.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import "HSQTopNavtionView.h"

@interface HSQTopNavtionView ()

@property (nonatomic, strong) UILabel *Name_Label;


@end

@implementation HSQTopNavtionView

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        // 添加 “图文详情的提示语”
        UILabel *name_Label = [[UILabel alloc] initWithFrame:frame];
        
        name_Label.text = @"图文详情";
        
        name_Label.textAlignment = NSTextAlignmentCenter;
        
        name_Label.font = [UIFont systemFontOfSize:KLabelFont(16.0, 14.0)];
        
        [self addSubview:name_Label];
        
        self.Name_Label = name_Label;
        
        // 添加三个按钮的背景视图
        UIView *Title_View = [[UIView alloc] initWithFrame:frame];
        
        [self addSubview:Title_View];
        
        self.Title_View = Title_View;
    }
    
    return self;
}

/**
 * @brief 是否隐藏
 */
- (void)setIsHidden_TitleView:(BOOL)IsHidden_TitleView{
    
    _IsHidden_TitleView = IsHidden_TitleView;
    
    self.Name_Label.hidden = IsHidden_TitleView;
    
    self.Title_View.hidden = !IsHidden_TitleView;
}

- (void)setTitlesArray:(NSArray *)TitlesArray{
    
    _TitlesArray = TitlesArray;
    
    [self setupTopTitlesView:TitlesArray];
}

/**
 * @brief 设置顶部标题栏
 */
- (void)setupTopTitlesView:(NSArray *)titlesArray{
    
    // 标签栏整体
    self.Title_View.backgroundColor = [[UIColor whiteColor]colorWithAlphaComponent:0.8];
    
    // 底部的红色指示器
    UIImageView *indicatorView = [[UIImageView alloc] init];
    
    indicatorView.backgroundColor = RGB(255, 83, 63);
    
    indicatorView.mj_h = 2;
    
    indicatorView.tag = -1;
    
    indicatorView.mj_y = self.mj_h - indicatorView.mj_h;
    
    self.indicatorView = indicatorView;
    
    // 内部的子标签
    CGFloat width = self.mj_w / titlesArray.count;
    
    CGFloat height = self.mj_h;
    
    for (NSInteger i = 0; i < titlesArray.count; i++) {
        
        UIButton *button = [UIButton buttonWithType:(UIButtonTypeCustom)];
        
        button.tag = i;
        
        button.mj_h = height;
        
        button.mj_w = width;
        
        button.mj_x = i * width;
        
        [button setTitle:titlesArray[i] forState:UIControlStateNormal];
        
        [button setTitleColor:RGB(131, 131, 131) forState:UIControlStateNormal];
        
        [button setTitleColor:RGB(255, 83, 63) forState:UIControlStateDisabled];
        
        button.titleLabel.font = [UIFont systemFontOfSize:KLabelFont(16.0, 14.0)];
        
        [button addTarget:self action:@selector(titleClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.Title_View addSubview:button];
        
        // 默认点击了第一个按钮
        if (i == 0)
        {
            button.enabled = NO;
            
            self.selectedButton = button;
            
            // 让按钮内部的label根据文字内容来计算尺寸
            [button.titleLabel sizeToFit];
            
            self.indicatorView.mj_w = button.titleLabel.mj_w;
            
            self.indicatorView.centerX = button.centerX;
        }
    }
    
    [self.Title_View addSubview:indicatorView];
}

/**
 * @brief 顶部按钮的点击事件
 */
- (void)titleClick:(UIButton *)button{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(TopNavtionViewButtonClickAction:)]) {
        
        [self.delegate TopNavtionViewButtonClickAction:button];
    }
}


@end
