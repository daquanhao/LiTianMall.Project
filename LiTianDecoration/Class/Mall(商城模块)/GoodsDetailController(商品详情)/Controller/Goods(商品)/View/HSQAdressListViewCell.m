//
//  HSQAdressListViewCell.m
//  LiTianDecoration
//
//  Created by administrator on 2018/7/3.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import "HSQAdressListViewCell.h"

@interface HSQAdressListViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *SongZhi_Label;


@end

@implementation HSQAdressListViewCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    self.contentView.backgroundColor = KViewBackGroupColor;
    
    self.SongZhi_Label.font = [UIFont systemFontOfSize:KLabelFont(14.0, 12.0)];
    
    self.placher_Label.font = [UIFont systemFontOfSize:KLabelFont(14.0, 12.0)];
    
    self.Goods_label.font = [UIFont systemFontOfSize:KLabelFont(14.0, 12.0)];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
