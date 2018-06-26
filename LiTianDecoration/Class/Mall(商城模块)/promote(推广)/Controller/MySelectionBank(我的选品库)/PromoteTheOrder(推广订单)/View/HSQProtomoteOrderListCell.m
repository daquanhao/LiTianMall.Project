//
//  HSQProtomoteOrderListCell.m
//  LiTianDecoration
//
//  Created by administrator on 2018/6/18.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import "HSQProtomoteOrderListCell.h"
#import "HSQProtomoteOrderListDataModel.h"

@interface HSQProtomoteOrderListCell ()

@property (nonatomic, strong) UILabel *PromotionNumber_Label;  // 推广单号

@property (nonatomic, strong) UILabel *PromotionState_Label;  // 推广状态

@property (nonatomic, strong) UIImageView *Goods_ImageView;  // 推广商品图片

@property (nonatomic, strong) UILabel *GoodsName_Label;  // 推广商品名字

@property (nonatomic, strong) UILabel *TransactionStatus_Label;  // 交易状态

@property (nonatomic, strong) UILabel *Price_Label;  // 价格

@property (nonatomic, strong) UILabel *GoodsCount_Label;  // 数量

@property (nonatomic, strong) UILabel *ProtomotePrice_Label;  // 推广价格

@property (nonatomic, strong) UILabel *CommissionRatio_Label;  // 佣金比例

@property (nonatomic, strong) UILabel *Commission_Label;  // 佣金

@property (nonatomic, strong) UIView *TopLine_View;

@property (nonatomic, strong) UIView *BottomLine_View;

@end

@implementation HSQProtomoteOrderListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        // 推广单号
        UILabel *PromotionNumber_Label = [[UILabel alloc] init];
        PromotionNumber_Label.textColor = RGB(150, 150, 150);
        PromotionNumber_Label.font = [UIFont systemFontOfSize:12.0];
        PromotionNumber_Label.numberOfLines = 0;
        [self.contentView addSubview:PromotionNumber_Label];
        self.PromotionNumber_Label = PromotionNumber_Label;
        
        // 推广状态
        UILabel *PromotionState_Label = [[UILabel alloc] init];
        PromotionState_Label.textColor = RGB(238, 58, 68);
        PromotionState_Label.font = [UIFont systemFontOfSize:12.0];
        PromotionState_Label.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:PromotionState_Label];
        self.PromotionState_Label = PromotionState_Label;
        
        // 推广商品图片
        UIImageView *good_imageView = [[UIImageView alloc] init];
        [self.contentView addSubview:good_imageView];
        self.Goods_ImageView = good_imageView;
        
        // 推广商品名字
        UILabel *GoodsName_Label = [[UILabel alloc] init];
        GoodsName_Label.textColor = RGB(74, 74, 74);
        GoodsName_Label.font = [UIFont systemFontOfSize:12.0];
        GoodsName_Label.numberOfLines = 0;
        [self.contentView addSubview:GoodsName_Label];
        self.GoodsName_Label = GoodsName_Label;
        
        // 交易状态
        UILabel *TransactionStatus_Label = [[UILabel alloc] init];
        TransactionStatus_Label.textColor = RGB(150, 150, 150);
        TransactionStatus_Label.font = [UIFont systemFontOfSize:12.0];
        TransactionStatus_Label.numberOfLines = 0;
        [self.contentView addSubview:TransactionStatus_Label];
        self.TransactionStatus_Label = TransactionStatus_Label;
        
        // 价格
        UILabel *Price_Label = [[UILabel alloc] init];
        Price_Label.textColor = RGB(150, 150, 150);
        Price_Label.font = [UIFont systemFontOfSize:12.0];
        Price_Label.numberOfLines = 0;
        Price_Label.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:Price_Label];
        self.Price_Label = Price_Label;
        
        // 数量
        UILabel *GoodsCount_Label = [[UILabel alloc] init];
        GoodsCount_Label.textColor = RGB(150, 150, 150);
        GoodsCount_Label.font = [UIFont systemFontOfSize:12.0];
        GoodsCount_Label.numberOfLines = 0;
        GoodsCount_Label.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:GoodsCount_Label];
        self.GoodsCount_Label = GoodsCount_Label;
        
        // 推广价格
        UILabel *ProtomotePrice_Label = [[UILabel alloc] init];
        ProtomotePrice_Label.textColor = RGB(150, 150, 150);
        ProtomotePrice_Label.font = [UIFont systemFontOfSize:12.0];
        ProtomotePrice_Label.numberOfLines = 0;
        ProtomotePrice_Label.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:ProtomotePrice_Label];
        self.ProtomotePrice_Label = ProtomotePrice_Label;
        
        // 佣金比例
        UILabel *CommissionRatio_Label = [[UILabel alloc] init];
        CommissionRatio_Label.textColor = RGB(150, 150, 150);
        CommissionRatio_Label.font = [UIFont systemFontOfSize:14.0];
        CommissionRatio_Label.numberOfLines = 0;
        CommissionRatio_Label.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:CommissionRatio_Label];
        self.CommissionRatio_Label = CommissionRatio_Label;
        
        // 佣金
        UILabel *Commission_Label = [[UILabel alloc] init];
        Commission_Label.textColor = RGB(238, 58, 68);
        Commission_Label.font = [UIFont systemFontOfSize:12.0];
        Commission_Label.numberOfLines = 0;
        Commission_Label.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:Commission_Label];
        self.Commission_Label = Commission_Label;
        
        // 第一条分割线
        UIView *TopLine_View = [[UIView alloc] init];
        TopLine_View.backgroundColor = KViewBackGroupColor;
        [self.contentView addSubview:TopLine_View];
        self.TopLine_View = TopLine_View;
        
        // 第二条分割线
        UIView *BottomLine_View = [[UIView alloc] init];
        BottomLine_View.backgroundColor = KViewBackGroupColor;
        [self.contentView addSubview:BottomLine_View];
        self.BottomLine_View = BottomLine_View;
        
        // 添加约束
        [self AddViewLayOut];
    }
    
    return self;
}

