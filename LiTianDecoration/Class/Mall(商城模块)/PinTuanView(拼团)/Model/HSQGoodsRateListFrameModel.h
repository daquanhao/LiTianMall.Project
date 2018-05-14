//
//  HSQGoodsRateListFrameModel.h
//  LiTianDecoration
//
//  Created by administrator on 2018/5/12.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HSQGoodsRateListModel;

@interface HSQGoodsRateListFrameModel : NSObject

@property (nonatomic, strong) HSQGoodsRateListModel *model;

/** 用户评论的内容的Frame*/
@property (nonatomic, assign) CGRect ContentFrame;

/** 用户评论的图片的Frame*/
@property (nonatomic, assign) CGRect ContentImageViewFrame;

/** 追加评论的时间坐标的图片*/
@property (nonatomic, assign) CGRect LeftImageFrame;

/** 用户追加评论的时间的Frame*/
@property (nonatomic, assign) CGRect ZhuiJiaRateTimeFrame;

/** 用户追加评论的内容的Frame*/
@property (nonatomic, assign) CGRect ZhuiJiaContentFrame;

/** 用户追加评论的图片的Frame*/
@property (nonatomic, assign) CGRect ZhuiJiaRateImageFrame;

/** 用户cell的高度*/
@property (nonatomic, assign) CGFloat CellHeight;

/** footerViewde高度*/
@property (nonatomic, assign) CGFloat FooterViewHeight;

@end
