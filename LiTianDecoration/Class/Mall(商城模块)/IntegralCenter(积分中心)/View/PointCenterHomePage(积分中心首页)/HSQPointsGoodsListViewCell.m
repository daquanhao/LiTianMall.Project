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

@property (nonatomic, strong) UIImageView *Goods_ImageView;

@property (nonatomic, strong) UILabel *goodsName_Label;

@property (nonatomic, strong) UILabel *expendPoints_Label;

@property (nonatomic, strong) UILabel *appPriceMin_Label;

@end

@implementation HSQPointsGoodsListViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        // 创建视图
        [self CreatView];
        
        // 创建视图的约束
        [self CreatViewLayOut];
    }
    
    return self;
}

/**
 * @brief 创建视图
 */
- (void)CreatView{
    
    // 1.商品的图片
    UIImageView *Goods_ImageView = [[UIImageView alloc] init];
    [self.contentView addSubview:Goods_ImageView];
    self.Goods_ImageView = Goods_ImageView;
    
    // 2.商品的名字
    UILabel *goodsName_Label = [[UILabel alloc] init];
    goodsName_Label.font = [UIFont systemFontOfSize:KLabelFont(14.0, 12.0)];
    goodsName_Label.textColor = RGB(71, 71, 71);
    [self.contentView addSubview:goodsName_Label];
    self.goodsName_Label = goodsName_Label;
    
    // 3.商品的积分
    UILabel *expendPoints_Label = [[UILabel alloc] init];
    expendPoints_Label.font = [UIFont systemFontOfSize:12.0];
    expendPoints_Label.textColor = RGB(71, 71, 71);
    [self.contentView addSubview:expendPoints_Label];
    self.expendPoints_Label = expendPoints_Label;
    
    // 4.商品的价格
    UILabel *appPriceMin_Label = [[UILabel alloc] init];
    appPriceMin_Label.font = [UIFont systemFontOfSize:KLabelFont(14.0, 12.0)];
    appPriceMin_Label.textColor = RGB(150, 150, 150);
    [self.contentView addSubview:appPriceMin_Label];
    self.appPriceMin_Label = appPriceMin_Label;
}

/**
 * @brief 创建视图的约束
 */
- (void)CreatViewLayOut{
    
    // 1.商品的图片
    self.Goods_ImageView.sd_layout.leftSpaceToView(self.contentView, 5).topSpaceToView(self.contentView, 10).rightSpaceToView(self.contentView, 5).heightEqualToWidth();
    
    // 2.商品的名字
    self.goodsName_Label.sd_layout.leftSpaceToView(self.contentView, 10).topSpaceToView(self.Goods_ImageView, 5).rightSpaceToView(self.contentView, 5).autoHeightRatio(0);
    [self.goodsName_Label setMaxNumberOfLinesToShow:1];
    
    // 3.商品的积分
    self.expendPoints_Label.sd_layout.leftEqualToView(self.goodsName_Label).topSpaceToView(self.goodsName_Label, 5).rightEqualToView(self.goodsName_Label).autoHeightRatio(0);

    // 4.商品的价格
    self.appPriceMin_Label.sd_layout.leftEqualToView(self.goodsName_Label).topSpaceToView(self.expendPoints_Label, 5).rightEqualToView(self.goodsName_Label).autoHeightRatio(0);

}

/**
 * @brief 数据模型
 */
- (void)setModel:(HSQPointsExchangeGoodsListModel *)model{
    
    _model = model;
    
    // 商品的图片
    [self.Goods_ImageView sd_setImageWithURL:[NSURL URLWithString:model.imageSrc] placeholderImage:KGoodsPlacherImage];
    
    // 商品的名字
    self.goodsName_Label.text = model.goodsName;
    
    // 兑换商品所需的积分
    self.expendPoints_Label.text = [NSString stringWithFormat:@"%@积分",model.expendPoints];
    
    // 商品的价格---中划线
    
    NSString *appPriceMin = [NSString stringWithFormat:@"¥%.2f",model.appPriceMin.floatValue];
    
    NSDictionary *attribtDic = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
    
    NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:appPriceMin attributes:attribtDic];
    
    self.appPriceMin_Label.attributedText = attribtStr;
    
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

@end
