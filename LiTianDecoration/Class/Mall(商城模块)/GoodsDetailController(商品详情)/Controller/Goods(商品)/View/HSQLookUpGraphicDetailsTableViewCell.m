//
//  HSQLookUpGraphicDetailsTableViewCell.m
//  LiTianDecoration
//
//  Created by administrator on 2018/7/3.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import "HSQLookUpGraphicDetailsTableViewCell.h"

@interface HSQLookUpGraphicDetailsTableViewCell ()

@property (nonatomic, strong) UIButton *LookUpGraphic_Button;

@end

@implementation HSQLookUpGraphicDetailsTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.contentView.backgroundColor = [UIColor clearColor];
        
        UIButton *LookUpGraphic_Button = [UIButton buttonWithType:(UIButtonTypeCustom)];
        
        [LookUpGraphic_Button setTitle:@"上拉查看图文详情" forState:(UIControlStateDisabled)];
        
        [LookUpGraphic_Button setImage:KImageName(@"F29714FE-BAB1-48BE-AED0-4825E2E9BFB6") forState:(UIControlStateDisabled)];
        
        [LookUpGraphic_Button setTitleColor:RGB(71, 71, 71) forState:(UIControlStateDisabled)];
        
        LookUpGraphic_Button.titleLabel.font = [UIFont systemFontOfSize:KLabelFont(14.0, 12.0)];
        
        [LookUpGraphic_Button setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
        
        LookUpGraphic_Button.enabled = NO;
        
        [self.contentView addSubview:LookUpGraphic_Button];
        
        self.LookUpGraphic_Button = LookUpGraphic_Button;
        
        self.LookUpGraphic_Button.sd_layout.leftSpaceToView(self.contentView, 0).topSpaceToView(self.contentView, 0).rightSpaceToView(self.contentView, 0).bottomSpaceToView(self.contentView, 0);
    }
    
    return self;
}

- (void)awakeFromNib {
    
    [super awakeFromNib];
}

- (void)setFrame:(CGRect)frame{
    
    frame.origin.y += 5;
    
    frame.size.height -= 10;
    
    [super setFrame:frame];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];

    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

@end
