//
//  HSQHomePageFirstTypeViewCell.m
//  LiTianDecoration
//
//  Created by administrator on 2018/7/10.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import "HSQHomePageFirstTypeViewCell.h"

@interface HSQHomePageFirstTypeViewCell ()

@property (nonatomic, strong) UIButton *Mall_Button; // 商城

@property (nonatomic, strong) UIButton *Point_Button; // 积分兑换

@end

@implementation HSQHomePageFirstTypeViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        // 商城
        UIButton *Mall_Button = [UIButton buttonWithType:(UIButtonTypeSystem)];
        [Mall_Button setBackgroundImage:KImageName(@"shouye_shangcheng") forState:(UIControlStateNormal)];
        [Mall_Button addTarget:self action:@selector(Mall_ButtonClickAction:) forControlEvents:(UIControlEventTouchUpInside)];
        [self.contentView addSubview:Mall_Button];
        self.Mall_Button = Mall_Button;
        
        // 积分兑换
        UIButton *Point_Button = [UIButton buttonWithType:(UIButtonTypeSystem)];
        [Point_Button setBackgroundImage:KImageName(@"shouye_Jifen") forState:(UIControlStateNormal)];
        [Point_Button addTarget:self action:@selector(Point_ButtonClickAction:) forControlEvents:(UIControlEventTouchUpInside)];
        [self.contentView addSubview:Point_Button];
        self.Point_Button = Point_Button;
        
        // 添加约束
        self.Mall_Button.sd_layout.leftSpaceToView(self.contentView, 2.5).topSpaceToView(self.contentView, 2.5).bottomSpaceToView(self.contentView, 2.5).widthIs((frame.size.width - 7.5) * 2 / 3);
        
        self.Point_Button.sd_layout.leftSpaceToView(self.Mall_Button, 5).topEqualToView(self.Mall_Button).rightSpaceToView(self.contentView, 2.5).bottomEqualToView(self.Mall_Button);
    }
    
    return self;
}

/**
 * @brief 商城
 */
- (void)Mall_ButtonClickAction:(UIButton *)sender{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(EnterTheMallModuleBtnClickAction:)]) {
        
        [self.delegate EnterTheMallModuleBtnClickAction:sender];
    }
}

/**
 * @brief 积分兑换
 */
- (void)Point_ButtonClickAction:(UIButton *)sender{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(EntryPointExchangeBtnClickAction:)]) {
        
        [self.delegate EntryPointExchangeBtnClickAction:sender];
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

@end
