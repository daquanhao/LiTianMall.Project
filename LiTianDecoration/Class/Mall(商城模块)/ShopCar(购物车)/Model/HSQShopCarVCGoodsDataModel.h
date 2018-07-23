//
//  HSQShopCarVCGoodsDataModel.h
//  LiTianDecoration
//
//  Created by administrator on 2018/5/22.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import "JSONModel.h"

@class HSQShopCarGoodsTypeListModel;

@interface HSQShopCarVCSecondGoodsDataModel : JSONModel

/** 每种商品下有几种规格的商品*/
@property (nonatomic, strong) NSMutableArray *cartItemVoList;

/** 每种商品下有几种规格的商品*/
@property (nonatomic, strong) NSMutableArray<Optional> *SecondCartItemVoList;

/**商品的图片*/
@property (nonatomic, strong) NSString<Optional>  *imageSrc;

/** 商品的名字*/
@property (nonatomic, strong) NSString<Optional> *goodsName;

/** 规格商品的是否被选中*/
@property (nonatomic, strong) NSString<Optional> *IsSelect;

/** cell的数组属性，用于判断cell是否全部选中 */
@property (nonatomic, strong) NSMutableArray<Optional>  *Select_DataSource;

/** 商品的id*/
@property (nonatomic, strong) NSString <Optional> *commonId;

/** 用于判断选中商品的种类数，和总的数量*/
@property (nonatomic, strong) NSMutableArray<Optional>  *Cell_array;



/** 提交订单。商品有几种类型*/
@property (nonatomic, strong) NSMutableArray <Optional> *buyGoodsItemVoListSource;

@end

@interface HSQShopCarVCGoodsDataModel : JSONModel

/** 店铺的id*/
@property (nonatomic, strong) NSString<Optional> *storeId;

/** 优惠套装*/
@property (nonatomic, strong) NSArray<Optional>  *cartBundlingVoList;

/** 有多少个店铺*/
@property (nonatomic, strong) NSArray<Optional>  *cartStoreVoList;

/** 一共购买的数量*/
@property (nonatomic, strong) NSString<Optional> *buyNum;

/** 店铺的名字*/
@property (nonatomic, strong) NSString<Optional> *storeName;

/** 购物车总金额*/
@property (nonatomic, strong) NSString<Optional> *cartAmount;

/** 规格商品的是否被选中*/
@property (nonatomic, strong) NSString<Optional> *IsSelect;

/** 每个店铺中有多少个商品*/
@property (nonatomic, strong) NSMutableArray<Optional> *cartSpuVoList;

/** 每个店铺里商品的选中个数*/
@property (nonatomic, strong) NSMutableArray<Optional> *StoreSelect_Source;

/** 优惠套装*/
@property (nonatomic, strong) NSArray<Optional> *cartDbMaxCount;

/** 选中商品的种类及数量*/
@property (nonatomic, strong) NSString<Optional> *SelectTypeString;

/** 选中商品的数量*/
@property (nonatomic, strong) NSString<Optional> *SelectCountString;

/** 选中商品的总的价钱*/
@property (nonatomic, strong) NSString<Optional> *SelectGoodsPrice;

/** 用于判断选中商品的种类数，和总的数量*/
@property (nonatomic, strong) NSMutableArray<Optional>  *Cell_array;



/** 提交订单界面 有多少个商品**/
@property (nonatomic, strong) NSMutableArray<Optional>*buyGoodsSpuVoList;

/** 提交订单界面，优惠券列表**/
@property (nonatomic, strong) NSArray <Optional> *conformList;

/** 提交订单界面商品的总金额*/
@property (nonatomic, strong) NSString<Optional> *buyItemAmount;

/** 提交订单界面--买家留言*/
@property (nonatomic, strong) NSString<Optional> *receiverMessage;

/** 提交订单界面--优惠活动的id*/
@property (nonatomic, strong) NSString<Optional> *conformId;




@end
