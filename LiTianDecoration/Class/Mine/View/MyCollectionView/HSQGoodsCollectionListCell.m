//
//  HSQGoodsCollectionListCell.m
//  LiTianDecoration
//
//  Created by administrator on 2018/4/11.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import "HSQGoodsCollectionListCell.h"
#import "HSQMallHomeDataModel.h"

@interface HSQGoodsCollectionListCell ()

@property (nonatomic, strong) UILabel *price_label;  // 现在的价格

@property (nonatomic, strong) UILabel *name_label;  // 商品的标题

@property (nonatomic, strong) UIImageView *good_imageView; // 商品的图片

@end

@implementation HSQGoodsCollectionListCell

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        // 1.价格
        UILabel *price_label = [[UILabel alloc] init];
        price_label.textColor = [UIColor redColor];
        price_label.font = [UIFont systemFontOfSize:12.0];
        [self.contentView addSubview:price_label];
        self.price_label = price_label;
        
        // 2.原来的价格
        UILabel *OrginPrice_label = [[UILabel alloc] init];
        OrginPrice_label.textColor = [UIColor grayColor];
        OrginPrice_label.textAlignment = NSTextAlignmentRight;
        OrginPrice_label.font = [UIFont systemFontOfSize:12.0];
        [self.contentView addSubview:OrginPrice_label];
        self.OrginPrice_label = OrginPrice_label;
        
        // 3.商品的标题
        UILabel *name_label = [[UILabel alloc] init];
        name_label.textColor = [UIColor blackColor];
        name_label.font = [UIFont systemFontOfSize:KLabelFont(14.0, 12.0)];
        [self.contentView addSubview:name_label];
        self.name_label = name_label;
        
        // 4.商品的图片
        UIImageView *good_image = [[UIImageView alloc] init];
        [self.contentView addSubview:good_image];
        self.good_imageView = good_image;
        
        // 5.添加约束
        self.good_imageView.sd_layout.leftSpaceToView(self.contentView, 10).rightSpaceToView(self.contentView, 10).topSpaceToView(self.contentView, 10).heightEqualToWidth();
        
        self.name_label.sd_layout.leftSpaceToView(self.contentView, 10).rightSpaceToView(self.contentView, 5).topSpaceToView(self.good_imageView, 5).autoHeightRatio(0);
        [self.name_label setMaxNumberOfLinesToShow:1];
        
        self.price_label.sd_layout.leftEqualToView(self.name_label).topSpaceToView(self.name_label, 10).autoWidthRatio(0).autoHeightRatio(0);
        [self.price_label setSingleLineAutoResizeWithMaxWidth:KScreenWidth / 2];
        
        self.OrginPrice_label.sd_layout.leftSpaceToView(self.price_label, 5).bottomEqualToView(self.price_label).rightSpaceToView(self.contentView, 5).autoHeightRatio(0);
       
    }
    
    return self;
}


- (void)setDiction:(NSDictionary *)Diction{
    
    _Diction = Diction;
    
    // 商品的图片
    [self.good_imageView sd_setImageWithURL:[NSURL URLWithString:Diction[@"imageUrl"]] placeholderImage:KGoodsPlacherImage];
    
    // 商品的名字
    self.name_label.text = [NSString stringWithFormat:@"%@",Diction[@"goodsName"]];
    
    // 商品的价格
    self.price_label.text = [NSString stringWithFormat:@"¥%@",Diction[@"goodsPrice"]];
}

- (void)setStoreGoodsDiction:(NSDictionary *)StoreGoodsDiction{
    
    _StoreGoodsDiction = StoreGoodsDiction;
    
    // 商品的图片
    [self.good_imageView sd_setImageWithURL:[NSURL URLWithString:StoreGoodsDiction[@"imageSrc"]] placeholderImage:KGoodsPlacherImage];
    
    // 商品的名字
    self.name_label.text = [NSString stringWithFormat:@"%@",StoreGoodsDiction[@"goodsName"]];
    
    // 商品的价格
    self.price_label.text = [NSString stringWithFormat:@"¥%@",StoreGoodsDiction[@"appPrice0"]];
}












@end
