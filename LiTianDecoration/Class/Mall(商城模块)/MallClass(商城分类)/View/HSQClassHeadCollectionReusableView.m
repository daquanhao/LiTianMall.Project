//
//  HSQClassHeadCollectionReusableView.m
//  LiTianDecoration
//
//  Created by administrator on 2018/4/12.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import "HSQClassHeadCollectionReusableView.h"

@interface HSQClassHeadCollectionReusableView ()

@property (nonatomic, strong) UIButton *ClearButton;

@end

@implementation HSQClassHeadCollectionReusableView

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = KViewBackGroupColor;
        
        // 顶部的图片
        UIImageView *head_image = [[UIImageView alloc] init];
        head_image.image = KImageName(@"3-1P106112Q1-51");
        [self addSubview:head_image];
        self.head_imageView = head_image;
        
        // 名字
        UILabel *title_label = [[UILabel alloc] init];
        title_label.text = @"男装";
        title_label.font = [UIFont systemFontOfSize:12.0];
        title_label.textColor = [UIColor blackColor];
        [self addSubview:title_label];
        self.title_label = title_label;
        
        // 底部的清除视图
        UIView *bottomView = [[UIView alloc] init];
        bottomView.backgroundColor = [UIColor whiteColor];
        [self addSubview:bottomView];
        self.BottomView = bottomView;
        
        // 清除的按钮
        UIButton *ClearButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [ClearButton setTitle:@"清除历史搜索" forState:(UIControlStateNormal)];
        [ClearButton setTitleColor:RGB(180, 180, 180) forState:(UIControlStateNormal)];
        ClearButton.titleLabel.font = [UIFont systemFontOfSize:15.0];
        [ClearButton setBackgroundImage:[UIImage ReturnAPictureOfStretching:@"7D99DFED-F3B6-4DB1-9F77-E24CA867DD17"] forState:(UIControlStateNormal)];
        [ClearButton setImage:KImageName(@"E40551FD-B428-45CB-B91D-FF4D678D0EF7") forState:(UIControlStateNormal)];
        [ClearButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
        [ClearButton addTarget:self action:@selector(clearchBtnClickAction:) forControlEvents:(UIControlEventTouchUpInside)];
        [bottomView addSubview:ClearButton];
        self.ClearButton = ClearButton;
        
        self.title_label.sd_layout.leftEqualToView(self).rightEqualToView(self).bottomEqualToView(self).heightIs(30);
        
        self.head_imageView.sd_layout.leftEqualToView(self).rightSpaceToView(self, 0).bottomSpaceToView(self.title_label, 10).topSpaceToView(self, 10);
        
        self.BottomView.sd_layout.leftSpaceToView(self, 0).rightEqualToView(self).topEqualToView(self).bottomEqualToView(self);
        
        self.ClearButton.sd_layout.centerYEqualToView(self.BottomView).leftSpaceToView(self.BottomView, 30).rightSpaceToView(self.BottomView, 30).heightIs(50);
    }
    
    return self;
}

- (void)clearchBtnClickAction:(UIButton *)sender{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(ClearSearchHistoryButtonClickAction:)]) {
        
        [self.delegate ClearSearchHistoryButtonClickAction:sender];
    }
}











@end
