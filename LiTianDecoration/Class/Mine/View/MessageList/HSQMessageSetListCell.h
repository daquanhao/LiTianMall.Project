//
//  HSQMessageSetListCell.h
//  LiTianDecoration
//
//  Created by administrator on 2018/4/26.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HSQMessageListModel;

@protocol HSQMessageSetListCellDelegate <NSObject>

- (void)ChangeTheReceivingStateOfTheMessage:(UISwitch *)Switch;

@end

@interface HSQMessageSetListCell : UITableViewCell

@property (nonatomic, strong) HSQMessageListModel *model;

@property (nonatomic, weak) id<HSQMessageSetListCellDelegate>delegate;

@end
