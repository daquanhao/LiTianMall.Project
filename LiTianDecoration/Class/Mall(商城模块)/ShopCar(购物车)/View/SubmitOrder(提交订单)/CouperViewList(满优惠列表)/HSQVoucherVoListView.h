//
//  HSQVoucherVoListView.h
//  LiTianDecoration
//
//  Created by administrator on 2018/7/9.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HSQVoucherVoListView : UIView

/**
 * @brief 初始化视图
 */
+ (instancetype)initSubmitVoucherListView;

/**
 * @brief 显示视图
 */
- (void)ShowSubmitVoucherListView;

/**
 * @Brief 店铺券的数据
 */
- (void)SetValueDataWithArray:(NSArray *)data_Array Select_Index:(NSString *)index;


/**
 * @brief 回调选中的地址
 */
@property (nonatomic,copy) void(^SelectVoucherDataBlock)(id success);

@end
