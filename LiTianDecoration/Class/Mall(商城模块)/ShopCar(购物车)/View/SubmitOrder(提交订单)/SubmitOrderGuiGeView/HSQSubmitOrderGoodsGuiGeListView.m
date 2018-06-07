//
//  HSQSubmitOrderGoodsGuiGeListView.m
//  LiTianDecoration
//
//  Created by administrator on 2018/5/25.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import "HSQSubmitOrderGoodsGuiGeListView.h"
#import "HSQShopCarGoodsTypeListModel.h"

@interface HSQSubmitOrderGoodsGuiGeListView ()

@property (nonatomic, strong) UILabel *GoodsSulLabel; // 商品的规格

@property (nonatomic, strong) UILabel *GoodsPrice_Label; // 商品的单价格

@property (nonatomic, strong) UILabel *TotalMonery_Label; // 商品的总价格

@property (nonatomic, strong) UILabel *BuyGoodsCount_Label; // 商品的购买数量

@end

@implementation HSQSubmitOrderGoodsGuiGeListView


- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = KViewBackGroupColor;
        
        // 商品的规格
        UILabel *GoodsSulLabel = [[UILabel alloc] init];
        GoodsSulLabel.textColor = RGB(150, 150, 150);
        GoodsSulLabel.numberOfLines = 0;
        GoodsSulLabel.font = [UIFont systemFontOfSize:12.0];
        [self addSubview:GoodsSulLabel];
        self.GoodsSulLabel = GoodsSulLabel;
        
        // 商品的单价
        UILabel *GoodsPrice_Label = [[UILabel alloc] init];
        GoodsPrice_Label.textColor = RGB(150, 150, 150);
        GoodsPrice_Label.numberOfLines = 0;
        GoodsPrice_Label.font = [UIFont systemFontOfSize:12.0];
        [self addSubview:GoodsPrice_Label];
        self.GoodsPrice_Label = GoodsPrice_Label;
        
        // 商品的总价格
        UILabel *TotalMonery_Label = [[UILabel alloc] init];
        TotalMonery_Label.textColor = RGB(71, 71, 71);
        TotalMonery_Label.numberOfLines = 0;
        TotalMonery_Label.textAlignment = NSTextAlignmentRight;
        TotalMonery_Label.font = [UIFont systemFontOfSize:14.0];
        [self addSubview:TotalMonery_Label];
        self.TotalMonery_Label = TotalMonery_Label;
        
        // 商品的购买数量
        UILabel *BuyGoodsCount_Label = [[UILabel alloc] init];
        BuyGoodsCount_Label.textColor = RGB(150, 150, 150);
        BuyGoodsCount_Label.numberOfLines = 0;
        BuyGoodsCount_Label.font = [UIFont systemFontOfSize:12.0];
        BuyGoodsCount_Label.textAlignment = NSTextAlignmentRight;
        [self addSubview:BuyGoodsCount_Label];
        self.BuyGoodsCount_Label = BuyGoodsCount_Label;
        
        // 添加控件的约束
        [self SetValueViewLayout];
    }
    
    return self;
}


/**
 * @brief 添加控件的约束
 */
- (void)SetValueViewLayout{
    
    // 商品的规格
    self.GoodsSulLabel.sd_layout.leftSpaceToView(self, 10).topSpaceToView(self, 5).autoWidthRatio(0).autoHeightRatio(0);
    [self.GoodsSulLabel setSingleLineAutoResizeWithMaxWidth:KScreenWidth * 0.7];
    
    // 商品的总价格
    self.TotalMonery_Label.sd_layout.leftSpaceToView(self.GoodsSulLabel, 0).topEqualToView(self.GoodsSulLabel).rightSpaceToView(self, 10).autoHeightRatio(0);
    
    // 商品的价格
    self.GoodsPrice_Label.sd_layout.leftEqualToView(self.GoodsSulLabel).topSpaceToView(self.GoodsSulLabel, 5).autoWidthRatio(0).heightIs(20);
    [self.GoodsPrice_Label setSingleLineAutoResizeWithMaxWidth:KScreenWidth * 0.7];
    
    // 商品的购买数量
    self.BuyGoodsCount_Label.sd_layout.leftSpaceToView(self.GoodsPrice_Label, 0).centerYEqualToView(self.GoodsPrice_Label).rightSpaceToView(self, 10).autoHeightRatio(0);
    
}

/**
 * @brief 数据
 */
- (void)setModel:(HSQShopCarGoodsTypeListModel *)model{
    
    _model = model;
    
    // 商品的规格
    self.GoodsSulLabel.text = [NSString stringWithFormat:@"%@",model.goodsFullSpecs];
    
    // 商品的总价格
    self.GoodsPrice_Label.text = [NSString stringWithFormat:@"¥%.2f",model.itemAmount.floatValue];
    
    // 商品的单价格
    self.GoodsPrice_Label.text = [NSString stringWithFormat:@"单价：¥%.2f/%@",model.appPrice0.floatValue,model.unitName];
    
    // 商品的购买数量
    self.BuyGoodsCount_Label.text = [NSString stringWithFormat:@"%@%@",model.buyNum,model.unitName];
    


}


@end
