//
//  HSQRedEnvelopeHeadView.m
//  LiTianDecoration
//
//  Created by administrator on 2018/6/26.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import "HSQRedEnvelopeHeadView.h"

@interface HSQRedEnvelopeHeadView ()



@end

@implementation HSQRedEnvelopeHeadView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        
        //提示文字
        UILabel *placher_Label = [[UILabel alloc] init];
        
        placher_Label.textColor = RGB(150, 150, 150);
        
        placher_Label.font = [UIFont systemFontOfSize:14.0];
        
        placher_Label.numberOfLines = 0;
        
        [self.contentView addSubview:placher_Label];
        
        self.placher_Label = placher_Label;
        
        // 添加约束
        self.placher_Label.sd_layout.centerXEqualToView(self.contentView).centerYEqualToView(self.contentView).autoWidthRatio(0).autoHeightRatio(0);
        
        [self.placher_Label setSingleLineAutoResizeWithMaxWidth:KScreenWidth / 2];
    }
    
    return self;
}










@end
