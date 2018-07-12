//
//  HSQZongHeMenuListCell.m
//  LiTianDecoration
//
//  Created by administrator on 2018/6/30.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import "HSQZongHeMenuListCell.h"

@implementation HSQZongHeMenuListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setFrame:(CGRect)frame{
    
    frame.origin.y += 1;
    
    frame.size.height -= 2;
    
    [super setFrame:frame];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
