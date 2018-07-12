//
//  HSQMyStoreCollectionHeaderView.h
//  LiTianDecoration
//
//  Created by administrator on 2018/6/29.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HSQStoreCollectionListDataModel;

@protocol HSQMyStoreCollectionHeaderViewDelegate <NSObject>

@optional

/**
 * @brief 编辑时选中按钮的点击事件
 */
- (void)SelectTheClickEventOfTheButtonWhenEditing:(UIButton *)sender;

/**
 * @brief 进入店铺详情的点击事件
 */
- (void)JoinStoreDetailButtonClickAction:(UIButton *)sender;

/**
 * @brief 显示商品视图按钮的点击事件
 */
- (void)ShowGoodsViewBtnClickAction:(UIButton *)sender;

@end

@interface HSQMyStoreCollectionHeaderView : UITableViewHeaderFooterView

@property (nonatomic, strong) HSQStoreCollectionListDataModel *StoreModel;

@property (nonatomic, assign) NSInteger section;

@property (nonatomic, weak) id<HSQMyStoreCollectionHeaderViewDelegate>delegate;

@end

