//
//  DiscoverHomeListCell.h
//  LiTianDecoration
//
//  Created by administrator on 2018/4/9.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DiscoverListModel;

@interface DiscoverHomeListCell : UITableViewCell

/**
 * @brief 初始化tableViewCell
 */
+ (instancetype)discoverHomeListCell:(UITableView *)tableView IndexPath:(NSIndexPath *)indexPath;

/**
 * @brief 接受数据模型
 */
@property (nonatomic, strong) DiscoverListModel *model;

@end
