//
//  MVGoodsDetailViewController.h
//  LiTianDecoration
//
//  Created by administrator on 2018/7/2.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MVGoodsDetailViewControllerDelegate <NSObject>

/**
 * @brief 选择商品的规格
 */
- (void)ChooseTheSpecificationsOfTheGoods:(NSIndexPath *)indexPath;

/**
 * @brief 查看全部评论
 */
- (void)LookUpAllGoodsComment;

/**
 * @brief 上拉查看图文详情
 */
- (void)ScrollupToSeeGraphicDetails:(NSInteger)number;


@end

@interface MVGoodsDetailViewController : UIViewController

/**
 * @brief 商品的详细数据
 */
@property (nonatomic, strong) NSDictionary *responseObject;

/**
 * @brief 设置代理
 */
@property (nonatomic, weak) id <MVGoodsDetailViewControllerDelegate>delegate;

/**
 * @brief 商品的规格
 */
@property (nonatomic, copy) NSString *goodsFullSpecs;

/**
 * @brief 商品的价格
 */
@property (nonatomic, copy) NSString *goodsPrice; 











@end
