//
//  HSQProductIntroductionTextListCell.m
//  LiTianDecoration
//
//  Created by administrator on 2018/7/2.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import "HSQProductIntroductionTextListCell.h"
#import "HSQGoodsMobileBodyVoListModel.h"

@interface HSQProductIntroductionTextListCell ()

/**
 * @brief 商品的文字介绍
 */
@property (nonatomic, strong) UILabel *ProductIntroduction_Label;

@end

@implementation HSQProductIntroductionTextListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        UILabel *ProductIntroduction_Label = [[UILabel alloc] init];
        
        ProductIntroduction_Label.textColor = RGB(71, 71, 71);
        
        ProductIntroduction_Label.font = [UIFont systemFontOfSize:KLabelFont(14.0, 12.0)];
        
        ProductIntroduction_Label.numberOfLines = 0;
        
        [self.contentView addSubview:ProductIntroduction_Label];
        
        self.ProductIntroduction_Label = ProductIntroduction_Label;
        
        self.ProductIntroduction_Label.sd_layout.leftSpaceToView(self.contentView, 10).topSpaceToView(self.contentView, 5).rightSpaceToView(self.contentView, 10).autoHeightRatio(0);
                
    }
    
    return self;
}

- (void)setModel:(HSQGoodsMobileBodyVoListModel *)model{
    
    _model = model;
    
    self.ProductIntroduction_Label.text = model.value;
    
     [self setupAutoHeightWithBottomView:self.ProductIntroduction_Label bottomMargin:10];
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
