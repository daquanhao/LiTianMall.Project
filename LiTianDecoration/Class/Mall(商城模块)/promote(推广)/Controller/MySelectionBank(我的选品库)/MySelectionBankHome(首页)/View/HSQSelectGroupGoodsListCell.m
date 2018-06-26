//
//  HSQSelectGroupGoodsListCell.m
//  LiTianDecoration
//
//  Created by administrator on 2018/6/14.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import "HSQSelectGroupGoodsListCell.h"
#import "HSQGoodsDataListModel.h"

@interface HSQSelectGroupGoodsListCell ()

@property (nonatomic, strong) UIImageView *good_imageView; // 商品的图片

@property (nonatomic, strong) UILabel *goodName_label; // 商品的名字

@property (nonatomic, strong) UILabel *goodPrice_Label; // 商品的价格

@property (nonatomic, strong) UILabel *BiLu_Label;  // 商品的比率

@property (nonatomic, strong) UILabel *TuiGuangCount_Label;  // 商品推广数量

@end

@implementation HSQSelectGroupGoodsListCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        // 1.商品的图片
        UIImageView *good_imageView = [[UIImageView alloc] init];
        [self.contentView addSubview:good_imageView];
        self.good_imageView = good_imageView;
        
        // 2.商品的名字
        UILabel *goodName_label = [[UILabel alloc] init];
        goodName_label.textColor = [UIColor blackColor];
        goodName_label.font = [UIFont systemFontOfSize:12.0];
        goodName_label.numberOfLines = 0;
        [self.contentView addSubview:goodName_label];
        self.goodName_label = goodName_label;
        
        // 3.商品的价格
        UILabel *goodPrice_Label = [[UILabel alloc] init];
        goodPrice_Label.textColor = [UIColor redColor];
        goodPrice_Label.font = [UIFont systemFontOfSize:14.0];
        [self.contentView addSubview:goodPrice_Label];
        self.goodPrice_Label = goodPrice_Label;
        
        // 4.商品的比率
        UILabel *BiLu_Label = [[UILabel alloc] init];
        BiLu_Label.textColor = [UIColor redColor];
        BiLu_Label.font = [UIFont systemFontOfSize:12.0];
        [self.contentView addSubview:BiLu_Label];
        self.BiLu_Label = BiLu_Label;
        
        // 5.商品推广数量
        UILabel *TuiGuangCount_Label = [[UILabel alloc] init];
        TuiGuangCount_Label.textColor = [UIColor blackColor];
        TuiGuangCount_Label.font = [UIFont systemFontOfSize:12.0];
        [self.contentView addSubview:TuiGuangCount_Label];
        self.TuiGuangCount_Label = TuiGuangCount_Label;
        
        // 5.商品佣金比例
        
        [self AddViewLayOut];
    }
    
    return self;
}

/**
 * @brief 添加约束
 */
- (void)AddViewLayOut{
    
    // 商品的图片
    self.good_imageView.sd_layout.leftSpaceToView(self.contentView, 10).centerYEqualToView(self.contentView).heightIs(60).widthEqualToHeight();
    
    // 商品的比率
    self.BiLu_Label.sd_layout.rightSpaceToView(self.contentView, 10).topSpaceToView(self.contentView, 10).autoHeightRatio(0).autoWidthRatio(0);
    [self.BiLu_Label setSingleLineAutoResizeWithMaxWidth:120];
    
    // 商品的名字
    self.goodName_label.sd_layout.leftSpaceToView(self.contentView, 80).rightSpaceToView(self.BiLu_Label, 5).topSpaceToView(self.contentView, 10).autoHeightRatio(0);
    
    // 商品的价格
    self.goodPrice_Label.sd_layout.leftEqualToView(self.goodName_label).topSpaceToView(self.goodName_label, 5).rightSpaceToView(self.contentView, 10).autoHeightRatio(0);
    
    // 商品推广数量
    self.TuiGuangCount_Label.sd_layout.leftEqualToView(self.goodName_label).topSpaceToView(self.goodPrice_Label, 5).rightSpaceToView(self.contentView, 10).autoHeightRatio(0);
    
}

/**
 * @brief 数据模型
 */
- (void)setModel:(HSQGoodsDataListModel *)model{
    
    _model = model;
    
    // 商品的图片
    [self.good_imageView sd_setImageWithURL:[NSURL URLWithString:model.imageSrc] placeholderImage:KGoodsPlacherImage];
    
    // 商品的名字
    self.goodName_label.text = model.goodsName;
    
    // 商品的价格
    self.goodPrice_Label.text = [NSString stringWithFormat:@"¥%.2f",model.appPriceMin.floatValue];
    
    // 商品推广数量
    self.TuiGuangCount_Label.text = [NSString stringWithFormat:@"推广数量  %@",model.distributionCount];
    
    // 商品的比率
    NSString *commissionRate = [NSString stringWithFormat:@"佣金比例  %.2f%@",model.commissionRate.floatValue,@"%"];
    
    NSMutableAttributedString *attribe = [[NSMutableAttributedString alloc] initWithString:commissionRate];
    
    [attribe addAttribute:NSForegroundColorAttributeName value:RGB(150, 150, 150) range:NSMakeRange(0, 4)];
    
    self.BiLu_Label.attributedText = attribe;
    
    // *********************** 高度自适应cell设置步骤01 ************************
    [self setupAutoHeightWithBottomView:self.TuiGuangCount_Label bottomMargin:10];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
