//
//  HSQChooseproductlibraryHeadView.h
//  LiTianDecoration
//
//  Created by administrator on 2018/6/14.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HSQSelectionListModel;

@protocol HSQChooseproductlibraryHeadViewDelegate <NSObject>

/**
 * @brief 进入分组详情
 */
- (void)DetailsOfAccessToTheSelectiveLibrary:(UIButton *)sender;

@end

@interface HSQChooseproductlibraryHeadView : UICollectionReusableView

/**
 * @brief 数据模型
 */
@property (nonatomic, strong) HSQSelectionListModel *model;

/**
 * @brief 标记
 */
@property (nonatomic, assign) NSInteger section;

/**
 * @brief 设置代理
 */
@property (nonatomic, weak) id<HSQChooseproductlibraryHeadViewDelegate>delegate;

@end
