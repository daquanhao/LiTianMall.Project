//
//  HSQTrialReportFrameModel.h
//  LiTianDecoration
//
//  Created by administrator on 2018/4/17.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HSQTrialReportListModel;

@interface HSQTrialReportFrameModel : NSObject

@property (nonatomic, strong) HSQTrialReportListModel *model;

/** 计算头像的尺寸*/
@property (nonatomic, assign) CGRect iconFrame;

/** 计算昵称的尺寸*/
@property (nonatomic, assign) CGRect NickNameFrame;

/** 计算时间的尺寸*/
@property (nonatomic, assign) CGRect TimeLabelFrame;

/** 计算商品名字的尺寸*/
@property (nonatomic, assign) CGRect GoodsNameFrame;

/** 计算分割线的尺寸*/
@property (nonatomic, assign) CGRect LineViewFrame;

/** 计算评论内容的尺寸*/
@property (nonatomic, assign) CGRect ContentFrame;

/** 计算评论图片的尺寸*/
@property (nonatomic, assign) CGRect PhotosViewFrame;

/** 计算cell片的尺寸*/
@property (nonatomic, assign) CGFloat CellHeight;



@end
