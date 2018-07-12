//
//  HSQHomePageSecondTypeViewCell.m
//  LiTianDecoration
//
//  Created by administrator on 2018/7/10.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import "HSQHomePageSecondTypeViewCell.h"

@interface HSQHomePageSecondTypeViewCell ()


@end

@implementation HSQHomePageSecondTypeViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        self.contentView.backgroundColor = [UIColor clearColor];
        
        // 图标
        UIImageView *Placher_ImageView = [[UIImageView alloc] init];
        
        Placher_ImageView.backgroundColor = [UIColor orangeColor];
        
        [self.contentView addSubview:Placher_ImageView];
        
        self.Placher_ImageView = Placher_ImageView;
        
        // 约束
        self.Placher_ImageView.sd_layout.leftSpaceToView(self.contentView, 2.5).topSpaceToView(self.contentView, 2.5).rightSpaceToView(self.contentView, 2.5).bottomSpaceToView(self.contentView, 2.5);
    }
    
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

@end
