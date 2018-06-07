//
//  HSQTuiMoneryListFooterView.m
//  LiTianDecoration
//
//  Created by administrator on 2018/6/4.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import "HSQTuiMoneryListFooterView.h"

@implementation HSQTuiMoneryListFooterView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        
        
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    
    if (self = [super initWithCoder:aDecoder]) {
        
        
    }
    
    return self;
}

/**
 * @brief 退款详情的点击
 */
- (IBAction)TuiKuanDetailButtonClickAction:(UIButton *)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(RefundDetailsButtonClickEvent:)]) {
        
        [self.delegate RefundDetailsButtonClickEvent:sender];
    }
}



@end
