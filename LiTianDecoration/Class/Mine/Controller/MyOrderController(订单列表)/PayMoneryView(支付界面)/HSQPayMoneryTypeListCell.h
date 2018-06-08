//
//  HSQPayMoneryTypeListCell.h
//  LiTianDecoration
//
//  Created by administrator on 2018/5/26.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HSQPayMoneryTypeListCellDelegate <NSObject>

- (void)SelectThePaymentMethodButtonClickEvent:(UISwitch *)sender;

@end

@interface HSQPayMoneryTypeListCell : UITableViewCell

/**
 * @brief 设置代理
 */
@property (nonatomic, weak) id<HSQPayMoneryTypeListCellDelegate>delegate;

/**
 * @brief 可用的余额
 */
@property (weak, nonatomic) IBOutlet UILabel *MineYuE_Label;

/**
 * @brief 输入的密码
 */
@property (weak, nonatomic) IBOutlet UITextField *PassWord_TextField;

/**
 * @brief 选择的开关
 */
@property (weak, nonatomic) IBOutlet UISwitch *Switch;

/**
 * @brief 密码的背景框
 */
@property (weak, nonatomic) IBOutlet UIView *PassWordBgView;


@end
