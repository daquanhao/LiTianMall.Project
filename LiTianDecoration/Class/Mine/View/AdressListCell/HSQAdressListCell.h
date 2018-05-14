//
//  HSQAdressListCell.h
//  LiTianDecoration
//
//  Created by administrator on 2018/4/25.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HSQAcceptAddressListModel;

@protocol HSQAdressListCellDelegate <NSObject>

/** 删除按钮的点击*/
- (void)DeleteTheClickEventOfTheReceivingAddress:(UIButton *)sender;

/** 编辑按钮的点击*/
- (void)EditTheClickEventOfTheReceivingAddress:(UIButton *)sender;

@end

@interface HSQAdressListCell : UITableViewCell

@property (nonatomic, strong) HSQAcceptAddressListModel *model;

@property (nonatomic, weak) id<HSQAdressListCellDelegate>delegate;

@end
