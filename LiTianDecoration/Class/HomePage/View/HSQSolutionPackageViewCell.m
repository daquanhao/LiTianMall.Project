//
//  HSQSolutionPackageViewCell.m
//  LiTianDecoration
//
//  Created by administrator on 2018/7/11.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import "HSQSolutionPackageViewCell.h"

@interface HSQSolutionPackageViewCell ()

@property (nonatomic, strong) UIImageView *Placher_ImageView;

@end

@implementation HSQSolutionPackageViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        self.contentView.backgroundColor = [UIColor clearColor];
        
        // 图标
        UIImageView *Placher_ImageView = [[UIImageView alloc] init];
        
        Placher_ImageView.image = KImageName(@"3BD5E096-EAB3-4850-81E7-D2B6D85820D9");
        
        [self.contentView addSubview:Placher_ImageView];
        
        self.Placher_ImageView = Placher_ImageView;
        
        // 约束
        self.Placher_ImageView.sd_layout.leftSpaceToView(self.contentView, 0).topSpaceToView(self.contentView, 0).rightSpaceToView(self.contentView, 0).bottomSpaceToView(self.contentView, 0);
    }
    
    return self;
}

@end
