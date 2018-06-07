//
//  HSQTuiKuanGoodsListCell.m
//  LiTianDecoration
//
//  Created by administrator on 2018/6/7.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import "HSQTuiKuanGoodsListCell.h"
#import "HSQShopCarGoodsTypeListModel.h"

@interface HSQTuiKuanGoodsListCell ()

@property (weak, nonatomic) IBOutlet UIImageView *GoodsImageView;

@property (weak, nonatomic) IBOutlet UILabel *GoodsName_Label;

@property (weak, nonatomic) IBOutlet UILabel *GoodsPrice_Label;

@property (weak, nonatomic) IBOutlet UILabel *GoodsGuiGe_Label;

@property (weak, nonatomic) IBOutlet UILabel *GoodsCount_Label;

@end

@implementation HSQTuiKuanGoodsListCell

/**
 * @brief 数据模型
 */
- (void)setModel:(HSQShopCarGoodsTypeListModel *)model{
    
    _model = model;
    
    // 商品的图片
    [self.GoodsImageView sd_setImageWithURL:[NSURL URLWithString:model.imageSrc] placeholderImage:KGoodsPlacherImage];
    
    // 商品的名字
    self.GoodsName_Label.text = model.goodsName;
    
    // 商品的价格
    self.GoodsPrice_Label.text = [NSString stringWithFormat:@"¥%.2f",model.goodsPrice.floatValue];
    
    // 商品的规格
    self.GoodsGuiGe_Label.text = model.goodsFullSpecs;
    
    // 商品的购买数量
    self.GoodsCount_Label.text = [NSString stringWithFormat:@"X%@",model.buyNum];
    
}



- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
