//
//  BrowseFootprintListModel.h
//  LiTianDecoration
//
//  Created by administrator on 2018/4/27.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BrowseFootprintListModel : NSObject

/** 商品的图片*/
@property (nonatomic, copy) NSString *imageName;

/** 商品的名字*/
@property (nonatomic, copy) NSString *goodsName;

/** 会员ID*/
@property (nonatomic, copy) NSString *memberId;

/** 商品SPU编号*/
@property (nonatomic, copy) NSString *commonId;

/**商品的价格*/
@property (nonatomic, copy) NSString *appPrice0;

/** 商品的信息*/
@property (nonatomic, strong) NSDictionary *goodsCommon;

@end


