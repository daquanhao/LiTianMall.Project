//
//  HSQSelectionListModel.h
//  LiTianDecoration
//
//  Created by administrator on 2018/6/14.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import "JSONModel.h"

/**
 * @brief 选品库商品列表
 */
@interface HSQSelectionGoodsListModel : JSONModel

/** 商品的名字*/
@property (nonatomic, strong) NSString<Optional> *goodsName;

/** 商品所在店铺的名字*/
@property (nonatomic, strong) NSString<Optional>  *storeName;

/** 商品所在店铺的id*/
@property (nonatomic, strong) NSString<Optional> *storeId;

/** 商品的图片*/
@property (nonatomic, strong) NSString<Optional> *imageSrc;

@end

/**
 * @brief 选品库列表
 */
@interface HSQSelectionListModel : JSONModel

/** 分组id*/
@property (nonatomic, strong) NSString<Optional> *distributorFavoritesId;

/** 参数商品数量 */
@property (nonatomic, strong) NSString<Optional>  *goodsCount;

/** 推广会员id */
@property (nonatomic, strong) NSString<Optional>  *distributorId;

/** 分组名称 */
@property (nonatomic, strong) NSString<Optional>  *distributorFavoritesName;

/** 是否是默认分组 */
@property (nonatomic, strong) NSString<Optional>  *isDefault;

/** 创建时间 */
@property (nonatomic, strong) NSString<Optional>  *createTime;

/** 该分组下的头4个商品信息*/
@property (nonatomic, strong) NSMutableArray<HSQSelectionGoodsListModel *> *distributionGoodsVoList;

/** 该分组下的头4个商品图片链接*/
@property (nonatomic, strong) NSMutableArray<Optional> *ImageArrayUrl;

@end
