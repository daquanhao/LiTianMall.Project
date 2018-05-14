//
//  HSQMyPropertyHomeListCell.h
//  LiTianDecoration
//
//  Created by administrator on 2018/4/28.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MyPropertyListModel;

@interface HSQMyPropertyHomeListCell : UITableViewCell

+ (instancetype)HSQMyPropertyHomeListCellWithXIB;

@property (nonatomic, strong) MyPropertyListModel *model;

- (void)SetValueWithDiction:(NSDictionary *)diction indexPath:(NSIndexPath *)indexPath;

@end
