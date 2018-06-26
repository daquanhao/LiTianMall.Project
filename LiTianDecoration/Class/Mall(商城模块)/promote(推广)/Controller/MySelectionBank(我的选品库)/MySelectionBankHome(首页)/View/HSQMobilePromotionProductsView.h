//
//  HSQMobilePromotionProductsView.h
//  LiTianDecoration
//
//  Created by administrator on 2018/6/14.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HSQMobilePromotionProductsView : UIView

/**
 * @brief 初始化视图
 */
+ (instancetype)initMobilePromotionProductsView;

/**
 * @brief 显示视图
 */
- (void)ShowMobilePromotionProductsView;

/**
 * @brief 分组的id
 */
@property (nonatomic, copy) NSString *distributorFavoritesId;

/**
 * @brief 点击的回调
 */
@property (nonatomic, copy)void(^ClickGroupSuccessBlock) (id distributorFavoritesId);







@end
