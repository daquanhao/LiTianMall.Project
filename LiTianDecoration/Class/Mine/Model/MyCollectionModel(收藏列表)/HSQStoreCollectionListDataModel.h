//
//  HSQStoreCollectionListDataModel.h
//  LiTianDecoration
//
//  Created by administrator on 2018/6/29.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import "JSONModel.h"

@interface HSQNewGoodsListModel : JSONModel

/** 商品的SKU*/
@property (nonatomic, copy) NSString<Optional>  *commonId;

/** 商品的名字*/
@property (nonatomic, copy) NSString<Optional>  *goodsName;

/** 商品的价格*/
@property (nonatomic, copy) NSString<Optional>  *appPrice0;

/** 商品的图片*/
@property (nonatomic, copy) NSString<Optional>  *imageSrc;

@end

@interface HSQStoreCollectionListDataModel : JSONModel

/** 商品SPU详情*/
@property (nonatomic, strong) NSDictionary *store;

/** 关注编号*/
@property (nonatomic, copy) NSString<Optional>  *favoritesId;

/**  店铺编码*/
@property (nonatomic, copy) NSString<Optional>  *storeId;

/** 关注时间*/
@property (nonatomic, copy) NSString<Optional>  *addTime;

/**  是否展开*/
@property (nonatomic, copy) NSString<Optional>  *IsOpen;

/**  是否是编辑状态*/
@property (nonatomic, copy) NSString<Optional>  *IsEditState;

/**  是否是选中状态*/
@property (nonatomic, copy) NSString<Optional>  *IsSelectState;

/**  是否显示商品的视图 0 不显示 1 显示*/
@property (nonatomic, copy) NSString<Optional>  *IsShow;

/**  店铺新品 */
@property (nonatomic, strong) NSMutableArray<Optional>  *StoreNewGoodsList;

@end
