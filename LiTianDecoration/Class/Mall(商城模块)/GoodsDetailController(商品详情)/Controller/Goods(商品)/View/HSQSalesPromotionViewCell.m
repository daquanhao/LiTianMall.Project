//
//  HSQSalesPromotionViewCell.m
//  LiTianDecoration
//
//  Created by administrator on 2018/7/3.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import "HSQSalesPromotionViewCell.h"

@interface HSQSalesPromotionViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *SalesPromotion_Label; // 促销提示语


@end

@implementation HSQSalesPromotionViewCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    self.contentView.backgroundColor = KViewBackGroupColor;
    
    self.SalesPromotion_Label.font = [UIFont systemFontOfSize:KLabelFont(14.0, 12.0)];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
