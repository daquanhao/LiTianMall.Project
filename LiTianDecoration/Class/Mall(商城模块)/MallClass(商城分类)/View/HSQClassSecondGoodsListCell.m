//
//  HSQClassSecondGoodsListCell.m
//  LiTianDecoration
//
//  Created by administrator on 2018/4/30.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import "HSQClassSecondGoodsListCell.h"

@interface HSQClassSecondGoodsListCell ()

@property (nonatomic, strong) UIImageView *GoodsImageView;

@property (nonatomic, strong) UILabel *GoodsNameLabel;

@property (nonatomic, strong) UILabel *PriceLabel;

@property (nonatomic, strong) UIButton *DiscountBtn;


@end

@implementation HSQClassSecondGoodsListCell

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        // 商品的图片
        UIImageView *GoodsImageView = [[UIImageView alloc] init];
        GoodsImageView.image = [UIImage imageNamed:@"3-1P106112Q1-51"];
        [self.contentView addSubview:GoodsImageView];
        self.GoodsImageView = GoodsImageView;
        
        // 商品的名字
        UILabel *nameLabel = [[UILabel alloc] init];
        nameLabel.text = @"七匹狼短袖T桖 青年男款，七匹狼短袖T桖 青年男款";
        nameLabel.textColor = RGB(33, 33, 33);
        nameLabel.font = [UIFont systemFontOfSize:KTextFont_(14)];
        nameLabel.numberOfLines = 0;
        [self.contentView addSubview:nameLabel];
        self.GoodsNameLabel = nameLabel;
        
        // 商品的价格
        UILabel *priceLabel = [[UILabel alloc] init];
        priceLabel.textColor = RGB(255, 38, 58);
        priceLabel.font = [UIFont systemFontOfSize:KTextFont_(14)];
        priceLabel.text = @"¥323.10";
        [self.contentView addSubview:priceLabel];
        self.PriceLabel = priceLabel;
        
        // 商品的标签
        UIButton *DiscountBtn = [UIButton buttonWithType:(UIButtonTypeSystem)];
        [DiscountBtn setTitle:@"限时折扣" forState:(UIControlStateNormal)];
        [DiscountBtn setTitleColor:RGB(255, 38, 58) forState:(UIControlStateNormal)];
        DiscountBtn.titleLabel.font = [UIFont systemFontOfSize:12.0];
        DiscountBtn.layer.borderWidth = 1;
        DiscountBtn.layer.borderColor = RGB(255, 38, 58).CGColor;
        [self.contentView addSubview:DiscountBtn];
        self.DiscountBtn = DiscountBtn;
        
        
    }
    
    return self;
}

- (void)setIsGrid:(BOOL)isGrid{
    
    _isGrid = isGrid;
    
    if (isGrid)
    {
        // 商品的图片
        self.GoodsImageView.frame = CGRectMake(10, 10, self.bounds.size.width - 20, self.bounds.size.width - 10);
        
        // 商品的名字
        self.GoodsNameLabel.frame = CGRectMake(10, CGRectGetMaxY(self.GoodsImageView.frame)+10, self.bounds.size.width - 20, 20);
        
        // 商品的标签
        self.DiscountBtn.frame = CGRectMake(self.bounds.size.width - 70, CGRectGetMaxY(self.GoodsNameLabel.frame)+10, 60, 20);
        
        // 商品的价格
        self.PriceLabel.frame = CGRectMake(10, CGRectGetMaxY(self.GoodsNameLabel.frame)+10, self.bounds.size.width - 80, 20);
        
    }
    else
    {
        // 商品的图片
        self.GoodsImageView.frame = CGRectMake(10, 10, self.bounds.size.height - 20, self.bounds.size.height - 20);
        
        // 商品的名字
        self.GoodsNameLabel.frame = CGRectMake(CGRectGetMaxX(self.GoodsImageView.frame)+10, self.GoodsImageView.mj_y, self.bounds.size.width - self.GoodsImageView.mj_w - 30, 50);
        
        // 商品的价格
        self.PriceLabel.frame = CGRectMake(CGRectGetMaxX(self.GoodsImageView.frame)+10, CGRectGetMaxY(self.GoodsNameLabel.frame)+10, 100, 20);
        
        // 商品的标签
        self.DiscountBtn.frame = CGRectMake(CGRectGetMaxX(self.PriceLabel.frame), CGRectGetMaxY(self.GoodsNameLabel.frame)+10, 60, 20);
    }
}

@end
