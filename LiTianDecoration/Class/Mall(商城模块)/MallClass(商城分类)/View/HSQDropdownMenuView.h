//
//  HSQDropdownMenuView.h
//  LiTianDecoration
//
//  Created by administrator on 2018/4/30.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HSQDropdownMenuViewDelegate <NSObject>

- (void)MenuButtonSelectionClickIndexPath:(NSIndexPath *)indexPath content:(NSString *)SelectString;

@end

@interface HSQDropdownMenuView : UIView

/**
 * @brief 选中的行数
 */
@property (nonatomic, copy) NSString *SelectNumber;

/**
 * @brief 选中的行数
 */
@property (nonatomic, weak) id<HSQDropdownMenuViewDelegate>delegate;

/**
 * @brief 显示菜单视图
 */
- (void)ShowMenuView;

/**
 * @brief 隐藏菜单视图
 */
- (void)HiddenMenuView;

@end
