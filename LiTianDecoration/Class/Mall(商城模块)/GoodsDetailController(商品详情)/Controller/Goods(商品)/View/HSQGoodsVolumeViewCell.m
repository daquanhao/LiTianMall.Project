//
//  HSQGoodsVolumeViewCell.m
//  LiTianDecoration
//
//  Created by administrator on 2018/7/3.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import "HSQGoodsVolumeViewCell.h"

@interface HSQGoodsVolumeViewCell ()

@property (nonatomic, strong) UILabel *Placher_Label;

@end

@implementation HSQGoodsVolumeViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        // 提示语
        UILabel *Placher_Label = [[UILabel alloc] init];
        
        Placher_Label.textColor = RGB(150, 150, 150);
        
        Placher_Label.font = [UIFont systemFontOfSize:KLabelFont(14.0, 12.0)];
        
        Placher_Label.text = @"体积";
        
        [self.contentView addSubview:Placher_Label];
        
        self.Placher_Label = Placher_Label;
        
        // 体积
        UILabel *freightVolume_Label = [[UILabel alloc] init];
        
        freightVolume_Label.textColor = RGB(71, 71, 71);
        
        freightVolume_Label.font = [UIFont systemFontOfSize:KLabelFont(14.0, 12.0)];
        
        [self.contentView addSubview:freightVolume_Label];
        
        self.freightVolume_Label = freightVolume_Label;
        
        // 添加约束
        self.Placher_Label.sd_layout.leftSpaceToView(self.contentView, 10).centerYEqualToView(self.contentView).autoWidthRatio(0).autoHeightRatio(0);
        [self.Placher_Label setSingleLineAutoResizeWithMaxWidth:100];
        
        self.freightVolume_Label.sd_layout.leftSpaceToView(self.Placher_Label, 10).topSpaceToView(self.contentView, 0).rightSpaceToView(self.contentView, 0).bottomSpaceToView(self.contentView, 0);
        
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
