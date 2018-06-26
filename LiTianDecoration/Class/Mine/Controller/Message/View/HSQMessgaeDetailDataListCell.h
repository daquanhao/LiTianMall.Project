//
//  HSQMessgaeDetailDataListCell.h
//  LiTianDecoration
//
//  Created by administrator on 2018/6/20.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HSQClassMessageListModel;

@interface HSQMessgaeDetailDataListCell : UITableViewCell

/**
 * @brief 数据模型
 */
@property (nonatomic, strong) HSQClassMessageListModel *model;

@end
