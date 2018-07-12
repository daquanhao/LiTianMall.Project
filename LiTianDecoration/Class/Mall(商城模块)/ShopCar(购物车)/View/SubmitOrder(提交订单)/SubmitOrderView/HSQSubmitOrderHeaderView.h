//
//  HSQSubmitOrderHeaderView.h
//  LiTianDecoration
//
//  Created by administrator on 2018/5/24.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HSQShopCarVCGoodsDataModel;

@interface HSQSubmitOrderHeaderView : UITableViewHeaderFooterView

/**
 * @brief 数据模型
 */
@property (nonatomic, strong) HSQShopCarVCGoodsDataModel *model;

@end
