//
//  HSQStoreActivityListCollectionViewCell.h
//  LiTianDecoration
//
//  Created by administrator on 2018/5/16.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HSQStoreActivityListCollectionViewCell : UICollectionViewCell

/**
 * @brief 店铺限时折扣活动的数据
 */
@property (nonatomic, strong) NSDictionary *discountList_diction;

/**
 * @brief  店铺优惠券活动的数据
 */
@property (nonatomic, strong) NSDictionary *conformList_diction;

@end
