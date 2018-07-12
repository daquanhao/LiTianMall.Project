//
//  HSQProductIntroductionPictureListCell.m
//  LiTianDecoration
//
//  Created by administrator on 2018/7/2.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import "HSQProductIntroductionPictureListCell.h"

@implementation HSQProductIntroductionPictureListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        UIImageView *GoodsIntroduction_ImageView = [[UIImageView alloc] init];
        
        [self.contentView addSubview:GoodsIntroduction_ImageView];
        
        self.GoodsIntroduction_ImageView = GoodsIntroduction_ImageView;
        
        self.GoodsIntroduction_ImageView.sd_layout.leftSpaceToView(self.contentView, 0).topSpaceToView(self.contentView, 0).rightSpaceToView(self.contentView, 0).bottomSpaceToView(self.contentView, 0);
        
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
