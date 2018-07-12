//
//  HSQTheSelectedViewCell.m
//  LiTianDecoration
//
//  Created by administrator on 2018/7/3.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import "HSQTheSelectedViewCell.h"

@interface HSQTheSelectedViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *TheSelected_Label; // 已选

@property (weak, nonatomic) IBOutlet UILabel *goodsFullSpecs_Label; // 商品的规格

@end

@implementation HSQTheSelectedViewCell

/**
 * @brief 商品的规格
 */
- (void)setGoodsFullSpecs:(NSString *)goodsFullSpecs{
    
    _goodsFullSpecs = goodsFullSpecs;
    
    HSQLog(@"====%@",goodsFullSpecs);
    
    self.goodsFullSpecs_Label.text = (goodsFullSpecs.length == 0 ? @"" : goodsFullSpecs);
}

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    self.contentView.backgroundColor = KViewBackGroupColor;
    
    self.TheSelected_Label.font = [UIFont systemFontOfSize:KLabelFont(14.0, 12.0)];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];

   
}

@end
