//
//  HSQAddressView.m
//  LiTianDecoration
//
//  Created by administrator on 2018/4/18.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import "HSQAddressView.h"

static  CGFloat  const  HYBarItemMargin = 20;

@interface HSQAddressView ()

@property (nonatomic,strong) NSMutableArray * btnArray;

@end

@implementation HSQAddressView

- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    for (NSInteger i = 0; i <= self.btnArray.count - 1 ; i++) {
        
        UIView * view = self.btnArray[i];
        
        if (i == 0)
        {
            view.left = HYBarItemMargin;
        }
        if (i > 0)
        {
            UIView * preView = self.btnArray[i - 1];
            
            view.left = HYBarItemMargin  + preView.right;
        }
    }
}

- (NSMutableArray *)btnArray{
    
    NSMutableArray * mArray  = [NSMutableArray array];
    
    for (UIView * view in self.subviews)
    {
        if ([view isKindOfClass:[UIButton class]])
        {
            [mArray addObject:view];
        }
    }
    _btnArray = mArray;
    
    return _btnArray;
}

@end
