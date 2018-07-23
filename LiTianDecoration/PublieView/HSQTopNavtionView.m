//
//  HSQTopNavtionView.m
//  LiTianDecoration
//
//  Created by administrator on 2018/4/29.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import "HSQTopNavtionView.h"

@interface HSQTopNavtionView ()

@end

@implementation HSQTopNavtionView

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        
    }
    
    return self;
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
    self.backgroundColor = [[UIColor whiteColor]colorWithAlphaComponent:0.8];
    
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
        
        button.titleLabel.font = [UIFont systemFontOfSize:KTextFont_(14)];
        
        [button addTarget:self action:@selector(titleClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:button];
        
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
    
    [self addSubview:indicatorView];
    
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
