//
//  HSQStoreCollectionDataListModel.h
//  LiTianDecoration
//
//  Created by administrator on 2018/6/8.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HSQStoreCollectionDataListModel : NSObject

/** 商品SPU详情*/
@property (nonatomic, strong) NSDictionary *store;

/** 关注编号*/
@property (nonatomic, copy) NSString *favoritesId;

/**  店铺编码*/
@property (nonatomic, copy) NSString *storeId;


/** 关注时间*/
@property (nonatomic, copy) NSString *addTime;

/**  是否展开*/
@property (nonatomic, copy) NSString *IsOpen;

/**  是否是编辑状态*/
@property (nonatomic, copy) NSString *IsEditState;

/**  是否是选中状态*/
@property (nonatomic, copy) NSString *IsSelectState;

@end
