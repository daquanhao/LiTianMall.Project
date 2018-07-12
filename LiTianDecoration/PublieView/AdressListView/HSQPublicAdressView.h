//
//  HSQPublicAdressView.h
//  LiTianDecoration
//
//  Created by administrator on 2018/4/18.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HSQPublicAdressView : UIView

/**
 * @brief 初始化视图
 */
+ (instancetype)initAdressView;

/**
 * @brief 顶部的提示文字
 */
@property (nonatomic, copy) NSString *placherString;

/**
 * @brief 省级别数据源
 */
@property (nonatomic, strong) NSMutableArray *dataSource;

/**
 * @brief 选中地址的回调
 */
@property (nonatomic, copy) void(^chooseFinish)(id string, id proId, id cityId, id areaId);

/**
 * @brief 选中地址
 */
@property (nonatomic, copy) NSString * address;

/**
 * @brief 显示视图
 */
- (void)ShowAdressView;

@end
