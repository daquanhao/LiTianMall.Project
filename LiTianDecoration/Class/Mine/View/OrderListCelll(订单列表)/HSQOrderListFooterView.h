//
//  HSQOrderListFooterView.h
//  LiTianDecoration
//
//  Created by administrator on 2018/5/26.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HSQOrderListFirstCengModel;

@protocol HSQOrderListFooterViewDelegate <NSObject>

/**
 * @brief 底部按钮的点击
 */
- (void)hsqOrderListFooterViewBottomButtonClickAction:(UIButton *)sender;

@end

@interface HSQOrderListFooterView : UITableViewHeaderFooterView

/**
 * @brief 数据模型
 */
@property (nonatomic, strong) HSQOrderListFirstCengModel *model;

/**
 * @biref 数据的位置
 */
@property (nonatomic, assign) NSInteger Section;

/**
 * @brief 设置代理
 */
@property (nonatomic, weak) id<HSQOrderListFooterViewDelegate>delegate;

@end
