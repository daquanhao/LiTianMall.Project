//
//  HSQDiscoverHeadView.m
//  LiTianDecoration
//
//  Created by administrator on 2018/4/10.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import "HSQDiscoverHeadView.h"
#import "HSQCustomButton.h"

@interface HSQDiscoverHeadView ()

@end

@implementation HSQDiscoverHeadView

/**
 * @brief 初始化头部控件
 */
- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
    }
    
    return self;
}

- (void)setDataSource:(NSMutableArray<NSDictionary *> *)dataSource{
    
    _dataSource = dataSource;
    
    for (NSInteger i = 0; i < dataSource.count; i++) {
        
        NSDictionary *diction = dataSource[i];
        
        HSQCustomButton *CustomBtn = [HSQCustomButton buttonWithType:(UIButtonTypeCustom)];
        
        CustomBtn.alignmentType = Button_AlignmentStatusTop;
        
        CustomBtn.titleLabel.font = [UIFont systemFontOfSize:12.0];
        
        [CustomBtn setTitleColor: RGB(74, 74, 74) forState:(UIControlStateNormal)];
        
        [CustomBtn setTitle:diction[@"name"] forState:(UIControlStateNormal)];
        
        [CustomBtn setImage:KImageName(diction[@"icon"]) forState:(UIControlStateNormal)];
        
        CGFloat Button_W = KScreenWidth / dataSource.count;
        
        CustomBtn.frame = CGRectMake(i * Button_W, 0, Button_W, 64);
        
        CustomBtn.tag = i + 100;
        
        [CustomBtn addTarget:self action:@selector(btnClick:) forControlEvents:(UIControlEventTouchUpInside)];
        
        [self addSubview:CustomBtn];
    }
}

- (void)btnClick:(UIButton *)sender{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(headerViewButtonClickAction:)]) {
        
        [self.delegate headerViewButtonClickAction:sender];
    }
}






@end
