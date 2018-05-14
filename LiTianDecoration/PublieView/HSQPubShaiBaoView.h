//
//  HSQPubShaiBaoView.h
//  LiTianDecoration
//
//  Created by administrator on 2018/4/11.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HSQPubShaiBaoViewDelegate <NSObject>

- (void)PublieTableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface HSQPubShaiBaoView : UIView

/**
 * @brief 数据源数据
 */
@property (nonatomic, strong) NSMutableArray *dataSource;

/**
 * @brief 设置代理
 */
@property (nonatomic, weak) id<HSQPubShaiBaoViewDelegate>delegate;

@end
