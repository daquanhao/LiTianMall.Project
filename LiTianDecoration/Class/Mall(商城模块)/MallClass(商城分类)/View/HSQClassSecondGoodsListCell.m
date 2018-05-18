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

@property (nonatomic, strong) UILabel *XiaoLiang_Label; // 商品的销量

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
        
        // 商品的销量
        UILabel *XiaoLiang_Label = [[UILabel alloc] init];
        XiaoLiang_Label.textColor = RGB(150, 150, 150);
        XiaoLiang_Label.font = [UIFont systemFontOfSize:12.0];
        [self.contentView addSubview:XiaoLiang_Label];
        self.XiaoLiang_Label = XiaoLiang_Label;
        
        
    }
    
    return self;
}

- (void)setIsGrid:(BOOL)isGrid{
    
    _isGrid = isGrid;
    
    if (isGrid)
    {
        // 商品的图片
        self.GoodsImageView.frame = CGRectMake(10, 10, self.bounds.size.width - 20, self.bounds.size.width - 20);
        
        // 商品的名字
        self.GoodsNameLabel.frame = CGRectMake(10, CGRectGetMaxY(self.GoodsImageView.frame)+10, self.bounds.size.width - 20, 20);
        
        // 商品的标签
        self.DiscountBtn.frame = CGRectMake(self.bounds.size.width - 70, CGRectGetMaxY(self.GoodsNameLabel.frame)+10, 60, 20);
        
        // 商品的价格
        self.PriceLabel.frame = CGRectMake(10, CGRectGetMaxY(self.GoodsNameLabel.frame)+5, self.bounds.size.width - 80, 20);
        
        // 商品的销量
        self.XiaoLiang_Label.frame = CGRectMake(10, CGRectGetMaxY(self.PriceLabel.frame)+5, self.bounds.size.width - 80, 15);
        
    }
    else
    {
        // 商品的图片
        self.GoodsImageView.frame = CGRectMake(10, 10, self.bounds.size.height - 20, self.bounds.size.height - 20);
        
        // 商品的名字
        self.GoodsNameLabel.frame = CGRectMake(CGRectGetMaxX(self.GoodsImageView.frame)+10, self.GoodsImageView.mj_y, self.bounds.size.width - self.GoodsImageView.mj_w - 30, 50);
        
        // 商品的价格
        self.PriceLabel.frame = CGRectMake(CGRectGetMaxX(self.GoodsImageView.frame)+10, CGRectGetMaxY(self.GoodsNameLabel.frame)+5, 100, 20);
        
        // 商品的标签
        self.DiscountBtn.frame = CGRectMake(CGRectGetMaxX(self.PriceLabel.frame), CGRectGetMaxY(self.GoodsNameLabel.frame)+10, 60, 20);
        
        // 商品的销量
        self.XiaoLiang_Label.frame = CGRectMake(CGRectGetMaxX(self.GoodsImageView.frame)+10, CGRectGetMaxY(self.PriceLabel.frame)+10, 100, 15);
    }
}

/**
 * @brief 商品的数据
 */
- (void)setDataDiction:(NSDictionary *)dataDiction{
    
    _dataDiction = dataDiction;
    
    // 1.商品的图片
    [self.GoodsImageView sd_setImageWithURL:[NSURL URLWithString:dataDiction[@"imageSrc"]] placeholderImage:KGoodsPlacherImage];
    
    // 2.商品的名字
    self.GoodsNameLabel.text = [NSString stringWithFormat:@"%@",dataDiction[@"goodsName"]];
    
    // 3.商品的价格
    self.PriceLabel.text = [NSString stringWithFormat:@"¥%@",dataDiction[@"appPrice0"]];
    
    // 4.商品的销量
    self.XiaoLiang_Label.text = [NSString stringWithFormat:@"销量：%@",dataDiction[@"goodsSaleNum"]];
}




@end
