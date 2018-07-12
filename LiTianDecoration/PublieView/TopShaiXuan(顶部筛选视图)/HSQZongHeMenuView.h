//
//  HSQZongHeMenuView.h
//  LiTianDecoration
//
//  Created by administrator on 2018/6/30.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HSQZongHeMenuViewDelegate <NSObject>

- (void)SelectZongHeTiaoJian:(NSString *)Select_String Index:(NSInteger)Select_Index;

@end

@interface HSQZongHeMenuView : UIView

/**
 * @brief 下拉菜单的数据
 */
@property (nonatomic, strong) NSMutableArray *Menu_Source;

/**
 * @brief 选中的筛选条件
 */
@property (nonatomic, assign) NSInteger Index;

/**
 *@brief 设置代理
 */
@property (nonatomic, weak) id<HSQZongHeMenuViewDelegate>delegate;

@end
