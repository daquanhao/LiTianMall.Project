//
//  HSQPointsGoodsListViewCell.m
//  LiTianDecoration
//
//  Created by administrator on 2018/6/21.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import "HSQPointsGoodsListViewCell.h"
#import "HSQPointsExchangeGoodsListModel.h"

@interface HSQPointsGoodsListViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *GoodsImageView;

@property (weak, nonatomic) IBOutlet UILabel *GoodsName_Label;

@property (weak, nonatomic) IBOutlet UILabel *GoodsPoint_Label;

@property (weak, nonatomic) IBOutlet UILabel *GoodsPrice_Label;

@end

@implementation HSQPointsGoodsListViewCell

/**
 * @brief 数据模型
 */
- (void)setModel:(HSQPointsExchangeGoodsListModel *)model{
    
    _model = model;
    
    // 商品的图片
    [self.GoodsImageView sd_setImageWithURL:[NSURL URLWithString:model.imageSrc] placeholderImage:KGoodsPlacherImage];
    
    // 商品的名字
    self.GoodsName_Label.text = model.goodsName;
    
    // 兑换商品所需的积分
    self.GoodsPoint_Label.text = [NSString stringWithFormat:@"%@积分",model.expendPoints];
    
    // 商品的价格---中划线
    
    NSString *appPriceMin = [NSString stringWithFormat:@"¥%.2f",model.appPriceMin.floatValue];
    
    NSDictionary *attribtDic = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
    
    NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:appPriceMin attributes:attribtDic];
    
    self.GoodsPrice_Label.attributedText = attribtStr;
    
    
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

@end
