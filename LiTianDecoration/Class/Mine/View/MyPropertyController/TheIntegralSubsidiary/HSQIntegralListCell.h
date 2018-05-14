//
//  HSQIntegralListCell.h
//  LiTianDecoration
//
//  Created by administrator on 2018/4/28.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HSQIntegralListModel;

@interface HSQIntegralListCell : UITableViewCell

+ (instancetype)HSQIntegralListCellWithXIB;

@property (nonatomic, strong) HSQIntegralListModel *model;

@end
