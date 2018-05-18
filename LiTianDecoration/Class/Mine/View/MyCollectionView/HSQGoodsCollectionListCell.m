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

@property (nonatomic, strong) UIView *BgView;  // 图片的背景视图

@end

@implementation HSQGoodsCollectionListCell

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        // 1.价格
        UILabel *price_label = [[UILabel alloc] init];
        price_label.text = @"¥10899";
        price_label.textColor = [UIColor redColor];
        price_label.font = [UIFont systemFontOfSize:14.0];
        [self.contentView addSubview:price_label];
        self.price_label = price_label;
        
        // 2.价格
        UILabel *OrginPrice_label = [[UILabel alloc] init];
        OrginPrice_label.text = @"¥10899";
        OrginPrice_label.textColor = [UIColor grayColor];
        OrginPrice_label.textAlignment = NSTextAlignmentRight;
        OrginPrice_label.font = [UIFont systemFontOfSize:14.0];
        [self.contentView addSubview:OrginPrice_label];
        self.OrginPrice_label = OrginPrice_label;
        
        // 3.商品的标题
        UILabel *name_label = [[UILabel alloc] init];
        name_label.text = @"MacBook Pro 13.3英寸苹果笔记本电脑（I5  2.7GHz  8G  128G）";
        name_label.textColor = [UIColor blackColor];
        name_label.font = [UIFont systemFontOfSize:12.0];
        name_label.numberOfLines = 2;
        [self.contentView addSubview:name_label];
        self.name_label = name_label;
        
        // 4.商品的图片
        UIView *bgView = [[UIView alloc] init];
        [self.contentView addSubview:bgView];
        self.BgView = bgView;
        
        UIImageView *good_image = [[UIImageView alloc] init];
        good_image.image = [UIImage imageNamed:@"macPro"];
        [bgView addSubview:good_image];
        self.good_imageView = good_image;
        
        // 5.添加约束
        self.price_label.sd_layout.leftSpaceToView(self.contentView, 10).bottomSpaceToView(self.contentView, 0).widthRatioToView(self.contentView, 0.5).heightIs(25);
        
        self.OrginPrice_label.sd_layout.leftSpaceToView(self.price_label, 5).bottomEqualToView(self.price_label).rightSpaceToView(self.contentView, 10).heightRatioToView(self.price_label, 1.0);
        
        self.name_label.sd_layout.leftEqualToView(self.price_label).rightSpaceToView(self.contentView, 10).bottomSpaceToView(self.price_label, 5).heightIs(30);
        
        self.BgView.sd_layout.leftEqualToView(self.contentView).rightEqualToView(self.contentView).topSpaceToView(self.contentView, 5).bottomSpaceToView(self.name_label, 5);
        
        self.good_imageView.sd_layout.topSpaceToView(self.BgView, 5).bottomSpaceToView(self.BgView, 5).widthEqualToHeight().centerXEqualToView(self.BgView);
        
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
