//
//  HSQLimitedTimeDiscountCell.m
//  LiTianDecoration
//
//  Created by administrator on 2018/7/10.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import "HSQLimitedTimeDiscountCell.h"

@interface HSQLimitedTimeDiscountCell ()



@end

@implementation HSQLimitedTimeDiscountCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    self.appPrice0_Label.font = self.discountExplain_Label.font = self.discount_Label.font = [UIFont systemFontOfSize:KLabelFont(14.0, 12.0)];
}

- (void)setFrame:(CGRect)frame{
    
    frame.origin.y += 2;
    
    frame.size.height -= 4;
    
    [super setFrame:frame];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];

    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

@end
