//
//  HSQLoginChooseAdressView.h
//  LiTianDecoration
//
//  Created by administrator on 2018/7/6.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HSQLoginChooseAdressViewDelegate <NSObject>

/**
 * @brief 选择收货地址
 */
- (void)ChooseMemberAdressWithModel:(NSString *)AdressName Adreid:(NSString *)adreid2;

@end

@interface HSQLoginChooseAdressView : UIView

/**
 * @brief 初始化视图
 */
+ (instancetype)initGuiGeAndCouperView;

/**
 * @brief 初始化视图
 */
@property (nonatomic, copy) NSString *placherString;

/**
 * @brief 选中的城市id
 */
@property (nonatomic, copy) NSString *city_name;

/**
 * @brief 数据源
 */
@property (nonatomic, strong) NSMutableArray *dataSource;

/**
 * @brief 显示视图
 */
- (void)ShowLoginChooseAdressView;

/**
 * @brief 设置代理
 */
@property (nonatomic, weak) id<HSQLoginChooseAdressViewDelegate>delegate;

@end
