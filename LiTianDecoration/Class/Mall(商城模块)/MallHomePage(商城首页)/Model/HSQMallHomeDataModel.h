//
//  HSQMallHomeDataModel.h
//  LiTianDecoration
//
//  Created by administrator on 2018/5/7.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HSQMallHomeDataModel : NSObject

/** 项目编号*/
@property (nonatomic, copy) NSString *itemId;

/** 专题编号*/
@property (nonatomic, copy) NSString *specialId;

/** 项目类型*/
@property (nonatomic, copy) NSString *itemType;

/** 项目数据*/
@property (nonatomic, copy) NSString *itemData;

/** 轮播数据*/
@property (nonatomic, strong) NSArray *itemDataSource;

/** 项目排序 0-999 从小到大排序*/
@property (nonatomic, copy) NSString *itemSort;

/** 专题编号*/
@property (nonatomic, copy) NSString *wap;

/** 微信*/
@property (nonatomic, copy) NSString *wechat;

/** 安卓*/
@property (nonatomic, copy) NSString *android;

/** ios*/
@property (nonatomic, copy) NSString *ios;

/** 项目类型文字*/
@property (nonatomic, copy) NSString *itemTypeText;


@end
