//
//  PublieTuiJianGoodsListView.m
//  LiTianDecoration
//
//  Created by administrator on 2018/5/11.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import "PublieTuiJianGoodsListView.h"

@interface PublieTuiJianGoodsListView ()

@property (nonatomic, strong) UIView *BgView;

@property (nonatomic, strong) UILabel *GoodsNameLabel; // 商品的名字

@property (nonatomic, strong) UILabel *GoodsPriceLabel; // 商品的价格

@property (nonatomic, strong) UIImageView *GoodsImage; // 商品的图片

@property (nonatomic, strong) UIButton *GoodsBtn;

@end

@implementation PublieTuiJianGoodsListView

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        // 添加商品的视图
        [self SetUpGoodsView];
        
        // 添加商品的视图的约束
        [self SetUpGoodsViewLayOut];
    }
    
    return self;
}

/**
 * @brief 添加商品的视图
 */
- (void)SetUpGoodsView{
    
     // 商品的价格
    UILabel *GoodsPriceLabel = [[UILabel alloc] init];
    GoodsPriceLabel.textColor = RGB(71, 71, 71);
    GoodsPriceLabel.font = [UIFont systemFontOfSize:14.0];
    [self addSubview:GoodsPriceLabel];
    self.GoodsPriceLabel = GoodsPriceLabel;
    
    // 商品的名字
    UILabel *GoodsNameLabel = [[UILabel alloc] init];
    GoodsNameLabel.textColor = RGB(71, 71, 71);
    GoodsNameLabel.font = [UIFont systemFontOfSize:14.0];
    GoodsNameLabel.numberOfLines = 2;
    [self addSubview:GoodsNameLabel];
    self.GoodsNameLabel = GoodsNameLabel;
    
    // 商品图片的背景图
    UIView *BgView = [[UIView alloc] init];
    [self addSubview:BgView];
    self.BgView = BgView;
    
    // 商品的图片
    UIImageView *GoodsImage = [[UIImageView alloc] init];
    [BgView addSubview:GoodsImage];
    self.GoodsImage = GoodsImage;
    
    // 按钮
    UIButton *GoodsBtn = [UIButton buttonWithType:(UIButtonTypeSystem)];
    [GoodsBtn addTarget:self action:@selector(GoodsButtonClickAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:GoodsBtn];
    self.GoodsBtn = GoodsBtn;
    
}

/**
 * @brief 添加商品的视图的约束
 */
- (void)SetUpGoodsViewLayOut{
    
    // 商品的价格
    self.GoodsPriceLabel.sd_layout.leftSpaceToView(self, 5).rightSpaceToView(self, 5).bottomSpaceToView(self, 5).autoHeightRatio(0);
    
    // 商品的名字
    self.GoodsNameLabel.sd_layout.leftEqualToView(self.GoodsPriceLabel).rightEqualToView(self.GoodsPriceLabel).bottomSpaceToView(self.GoodsPriceLabel, 5).autoHeightRatio(0);
    [self.GoodsNameLabel setMaxNumberOfLinesToShow:2];
    
    // 商品图片的背景图
    self.BgView.sd_layout.leftSpaceToView(self, 0).topSpaceToView(self, 0).rightSpaceToView(self, 0).bottomSpaceToView(self.GoodsNameLabel, 0);
    
    // 商品的图片
    self.GoodsImage.sd_layout.leftSpaceToView(self.BgView, 2).rightSpaceToView(self.BgView, 2).centerYEqualToView(self.BgView).heightEqualToWidth();
    
    // 商品的图片按钮
    self.GoodsBtn.sd_layout.leftSpaceToView(self, 0).topSpaceToView(self, 0).rightSpaceToView(self, 0).bottomSpaceToView(self, 0);
}

/**
 * @brief 控件赋值
 */
- (void)setDataDiction:(NSDictionary *)dataDiction{
    
    _dataDiction = dataDiction;
    
    // 商品的价格
    self.GoodsPriceLabel.text = [NSString stringWithFormat:@"¥%@",dataDiction[@"appPrice0"]];

    // 商品的名字
     self.GoodsNameLabel.text = [NSString stringWithFormat:@"%@",dataDiction[@"goodsName"]];

    // 商品的图片
    [self.GoodsImage sd_setImageWithURL:[NSURL URLWithString:dataDiction[@"imageSrc"]] placeholderImage:KGoodsPlacherImage];
}

/**
 * @brief 商品按钮的点击
 */
- (void)GoodsButtonClickAction:(UIButton *)sender{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(TuiJianGoodsListClickAction:commonId:)]) {
        
        [self.delegate TuiJianGoodsListClickAction:sender commonId:self.dataDiction[@"commonId"]];
    }
}








@end
