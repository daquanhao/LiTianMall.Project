//
//  HSQPinTuanListCell.m
//  LiTianDecoration
//
//  Created by administrator on 2018/4/12.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import "HSQPinTuanListCell.h"
#import "HSQPinTuanListModel.h"

@interface HSQPinTuanListCell ()

@property (nonatomic, strong) UIImageView *Goods_Image;

@property (nonatomic, strong) UILabel *GoodsName_Label;

@property (nonatomic, strong) UILabel *KaiTuanCount_Label;

@property (nonatomic, strong) UILabel *PrePrice_Label;  // 现价

@property (nonatomic, strong) UILabel *OriginalPrice_Label; // 原价

@property (nonatomic, strong) UIButton *KaiTuan_Button; // 开团按钮

@end

@implementation HSQPinTuanListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        // 1.商品的图片
        UIImageView *goods_image = [[UIImageView alloc] init];
        [self.contentView addSubview:goods_image];
        self.Goods_Image = goods_image;
        
        // 2.商品的名字
        UILabel *goodName_Label = [[UILabel alloc] init];
        goodName_Label.textColor = [UIColor blackColor];
        goodName_Label.font = [UIFont systemFontOfSize:12.0];
        goodName_Label.numberOfLines = 2;
        [self.contentView addSubview:goodName_Label];
        self.GoodsName_Label = goodName_Label;
        
        // 3.开团的人数
        UILabel *KaiTuanCount_Label = [[UILabel alloc] init];
        KaiTuanCount_Label.textColor = [UIColor grayColor];
        KaiTuanCount_Label.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:KaiTuanCount_Label];
        self.KaiTuanCount_Label = KaiTuanCount_Label;
        
        // 4.开团的按钮
        UIButton *KaiTuan_Button = [UIButton buttonWithType:(UIButtonTypeSystem)];
        KaiTuan_Button.enabled = NO;
        [KaiTuan_Button setTitle:@"去 开 团" forState:(UIControlStateDisabled)];
        [KaiTuan_Button setTitleColor:[UIColor whiteColor] forState:(UIControlStateDisabled)];
        [KaiTuan_Button setBackgroundImage:[UIImage ImageWithColor:[UIColor redColor]] forState:(UIControlStateDisabled)];
        KaiTuan_Button.titleLabel.font = [UIFont systemFontOfSize:12.0];
        [self.contentView addSubview:KaiTuan_Button];
        self.KaiTuan_Button = KaiTuan_Button;
        
        // 5.商品的现价
        UILabel *PrePrice_Label = [[UILabel alloc] init];
        PrePrice_Label.textColor = [UIColor redColor];
        PrePrice_Label.font = [UIFont systemFontOfSize:12.0];
        [self.contentView addSubview:PrePrice_Label];
        self.PrePrice_Label = PrePrice_Label;
        
        // 6.商品的原价
        UILabel *OriginalPrice_Label = [[UILabel alloc] init];
        OriginalPrice_Label.textColor = [UIColor grayColor];
        OriginalPrice_Label.font = [UIFont systemFontOfSize:12.0];
        [self.contentView addSubview:OriginalPrice_Label];
        self.OriginalPrice_Label = OriginalPrice_Label;
        
        // 添加约束
        [self AddViewLayOut];

    }
    
    return self;
}

/**
 * @brief 添加控件的约束
 */
- (void)AddViewLayOut{
    
    // 商品的名字
    CGFloat LeftMargin = ([UIDevice iPhonesModel] == iPhone6Plus ? 120 : 110);
    self.GoodsName_Label.sd_layout.topSpaceToView(self.contentView, 10).leftSpaceToView(self.contentView, LeftMargin).rightSpaceToView(self.contentView, 10).autoHeightRatio(0);
    
    // 开团的人数
    self.KaiTuanCount_Label.sd_layout.leftEqualToView(self.GoodsName_Label).topSpaceToView(self.GoodsName_Label, 10).rightSpaceToView(self.contentView, 10).autoHeightRatio(0);
    
    // 去开团的按钮
    self.KaiTuan_Button.sd_layout.rightSpaceToView(self.contentView, 10).topSpaceToView(self.KaiTuanCount_Label, 10).widthIs(70).heightIs(25);
    self.KaiTuan_Button.sd_cornerRadius = @(3);
    
    // 商品的开团价
    self.PrePrice_Label.sd_layout.leftEqualToView(self.GoodsName_Label).centerYEqualToView(self.KaiTuan_Button).heightIs(20).autoWidthRatio(0);
    [self.PrePrice_Label setSingleLineAutoResizeWithMaxWidth: (KScreenWidth - 90 - 130 * KScreenHeight / 667 - 15) / 2];
    
    // 商品的原来的价格
    self.OriginalPrice_Label.sd_layout.leftSpaceToView(self.PrePrice_Label, 5).centerYEqualToView(self.PrePrice_Label).heightRatioToView(self.PrePrice_Label, 1.0).autoWidthRatio(0);
    [self.OriginalPrice_Label setSingleLineAutoResizeWithMaxWidth: (KScreenWidth - 90 - 130 * KScreenHeight / 667 - 15) / 2];
    
    // 商品的图片
    self.Goods_Image.sd_layout.leftSpaceToView(self.contentView, 5).topSpaceToView(self.contentView, 10).bottomEqualToView(self.KaiTuan_Button).widthEqualToHeight();
    
}

/**
 * @brief 控件赋值
 */
- (void)setModel:(HSQPinTuanListModel *)model{
    
    _model = model;
    
    // 商品的图片
    [self.Goods_Image sd_setImageWithURL:[NSURL URLWithString:model.imageSrc] placeholderImage:KGoodsPlacherImage];
    
    // 商品的名字
    self.GoodsName_Label.text = model.goodsName;
    
    // 商品的拼团数量
    self.KaiTuanCount_Label.text = [NSString stringWithFormat:@"已团%@件",model.joinedNum];
    
    // 拼团的价格
    self.PrePrice_Label.text = [NSString stringWithFormat:@"¥%@",model.groupPrice];
    
    // 商品原来的价格-----中划线
    NSString *orgin_price = [NSString stringWithFormat:@"¥%@",model.goodsPrice];
    
    NSDictionary *attribtDic = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
    
    NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:orgin_price attributes:attribtDic];

    self.OriginalPrice_Label.attributedText = attribtStr;
    
    // *********************** 高度自适应cell设置步骤01 ************************
    [self setupAutoHeightWithBottomView:self.KaiTuan_Button bottomMargin:10];
}

- (void)setFrame:(CGRect)frame{
    
    frame.origin.y += 1;
    
    frame.size.height -= 2;
    
    [super setFrame:frame];
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
