//
//  HSQMenuListCell.m
//  LiTianDecoration
//
//  Created by administrator on 2018/4/30.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import "HSQMenuListCell.h"

@implementation HSQMenuListCell

+ (instancetype)HSQMenuListCellWithXIB{
    
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:self options:nil] firstObject];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
    
    self.NameLabel.textColor = (self.selected ? [UIColor redColor] :RGB(51, 51, 51));
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    self.Right_ImageView.hidden = !self.selected;
}

@end
