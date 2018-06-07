//
//  HSQChooseTuiKuanReasonView.h
//  LiTianDecoration
//
//  Created by administrator on 2018/6/4.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HSQChooseTuiKuanReasonView : UIView

/**
 * @brief 初始化视图
 */
+ (instancetype)initChooseTuiKuanReasonView;

/**
 * @brief 显示视图
 */
- (void)ShowChooseTuiKuanReasonView;

/**
 * @Brief 选中的数据
 */
- (void)SetValueDataWithArray:(NSArray *)data_Array Select_Index:(NSString *)index;

/**
 * @brief 回调选中的地址
 */
@property (nonatomic,copy) void(^SelectReasonDataBlock)(id success);

@end
