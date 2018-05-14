//
//  HSQMenuListCell.h
//  LiTianDecoration
//
//  Created by administrator on 2018/4/30.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HSQMenuListCell : UITableViewCell

+ (instancetype)HSQMenuListCellWithXIB;

@property (weak, nonatomic) IBOutlet UIImageView *Right_ImageView;

@property (weak, nonatomic) IBOutlet UILabel *NameLabel;

@end
