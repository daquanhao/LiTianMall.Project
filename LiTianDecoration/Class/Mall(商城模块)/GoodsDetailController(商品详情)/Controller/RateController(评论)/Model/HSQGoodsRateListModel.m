//
//  HSQGoodsRateListModel.m
//  LiTianDecoration
//
//  Created by administrator on 2018/5/11.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import "HSQGoodsRateListModel.h"
#import "HSQGoodsRateImageView.h"

@implementation HSQGoodsRateListModel

- (CGFloat)CellHeight{
    
    CGFloat Height = 35;
    
    // 商品的评价内容
    CGSize Content_size = [NSString SizeOfTheText:self.evaluateContent1 font:[UIFont systemFontOfSize:KLabelFont(14.0, 12.0)] MaxSize:CGSizeMake(KScreenWidth - 20, MAXFLOAT)];
    
    if (self.evaluateContent1.length == 0)
    {
        Height =  35;
    }
    else
    {
        Height = Height + Content_size.height +5;
    }
    
    // 商品评价的图片
    if (self.image1FullList.count > 0)
    {
        CGSize photosSize = [HSQGoodsRateImageView sizeWithCount:self.image1FullList.count];
        
        Height = Height + photosSize.height + 5;
    }
    else
    {
        Height = Height + 0;
    }
    
    // ************** 判断是否有追加评论  ************************
    
    if (self.evaluateAgainTimeStr.length == 0)
    {
        Height = Height + 0;
    }
    else
    {
        // 追评的时间
        CGSize TimetextSize = [NSString SizeOfTheText:self.days font:[UIFont systemFontOfSize:KLabelFont(14.0, 12.0)] MaxSize:CGSizeMake(KScreenWidth - 20, MAXFLOAT)];
        
        CGSize evaluateContent2Size = [NSString SizeOfTheText:self.evaluateContent2 font:[UIFont systemFontOfSize:KLabelFont(14.0, 12.0)] MaxSize:CGSizeMake(KScreenWidth - 20, MAXFLOAT)];
        
        if (self.evaluateContent2.length == 0) // 没有追评内容
        {
            Height = Height + TimetextSize.height + 5;
        }
        else
        {
            Height = Height + evaluateContent2Size.height + 5;
        }
        
        // 商品追加评价的图片
        if (self.image2FullList.count > 0)
        {
            CGSize photosSize = [HSQGoodsRateImageView sizeWithCount:self.image2FullList.count];
            
            Height =  Height + photosSize.height + 5;
        }
        else
        {
            Height =  Height + 0;
        }
    }
    
    return Height + 5;
  
}


@end
