//
//  HSQCoupterListCell.m
//  LiTianDecoration
//
//  Created by administrator on 2018/5/10.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import "HSQCoupterListCell.h"

@interface HSQCoupterListCell ()

@end

@implementation HSQCoupterListCell

- (void)setFrame:(CGRect)frame{
    
    frame.origin.y += 7;
    
    frame.size.height -= 14;
    
    [super setFrame:frame];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];

    self.selectionStyle = UITableViewCellSeparatorStyleNone;
}

@end
