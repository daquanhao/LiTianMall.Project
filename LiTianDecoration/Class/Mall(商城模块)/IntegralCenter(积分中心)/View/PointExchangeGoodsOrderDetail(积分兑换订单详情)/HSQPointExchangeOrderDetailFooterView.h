//
//  HSQPointExchangeOrderDetailFooterView.h
//  LiTianDecoration
//
//  Created by administrator on 2018/6/25.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HSQPointsOrdersListModel;

@interface HSQPointExchangeOrderDetailFooterView : UITableViewHeaderFooterView

/**
 * @brief 数据
 */
@property (nonatomic, strong) HSQPointsOrdersListModel *model;

@end
