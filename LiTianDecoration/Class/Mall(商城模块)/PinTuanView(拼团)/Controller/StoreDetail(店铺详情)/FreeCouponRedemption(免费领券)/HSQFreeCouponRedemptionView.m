//
//  HSQFreeCouponRedemptionView.m
//  LiTianDecoration
//
//  Created by administrator on 2018/5/18.
//  Copyright © 2018年 administrator. All rights reserved.
//

#define KViewHeight KScreenHeight - KSafeBottomHeight

#import "HSQFreeCouponRedemptionView.h"

@interface HSQFreeCouponRedemptionView ()

@property (nonatomic, strong) UIView *BackGroupView;

@property (nonatomic, strong) UIButton *exit_Btn; // 退出按钮

@property (nonatomic, strong) UILabel *TopTitle_Label; // 头部的标题

@property (nonatomic, strong) UILabel *Placher_Label; // 提示文字

@property (nonatomic, strong) UIView *LineView;  // 商品图片下面的分割线


@end

@implementation HSQFreeCouponRedemptionView

/**
 * @brief 初始化视图
 */
+ (instancetype)initFreeCouponRedemptionView{
    
    HSQFreeCouponRedemptionView *publicView = [[HSQFreeCouponRedemptionView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KViewHeight)];
    
    publicView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
    
    [[[UIApplication sharedApplication] keyWindow]addSubview:publicView];
    
    return publicView;
}

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        // 1.创建控件
        [self SetUpViews];
        
    }
    
    return self;
}

// 1.创建控件
- (void)SetUpViews{
    
    // 1.最底部的点击按钮
    UIButton *Bottombtn = [UIButton buttonWithType:(UIButtonTypeSystem)];
    Bottombtn.backgroundColor = [UIColor clearColor];
    Bottombtn.frame = self.bounds;
    [Bottombtn addTarget:self action:@selector(btnClickAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:Bottombtn];
    
    // 2.屏幕一半的背景图
    UIView *BackGroupView = [[UIView alloc] initWithFrame:CGRectMake(0, KScreenHeight, KScreenWidth,(KViewHeight)/2)];
    BackGroupView.backgroundColor = [UIColor whiteColor];
    [self addSubview:BackGroupView];
    self.BackGroupView = BackGroupView;
    
    // 2.1.退出按钮
    UIButton *exit_Btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [exit_Btn setImage:[UIImage imageNamed:@"123"] forState:(UIControlStateNormal)];
    exit_Btn.frame = CGRectMake(KScreenWidth - 45, 0, 45, 45);
    [exit_Btn addTarget:self action:@selector(dismissAdressView) forControlEvents:(UIControlEventTouchUpInside)];
    [BackGroupView addSubview:exit_Btn];
    self.exit_Btn = exit_Btn;
    
    // 3.头部的标题
    UILabel *TopTitle_Label = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, KScreenWidth - 45, 25)];
    TopTitle_Label.text = @"店铺券";
    TopTitle_Label.textColor = RGB(74, 74, 74);
    TopTitle_Label.font = [UIFont systemFontOfSize:14.0];
    TopTitle_Label.textAlignment = NSTextAlignmentCenter;
    [BackGroupView addSubview:TopTitle_Label];
    self.TopTitle_Label = TopTitle_Label;
    
    // 3.1.标题下面的图片
    UIView *LineView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.TopTitle_Label.frame)+10, KScreenWidth, 1)];
    LineView.backgroundColor = KViewBackGroupColor;
    [BackGroupView addSubview:LineView];
    self.LineView = LineView;
    
    // 4.头部的标题
    UILabel *Placher_Label = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.LineView.frame)+10, KScreenWidth, 20)];
    Placher_Label.text = @"可用店铺券";
    Placher_Label.textColor = RGB(74, 74, 74);
    Placher_Label.font = [UIFont systemFontOfSize:14.0];
    [BackGroupView addSubview:Placher_Label];
    self.Placher_Label = Placher_Label;
    
}

/**
 * @brief 点击背景按钮的点击事件
 */
- (void)btnClickAction:(UIButton *)sender{
    
    [self dismissAdressView];
}

/**
 * @brief 显示视图
 */
- (void)ShowFreeCouponRedemptionView{
    
    [UIView animateWithDuration:0.25 animations:^{
        
        self.BackGroupView.frame = ({
            
            CGRect frame = self.BackGroupView.frame;
            
            frame.origin.y = (KScreenHeight) / 2;
            
            frame;
        });
    }];
}


/**
 * @brief 隐藏视图
 */
- (void)dismissAdressView{
    
    [UIView animateWithDuration:0.25 animations:^{
        
        self.BackGroupView.frame = ({
            
            CGRect frame = self.BackGroupView.frame;
            
            frame.origin.y = KScreenHeight;
            
            frame;
        });
    }completion:^(BOOL finished) {
        
        [self.BackGroupView removeFromSuperview];
        
        [self removeFromSuperview];
    }];
}




@end
