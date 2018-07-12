//
//  HSQGoodsDetailPriceCell.m
//  LiTianDecoration
//
//  Created by administrator on 2018/7/10.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import "HSQGoodsDetailPriceCell.h"

@interface HSQGoodsDetailPriceCell ()



@end

@implementation HSQGoodsDetailPriceCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        UILabel *appPrice0_Label = [[UILabel alloc] init];
        
        appPrice0_Label.textColor = RGB(238, 58, 68);
        
        appPrice0_Label.font = [UIFont systemFontOfSize:KLabelFont(14.0, 14.0)];
        
        [self.contentView addSubview:appPrice0_Label];
        
        self.appPrice0_Label = appPrice0_Label;
        
        self.appPrice0_Label.sd_layout.leftSpaceToView(self.contentView, 10).topSpaceToView(self.contentView, 0).rightSpaceToView(self.contentView, 10).bottomSpaceToView(self.contentView, 0);
    }
    
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];

    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

@end
