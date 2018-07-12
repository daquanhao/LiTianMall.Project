//
//  HSQDesignCaseViewCell.m
//  LiTianDecoration
//
//  Created by administrator on 2018/7/11.
//  Copyright © 2018年 administrator. All rights reserved.
//

#define KDesignCaseViewW (self.contentView.mj_w - 20) / 2

#define KDesignCaseViewH self.contentView.mj_h

#import "HSQDesignCaseViewCell.h"
#import "HSQDesignCaseBgView.h"  // 设计案例

@interface HSQDesignCaseViewCell ()

@property (nonatomic, strong) UIScrollView *scrollerView; // 底部的滚动式图

@property (nonatomic, strong) HSQDesignCaseBgView *DesignCaseBgView; // 背景视图


@end

@implementation HSQDesignCaseViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        self.contentView.backgroundColor = [UIColor clearColor];
        
        // 滚动式图
        UIScrollView *scrollerView = [[UIScrollView alloc] init];
        
        scrollerView.showsVerticalScrollIndicator = NO;
        
        scrollerView.showsHorizontalScrollIndicator = NO;
        
        scrollerView.backgroundColor = [UIColor clearColor];
        
        [self.contentView addSubview:scrollerView];
        
        self.scrollerView = scrollerView;
        
        // 约束
        self.scrollerView.sd_layout.leftSpaceToView(self.contentView, 0).topSpaceToView(self.contentView, 0).rightSpaceToView(self.contentView, 0).bottomSpaceToView(self.contentView, 0);
    }
    
    return self;
}

/**
 * @brief 设计案例数据
 */
- (void)setDesignCase_array:(NSMutableArray *)DesignCase_array{
    
    _DesignCase_array = DesignCase_array;
    
    self.scrollerView.contentSize = CGSizeMake(KDesignCaseViewW * DesignCase_array.count + 30, 0);
    
    // 创建足够数量的图片控件
    while (self.scrollerView.subviews.count < DesignCase_array.count) {
        
        HSQDesignCaseBgView *DesignCaseBgView = [[HSQDesignCaseBgView alloc] init];
        
        [self.scrollerView addSubview:DesignCaseBgView];
    }
    
    // 遍历所有的图片控件，设置图片
    for (int i = 0; i < self.scrollerView.subviews.count; i++)
    {
        HSQDesignCaseBgView *DesignCaseBgView = self.scrollerView.subviews[i];
        
        if (i < DesignCase_array.count) // 显示
        {
            DesignCaseBgView.hidden = NO;
        }
        else // 隐藏
        {
            DesignCaseBgView.hidden = YES;
        }
    }

}

- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    // 设置图片的尺寸和位置
    NSUInteger photosCount = self.DesignCase_array.count;
    
    for (int i = 0; i< photosCount; i++) {
        
        HSQDesignCaseBgView *BgView = self.scrollerView.subviews[i];
        
        BgView.frame = CGRectMake((KDesignCaseViewW + 5) * i, 0, KDesignCaseViewW, KDesignCaseViewH);
    }
}
























@end
