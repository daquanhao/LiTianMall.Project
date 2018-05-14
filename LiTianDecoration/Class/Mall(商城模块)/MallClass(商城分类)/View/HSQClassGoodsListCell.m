//
//  HSQClassGoodsListCell.m
//  LiTianDecoration
//
//  Created by administrator on 2018/4/12.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import "HSQClassGoodsListCell.h"

@interface HSQClassGoodsListCell ()

@end

@implementation HSQClassGoodsListCell

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        self.contentView.backgroundColor = [UIColor whiteColor]
        ;
        UIImageView *head_image = [[UIImageView alloc] init];
        head_image.image = KImageName(@"3-1P106112Q1-51");
        [self.contentView addSubview:head_image];
        self.good_image = head_image;
        
        
        UILabel *title_label = [[UILabel alloc] init];
        title_label.text = @"羽绒服";
        title_label.font = [UIFont systemFontOfSize:12.0];
        title_label.textColor = [UIColor blackColor];
        title_label.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:title_label];
        self.good_titleLabel = title_label;
        
        self.good_titleLabel.sd_layout.leftEqualToView(self.contentView).rightEqualToView(self.contentView).bottomEqualToView(self.contentView).heightIs(25);
        
        self.good_image.sd_layout.leftSpaceToView(self.contentView, 10).rightSpaceToView(self.contentView, 10).topSpaceToView(self.contentView, 10).bottomSpaceToView(self.good_titleLabel, 5);
    }
    
    return self;
}

@end
