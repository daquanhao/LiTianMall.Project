
//
//  HSQStarsView.m
//  LiTianDecoration
//
//  Created by administrator on 2018/5/12.
//  Copyright © 2018年 administrator. All rights reserved.
//

#define HWStatusPhotoW 10

#define HWStatusPhotoH 8

#define HWStatusPhotoMargin 5

#import "HSQStarsView.h"

@interface HSQStarsView ()

@property (nonatomic, strong) UIImageView *Stars_Image;

@end

@implementation HSQStarsView

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor clearColor];
    }
    
    return self;
    
}

/**
 * @brief 星星的个数
 */
- (void)setStarsCount:(NSString *)StarsCount{
    
    _StarsCount = StarsCount;
        
    // 创建足够数量的图片控件
    while (self.subviews.count < StarsCount.integerValue) {
        
        UIImageView *photoView = [[UIImageView alloc] init];
        
        [self addSubview:photoView];
    }
    
    // 遍历所有的图片控件，设置图片
    for (int i = 0; i<self.subviews.count; i++)
    {
        UIImageView *photoView = self.subviews[i];
        
        if (i < StarsCount.integerValue) { // 显示
            
            photoView.image = [UIImage imageNamed:@"xin"];
            
            photoView.hidden = NO;
        }
        else // 隐藏
        {
            photoView.hidden = YES;
        }
    }
}

- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    // 设置图片的尺寸和位置
    NSUInteger photosCount = self.StarsCount.integerValue;
    
    int maxCol = 5;
    
    for (int i = 0; i<photosCount; i++) {
        
        UIImageView *photoView = self.subviews[i];
        
        int col = i % maxCol;
        photoView.mj_x = col * (HWStatusPhotoW + HWStatusPhotoMargin);
        
        photoView.mj_y = (self.mj_h - HWStatusPhotoH)/2;
        
        photoView.width = HWStatusPhotoW;
        photoView.height = HWStatusPhotoH;
    }
}



@end
