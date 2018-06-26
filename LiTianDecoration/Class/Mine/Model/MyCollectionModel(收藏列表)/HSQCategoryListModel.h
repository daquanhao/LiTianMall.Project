//
//  HSQCategoryListModel.h
//  LiTianDecoration
//
//  Created by administrator on 2018/6/8.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HSQCategoryListModel : NSObject

/** 分类的标题*/
@property (nonatomic, copy) NSString *categoryName;

/** 商品分类编号*/
@property (nonatomic, copy) NSString *categoryId;

/** 深度*/
@property (nonatomic, copy) NSString *deep;

/**  排序*/
@property (nonatomic, copy) NSString *categorySort;

/** 父级分类编号*/
@property (nonatomic, copy) NSString *parentId;

/** 移动端分类图片Url*/
@property (nonatomic, copy) NSString *appImageUrl;

@end
