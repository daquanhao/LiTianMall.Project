//
//  HSQSelectGroupImageListView.m
//  LiTianDecoration
//
//  Created by administrator on 2018/5/12.
//  Copyright © 2018年 administrator. All rights reserved.
//

#define HWStatusPhotoWH ((KScreenWidth - 10)/2 - 10 - 9) / 4
#define HWStatusPhotoMargin 3
//#define HWStatusPhotoMaxCol(count) ((count==4)?2:3)


#import "HSQSelectGroupImageListView.h"

@interface HSQSelectGroupImageListView ()

@end

@implementation HSQSelectGroupImageListView

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        
    }
    
    return self;
}

/**
 * @brief 图片的个数
 */
- (void)setPhotos:(NSArray *)photos{
    
    _photos = photos;
    
    // 创建足够数量的图片控件
    while (self.subviews.count < photos.count) {
        
        UIImageView *photoView = [[UIImageView alloc] init];
        
        [self addSubview:photoView];
    }
    
    // 遍历所有的图片控件，设置图片
    for (int i = 0; i<self.subviews.count; i++)
    {
        UIImageView *photoView = self.subviews[i];
        
        if (i < photos.count) // 显示
        {
            [photoView sd_setImageWithURL:[NSURL URLWithString:photos[i]] placeholderImage:KGoodsPlacherImage];
            
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
    NSUInteger photosCount = self.photos.count;
    
    int maxCol = 4;
    
    for (int i = 0; i<photosCount; i++) {
        
        UIImageView *photoView = self.subviews[i];
        
        int col = i % maxCol;
        photoView.mj_x = col * (HWStatusPhotoWH + HWStatusPhotoMargin);
        
        int row = i / maxCol;
        photoView.mj_y = row * (HWStatusPhotoWH + HWStatusPhotoMargin);
        
        photoView.width = HWStatusPhotoWH;
        photoView.height = HWStatusPhotoWH;
    }
}

/** 根据图片个数计算相册的尺寸 */
+ (CGSize)sizeWithCount:(NSUInteger)count{
    
    // 最大列数（一行最多有多少列）
    int maxCols = 4;
    
    if (count == 0)
    {
        return CGSizeMake(0, 0);
    }
    else
    {
        // 列数
        NSUInteger cols = (count >= maxCols)? maxCols : count;
        CGFloat photosW = cols * HWStatusPhotoWH + (cols - 1) * HWStatusPhotoMargin;
        
        // 行数
        NSUInteger rows = (count + maxCols - 1) / maxCols;
        CGFloat photosH = rows * HWStatusPhotoWH + (rows - 1) * HWStatusPhotoMargin;
        
        return CGSizeMake(photosW, photosH);
    }
}

@end
