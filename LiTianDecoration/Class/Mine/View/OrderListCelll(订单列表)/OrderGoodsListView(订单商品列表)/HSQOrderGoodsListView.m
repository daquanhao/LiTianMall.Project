//
//  HSQOrderGoodsListView.m
//  LiTianDecoration
//
//  Created by administrator on 2018/5/26.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import "HSQOrderGoodsListView.h"
#import "HSQShopCarGoodsTypeListModel.h"

@interface HSQOrderGoodsListView ()

@property (nonatomic, strong) UIImageView *GoodsImageView; // 商品的图片

@property (nonatomic, strong) UILabel *GoodsNameLabel; // 商品的名字

@property (nonatomic, strong) UILabel *GoodsPriceLabel; // 商品的价格

@property (nonatomic, strong) UILabel *GoodsTypeLabel; // 商品的型号

@property (nonatomic, strong) UILabel *GoodsCountLabel; // 商品的数量

@end

@implementation HSQOrderGoodsListView

-(instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        // 商品的图片
        UIImageView *GoodsImageView = [[UIImageView alloc] init];
        [self addSubview:GoodsImageView];
        self.GoodsImageView = GoodsImageView;
        
        // 商品的名字
        UILabel *GoodsNameLabel = [[UILabel alloc] init];
        GoodsNameLabel.textColor = RGB(71, 71, 71);
        GoodsNameLabel.numberOfLines = 0;
        GoodsNameLabel.font = [UIFont systemFontOfSize:12.0];
        [self addSubview:GoodsNameLabel];
        self.GoodsNameLabel = GoodsNameLabel;
        
        // 商品的价格
        UILabel *GoodsPriceLabel = [[UILabel alloc] init];
        GoodsPriceLabel.textColor = RGB(238, 58, 68);
        GoodsPriceLabel.numberOfLines = 0;
        GoodsPriceLabel.textAlignment = NSTextAlignmentRight;
        GoodsPriceLabel.font = [UIFont systemFontOfSize:12.0];
        [self addSubview:GoodsPriceLabel];
        self.GoodsPriceLabel = GoodsPriceLabel;
        
        // 商品的型号
        UILabel *GoodsTypeLabel = [[UILabel alloc] init];
        GoodsTypeLabel.textColor = RGB(150, 150, 150);
        GoodsTypeLabel.numberOfLines = 0;
        GoodsTypeLabel.font = [UIFont systemFontOfSize:12.0];
        [self addSubview:GoodsTypeLabel];
        self.GoodsTypeLabel = GoodsTypeLabel;
        
        // 商品的数量
        UILabel *GoodsCountLabel = [[UILabel alloc] init];
        GoodsCountLabel.textColor = RGB(150, 150, 150);
        GoodsCountLabel.numberOfLines = 0;
        GoodsCountLabel.textAlignment = NSTextAlignmentRight;
        GoodsCountLabel.font = [UIFont systemFontOfSize:12.0];
        [self addSubview:GoodsCountLabel];
        self.GoodsCountLabel = GoodsCountLabel;
        
        // 设置控件的约束
        [self SetViewLayOut];
        
    }
    
    return self;
}

/**
 * @brief 设置控件的约束
 */
- (void)SetViewLayOut{
    
    // 商品的图片
    self.GoodsImageView.sd_layout.leftSpaceToView(self, 10).topSpaceToView(self, 5).bottomSpaceToView(self, 5).widthEqualToHeight();
    
    // 商品的价格
    self.GoodsPriceLabel.sd_layout.topEqualToView(self.GoodsNameLabel).rightSpaceToView(self, 10).autoHeightRatio(0).autoWidthRatio(0);
    [self.GoodsPriceLabel setSingleLineAutoResizeWithMaxWidth:65];
    
    // 商品的名字
    self.GoodsNameLabel.sd_layout.leftSpaceToView(self.GoodsImageView, 5).topSpaceToView(self, 10).rightSpaceToView(self.GoodsPriceLabel, 5).autoHeightRatio(0);
    
    // 商品的型号
    self.GoodsTypeLabel.sd_layout.leftEqualToView(self.GoodsNameLabel).topSpaceToView(self.GoodsNameLabel, 5).rightEqualToView(self.GoodsNameLabel).autoHeightRatio(0);
    
    // 商品的数量
    self.GoodsCountLabel.sd_layout.topEqualToView(self.GoodsTypeLabel).rightEqualToView(self.GoodsPriceLabel).leftSpaceToView(self.GoodsTypeLabel, 5).autoHeightRatio(0);

}

/**
 * @brief 数据模型赋值
 */
- (void)setModel:(HSQShopCarGoodsTypeListModel *)model{
    
    _model = model;
    
    // 商品的图片
    [self.GoodsImageView sd_setImageWithURL:[NSURL URLWithString:model.imageSrc] placeholderImage:KGoodsPlacherImage];
    
    // 商品的名字
    self.GoodsNameLabel.text = model.goodsName;
    
    // 商品的单价
    self.GoodsPriceLabel.text = [NSString stringWithFormat:@"¥%.2f",model.goodsPrice.floatValue];
    
    // 商品的规格
    self.GoodsTypeLabel.text = model.goodsFullSpecs;
    
    // 商品的数量
    self.GoodsCountLabel.text = [NSString stringWithFormat:@"X%@",model.buyNum];
}



@end
