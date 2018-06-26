//
//  HSQStoreSearchListDataModel.h
//  LiTianDecoration
//
//  Created by administrator on 2018/6/18.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import "JSONModel.h"

@interface HSQGoodsCommonListModel : JSONModel

/** 商品的名字*/
@property (nonatomic, strong) NSString<Optional> *goodsName;

/** 商品SPU */
@property (nonatomic, strong) NSString<Optional>  *commonId;

/** app显示价格 */
@property (nonatomic, strong) NSString<Optional> *appPriceMin;

/** 商品的图片*/
@property (nonatomic, strong) NSString<Optional> *imageSrc;

@end

@interface HSQStoreSearchListDataModel : JSONModel

/** 店铺编号*/
@property (nonatomic, strong) NSString<Optional> *storeId;

/** 店铺名称 */
@property (nonatomic, strong) NSString<Optional>  *storeName;

/** 店铺头像*/
@property (nonatomic, strong) NSString<Optional>  *storeAvatarUrl;

/** 店铺销量 */
@property (nonatomic, strong) NSString<Optional>  *storeSales;

/** 店铺的收藏量 */
@property (nonatomic, strong) NSString<Optional>  *storeCollect;

/** 商品数量 */
@property (nonatomic, strong) NSString<Optional>  *goodsCommonCount;

/** 主营产品 */
@property (nonatomic, strong) NSString<Optional>  *storeZy;

/** 是否是自营店铺（1是，0否） */
@property (nonatomic, strong) NSString<Optional>  *isOwnShop;

/** 商品列表*/
@property (nonatomic, strong) NSMutableArray<HSQGoodsCommonListModel *> *goodsCommonList;


@end
