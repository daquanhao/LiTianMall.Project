//
//  HSQHeadMessageView.h
//  LiTianDecoration
//
//  Created by administrator on 2018/4/26.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HSQMessageReceiveModel;

@interface HSQHeadMessageView : UITableViewHeaderFooterView

@property (nonatomic, strong) HSQMessageReceiveModel *model;

@property (nonatomic, strong) UILabel *nameLabel;

@end