/**
 * @brief 添加约束
 */
- (void)AddViewLayOut{
    
    // 推广单号
    self.PromotionNumber_Label.sd_layout.leftSpaceToView(self.contentView, 10).topSpaceToView(self.contentView, 5).autoWidthRatio(0).autoHeightRatio(0);
    [self.PromotionNumber_Label setSingleLineAutoResizeWithMaxWidth:KScreenWidth / 2];
    
    // 推广状态
    self.PromotionState_Label.sd_layout.rightSpaceToView(self.contentView, 10).topEqualToView(self.PromotionNumber_Label).autoWidthRatio(0).autoHeightRatio(0);
    [self.PromotionState_Label setSingleLineAutoResizeWithMaxWidth:KScreenWidth / 2];
    
    // 第一条分割线
    self.TopLine_View.sd_layout.leftEqualToView(self.PromotionNumber_Label).topSpaceToView(self.PromotionNumber_Label, 5).rightSpaceToView(self.contentView, 0).heightIs(1);
    
    // 推广商品图片
    self.Goods_ImageView.sd_layout.leftSpaceToView(self.contentView, 10).topSpaceToView(self.TopLine_View, 5).widthIs(50).heightEqualToWidth();
    
    // 商品的价格
    self.Price_Label.sd_layout.rightSpaceToView(self.contentView, 10).topEqualToView(self.Goods_ImageView).autoHeightRatio(0).autoWidthRatio(0);
    [self.Price_Label setSingleLineAutoResizeWithMaxWidth:120];
    
    // 商品的数量
    self.GoodsCount_Label.sd_layout.rightSpaceToView(self.contentView, 10).topSpaceToView(self.Price_Label, 5).autoHeightRatio(0).autoWidthRatio(0);
    [self.GoodsCount_Label setSingleLineAutoResizeWithMaxWidth:120];
    
    // 商品的推广价格
    self.ProtomotePrice_Label.sd_layout.rightSpaceToView(self.contentView, 10).topSpaceToView(self.GoodsCount_Label, 5).autoHeightRatio(0).autoWidthRatio(0);
    [self.ProtomotePrice_Label setSingleLineAutoResizeWithMaxWidth:120];
    
    // 商品的名字
    self.GoodsName_Label.sd_layout.leftSpaceToView(self.Goods_ImageView, 10).topEqualToView(self.Goods_ImageView).rightSpaceToView(self.Price_Label, 5).autoHeightRatio(0);
    
    // 交易状态
    self.TransactionStatus_Label.sd_layout.leftEqualToView(self.GoodsName_Label).topSpaceToView(self.GoodsName_Label, 5).rightSpaceToView(self.ProtomotePrice_Label, 5).autoHeightRatio(0);
    
    // 第二条
    self.BottomLine_View.sd_layout.leftEqualToView(self.PromotionNumber_Label).topSpaceToView(self.ProtomotePrice_Label, 5).rightSpaceToView(self.contentView, 0).heightIs(1);
    
    // 佣金比例
    self.CommissionRatio_Label.sd_layout.leftSpaceToView(self.contentView, 10).topSpaceToView(self.BottomLine_View, 5).autoWidthRatio(0).autoHeightRatio(0);
    [self.CommissionRatio_Label setSingleLineAutoResizeWithMaxWidth:KScreenWidth / 2];
    
    // 佣金
    self.Commission_Label.sd_layout.rightSpaceToView(self.contentView, 10).topSpaceToView(self.BottomLine_View, 5).autoWidthRatio(0).autoHeightRatio(0);
    [self.Commission_Label setSingleLineAutoResizeWithMaxWidth:KScreenWidth / 2];
    
}

