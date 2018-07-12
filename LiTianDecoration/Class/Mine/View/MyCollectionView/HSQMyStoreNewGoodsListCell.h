//
//  HSQMyStoreNewGoodsListCell.h
//  LiTianDecoration
//
//  Created by administrator on 2018/6/29.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HSQStoreCollectionListDataModel;

@protocol HSQMyStoreNewGoodsListCellDelegate <NSObject>

/**
 * @brief 进入商品详情的点击
 */
- (void)JoinGoodsDetailViewControllerWithindexPath:(NSIndexPath *)indexPath StoreModel:(HSQStoreCollectionListDataModel *)Model;

@end

@interface HSQMyStoreNewGoodsListCell : UITableViewCell

/**
 * @brief 数据模型
 */
@property (nonatomic, strong) HSQStoreCollectionListDataModel *StoreListModel;

/**
 * @brief 设置代理
 */
@property (nonatomic, weak) id<HSQMyStoreNewGoodsListCellDelegate>delegate;

@end
