//
//  HSQPhotosView.m
//  LiTianDecoration
//
//  Created by administrator on 2018/4/17.
//  Copyright © 2018年 administrator. All rights reserved.
//

#define HWStatusPhotoWH 70
#define HWStatusPhotoMargin 10
#define HWStatusPhotoMaxCol(count) ((count==4)?2:3)

#import "HSQPhotosView.h"
#import "HWStatusPhotoView.h"

@implementation HSQPhotosView

- (id)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
    }
    return self;
}

- (void)setPhotos:(NSArray *)photos{
    
    _photos = photos;
    
    NSUInteger photosCount = photos.count;
    
    // 创建足够数量的图片控件
    // 这里的self.subviews.count不要单独赋值给其他变量
    while (self.subviews.count < photosCount) {
        
        HWStatusPhotoView *photoView = [[HWStatusPhotoView alloc] init];
        
        [self addSubview:photoView];
    }
    
    // 遍历所有的图片控件，设置图片
    for (int i = 0; i<self.subviews.count; i++)
    {
        HWStatusPhotoView *photoView = self.subviews[i];
        
        if (i < photosCount) { // 显示
            
//            photoView.photo = photos[i];
            photoView.image_url = photos[i];
            
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
    
    int maxCol = HWStatusPhotoMaxCol(photosCount);
    
    for (int i = 0; i<photosCount; i++) {
        
        HWStatusPhotoView *photoView = self.subviews[i];
        
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
    int maxCols = HWStatusPhotoMaxCol(count);
    
   // 列数
    NSUInteger cols = (count >= maxCols)? maxCols : count;
    CGFloat photosW = cols * HWStatusPhotoWH + (cols - 1) * HWStatusPhotoMargin;
    
    // 行数
    NSUInteger rows = (count + maxCols - 1) / maxCols;
    CGFloat photosH = rows * HWStatusPhotoWH + (rows - 1) * HWStatusPhotoMargin;
    
    return CGSizeMake(photosW, photosH);
}

@end
