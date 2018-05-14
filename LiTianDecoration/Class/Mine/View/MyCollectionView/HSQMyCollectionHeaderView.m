//
//  HSQMyCollectionHeaderView.m
//  LiTianDecoration
//
//  Created by administrator on 2018/4/27.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import "HSQMyCollectionHeaderView.h"

@interface HSQMyCollectionHeaderView ()

@property (nonatomic, strong) UIImageView *GoodsImageView;

@property (nonatomic, strong) UILabel *GoodsNameLabel;

@property (nonatomic, strong) UIButton *Mark_Button;

@property (nonatomic, strong) UILabel *GoodsPriceLabel;

@property (nonatomic, strong) UIButton *Right_Button;

@property (nonatomic, strong) UIView *Btn_View;

@property (nonatomic, strong) UIButton *Share_Button;

@property (nonatomic, strong) UIButton *Cancel_Button;

@end

@implementation HSQMyCollectionHeaderView

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        // 1.商品的图片
        UIImageView *GoodsImageView = [[UIImageView alloc] init];
        GoodsImageView.image = KImageName(@"icon4");
        [self addSubview:GoodsImageView];
        self.GoodsImageView = GoodsImageView;
        
        // 2.商品的名字
        UILabel *nameLabel = [[UILabel alloc] init];
        nameLabel.font = [UIFont systemFontOfSize:KTextFont_(14)];
        nameLabel.textColor = RGB(51, 51, 51);
        nameLabel.numberOfLines = 0;
        nameLabel.text = @"我的苹果手机";
        [self addSubview:nameLabel];
        self.GoodsNameLabel = nameLabel;
        
        // 3.商品的标签
        UIButton *Mark_Button = [UIButton buttonWithType:(UIButtonTypeSystem)];
        [Mark_Button setTitle:@"限时折扣" forState:(UIControlStateDisabled)];
        Mark_Button.titleLabel.font = [UIFont systemFontOfSize:KTextFont_(13)];
        [Mark_Button setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        [Mark_Button setBackgroundImage:[UIImage ImageWithColor:[UIColor redColor]] forState:(UIControlStateDisabled)];
        Mark_Button.enabled = NO;
        [self addSubview:Mark_Button];
        self.Mark_Button = Mark_Button;
        
        // 4.右下角的按钮
        UIButton *Right_Button = [UIButton buttonWithType:(UIButtonTypeSystem)];
        [Right_Button setBackgroundImage:[UIImage ImageWithColor:[UIColor redColor]] forState:(UIControlStateNormal)];
        [Right_Button addTarget:self action:@selector(Right_ButtonClickAction:) forControlEvents:(UIControlEventTouchUpInside)];
        [self addSubview:Right_Button];
        self.Right_Button = Right_Button;
        
        // 5.商品的价格
        UILabel *GoodsPriceLabel = [[UILabel alloc] init];
        GoodsPriceLabel.font = [UIFont systemFontOfSize:KTextFont_(16)];
        GoodsPriceLabel.textColor = RGB(238, 48, 51);
        GoodsPriceLabel.numberOfLines = 0;
        GoodsPriceLabel.text = @"¥3099.00";
        [self addSubview:GoodsPriceLabel];
        self.GoodsPriceLabel = GoodsPriceLabel;
        
        // 6.猜你喜欢
        UIButton *Like_Btn = [UIButton buttonWithType:(UIButtonTypeSystem)];
        Like_Btn.backgroundColor = [UIColor clearColor];
        [Like_Btn setTitle:@"猜  你  喜  欢" forState:(UIControlStateNormal)];
        [Like_Btn setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
        Like_Btn.backgroundColor = KViewBackGroupColor;
        [self addSubview:Like_Btn];
        self.Like_Btn = Like_Btn;
        
        // 7.按钮的背景视图
        UIView *Btn_View = [[UIView alloc] init];
        Btn_View.backgroundColor = [UIColor whiteColor];
        [self addSubview:Btn_View];
        self.Btn_View = Btn_View;
        
        // 7.1.分享的按钮
        UIButton *Share_Button = [UIButton buttonWithType:(UIButtonTypeSystem)];
        [Share_Button setBackgroundImage:[UIImage ImageWithColor:[UIColor orangeColor]] forState:(UIControlStateNormal)];
        [Share_Button setTitle:@"立即分享" forState:(UIControlStateNormal)];
        [Share_Button setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        Share_Button.titleLabel.font = [UIFont systemFontOfSize:KTextFont_(13)];
        [Btn_View addSubview:Share_Button];
        self.Share_Button = Share_Button;
        
        // 7.2.取消的按钮
        UIButton *Cancel_Button = [UIButton buttonWithType:(UIButtonTypeSystem)];
        [Cancel_Button setBackgroundImage:[UIImage ImageWithColor:[UIColor purpleColor]] forState:(UIControlStateNormal)];
        [Cancel_Button setTitle:@"加入购物车" forState:(UIControlStateNormal)];
        [Cancel_Button setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        Cancel_Button.titleLabel.font = [UIFont systemFontOfSize:KTextFont_(13)];
        [Btn_View addSubview:Cancel_Button];
        self.Cancel_Button = Cancel_Button;

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
    
    // 1.商品的图片
    self.GoodsImageView.sd_layout.leftSpaceToView(self, 10).topSpaceToView(self, 10).heightIs(80).widthEqualToHeight();
    
    // 2.商品的名字
    self.GoodsNameLabel.sd_layout.leftSpaceToView(self.GoodsImageView, 10).topSpaceToView(self, 10).rightSpaceToView(self, 10).autoHeightRatio(0);
    
    // 3.商品的标签
    self.Mark_Button.sd_layout.leftEqualToView(self.GoodsNameLabel).topSpaceToView(self.GoodsNameLabel, 10).widthIs(60).heightIs(20);
    
    // 5.右下角的按钮
    self.Right_Button.sd_layout.rightSpaceToView(self, 0).bottomEqualToView(self.GoodsImageView).widthIs(60).heightIs(30);
    
    // 4.商品的价格
    self.GoodsPriceLabel.sd_layout.leftSpaceToView(self.GoodsImageView, 10).bottomEqualToView(self.Right_Button).rightSpaceToView(self.Right_Button, 10).heightIs(20);
    
    // 5.按钮的背景视图
    self.Btn_View.sd_layout.leftEqualToView(self.GoodsNameLabel).topEqualToView(self.GoodsImageView).bottomEqualToView(self.GoodsImageView).rightSpaceToView(self, 0);
    
    // 5.1.左边的分享按钮
    self.Share_Button.sd_layout.leftSpaceToView(self.Btn_View, 20).topSpaceToView(self.Btn_View, 0).bottomSpaceToView(self.Btn_View, 0).widthEqualToHeight();
    [self.Share_Button setSd_cornerRadiusFromHeightRatio:@(0.5)];
    
    // 5.2.左边的分享按钮
    self.Cancel_Button.sd_layout.leftSpaceToView(self.Share_Button, 30).topEqualToView(self.Share_Button).bottomEqualToView(self.Share_Button).widthEqualToHeight();
    [self.Cancel_Button setSd_cornerRadiusFromHeightRatio:@(0.5)];
}

- (void)Right_ButtonClickAction:(UIButton *)sender{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(ClickOnTheButtonInTheLowerRightCorner:)]) {
        
        [self.delegate ClickOnTheButtonInTheLowerRightCorner:sender];
    }
}


@end
