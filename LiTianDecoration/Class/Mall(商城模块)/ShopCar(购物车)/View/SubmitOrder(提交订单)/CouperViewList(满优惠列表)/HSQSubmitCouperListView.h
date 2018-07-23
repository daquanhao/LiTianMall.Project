//
//  HSQSubmitCouperListView.h
//  LiTianDecoration
//
//  Created by administrator on 2018/5/25.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HSQSubmitCouperListView : UIView

/** 初始化视图 */
+ (instancetype)initSubmitCouperListView;

/** 显示视图 */
- (void)ShowSubmitCouperListView;

/**
 * @Brief 选中的数据
 */
- (void)SetValueDataWithArray:(NSArray *)data_Array Select_Index:(NSString *)index;

/**
 * @brief 回调选中的地址
 */
@property (nonatomic,copy) void(^SelectCouperDataBlock)(id success);


@end
