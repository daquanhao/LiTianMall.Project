//
//  HSQStoreSearchFooterReusableView.m
//  LiTianDecoration
//
//  Created by administrator on 2018/6/19.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import "HSQStoreSearchFooterReusableView.h"

@interface HSQStoreSearchFooterReusableView ()

@property (nonatomic, strong) UIView *bgView;

@end

@implementation HSQStoreSearchFooterReusableView


- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
      
        // 背景图
        UIView *bgView = [[UIView alloc] init];
        bgView.backgroundColor = KViewBackGroupColor;
        [self addSubview:bgView];
        self.bgView = bgView;
        
        // 添加约束
        self.bgView.sd_layout.leftSpaceToView(self, 0).topSpaceToView(self, 10).rightSpaceToView(self, 0).bottomSpaceToView(self, 0);
    }
    
    return self;
}


@end
