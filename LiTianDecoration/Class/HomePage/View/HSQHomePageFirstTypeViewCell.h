//
//  HSQHomePageFirstTypeViewCell.h
//  LiTianDecoration
//
//  Created by administrator on 2018/7/10.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HSQHomePageFirstTypeViewCellDelegate <NSObject>

/**
 * @brief 点击商城
 */
- (void)EnterTheMallModuleBtnClickAction:(UIButton *)sender;

/**
 * @brief 积分兑换
 */
- (void)EntryPointExchangeBtnClickAction:(UIButton *)sender;


@end

@interface HSQHomePageFirstTypeViewCell : UICollectionViewCell

/**
 * @brief 设置代理
 */
@property (nonatomic, weak) id <HSQHomePageFirstTypeViewCellDelegate>delegate;

@end
