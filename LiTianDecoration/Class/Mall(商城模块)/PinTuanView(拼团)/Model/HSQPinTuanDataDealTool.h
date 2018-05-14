//
//  HSQPinTuanDataDealTool.h
//  LiTianDecoration
//
//  Created by administrator on 2018/5/9.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HSQPinTuanDataDealTool : NSObject

/**
 * @brief 初始化一个单利
 */
+ (HSQPinTuanDataDealTool *)shareDataDealTool;

/**
 * brief 返回是否收藏的字段  0代表没有收藏 1代表收藏
 */
- (NSString *)IsCollectionString:(NSString *)commonId  token:(NSString *)token View:(UIView *)SupView;

/**
 * @brief 返回是否收藏的图片
 */
- (NSString *)imageNameWithIsCollection:(NSString *)isCollection;

/**
 * @brief 收藏某商品
 */
- (NSString *)AddCollectionGoodsToServer:(NSString *)token  goodsId:(NSString *)commonId supView:(UIView *)SupView State:(NSString *)CollectionState;


@end
