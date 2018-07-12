//
//  HSQVoucherTemplateListCell.h
//  LiTianDecoration
//
//  Created by administrator on 2018/6/27.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HSQVoucherTemplateListModel;

@interface HSQVoucherTemplateListCell : UITableViewCell

/**
 * @brief 数据源
 */
@property (nonatomic, strong) HSQVoucherTemplateListModel *model;

@end
