//
//  HSQGoodsGuiGeTypeModel.h
//  LiTianDecoration
//
//  Created by administrator on 2018/5/14.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import "JSONModel.h"

@interface HSQGoodsGuiGeListModel : JSONModel

/** 规格的id*/
@property (nonatomic, strong) NSString<Optional> *specValueId;

/** 规格的名字*/
@property (nonatomic, strong) NSString<Optional>  *specValueName;

/** 规格商品的图片*/
@property (nonatomic, strong) NSString<Optional> *imageSrc;

/** 规格商品的是否被选中*/
@property (nonatomic, strong) NSString<Optional> *IsSelect;

@end

@interface HSQGoodsGuiGeTypeModel : JSONModel

/** 规格的id*/
@property (nonatomic, strong) NSString<Optional> *specId;

/** 规格的名字*/
@property (nonatomic, strong) NSString<Optional>  *specName;

/** 规格下的种类*/
@property (nonatomic, strong) NSMutableArray<HSQGoodsGuiGeListModel *> *specValueList;

@end
