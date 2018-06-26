//
//  HSQStoreSearchGoodsListCell.m
//  LiTianDecoration
//
//  Created by administrator on 2018/6/18.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import "HSQStoreSearchGoodsListCell.h"
#import "HSQStoreSearchListDataModel.h"

@interface HSQStoreSearchGoodsListCell ()

@property (weak, nonatomic) IBOutlet UIImageView *Goods_ImageView;

@property (weak, nonatomic) IBOutlet UILabel *GoodsPrice_Label;

@end

@implementation HSQStoreSearchGoodsListCell

- (void)setModel:(HSQGoodsCommonListModel *)model{
    
    _model = model;
    
    // 商品的图片
    [self.Goods_ImageView sd_setImageWithURL:[NSURL URLWithString:model.imageSrc] placeholderImage:KGoodsPlacherImage];
    
    // 商品的价格
    self.GoodsPrice_Label.text = [NSString stringWithFormat:@"¥%.2f",model.appPriceMin.floatValue];
}







- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

@end
