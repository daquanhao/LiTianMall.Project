//
//  HSQDevelopmentCourseViewCell.m
//  LiTianDecoration
//
//  Created by administrator on 2018/7/11.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import "HSQDevelopmentCourseViewCell.h"

@interface HSQDevelopmentCourseViewCell ()

@property (nonatomic, strong) UIScrollView *scrollerView; // 底部的滚动式图

@property (nonatomic, strong) UIImageView *DevelopmentCourse_ImageView;

@end

@implementation HSQDevelopmentCourseViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = RGB(57, 63, 78);
        
        // 滚动式图
        UIScrollView *scrollerView = [[UIScrollView alloc] init];
        
        scrollerView.showsVerticalScrollIndicator = NO;
        
        scrollerView.showsHorizontalScrollIndicator = NO;
        
        scrollerView.bounces = NO;
        
        scrollerView.backgroundColor = [UIColor clearColor];
        
        [self.contentView addSubview:scrollerView];
        
        self.scrollerView = scrollerView;
        
        UIImageView *DevelopmentCourse_ImageView = [[UIImageView alloc] init];
        
        DevelopmentCourse_ImageView.image = KImageName(@"fazhanlicheng");
        
        [scrollerView addSubview:DevelopmentCourse_ImageView];
        
        self.DevelopmentCourse_ImageView = DevelopmentCourse_ImageView;
        
        // 约束
        self.scrollerView.sd_layout.leftSpaceToView(self.contentView, 0).topSpaceToView(self.contentView, 0).rightSpaceToView(self.contentView, 0).bottomSpaceToView(self.contentView, 0);
        
        self.scrollerView.contentSize = CGSizeMake(self.DevelopmentCourse_ImageView.image.size.width, 0);
        
        self.DevelopmentCourse_ImageView.sd_layout.leftSpaceToView(self.scrollerView, 0).topSpaceToView(self.scrollerView, 0).widthIs(self.DevelopmentCourse_ImageView.image.size.width).heightIs(self.DevelopmentCourse_ImageView.image.size.height);
    }
    
    return self;
}

@end
