//
//  HSQConsultingCustomerServiceCell.m
//  LiTianDecoration
//
//  Created by administrator on 2018/7/3.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import "HSQConsultingCustomerServiceCell.h"

@interface HSQConsultingCustomerServiceCell ()

@property (weak, nonatomic) IBOutlet UILabel *Placher_Label;

@end

@implementation HSQConsultingCustomerServiceCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    self.contentView.backgroundColor = KViewBackGroupColor;
    
    self.Placher_Label.font = [UIFont systemFontOfSize:KLabelFont(14.0, 12.0)];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];

    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

@end
