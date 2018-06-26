//
//  HSQChooseProductionGoodsListCell.m
//  LiTianDecoration
//
//  Created by administrator on 2018/6/14.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import "HSQChooseProductionGoodsListCell.h"
#import "HSQSelectionListModel.h"

@interface HSQChooseProductionGoodsListCell ()

@property (nonatomic, strong) UIImageView *Goods_ImageView;

@end

@implementation HSQChooseProductionGoodsListCell

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        //商品的图片
        UIImageView *Goods_ImageView = [[UIImageView alloc] init];
        
        [self.contentView addSubview:Goods_ImageView];
        
        self.Goods_ImageView = Goods_ImageView;
        
        self.Goods_ImageView.sd_layout.leftSpaceToView(self.contentView, 5).topSpaceToView(self.contentView, 5).bottomSpaceToView(self.contentView, 5).rightSpaceToView(self.contentView, 5);
        
    }
    
    return self;
}

- (void)setModel:(HSQSelectionGoodsListModel *)model{
    
    _model = model;
    
    [self.Goods_ImageView sd_setImageWithURL:[NSURL URLWithString:model.imageSrc] placeholderImage:KGoodsPlacherImage];
}














@end
