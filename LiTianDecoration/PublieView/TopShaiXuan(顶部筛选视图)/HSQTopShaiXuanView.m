//
//  HSQTopShaiXuanView.m
//  LiTianDecoration
//
//  Created by administrator on 2018/5/17.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import "HSQTopShaiXuanView.h"
#import "HSQCustomButton.h"

@interface HSQTopShaiXuanView ()

@property (nonatomic, strong) UIButton *selectedButton;

@end

@implementation HSQTopShaiXuanView

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        // 添加界面的按钮
        [self setupTopTitlesView];
    }
    
    return self;
}


/**
 * @brief 添加界面的按钮
 */
- (void)setupTopTitlesView{
    
    NSArray *array = @[@"综合",@"销量",@"价格",@"布局"];
    
    // 内部的子标签
    CGFloat width = KScreenWidth / array.count;
    CGFloat height = self.mj_h;
    for (NSInteger i = 0; i < array.count; i++) {
        
        HSQCustomButton *button = [HSQCustomButton buttonWithType:(UIButtonTypeCustom)];
        button.tag = i;
        button.mj_h = height;
        button.mj_w = width;
        button.mj_x = i * width;
        
        [button setTitle:[NSString stringWithFormat:@"%@ ",array[i]] forState:UIControlStateNormal];
        
        if (i == 1 || i == 2)
        {
            button.alignmentType = Button_AlignmentStatusRight;
            [button setImage:[UIImage imageNamed:@"F29714FE-BAB1-48BE-AED0-4825E2E9BFB6"] forState:(UIControlStateNormal)];
        }
        
        [button setTitleColor:RGB(131, 131, 131) forState:UIControlStateNormal];
        
        [button setTitleColor:RGB(255, 83, 63) forState:UIControlStateSelected];
        
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        
        [button addTarget:self action:@selector(titleClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:button];
        
        // 默认点击了第一个按钮
        if (i == 0)
        {
            button.selected = YES;
            
            self.selectedButton = button;
            
            // 让按钮内部的label根据文字内容来计算尺寸
            [button.titleLabel sizeToFit];
        }
    }
}

/**
 * @brief 顶部按钮的点击事件
 */
- (void)titleClick:(UIButton *)button{
    
    // 修改按钮状态
    self.selectedButton.selected = NO;
    
    button.selected = YES;
    
    self.selectedButton = button;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(ClickTheButtonOnTheTopScreen:)]) {
        
        [self.delegate ClickTheButtonOnTheTopScreen:button];
    }
    
}


@end
