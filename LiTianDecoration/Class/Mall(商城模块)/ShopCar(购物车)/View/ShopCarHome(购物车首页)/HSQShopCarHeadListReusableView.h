//
//  HSQShopCarHeadListReusableView.h
//  LiTianDecoration
//
//  Created by administrator on 2018/5/21.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HSQShopCarVCGoodsDataModel;

@protocol HSQShopCarHeadListReusableViewDelegate <NSObject>

- (void)HeaderReusableViewLeftRato_ButtonClickAction:(UIButton *)sender;

@end

@interface HSQShopCarHeadListReusableView : UICollectionReusableView

/**
 * @brief 接收上一个界面的模型数据
 */
@property (nonatomic, strong) HSQShopCarVCGoodsDataModel *Model;

/**
 * @brief 设置
 */
@property (nonatomic, weak) id<HSQShopCarHeadListReusableViewDelegate>delegate;

/**
 * @brief 分区的排列数值
 */
@property (nonatomic, copy) NSString *Section;

@end
