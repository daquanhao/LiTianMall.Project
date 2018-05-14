//
//  HSQPinTuanListModel.h
//  LiTianDecoration
//
//  Created by administrator on 2018/5/8.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HSQPinTuanListModel : NSObject

/** 商品SPU编号*/
@property (nonatomic, copy) NSString *commonId;

/** 团长数据*/
@property (nonatomic, strong) NSArray *groupLogList;

/** 商品名称*/
@property (nonatomic, copy) NSString *goodsName;

/** 已参与拼团买家数*/
@property (nonatomic, copy) NSString *joinedNum;

/** 商品价格号*/
@property (nonatomic, copy) NSString *goodsPrice;

/** 拼团价格*/
@property (nonatomic, copy) NSString *groupPrice;

/** 拼团编号*/
@property (nonatomic, copy) NSString *groupId;

/** 商品图片*/
@property (nonatomic, copy) NSString *imageName;

/**  商品图片Url*/
@property (nonatomic, copy) NSString *imageSrc;



@end
