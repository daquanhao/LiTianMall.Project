//
//  HSQChooseMemberAdressListCell.h
//  LiTianDecoration
//
//  Created by administrator on 2018/7/6.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HSQAcceptAddressListModel;

@interface HSQChooseMemberAdressListCell : UITableViewCell

/**
 * @brief 数据模型
 */
@property (nonatomic, strong) HSQAcceptAddressListModel *model;

/**
 * @brief 地址
 */
@property (nonatomic, strong) UILabel *adress_Label;

/**
 * @brief 右边的图标
 */
@property (nonatomic, strong) UIImageView *RightAdress_Image;

@end
