//
//  HSQGoodsRateListFrameModel.m
//  LiTianDecoration
//
//  Created by administrator on 2018/5/12.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import "HSQGoodsRateListFrameModel.h"
#import "HSQGoodsRateListModel.h"
#import "HSQGoodsRateImageView.h"

@implementation HSQGoodsRateListFrameModel

- (void)setModel:(HSQGoodsRateListModel *)model{
    
    _model = model;
    
     CGFloat originalH = 0;
    
    // 评论文字的大小
    CGSize textSize = [NSString SizeOfTheText:model.evaluateContent1 font:[UIFont systemFontOfSize:14.0] MaxSize:CGSizeMake(KScreenWidth-20, MAXFLOAT)];
    self.ContentFrame = CGRectMake(10, 10, KScreenWidth - 20, textSize.height);
    originalH = CGRectGetMaxY(self.ContentFrame)+10;
    
    // 追评的时间
    CGSize TimetextSize = [NSString SizeOfTheText:model.days font:[UIFont systemFontOfSize:14.0] MaxSize:CGSizeMake(KScreenWidth-20, MAXFLOAT)];
    
    // 评论图片的尺寸
    if (model.image1FullList.count > 0)
    {
        CGSize photosSize = [HSQGoodsRateImageView sizeWithCount:model.image1FullList.count];
        
        self.ContentImageViewFrame = CGRectMake(10, CGRectGetMaxY(self.ContentFrame)+10, photosSize.width, photosSize.height);
        
        originalH = CGRectGetMaxY(self.ContentImageViewFrame)+10;
    }
    else
    {
        originalH = CGRectGetMaxY(self.ContentFrame)+10;
    }
    
    // 判断有没有追加的评论
    if (model.evaluateAgainTimeStr.length == 0) // 没有追加评论
    {
        originalH = originalH + 0;
    }
    else
    {
        // 追加评论左边红色的图片
        self.LeftImageFrame = CGRectMake(10, originalH, 3, TimetextSize.height);
        
        // 追评时间左边的图片
        self.ZhuiJiaRateTimeFrame = CGRectMake(CGRectGetMaxX(self.LeftImageFrame)+5, self.LeftImageFrame.origin.y, KScreenWidth-20, TimetextSize.height);
        originalH = CGRectGetMaxY(self.ZhuiJiaRateTimeFrame)+10;
        
        // 追评的内容的大小
        CGSize ZhuiContentSize = [NSString SizeOfTheText:model.evaluateContent2 font:[UIFont systemFontOfSize:14.0] MaxSize:CGSizeMake(KScreenWidth-20, MAXFLOAT)];
        self.ZhuiJiaContentFrame = CGRectMake(10, CGRectGetMaxY(self.ZhuiJiaRateTimeFrame)+5, KScreenWidth-20, ZhuiContentSize.height);
        originalH = CGRectGetMaxY(self.ZhuiJiaContentFrame)+10;
        
        // 追评的图片的尺寸
        if (model.image2FullList.count > 0)
        {
            CGSize ZhuiRateImageSize = [HSQGoodsRateImageView sizeWithCount:model.image2FullList.count];
            self.ZhuiJiaRateImageFrame = CGRectMake(10, CGRectGetMaxY(self.ZhuiJiaContentFrame)+10, ZhuiRateImageSize.width, ZhuiRateImageSize.height);
            originalH = CGRectGetMaxY(self.ZhuiJiaRateImageFrame)+10;
        }
        else
        {
            originalH = CGRectGetMaxY(self.ZhuiJiaContentFrame)+10;
        }
    }
    
    self.CellHeight = originalH;
    
    // 底部分区的尺寸
    CGSize FootertextSize = [NSString SizeOfTheText:model.goodsFullSpecs font:[UIFont systemFontOfSize:KLabelFont(14.0, 12.0)] MaxSize:CGSizeMake(KScreenWidth-20, MAXFLOAT)];
    self.FooterViewHeight =  FootertextSize.height + 20;
    
}



@end
