//
//  HSQMyCollectionHeaderView.m
//  LiTianDecoration
//
//  Created by administrator on 2018/4/27.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import "HSQMyCollectionHeaderView.h"
#import "HSQGoodsDataListModel.h"
#import "HSQStoreCollectionDataListModel.h"

@interface HSQMyCollectionHeaderView ()

@property (nonatomic, strong) UIView *BgView;

@property (nonatomic, strong) UIImageView *GoodsImageView;

@property (nonatomic, strong) UILabel *GoodsNameLabel;

@property (nonatomic, strong) UIButton *Mark_Button;

@property (nonatomic, strong) UILabel *GoodsPriceLabel;

@property (nonatomic, strong) UIButton *Right_Button;

@property (nonatomic, strong) UIView *Btn_View;

@property (nonatomic, strong) UIButton *Share_Button;

@property (nonatomic, strong) UIButton *Cancel_Button;

@property (nonatomic, strong) UIButton *Price_Button;

@property (nonatomic, strong) UIButton *Select_Button;  // 选中的按钮


@end

@implementation HSQMyCollectionHeaderView

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor clearColor];
        
        // 背景图
        UIView *bgView = [[UIView alloc] init];
        bgView.backgroundColor = [UIColor whiteColor];
        [self addSubview:bgView];
        self.BgView = bgView;
        
        // 是否选中
        UIImageView *Select_ImageView = [[UIImageView alloc] init];
        Select_ImageView.image = KImageName(@"878CADA4-7366-480C-856E-9DBA873C758C");
        [bgView addSubview:Select_ImageView];
        self.Select_ImageView = Select_ImageView;
        
        // 1.商品的图片
        UIImageView *GoodsImageView = [[UIImageView alloc] init];
        [bgView addSubview:GoodsImageView];
        self.GoodsImageView = GoodsImageView;
        
        // 2.商品的名字
        UILabel *nameLabel = [[UILabel alloc] init];
        nameLabel.font = [UIFont systemFontOfSize:12.0];
        nameLabel.textColor = RGB(51, 51, 51);
        nameLabel.numberOfLines = 0;
        [bgView addSubview:nameLabel];
        self.GoodsNameLabel = nameLabel;
        
        // 3.商品的标签
        UIButton *Mark_Button = [UIButton buttonWithType:(UIButtonTypeSystem)];
        Mark_Button.titleLabel.font = [UIFont systemFontOfSize:10.0];
        [Mark_Button setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        [Mark_Button setBackgroundImage:[UIImage ImageWithColor:[UIColor redColor]] forState:(UIControlStateDisabled)];
        Mark_Button.layer.cornerRadius = 5;
        Mark_Button.clipsToBounds = YES;
        Mark_Button.enabled = NO;
        [bgView addSubview:Mark_Button];
        self.Mark_Button = Mark_Button;
        
        // 3.折扣商品降价
        UIButton *Price_Button = [UIButton buttonWithType:(UIButtonTypeCustom)];
        Price_Button.titleLabel.font = [UIFont systemFontOfSize:12.0];
        Price_Button.enabled = NO;
        [Price_Button setTitleColor:RGB(150, 150, 150) forState:(UIControlStateDisabled)];
        [Price_Button setImage:KImageName(@"123") forState:(UIControlStateDisabled)];
        Price_Button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [Price_Button setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
        [bgView addSubview:Price_Button];
        self.Price_Button = Price_Button;
        
        // 4.右下角的按钮
        UIButton *Right_Button = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [Right_Button setImage:[UIImage ReturnAPictureOfStretching:@"RightItemImage"] forState:(UIControlStateNormal)];
        [Right_Button addTarget:self action:@selector(Right_ButtonClickAction:) forControlEvents:(UIControlEventTouchUpInside)];
        [bgView addSubview:Right_Button];
        self.Right_Button = Right_Button;
        
        // 5.商品的价格
        UILabel *GoodsPriceLabel = [[UILabel alloc] init];
        GoodsPriceLabel.font = [UIFont systemFontOfSize:KTextFont_(14)];
        GoodsPriceLabel.textColor = RGB(238, 48, 51);
        GoodsPriceLabel.numberOfLines = 0;
        [bgView addSubview:GoodsPriceLabel];
        self.GoodsPriceLabel = GoodsPriceLabel;
        
        // 6.猜你喜欢
        UIButton *Like_Btn = [UIButton buttonWithType:(UIButtonTypeSystem)];
        Like_Btn.backgroundColor = [UIColor clearColor];
        [Like_Btn setTitle:@"猜  你  喜  欢" forState:(UIControlStateNormal)];
        [Like_Btn setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
        Like_Btn.backgroundColor = KViewBackGroupColor;
//        [self addSubview:Like_Btn];
        self.Like_Btn = Like_Btn;
        
        // 7.按钮的背景视图
        UIView *Btn_View = [[UIView alloc] init];
        Btn_View.backgroundColor = [UIColor whiteColor];
        [bgView addSubview:Btn_View];
        self.Btn_View = Btn_View;
        
        // 7.1.分享的按钮
        UIButton *Share_Button = [UIButton buttonWithType:(UIButtonTypeSystem)];
        [Share_Button setBackgroundImage:[UIImage ImageWithColor:[UIColor orangeColor]] forState:(UIControlStateNormal)];
        [Share_Button setTitle:@"立即分享" forState:(UIControlStateNormal)];
        [Share_Button setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        Share_Button.titleLabel.font = [UIFont systemFontOfSize:12.0];
        [Share_Button addTarget:self action:@selector(Share_ButtonClickAction:) forControlEvents:(UIControlEventTouchUpInside)];
        [Btn_View addSubview:Share_Button];
        self.Share_Button = Share_Button;
        
        // 7.2.加入购物车的按钮
        UIButton *Cancel_Button = [UIButton buttonWithType:(UIButtonTypeSystem)];
        [Cancel_Button setBackgroundImage:[UIImage ImageWithColor:[UIColor purpleColor]] forState:(UIControlStateNormal)];
        [Cancel_Button setTitle:@"加入购物车" forState:(UIControlStateNormal)];
        [Cancel_Button setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        Cancel_Button.titleLabel.font = [UIFont systemFontOfSize:12.0];
        [Cancel_Button addTarget:self action:@selector(Cancel_ButtonClickAction:) forControlEvents:(UIControlEventTouchUpInside)];
        [Btn_View addSubview:Cancel_Button];
        self.Cancel_Button = Cancel_Button;
        
        // 选中按钮
        UIButton *Select_Button = [UIButton buttonWithType:(UIButtonTypeSystem)];
        [Select_Button addTarget:self action:@selector(Select_ButtonClickAction:) forControlEvents:(UIControlEventTouchUpInside)];
        [bgView addSubview:Select_Button];
        self.Select_Button = Select_Button;

        // 6.设置控件的约束
        [self SetsTheConstraintForTheControl];
        
    }
    
    return self;
}

/**
 * @brief 设置控件的约束
 */
- (void)SetsTheConstraintForTheControl{
    
    // 6.猜你喜欢
    self.Like_Btn.sd_layout.leftSpaceToView(self, 0).bottomSpaceToView(self, 0).rightSpaceToView(self, 0).heightIs(50);
    
    // 背景图
    self.BgView.sd_layout.leftSpaceToView(self, 0).topSpaceToView(self, 1).bottomSpaceToView(self, 1).rightSpaceToView(self, 0);
    
    // 选中按钮
    self.Select_Button.sd_layout.leftSpaceToView(self.BgView, 0).topSpaceToView(self.BgView, 0).rightSpaceToView(self.BgView, 0).bottomSpaceToView(self.BgView, 0);
    
    // 1.商品的图片
    self.Select_ImageView.sd_layout.leftSpaceToView(self.BgView, 5).centerYEqualToView(self.BgView).heightIs(20).widthEqualToHeight();
    
    // 1.商品的图片
    self.GoodsImageView.sd_layout.leftSpaceToView(self.BgView, 10).topSpaceToView(self.BgView, 10).bottomSpaceToView(self.BgView, 10).widthEqualToHeight();
    
    // 2.商品的名字
    self.GoodsNameLabel.sd_layout.leftSpaceToView(self.GoodsImageView, 5).topEqualToView(self.GoodsImageView).rightSpaceToView(self.BgView, 10).autoHeightRatio(0);
    
    // 3.商品的标签
    self.Mark_Button.sd_layout.leftEqualToView(self.GoodsNameLabel).topSpaceToView(self.GoodsNameLabel, 5).widthIs(50).heightIs(15);
    
    // 3.1.折扣商品降价
    self.Price_Button.sd_layout.leftEqualToView(self.Mark_Button).topSpaceToView(self.Mark_Button, 5).rightSpaceToView(self.BgView, 10).heightIs(20);
    
    // 5.右下角的按钮
    self.Right_Button.sd_layout.rightSpaceToView(self.BgView, 0).bottomEqualToView(self.BgView).widthIs(60).heightIs(30);
    
    // 4.商品的价格
    self.GoodsPriceLabel.sd_layout.leftEqualToView(self.GoodsNameLabel).bottomEqualToView(self.GoodsImageView).rightSpaceToView(self.Right_Button, 10).autoHeightRatio(0);
    
    // 5.按钮的背景视图
    self.Btn_View.sd_layout.leftEqualToView(self.GoodsNameLabel).topEqualToView(self.GoodsImageView).bottomEqualToView(self.GoodsImageView).rightSpaceToView(self.BgView, 0);
    
    // 5.1.左边的分享按钮
    self.Share_Button.sd_layout.leftSpaceToView(self.Btn_View, 0).centerYEqualToView(self.Btn_View).heightIs(70).widthEqualToHeight();
    [self.Share_Button setSd_cornerRadiusFromHeightRatio:@(0.5)];
    
    // 5.2.右边的加入购物车按钮
    self.Cancel_Button.sd_layout.leftSpaceToView(self.Share_Button, 10).centerYEqualToView(self.Btn_View).heightIs(70).widthEqualToHeight();
    [self.Cancel_Button setSd_cornerRadiusFromHeightRatio:@(0.5)];

}

/**
 * @brief 数据赋值
 */
- (void)setModel:(HSQGoodsDataListModel *)model{
    
    _model = model;
    
    // 不显示立即分享，加入购物车按钮
    self.Btn_View.hidden = (model.IsOpen == 0 ? YES : NO);
    
    // 商品的图片
    [self.GoodsImageView sd_setImageWithURL:[NSURL URLWithString:model.goodsCommon[@"imageSrc"]] placeholderImage:KGoodsPlacherImage];
    
    // 商品的名字
    self.GoodsNameLabel.text = model.goodsName;
    
    // 商品的价格
    NSString *appPrice0 = [NSString stringWithFormat:@"%@",model.goodsCommon[@"appPrice0"]];
    self.GoodsPriceLabel.text = [NSString stringWithFormat:@"¥%.2f",appPrice0.floatValue];
    
    // 判断是否是限时折扣商品
    NSString *promotionType = [NSString stringWithFormat:@"%@",model.goodsCommon[@"promotionType"]];
    
    NSString *GoodsPrce = [NSString stringWithFormat:@"%.2f",model.favGoodsPrice.floatValue - appPrice0.floatValue];
    
    if (promotionType.integerValue == 1)
    {
        self.Mark_Button.hidden = NO;
         self.Price_Button.hidden = NO;
        [self.Mark_Button setTitle:model.goodsCommon[@"promotionTypeText"] forState:(UIControlStateDisabled)];
        [self.Price_Button setTitle:[NSString stringWithFormat:@"比加入收藏时降%@元",GoodsPrce] forState:(UIControlStateDisabled)];
    }
    else
    {
         self.Mark_Button.hidden = YES;
        self.Price_Button.hidden = YES;
        [self.Mark_Button setTitle:@"" forState:(UIControlStateDisabled)];
        [self.Price_Button setTitle:@"" forState:(UIControlStateDisabled)];
    }
    
    // 判断是否选中
    if (model.IsEditState.integerValue == 1) // 没有编辑
    {
        self.Select_ImageView.hidden = self.Select_Button.hidden = YES;
        
        self.Right_Button.hidden = NO;
        
        // 1.商品的图片
        self.GoodsImageView.sd_resetLayout.leftSpaceToView(self.BgView, 10).topSpaceToView(self.BgView, 10).bottomSpaceToView(self.BgView, 10).widthEqualToHeight();
    }
    else
    {
        self.Select_ImageView.hidden = self.Select_Button.hidden = NO;
        
        self.Right_Button.hidden = YES;
        
        // 1.商品的图片
        self.GoodsImageView.sd_resetLayout.leftSpaceToView(self.Select_ImageView, 10).topSpaceToView(self.BgView, 10).bottomSpaceToView(self.BgView, 10).widthEqualToHeight();
    }
        
    // 是否选中
    if (model.IsSelectState.integerValue == 1) // 没有选中
    {
         self.Select_ImageView.image = KImageName(@"878CADA4-7366-480C-856E-9DBA873C758C");
    }
    else
    {
        self.Select_ImageView.image = KImageName(@"320A9B4D-0268-49C1-845B-7E3AABAB72BC");
    }
}


- (void)Right_ButtonClickAction:(UIButton *)sender{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(ClickOnTheButtonInTheLowerRightCorner:)]) {
        
        [self.delegate ClickOnTheButtonInTheLowerRightCorner:sender];
    }
}

/**
 * @brief 立即分享的按钮点击事件
 */
- (void)Share_ButtonClickAction:(UIButton *)sender{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(ShareTheButtonImmediatelyByClickingTheEvent:)]) {
        
        [self.delegate ShareTheButtonImmediatelyByClickingTheEvent:sender];
    }
}

/**
 * @brief 加入购物车的按钮点击事件
 */
- (void)Cancel_ButtonClickAction:(UIButton *)sender{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(AddTheCartButtonClickEvent:)]) {
        
        [self.delegate AddTheCartButtonClickEvent:sender];
    }
}

/**
 * @brief 编时选中按钮
 */
- (void)Select_ButtonClickAction:(UIButton *)sender{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(SelectTheClickEventOfTheButtonWhenEditing:)]) {
        
        [self.delegate SelectTheClickEventOfTheButtonWhenEditing:sender];
    }
}







@end
