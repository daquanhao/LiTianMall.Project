//
//  HSQStoreSearchHeadReusableView.h
//  LiTianDecoration
//
//  Created by administrator on 2018/6/18.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HSQStoreSearchListDataModel;

@protocol HSQStoreSearchHeadReusableViewDelegate <NSObject>

/**
 * @brief 进入店铺详情
 */
- (void)JoinStoreDetailDataWithButton:(UIButton *)sender;

@end

@interface HSQStoreSearchHeadReusableView : UICollectionReusableView

/**
 * @brief 数据模型
 */
@property (nonatomic, strong) HSQStoreSearchListDataModel *model;

/**
 * @brief 设置代理
 */
@property (nonatomic, weak) id<HSQStoreSearchHeadReusableViewDelegate>delegate;

/**
 * @brief 下标
 */
@property (nonatomic, assign) NSInteger section;

@end
