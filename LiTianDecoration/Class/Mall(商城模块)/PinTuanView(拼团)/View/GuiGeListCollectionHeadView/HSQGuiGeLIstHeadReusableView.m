//
//  HSQGuiGeLIstHeadReusableView.m
//  LiTianDecoration
//
//  Created by administrator on 2018/5/14.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import "HSQGuiGeLIstHeadReusableView.h"

@interface HSQGuiGeLIstHeadReusableView ()

@end

@implementation HSQGuiGeLIstHeadReusableView

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, KScreenWidth-20, self.mj_h)];
        nameLabel.textColor = RGB(51, 51, 51);
        nameLabel.font = [UIFont systemFontOfSize:14.0];
        [self addSubview:nameLabel];
        self.NameLabel = nameLabel;
        
    }
    
    return self;
}

@end
