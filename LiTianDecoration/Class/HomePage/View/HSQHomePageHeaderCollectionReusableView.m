//
//  HSQHomePageHeaderCollectionReusableView.m
//  LiTianDecoration
//
//  Created by administrator on 2018/7/11.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import "HSQHomePageHeaderCollectionReusableView.h"

@interface HSQHomePageHeaderCollectionReusableView ()

@property (nonatomic, strong) UIView *BgView;

@end

@implementation HSQHomePageHeaderCollectionReusableView

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        // 背景图
        UIView *BgView = [[UIView alloc] init];
        BgView.backgroundColor = [UIColor clearColor];
        [self addSubview:BgView];
        self.BgView = BgView;
        
        // 提示语
        UILabel *Placher_Label = [[UILabel alloc] init];
        Placher_Label.font = [UIFont systemFontOfSize:14.0];
        Placher_Label.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
        [self.BgView addSubview:Placher_Label];
        self.Placher_Label = Placher_Label;
        
        // 更多按钮
        UIButton *More_Btn = [UIButton buttonWithType:(UIButtonTypeSystem)];
        [More_Btn setTitle:@"MORE" forState:(UIControlStateNormal)];
        [More_Btn setTitleColor:[[UIColor whiteColor] colorWithAlphaComponent:0.5] forState:(UIControlStateNormal)];
        More_Btn.titleLabel.font = [UIFont systemFontOfSize:14.0];
        [More_Btn setContentHorizontalAlignment:(UIControlContentHorizontalAlignmentRight)];
        [self.BgView addSubview:More_Btn];
        self.More_Button = More_Btn;
        
        // 约束
        self.BgView.sd_layout.leftSpaceToView(self, 0).topSpaceToView(self, 0).rightSpaceToView(self, 0).bottomSpaceToView(self, 0);
        
        self.Placher_Label.sd_layout.leftSpaceToView(self.BgView, 0).topSpaceToView(self.BgView, 0).autoWidthRatio(0).bottomSpaceToView(self.BgView, 0);
        [self.Placher_Label setSingleLineAutoResizeWithMaxWidth:200];
        
        self.More_Button.sd_layout.leftSpaceToView(self.Placher_Label, 10).rightSpaceToView(self.BgView, 0).topSpaceToView(self.BgView, 0).bottomSpaceToView(self.BgView, 0);
    }
    
    return self;
}

@end
