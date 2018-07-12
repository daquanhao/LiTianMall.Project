//
//  HSQTrialReportFrameModel.m
//  LiTianDecoration
//
//  Created by administrator on 2018/4/17.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import "HSQTrialReportFrameModel.h"
#import "HSQTrialReportListModel.h"
#import "HSQPhotosView.h"

@implementation HSQTrialReportFrameModel

- (void)setModel:(HSQTrialReportListModel *)model{
    
    _model = model;
    
    CGFloat originalH = 0;
    
    // 1.计算头像的尺寸
    CGFloat IconImageHW = 50;
    self.iconFrame = CGRectMake(10, 10, IconImageHW, IconImageHW);
    
    // 2.计算昵称的尺寸
    self.NickNameFrame = CGRectMake(CGRectGetMaxX(self.iconFrame)+10, self.iconFrame.origin.y, KScreenWidth - CGRectGetMaxY(self.iconFrame) - 20, 25);
    
    // 3.计算时间的尺寸
    self.TimeLabelFrame = CGRectMake(self.NickNameFrame.origin.x, CGRectGetMaxY(self.NickNameFrame), self.NickNameFrame.size.width, 25);
    
    // 4.计算商品名字的尺寸
    self.GoodsNameFrame = CGRectMake(self.iconFrame.origin.x, CGRectGetMaxY(self.iconFrame)+10, KScreenWidth - 20, 25);
    
    // 5.分割线的尺寸
    self.LineViewFrame = CGRectMake(self.iconFrame.origin.x, CGRectGetMaxY(self.GoodsNameFrame)+10, KScreenWidth - 20, 1);
    
    // 6.评论的内容
    CGSize size = [NSString SizeOfTheText:model.reportContent font:[UIFont systemFontOfSize:KLabelFont(14.0, 12.0)] MaxSize:CGSizeMake(KScreenWidth - 20, MAXFLOAT)];
    self.ContentFrame = CGRectMake(self.iconFrame.origin.x, CGRectGetMaxY(self.LineViewFrame)+10, KScreenWidth - 20, size.height);
    
    // 7.评论图片的尺寸
    if (model.images.count > 0) // 有评论图片
    {
        CGFloat photosX = self.iconFrame.origin.x;
        
        CGFloat photosY = CGRectGetMaxY(self.ContentFrame) + 10;
        
        CGSize photosSize = [HSQPhotosView sizeWithCount:model.images.count];
        
        self.PhotosViewFrame = (CGRect){{photosX, photosY}, photosSize};
        
        originalH = CGRectGetMaxY(self.PhotosViewFrame);
    }
    else
    {
        originalH = CGRectGetMaxY(self.ContentFrame);
    }
    
    /* cell的高度 */
    self.CellHeight = originalH + 10;
}



@end
