//
//  HSQSubmitOrderSelectCouperModel.h
//  LiTianDecoration
//
//  Created by administrator on 2018/5/25.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HSQSubmitOrderSelectCouperModel : NSObject

/**
* @brief 满优惠是否被选中
*/
@property (nonatomic, copy) NSString *IsSelect;

/**
 * @brief 店铺券是否被选中
 */
@property (nonatomic, copy) NSString *IsVoucher;

/**
 * @brief 选中的满优惠
 */
@property (nonatomic, strong) NSMutableArray *conformList;

/**
 * @brief 选中的店铺券
 */
@property (nonatomic, strong) NSMutableArray *voucherVoList;

/**
 * @brief 选中的平台红包
 */
@property (nonatomic, strong) NSMutableArray *redPackageVoList;


@end