/**
 * @brief 数据模型
 */
- (void)setModel:(HSQProtomoteOrderListDataModel *)model{
    
    _model = model;
    
    // 推广单号
    self.PromotionNumber_Label.text = [NSString stringWithFormat:@"推广单号：%@",model.distributionOrdersId];
    
    // 推广状态
    self.PromotionState_Label.text = model.distributionOrdersTypeText;
    
    // 推广商品图片
    [self.Goods_ImageView sd_setImageWithURL:[NSURL URLWithString:model.imageSrc] placeholderImage:KGoodsPlacherImage];
    
    // 商品的价格
    self.Price_Label.text = [NSString stringWithFormat:@"¥%.2f",model.goodsPrice.floatValue];
    
    // 商品的数量
    self.GoodsCount_Label.text = [NSString stringWithFormat:@"X%@%@",model.buyNum,model.unitName];
    
    // 商品的推广价格
    self.ProtomotePrice_Label.text = [NSString stringWithFormat:@"¥%.2f",model.goodsPayAmount.floatValue];
    
    // 商品的名字
    self.GoodsName_Label.text = model.goodsName;
    
    // 交易状态
    self.TransactionStatus_Label.text = model.ordersStateText;
    
    // 佣金比例
    NSString *commissionRate = [NSString stringWithFormat:@"佣金比例 %@%%",model.commissionRate];
    
    NSMutableAttributedString *commissionRate_attribe = [[NSMutableAttributedString alloc] initWithString:commissionRate];
    
    [commissionRate_attribe addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12.0] range:NSMakeRange(0, 4)];
    
    self.CommissionRatio_Label.attributedText = commissionRate_attribe;
    
    // 佣金
    NSString *commission = [NSString stringWithFormat:@"佣金 %@",model.commission];
    
    NSMutableAttributedString *attribe = [[NSMutableAttributedString alloc] initWithString:commission];
    
    [attribe addAttribute:NSForegroundColorAttributeName value:RGB(150, 150, 150) range:NSMakeRange(0, 2)];
    
    self.Commission_Label.attributedText = attribe;
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
}

@end
