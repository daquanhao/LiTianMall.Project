//
//  HSQEvaluationOrderHeadView.m
//  LiTianDecoration
//
//  Created by administrator on 2018/5/28.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import "HSQEvaluationOrderHeadView.h"

@interface HSQEvaluationOrderHeadView ()

@property (nonatomic, strong) UIButton *Placher_Button;

@end

@implementation HSQEvaluationOrderHeadView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        
        // 提示标语
        UIButton *Placher_button = [UIButton buttonWithType:(UIButtonTypeSystem)];
        
        [Placher_button setTitle:KEvaluationOrderHeadPlacher forState:(UIControlStateDisabled)];
        
        [Placher_button setTitleColor:[UIColor whiteColor] forState:(UIControlStateDisabled)];
        
        Placher_button.titleLabel.font = [UIFont systemFontOfSize:12.0];
        
        [Placher_button setEnabled:NO];
        
        Placher_button.layer.cornerRadius = 10;
        
        Placher_button.clipsToBounds = YES;
        
        Placher_button.titleLabel.numberOfLines = 0;
        
        Placher_button.backgroundColor = RGB(170, 170, 170);
        
        [self.contentView addSubview:Placher_button];
        
        self.Placher_Button = Placher_button;
        
        self.Placher_Button.sd_layout.leftSpaceToView(self.contentView, 10).topSpaceToView(self.contentView, 10).bottomSpaceToView(self.contentView, 10).rightSpaceToView(self.contentView, 10);
    }
    
    return self;
}

@end
