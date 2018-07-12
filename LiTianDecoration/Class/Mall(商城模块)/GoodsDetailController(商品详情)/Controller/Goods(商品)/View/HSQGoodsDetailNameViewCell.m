//
//  HSQGoodsDetailNameViewCell.m
//  LiTianDecoration
//
//  Created by administrator on 2018/7/3.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import "HSQGoodsDetailNameViewCell.h"

@interface HSQGoodsDetailNameViewCell ()

@property (nonatomic, strong) UILabel *GoodsName_Label;  // 商品的名字

@property (nonatomic, strong) UILabel *GoodsDescribe_Label; // 商品的描述

@property (nonatomic, strong) UILabel *Proprietary_Label; // 自营


@end

@implementation HSQGoodsDetailNameViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        // 自营
        UILabel *Proprietary_Label = [[UILabel alloc] init];
        Proprietary_Label.textColor = [UIColor whiteColor];
        Proprietary_Label.font = [UIFont systemFontOfSize:12.0];
        Proprietary_Label.backgroundColor =RGB(238, 68, 58);
        Proprietary_Label.numberOfLines = 0;
        [self.contentView addSubview:Proprietary_Label];
        self.Proprietary_Label = Proprietary_Label;
        
        // 商品的名字
        UILabel *GoodsName_Label = [[UILabel alloc] init];
        GoodsName_Label.textColor = RGB(51, 51, 51);
        GoodsName_Label.font = [UIFont systemFontOfSize:14.0];
        GoodsName_Label.numberOfLines = 0;
        [self.contentView addSubview:GoodsName_Label];
        self.GoodsName_Label = GoodsName_Label;
        
        // 商品的描述
        UILabel *GoodsDescribe_Label = [[UILabel alloc] init];
        GoodsDescribe_Label.textColor = RGB(238, 58, 68);
        GoodsDescribe_Label.font = [UIFont systemFontOfSize:12.0];
        GoodsDescribe_Label.numberOfLines = 0;
        [self.contentView addSubview:GoodsDescribe_Label];
        self.GoodsDescribe_Label = GoodsDescribe_Label;
        
        // 添加约束
        [self addViewLayOut];
    }
    
    return self;
}

/**
 * @brief 添加约束
 */
- (void)addViewLayOut{
    
    // 自营
    self.Proprietary_Label.sd_layout.leftSpaceToView(self.contentView, 10).topSpaceToView(self.contentView, 10).autoWidthRatio(0).heightIs(20);
    
    [self.Proprietary_Label setSingleLineAutoResizeWithMaxWidth:100];
    
    [self.Proprietary_Label setSd_cornerRadius:@(5)];
    
    // 商品的名字
    self.GoodsName_Label.sd_layout.leftSpaceToView(self.Proprietary_Label, 5).topEqualToView(self.Proprietary_Label).rightSpaceToView(self.contentView, 10).autoHeightRatio(0);
    
    // 商品的描述
    self.GoodsDescribe_Label.sd_layout.leftSpaceToView(self.contentView, 10).topSpaceToView(self.GoodsName_Label, 10).rightSpaceToView(self.contentView, 10).autoHeightRatio(0);
}

/**
 * @brief 商品数据
 */
- (void)setGoods_Diction:(NSDictionary *)Goods_Diction{
    
    _Goods_Diction = Goods_Diction;
    
    // 商品的名字
    NSString *goodsName = [NSString stringWithFormat:@"%@",Goods_Diction[@"goodsDetail"][@"goodsName"]];
    self.GoodsName_Label.text = (goodsName.length == 0 ? @"" : goodsName);
    
    // 商品的描述
    NSString *jingle = [NSString stringWithFormat:@"%@",Goods_Diction[@"goodsDetail"][@"jingle"]];    // 商品的价格
    self.GoodsDescribe_Label.text  = (jingle.length == 0 ? @"" : jingle);

    // 是否是自营店铺 0-否 1-是
    NSString *isOwnShop = [NSString stringWithFormat:@"%@",Goods_Diction[@"storeInfo"][@"isOwnShop"]];
    
    if (isOwnShop.integerValue == 1)
    {
        self.Proprietary_Label.text = @" 自营 ";
        
        self.GoodsName_Label.sd_resetLayout.leftSpaceToView(self.Proprietary_Label, 5).topEqualToView(self.Proprietary_Label).rightSpaceToView(self.contentView, 10).autoHeightRatio(0);
    }
    else
    {
         self.Proprietary_Label.text = @"";
        
        self.GoodsName_Label.sd_resetLayout.leftSpaceToView(self.Proprietary_Label, 0).topEqualToView(self.Proprietary_Label).rightSpaceToView(self.contentView, 10).autoHeightRatio(0);
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];

    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

@end
