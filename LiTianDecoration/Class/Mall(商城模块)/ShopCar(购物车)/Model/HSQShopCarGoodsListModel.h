//
//  HSQShopCarGoodsListModel.h
//  LiTianDecoration
//
//  Created by administrator on 2018/5/18.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HSQShopCarGoodsListModel : NSObject

/** 商品的SKU编号*/
@property (nonatomic, copy) NSString *commonId;

/** 商品的id*/
@property (nonatomic, copy) NSString *goodsId;

/** 商品的数量*/
@property (nonatomic, copy) NSString *buyNum;

/** 商品的库存*/
@property (nonatomic, copy) NSString *goodsStorage;

/** 商品状态 1—有效 0–无效（下架）*/
@property (nonatomic, copy) NSString *goodsStatus;

/** 如果是优惠套装，优惠套装Id*/
@property (nonatomic, copy) NSString *bundlingId;

/** 添加购物车数据*/
@property (nonatomic, copy) NSString *buyData;

/** 客户端类型（android , ios,wap,wechat）*/
@property (nonatomic, copy) NSString *clientType;

/** 未登录时本地购物车数据（必填）,由商品(sku)Id和购买数量构成，登录后该参数不必传*/
@property (nonatomic, copy) NSString *cartData;


@end
