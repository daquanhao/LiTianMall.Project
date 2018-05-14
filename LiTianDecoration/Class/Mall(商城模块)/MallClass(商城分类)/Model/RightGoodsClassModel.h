//
//  RightGoodsClassModel.h
//  LiTianDecoration
//
//  Created by administrator on 2018/4/20.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RightGoodsClassModel : NSObject

/** 移动端分类图片 */
@property (nonatomic, copy) NSString *appImage;

/** 移动端分类图片Url */
@property (nonatomic, copy) NSString *appImageUrl;

/** 商品分类编号 */
@property (nonatomic, copy) NSString *categoryId;

/**  商品分类名称 */
@property (nonatomic, copy) NSString *categoryName;

/** 排序 */
@property (nonatomic, copy) NSString *categorySort;

/** 父级分类编号*/
@property (nonatomic, copy) NSString *parentId;

/** 三级菜单的个数*/
@property (nonatomic, strong) NSArray *categoryList;

@end
