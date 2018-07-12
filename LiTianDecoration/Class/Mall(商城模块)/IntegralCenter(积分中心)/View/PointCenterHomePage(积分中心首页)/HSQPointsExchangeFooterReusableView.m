//
//  HSQPointsExchangeFooterReusableView.m
//  LiTianDecoration
//
//  Created by administrator on 2018/6/21.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import "HSQPointsExchangeFooterReusableView.h"
#import "HSQMembershipListModel.h"

@interface HSQPointsExchangeFooterReusableView ()

// 顶部的所有标签
@property (nonatomic, weak) UIView *titlesView;

// 标签栏底部的红色指示器
@property (nonatomic, weak) UIImageView *indicatorView;

// 当前选中的按钮
@property (nonatomic, weak) UIButton *selectedButton;

@end

@implementation HSQPointsExchangeFooterReusableView

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    
    if (self = [super initWithCoder:aDecoder]) {
        
        NSArray *array = @[@"V0",@"V1及以下",@"V2及以下",@"V3及以下"];
        
        // 标签栏整体
        UIView *titlesView = [[UIView alloc] init];
        titlesView.backgroundColor = [UIColor whiteColor];
        titlesView.mj_w = [UIScreen mainScreen].bounds.size.width;
        titlesView.mj_h = self.mj_h - 41;
        titlesView.mj_y = 40;
        [self addSubview:titlesView];
        self.titlesView = titlesView;
        
        // 底部的红色指示器
        UIImageView *indicatorView = [[UIImageView alloc] init];
        indicatorView.backgroundColor = RGB(255, 83, 63);
        indicatorView.mj_h = 2;
        indicatorView.tag = -1;
        indicatorView.mj_y = titlesView.mj_h - indicatorView.mj_h;
        self.indicatorView = indicatorView;
        
        // 内部的子标签
        CGFloat width = titlesView.mj_w / array.count;
        
        CGFloat height = titlesView.mj_h;
        
        for (NSInteger i = 0; i < array.count; i++) {
            
            UIButton *button = [UIButton buttonWithType:(UIButtonTypeCustom)];
            
            button.tag = i;
            
            button.mj_h = height;
            
            button.mj_w = width;
            
            button.mj_x = i * width;
            
            [button setTitle:array[i] forState:UIControlStateNormal];
            
            [button setTitleColor:RGB(131, 131, 131) forState:UIControlStateNormal];
            
            [button setTitleColor:RGB(255, 83, 63) forState:UIControlStateDisabled];
            
            button.titleLabel.font = [UIFont systemFontOfSize:12.0];
            
            [button addTarget:self action:@selector(titleClick:) forControlEvents:UIControlEventTouchUpInside];
            
            [titlesView addSubview:button];
            
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
        
        [titlesView addSubview:indicatorView];
    }
    
    return self;
}

/**
 * @brief 会员等级数组
 */
-(void)setMemberGradeList:(NSMutableArray *)memberGradeList{
    
    _memberGradeList = memberGradeList;
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
    
    HSQMembershipListModel *model = self.memberGradeList[button.tag];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(ClickEventOfTheMembershipRankButton:model:)]) {
        
        [self.delegate ClickEventOfTheMembershipRankButton:button model:model];
    }

}

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
}

@end
