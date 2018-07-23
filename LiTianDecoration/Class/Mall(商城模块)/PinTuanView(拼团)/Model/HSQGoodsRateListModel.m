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
    
    // 评论文字的大小
    CGSize textSize = [NSString SizeOfTheText:self.evaluateContent1 font:[UIFont systemFontOfSize:14.0] MaxSize:CGSizeMake(KScreenWidth-20, MAXFLOAT)];
    
    CGSize RateImageSize = [HSQGoodsRateImageView sizeWithCount:self.image1FullList.count];
    
    if (self.image1FullList.count > 0)
    {
          return 60 + textSize.height + RateImageSize.height + 10;
    }
    else
    {
          return 50 + textSize.height + 10;
    }
  
}


@end
