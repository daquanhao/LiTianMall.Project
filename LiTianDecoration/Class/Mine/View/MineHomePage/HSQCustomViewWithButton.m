//
//  HSQCustomViewWithButton.m
//  LiTianDecoration
//
//  Created by administrator on 2018/4/11.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import "HSQCustomViewWithButton.h"
#import "HSQCustomButton.h"

@implementation HSQCustomViewWithButton

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor whiteColor];
    }
    
    return self;
}

- (void)setDataSource:(NSMutableArray<NSDictionary *> *)dataSource{
    
    _dataSource = dataSource;
    
    for (NSInteger i = 0; i < dataSource.count; i++) {
        
        NSDictionary *diction = dataSource[i];
        
        HSQCustomButton *btn = [HSQCustomButton buttonWithType:(UIButtonTypeCustom)];
        
        btn.frame = CGRectMake(i * KScreenWidth / dataSource.count, 0, KScreenWidth / dataSource.count, self.frame.size.height);
        
        [btn setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
        
        btn.alignmentType = Button_AlignmentStatusTop;
        
        btn.titleLabel.font = [UIFont systemFontOfSize:12.0];
        
        [btn setImage:KImageName(@"123") forState:(UIControlStateNormal)];
        
        [btn setTitle:diction[@"title"] forState:(UIControlStateNormal)];
        
        [btn addTarget:self action:@selector(CustomButtonClickAction:) forControlEvents:(UIControlEventTouchUpInside)];
        
        [self addSubview:btn];
    }
}

- (void)CustomButtonClickAction:(UIButton *)sender{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(CustomViewWithButtonClickAction:)]) {
        
        [self.delegate CustomViewWithButtonClickAction:sender];
    }
}









@end
