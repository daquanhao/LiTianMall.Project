//
//  HSQCustomNavBar.m
//  测试demo
//
//  Created by administrator on 2018/4/10.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import "HSQCustomNavBar.h"

@interface HSQCustomNavBar ()

@property (nonatomic, strong) UIButton *Left_Button;

@property (nonatomic, strong) UIButton *Right_Button;

@property (nonatomic, strong) UILabel *title_Label;

@end

@implementation HSQCustomNavBar

/**
 * @brief 初始化导航栏
 */
+ (instancetype)InitializeTheNavigationBar{
    
    return [[HSQCustomNavBar alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KSafeTopeHeight)];
}

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        // 1.左边的item
        UIButton *left_btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [self addSubview:left_btn];
        self.Left_Button = left_btn;
        
        // 2.右边的item
        UIButton *right_btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [right_btn addTarget:self action:@selector(Right_ButtonClickAction:) forControlEvents:(UIControlEventTouchUpInside)];
        [self addSubview:right_btn];
        self.Right_Button = right_btn;
        
        // 3.中间的标题
        UILabel *title_Label = [[UILabel alloc] init];
        title_Label.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width - 100) * 0.5, KSafeTopeHeight - 10 - 30, 100, 30);
        title_Label.textAlignment = NSTextAlignmentCenter;
        title_Label.font = [UIFont systemFontOfSize:16.0];
        [self addSubview:title_Label];
        self.title_Label = title_Label;
        
    }
    
    return self;
}

- (void)setTitle:(NSString *)title{
    
    _title = title;
    
    self.title_Label.text = title;
}

- (void)setTitleColor:(UIColor *)titleColor{
    
    _titleColor = titleColor;
    
    self.title_Label.textColor = titleColor ? titleColor : [[UIColor blackColor] colorWithAlphaComponent:0.0];
}

- (void)setTitleFont:(UIFont *)titleFont{
    
    _titleFont = titleFont;
    
    self.title_Label.font = titleFont;
}

- (void)setLeft_imageName:(NSString *)Left_imageName{
    
    _Left_imageName = Left_imageName;
    
    UIImage *leftImage = [UIImage imageNamed:Left_imageName];
    
    self.Left_Button.frame = CGRectMake(20, KSafeTopeHeight - 15 -leftImage.size.height , leftImage.size.width, leftImage.size.height);
    
    [self.Left_Button setImage:leftImage forState:(UIControlStateNormal)];
}

- (void)setRight_imageName:(NSString *)Right_imageName{
    
    _Right_imageName = Right_imageName;
    
    UIImage *rightImage = [UIImage imageNamed:Right_imageName];
    
    self.Right_Button.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 20 - rightImage.size.width, KSafeTopeHeight - 15 -rightImage.size.height , rightImage.size.width, rightImage.size.height);
    
    [self.Right_Button setImage:rightImage forState:(UIControlStateNormal)];
}

- (void)Right_ButtonClickAction:(UIButton *)sender{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(LookUpTheDataInTheMessageList:)]) {
        
        [self.delegate LookUpTheDataInTheMessageList:sender];
    }
}








@end
