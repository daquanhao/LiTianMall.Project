//
//  HSQToPromoteListCell.m
//  LiTianDecoration
//
//  Created by administrator on 2018/4/13.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import "HSQToPromoteListCell.h"
#import "HSQGoodsDataListModel.h"

@interface HSQToPromoteListCell ()

@property (nonatomic, strong) UIImageView *good_imageView; // 商品的图片

@property (nonatomic, strong) UILabel *goodName_label; // 商品的名字

@property (nonatomic, strong) UILabel *goodPrice_Label; // 商品的价格

@property (nonatomic, strong) UIButton *goodType_Button; // 商品的类型

@property (nonatomic, strong) UILabel *BiLu_Label;  // 商品的比率

@property (nonatomic, strong) UIButton *XuanQu_Button;  // 选取的按钮

@property (nonatomic, strong) UIView *bgView;  // 放有两个按钮的背景视图

@property (nonatomic, strong) UIButton *Share_Button;  // 分享的按钮

@property (nonatomic, strong) UIButton *Select_Button;  // 选取的按钮

@property (nonatomic, strong) UILabel *promotionType_Label; // 限时折扣的标示

@end

@implementation HSQToPromoteListCell

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
        goodPrice_Label.font = [UIFont systemFontOfSize:12.0];
        [self.contentView addSubview:goodPrice_Label];
        self.goodPrice_Label = goodPrice_Label;
        
        // 3.1.商品的价格
        UILabel *promotionType_Label = [[UILabel alloc] init];
        promotionType_Label.textColor = [UIColor whiteColor];
        promotionType_Label.backgroundColor = [UIColor redColor];
        promotionType_Label.font = [UIFont systemFontOfSize:12.0];
        [self.contentView addSubview:promotionType_Label];
        self.promotionType_Label = promotionType_Label;
        
        // 4.商品的比率
        UILabel *BiLu_Label = [[UILabel alloc] init];
        BiLu_Label.textColor = [UIColor blackColor];
        BiLu_Label.font = [UIFont systemFontOfSize:12.0];
        [self.contentView addSubview:BiLu_Label];
        self.BiLu_Label = BiLu_Label;
        
        // 4.商品的佣金
        UILabel *YongJin_Label = [[UILabel alloc] init];
        YongJin_Label.textColor = [UIColor blackColor];
        YongJin_Label.font = [UIFont systemFontOfSize:12.0];
        [self.contentView addSubview:YongJin_Label];
        self.YongJin_Label = YongJin_Label;
        
        // 5.立即选取的按钮
        UIButton *XuanQu_Button = [UIButton buttonWithType:(UIButtonTypeSystem)];
        [XuanQu_Button setTitle:@"立即选取" forState:(UIControlStateNormal)];
        [XuanQu_Button setBackgroundImage:[UIImage ImageWithColor:RGB(1, 154, 168)] forState:(UIControlStateNormal)];
        [XuanQu_Button setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        XuanQu_Button.titleLabel.font = [UIFont systemFontOfSize:12.0];
        [XuanQu_Button addTarget:self action:@selector(XuanQu_ButtonClickAction:) forControlEvents:(UIControlEventTouchUpInside)];
        [self.contentView addSubview:XuanQu_Button];
        self.XuanQu_Button = XuanQu_Button;
        
        // 6.背景视图
        UIView *bgView = [[UIView alloc] init];
        bgView.backgroundColor = KViewBackGroupColor;
        bgView.hidden = YES;
        [self.contentView addSubview:bgView];
        self.bgView = bgView;
        
        // 6.1.立即分享的按钮
        UIButton *Share_Button = [UIButton buttonWithType:(UIButtonTypeSystem)];
        [Share_Button setTitle:@"立即分享" forState:(UIControlStateNormal)];
        [Share_Button setBackgroundImage:[UIImage ImageWithColor:RGB(1, 154, 168)] forState:(UIControlStateNormal)];
        [Share_Button setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        Share_Button.titleLabel.font = [UIFont systemFontOfSize:14.0];
        [Share_Button addTarget:self action:@selector(Share_Button_ButtonClickAction:) forControlEvents:(UIControlEventTouchUpInside)];
        [bgView addSubview:Share_Button];
        self.Share_Button = Share_Button;
        
        // 5.立即选取的按钮
        UIButton *Select_Button = [UIButton buttonWithType:(UIButtonTypeSystem)];
        [Select_Button setTitle:@"立即选取" forState:(UIControlStateNormal)];
        [Select_Button setBackgroundImage:[UIImage ImageWithColor:RGB(1, 154, 168)] forState:(UIControlStateNormal)];
        [Select_Button setBackgroundImage:[UIImage ImageWithColor:RGB(150, 150, 150)] forState:(UIControlStateDisabled)];
        [Select_Button setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        Select_Button.titleLabel.font = [UIFont systemFontOfSize:14.0];
        [Select_Button addTarget:self action:@selector(Select_Button_ButtonClickAction:) forControlEvents:(UIControlEventTouchUpInside)];
        [bgView addSubview:Select_Button];
        self.Select_Button = Select_Button;
        
        // 添加约束
        [self AddViewLayout];
    }
    
    return self;
}

/**
 * @brief 添加约束
 */
- (void)AddViewLayout{
    
    // 商品的图片
    self.good_imageView.sd_layout.leftSpaceToView(self.contentView, 10).centerYEqualToView(self.contentView).heightIs(80).widthEqualToHeight();
    
    // 点击立即选取按钮后显示的背景图
    self.bgView.sd_layout.leftSpaceToView(self.good_imageView, 0).topSpaceToView(self.contentView, 0).bottomSpaceToView(self.contentView, 0).rightSpaceToView(self.contentView, 0);
    
    // 背景图上立即分享的按钮
    self.Share_Button.sd_layout.leftSpaceToView(self.bgView, 10).topSpaceToView(self.bgView, 20).bottomSpaceToView(self.bgView, 20).widthEqualToHeight();
    self.Share_Button.sd_cornerRadiusFromWidthRatio = @(0.5);
    
    // 背景图上立即选取的按钮
    self.Select_Button.sd_layout.leftSpaceToView(self.Share_Button, 20).topEqualToView(self.Share_Button).bottomEqualToView(self.Share_Button).widthEqualToHeight();
    self.Select_Button.sd_cornerRadiusFromWidthRatio = @(0.5);
    
    // 商品的名字
    self.goodName_label.sd_layout.leftSpaceToView(self.contentView, 100).rightSpaceToView(self.contentView, 10).topSpaceToView(self.contentView, 10).autoHeightRatio(0);
    
    // 商品的价格
    self.goodPrice_Label.sd_layout.leftEqualToView(self.goodName_label).topSpaceToView(self.goodName_label, 5).heightIs(20).autoWidthRatio(0);
    [self.goodPrice_Label setSingleLineAutoResizeWithMaxWidth:KScreenWidth / 2];
    
    // 商品是否是限时折扣
    self.promotionType_Label.sd_layout.leftSpaceToView(self.goodPrice_Label, 5).centerYEqualToView(self.goodPrice_Label).autoWidthRatio(0).autoHeightRatio(0);
     [self.promotionType_Label setSingleLineAutoResizeWithMaxWidth:100];
    
    // 商品的比率
    self.BiLu_Label.sd_layout.leftEqualToView(self.goodName_label).rightSpaceToView(self.contentView, 10).topSpaceToView(self.goodPrice_Label, 5).autoHeightRatio(0);
    
    // 商品-立即选取的按钮
    self.XuanQu_Button.sd_layout.rightSpaceToView(self.contentView, 10).bottomSpaceToView(self.contentView, 10).heightIs(25).widthIs(60);
    
    // 商品的佣金
    self.YongJin_Label.sd_layout.leftEqualToView(self.goodName_label).rightSpaceToView(self.XuanQu_Button, 10).topSpaceToView(self.BiLu_Label, 5).autoHeightRatio(0);
}

/**
 * @brief 数据模型
 */
- (void)setModel:(HSQGoodsDataListModel *)model{
    
    _model = model;
    
    // 商品的名字
    self.goodName_label.text = model.goodsName;
    
    // 商品的图片
    [self.good_imageView sd_setImageWithURL:[NSURL URLWithString:model.imageSrc] placeholderImage:KGoodsPlacherImage];
    
    // 商品的价格
    self.goodPrice_Label.text = [NSString stringWithFormat:@"¥%@",model.appPrice0];
    
    // 商品的限时折扣
    if (model.promotionType.integerValue == 0)
    {
        self.promotionType_Label.hidden = YES;
    }
    else
    {
        self.promotionType_Label.hidden = NO;
        
        self.promotionType_Label.text = [NSString stringWithFormat:@" %@ ",model.promotionTypeText];
    }
    
    // 比率
    self.BiLu_Label.text = [NSString stringWithFormat:@"比率：%.2f%@",model.commissionRate.floatValue,@"%%"];
    
    // 商品的佣金
    self.YongJin_Label.text = [NSString stringWithFormat:@"¥%@",model.appCommission];
    
    // 是否是选中状态
    if (model.IsSelectState.integerValue == 0)
    {
        self.bgView.hidden = YES;
    }
    else
    {
        self.bgView.hidden = NO;
    }
    
    // 是否加入选品库
    if (model.IsJoinLibrary == 1)
    {
        [self.Select_Button setEnabled:NO];
    }
    else
    {
        [self.Select_Button setEnabled:YES];
    }
    
    // *********************** 高度自适应cell设置步骤01 ************************
    [self setupAutoHeightWithBottomView:self.YongJin_Label bottomMargin:10];
    
}











-(void)setFrame:(CGRect)frame{
    
    frame.origin.y += 1;
    
    frame.size.height -= 2;
    
    [super setFrame:frame];
}

/**
 * @brief 列表上立即选取按钮的点击事件
 */
- (void)XuanQu_ButtonClickAction:(UIButton *)sender{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(AtOnceSelectButtonWithCellList:)]) {
        
        [self.delegate AtOnceSelectButtonWithCellList:sender];
    }
}

/**
 * @brief 背景视图上立即分享按钮的点击事件
 */
- (void)Share_Button_ButtonClickAction:(UIButton *)sender{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(AtOnceShareButtonWithBgViewClickAction:)]) {
        
        [self.delegate AtOnceShareButtonWithBgViewClickAction:sender];
    }
}

/**
 * @brief 背景视图上立即选取按钮的点击事件
 */
- (void)Select_Button_ButtonClickAction:(UIButton *)sender{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(AtOnceSelectButtonWithBgViewClickAction:)]) {
        
        [self.delegate AtOnceSelectButtonWithBgViewClickAction:sender];
    }
}

- (void)setIsHiddenBgView:(BOOL)IsHiddenBgView{
    
    _IsHiddenBgView = IsHiddenBgView;
    
//    self.bgView.hidden = IsHiddenBgView;
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
