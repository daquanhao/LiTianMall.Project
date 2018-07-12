//
//  CircleView.m
//  YKL
//
//  Created by Apple on 15/12/7.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "XLCircleProgress.h"
#import "XLCircle.h"

@implementation XLCircleProgress
{
    XLCircle* _circle;
    UILabel *_percentLabel;
}

-(instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
//        [self initUI];
        
    }
    return self;
}


-(void)initUI{
    
//    float lineWidth = 0.1*self.bounds.size.width;
    float lineWidth = 4;
    
    _percentLabel = [[UILabel alloc] initWithFrame:self.bounds];
    
    _percentLabel.textColor = [UIColor whiteColor];
    
    _percentLabel.textAlignment = NSTextAlignmentCenter;
    
    _percentLabel.font = [UIFont boldSystemFontOfSize:12.0];
    
    _percentLabel.text = @"0%";
    
    [self addSubview:_percentLabel];
    
    _circle = [[XLCircle alloc] initWithFrame:self.bounds lineWidth:lineWidth];
    
    [self addSubview:_circle];
}

- (void)setLineWidth:(CGFloat)lineWidth{
    
    _lineWidth = lineWidth;
        
    _percentLabel = [[UILabel alloc] initWithFrame:self.bounds];
    
    _percentLabel.textColor = [UIColor whiteColor];
    
    _percentLabel.textAlignment = NSTextAlignmentCenter;
    
    _percentLabel.font = [UIFont boldSystemFontOfSize:12.0];
    
    _percentLabel.text = @"0%";
    
    [self addSubview:_percentLabel];
    
    _circle = [[XLCircle alloc] initWithFrame:self.bounds lineWidth:lineWidth];
    
    [self addSubview:_circle];
}

- (void)setPlacherColor:(UIColor *)PlacherColor{
    
    _PlacherColor = PlacherColor;
    
    _percentLabel.textColor = PlacherColor;
}

- (void)setPlacherFont:(UIFont *)PlacherFont{
    
    _PlacherFont = PlacherFont;
    
    _percentLabel.font = PlacherFont;
}

#pragma mark Setter方法
-(void)setProgress:(float)progress{
    
    _progress = progress;
    
    _circle.progress = progress;
    
    _percentLabel.text = [NSString stringWithFormat:@"%.0f%%",progress*100];
}

@end
