//
//  HSQGoodsRateListModel.h
//  LiTianDecoration
//
//  Created by administrator on 2018/5/11.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HSQGoodsRateListModel : NSObject

/** 会员头像图片*/
@property (nonatomic, copy) NSString *memberHeadUrl;

/** 会员名称*/
@property (nonatomic, copy) NSString *memberName;

/** 商品完整规格*/
@property (nonatomic, copy) NSString *goodsFullSpecs;

/**商品评分*/
@property (nonatomic, copy) NSString *scores;

/** 商品评价内容*/
@property (nonatomic, copy) NSString *evaluateContent1;

/** 商品评价内容*/
@property (nonatomic, copy) NSString *images1;

/** 评价图片数组*/
@property (nonatomic, strong) NSArray *image1FullList;

/** 评价时间*/
@property (nonatomic, copy) NSString *evaluateTimeStr;

/** 解释评价*/
@property (nonatomic, copy) NSString *explainContent1;

/** 追评内容*/
@property (nonatomic, copy) NSString *evaluateContent2;

/** 追评图片*/
@property (nonatomic, copy) NSString *images2;

/** 追评图片数组*/
@property (nonatomic, strong) NSArray *image2FullList;

/** 解释追评*/
@property (nonatomic, copy) NSString *explainContent2;

/** 追加评价时间*/
@property (nonatomic, copy) NSString *evaluateAgainTimeStr;

/** 确认收货并评价后{days}天再次追加评价*/
@property (nonatomic, copy) NSString *days;

/** cell的高度*/
@property (nonatomic, assign) CGFloat CellHeight;







@end
