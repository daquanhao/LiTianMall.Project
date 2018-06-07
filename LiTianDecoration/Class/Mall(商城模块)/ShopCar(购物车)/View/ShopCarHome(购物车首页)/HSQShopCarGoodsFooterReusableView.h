//
//  HSQShopCarGoodsFooterReusableView.h
//  LiTianDecoration
//
//  Created by administrator on 2018/5/21.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HSQShopCarVCGoodsDataModel;

@interface HSQShopCarGoodsFooterReusableView : UICollectionReusableView

/**
 * @brief 编辑按钮的点击状态
 */
@property (nonatomic, copy) NSString *RightItemEditState;

/**
 * @brief 数据的模型
 */
@property (nonatomic, strong) HSQShopCarVCGoodsDataModel *FirstModel;

@end
