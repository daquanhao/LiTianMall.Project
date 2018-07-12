//
//  HSQCustomShareView.m
//  测试demo
//
//  Created by administrator on 2018/4/8.
//  Copyright © 2018年 administrator. All rights reserved.
//

#define ColumnNum 4

#define KBottomMargin ([UIScreen mainScreen].bounds.size.height == 812.0 ? 34 : 0)

#define Button_WH 60   // 按钮的大小

#define KFistBtn_Y 50

#define KMarginY 20

#define KBtnMargin 20

#import "HSQCustomShareView.h"
#import "HSQCustomButton.h"

@interface HSQCustomShareView ()

@property (nonatomic, strong) UIView *BackView;

@end

@implementation HSQCustomShareView

/**
 * @brief 初始化分享界面
 */
- (void) showInView:(UIView *)superView contentArray:(NSArray *)contentArray{
    
    if (contentArray == nil || contentArray.count < 1) return;
    
    self.backgroundColor = [UIColor whiteColor];
    
    // 1.添加最底层的背景图
    [self addBackView:superView];
    
    // 2.循环添加分享的平台
    for (NSInteger i = 0; i < contentArray.count; i++) {
        
        NSDictionary *diction = [contentArray objectAtIndex:i];
        
        HSQCustomButton *CustomButton = [HSQCustomButton buttonWithType:(UIButtonTypeCustom)];
        
        CustomButton.tag = i;
        
        CustomButton.alignmentType = Button_AlignmentStatusTop;
        
        CustomButton.titleLabel.font = [UIFont systemFontOfSize:12.0];
        
        [CustomButton setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
        
        [CustomButton setTitle:diction[@"name"] forState:(UIControlStateNormal)];
        
        [CustomButton setImage:[UIImage imageNamed:diction[@"icon"]] forState:(UIControlStateNormal)];
        
        [CustomButton addTarget:self action:@selector(CustomButtonClickAction:) forControlEvents:(UIControlEventTouchUpInside)];
        
        CGFloat marginX = (self.frame.size.width - ColumnNum * Button_WH - (ColumnNum - 1) * KBtnMargin) / 2;
        
        NSInteger col = i % ColumnNum;
        
        NSInteger row = i / ColumnNum;
        
        CGFloat btnX =  marginX + (KBtnMargin + Button_WH) * col;
        
        CGFloat btnY = KFistBtn_Y + (KMarginY + Button_WH) * row;
        
        CustomButton.frame = CGRectMake(btnX, btnY, Button_WH, Button_WH);
        
        [self addSubview:CustomButton];
        
        NSLog(@"===%f==%ld",btnX,(long)col);
    }
    
    //将当前视图加载父视图上
    [superView addSubview:self];
    
    // 计算View的frame
    NSUInteger row = (contentArray.count - 1) / ColumnNum;
    
    CGFloat height = KFistBtn_Y + 50 + (row +1) * (Button_WH + KMarginY) + KBottomMargin;
    
    CGFloat originY = [UIScreen mainScreen].bounds.size.height;
    
    self.frame = CGRectMake(0, originY, 0, height);
    
    [UIView animateWithDuration:0.25 animations:^{
        
        CGRect sF = self.frame;
        
        sF.origin.y = [UIScreen mainScreen].bounds.size.height - sF.size.height;
        
        self.frame = sF;
    }];
    
    // 头部的提示语
    UILabel *placeholder_Label = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, self.frame.size.width - 10, KFistBtn_Y)];
    
    placeholder_Label.textAlignment = NSTextAlignmentCenter;
    
    placeholder_Label.textColor = [UIColor colorWithRed:74 / 255.0 green:74 / 255.0 blue:74 / 255.0 alpha:1.0];
    
    placeholder_Label.font = [UIFont systemFontOfSize:14.0];
    
    placeholder_Label.text = @"请选择您要分享的平台";
    
    [self addSubview:placeholder_Label];
    
    //取消
    UIButton *canleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    canleBtn.frame = CGRectMake(0, self.frame.size.height - 44 - KBottomMargin, self.frame.size.width, 44);
    
    [canleBtn setTitle:@"取 消" forState:UIControlStateNormal];
    
    canleBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
    
    [canleBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    
    [canleBtn addTarget:self action:@selector(TapGRClickAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:canleBtn];
    
    //分割线
    UIView *line = [[UIView alloc] init];
    
    CGFloat lineY = CGRectGetMinY(canleBtn.frame)  - 2;
    
    line.frame = CGRectMake(40, lineY, [UIScreen mainScreen].bounds.size.width- 80 , 0.5);
    
    line.backgroundColor = [UIColor colorWithRed:180/255.0 green:180/255.0 blue:180/255.0 alpha:1.0];
    
    [self addSubview:line];
}

- (void)setFrame:(CGRect)frame{
    
    frame.size.width = [UIScreen mainScreen].bounds.size.width;
    
    if (frame.size.height <= 0)
    {
        frame.size.height = 0;
    }
    
    frame.origin.x = 0;
    
    [super setFrame:frame];
}

/**
 * @brief 添加最底层的背景图
 */
- (void)addBackView:(UIView *) superView{
    
    UIView *backView = [[UIView alloc] init];
    backView.frame = superView.bounds;
    backView.userInteractionEnabled = YES;
    backView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
    
    UITapGestureRecognizer *TapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(TapGRClickAction)];
    [backView addGestureRecognizer:TapGR];
    [superView addSubview:backView];
    self.BackView = backView;
    
}

/**
 * @brief 点击背景阴影视图触发的方法
 */
- (void)TapGRClickAction{
    
    [self.BackView removeFromSuperview];
    
    self.BackView = nil;
    
    [UIView animateWithDuration:0.25 animations:^{
        
        CGRect sf = self.frame;
        
        sf.origin.y = [UIScreen mainScreen].bounds.size.height;
        
        self.frame = sf;
        
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
        
    }];
}

- (void)CustomButtonClickAction:(UIButton *)sender{
    
    [self TapGRClickAction];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(CustomShareButtonClickEvent:)]) {
        
        [self.delegate CustomShareButtonClickEvent:sender];
    }
}


@end
