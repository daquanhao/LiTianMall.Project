//
//  HSQRedPageListView.h
//  LiTianDecoration
//
//  Created by administrator on 2018/7/10.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HSQRedPageListView : UIView

/**
 * @brief 初始化视图
 */
+ (instancetype)initSubmitRedPageListView;

/**
 * @brief 显示视图
 */
- (void)ShowSubmitRedPageListView;

/**
 * @Brief 店铺券的数据
 */
- (void)SetValueDataWithArray:(NSArray *)data_Array Select_Index:(NSString *)index;


/**
 * @brief 回调选中的地址
 */
@property (nonatomic,copy) void(^SelectRedPageDataBlock)(id success);

@end
