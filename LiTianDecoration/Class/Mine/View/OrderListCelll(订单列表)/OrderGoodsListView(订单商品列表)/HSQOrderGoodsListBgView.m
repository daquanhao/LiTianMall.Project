//
//  HSQOrderGoodsListBgView.m
//  LiTianDecoration
//
//  Created by administrator on 2018/5/26.
//  Copyright © 2018年 administrator. All rights reserved.
//

#define KGoodsListViewMargin 2

#import "HSQOrderGoodsListBgView.h"
#import "HSQOrderGoodsListView.h"

@implementation HSQOrderGoodsListBgView

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = KViewBackGroupColor;
        
        
    }
    
    return self;
}

/**
 * @brief 根据数据创建规格列表View
 */
- (void)setOrderGoodsList_Array:(NSArray *)OrderGoodsList_Array{
    
    _OrderGoodsList_Array = OrderGoodsList_Array;
    
    NSUInteger photosCount = OrderGoodsList_Array.count;
    
    // 创建足够数量的图片控件
    // 这里的self.subviews.count不要单独赋值给其他变量
    while (self.subviews.count < photosCount) {
        
        HSQOrderGoodsListView *photoView = [[HSQOrderGoodsListView alloc] init];
        
        [self addSubview:photoView];
    }
    
    // 遍历所有的图片控件，设置图片
    for (int i = 0; i<self.subviews.count; i++) {
        
        HSQOrderGoodsListView *photoView = self.subviews[i];
        
        if (i < photosCount) { // 显示
            
            photoView.model = OrderGoodsList_Array[i];
            
            photoView.hidden = NO;
            
        } else { // 隐藏
            photoView.hidden = YES;
        }
    }
}

/**
 * @brief 设置控件的尺寸
 */
- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    // 设置图片的尺寸和位置
    NSUInteger photosCount = self.OrderGoodsList_Array.count;
    
    for (int i = 0; i<photosCount; i++) {
        
        HSQOrderGoodsListView *photoView = self.subviews[i];
        
        photoView.width = KScreenWidth;
        
        photoView.mj_x = 0;
        
        photoView.mj_h = KGoodsListViewH;
        
        photoView.mj_y = i * (KGoodsListViewH + KGoodsListViewMargin);
        
    }
}


/**
 * @brief 根据数组返回view的尺寸
 */
+(CGSize)SizeWithDataModelArray:(NSArray *)dataSource{
    
    CGFloat photosH = dataSource.count * KGoodsListViewH + (dataSource.count - 1) * KGoodsListViewMargin;
    
    return CGSizeMake(KScreenWidth, photosH);
}

@end
