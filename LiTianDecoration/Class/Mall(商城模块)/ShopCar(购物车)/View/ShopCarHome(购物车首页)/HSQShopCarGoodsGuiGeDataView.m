//
//  HSQShopCarGoodsGuiGeDataView.m
//  LiTianDecoration
//
//  Created by administrator on 2018/5/21.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import "HSQShopCarGoodsGuiGeDataView.h"
#import "HSQShopCarGoodsTypeListModel.h"

@interface HSQShopCarGoodsGuiGeDataView ()

@property (nonatomic, strong) UIButton *LeftRato_Button;

@property (nonatomic, strong) UIView *BgView;  // 灰色背景图

@property (nonatomic, strong) UIButton *Add_Button;

@property (nonatomic, strong) UITextField *GoodsCount_TextField;

@property (nonatomic, strong) UIButton *Jian_Button;

@property (nonatomic, strong) UILabel *GoodsSulLabel; // 商品的规格

@property (nonatomic, strong) UILabel *GoodsPrice_Label; // 商品的价格

@property (nonatomic, strong) UILabel *EditStateCount_Label; // 商品的编辑状态下的数量

@end

@implementation HSQShopCarGoodsGuiGeDataView

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        // 左边的小圆圈
        UIButton *LeftRato_Button = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [LeftRato_Button setImage:KImageName(@"878CADA4-7366-480C-856E-9DBA873C758C") forState:(UIControlStateNormal)];
        [LeftRato_Button setImage:KImageName(@"320A9B4D-0268-49C1-845B-7E3AABAB72BC") forState:(UIControlStateSelected)];
        [LeftRato_Button addTarget:self action:@selector(LeftRato_ButtonClickAction:) forControlEvents:(UIControlEventTouchUpInside)];
        [self addSubview:LeftRato_Button];
        self.LeftRato_Button = LeftRato_Button;
        
        // 灰色背景图
        UIView *bgView = [[UIView alloc] init];
        bgView.backgroundColor = KViewBackGroupColor;
        [self addSubview:bgView];
        self.BgView = bgView;

        // 加号按钮
        UIButton *Add_Button = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [Add_Button setImage:KImageName(@"893B5C4F-ACBD-45A3-9607-948EC2B60365") forState:(UIControlStateNormal)];
        [Add_Button addTarget:self action:@selector(Add_ButtonClickAction:) forControlEvents:(UIControlEventTouchUpInside)];
        [bgView addSubview:Add_Button];
        self.Add_Button = Add_Button;

        // 商品的数量
        UITextField *GoodsCount_TextField = [[UITextField alloc] init];
        GoodsCount_TextField.textColor = RGB(71, 71, 71);
        GoodsCount_TextField.font = [UIFont systemFontOfSize:12.0];
        GoodsCount_TextField.textAlignment = NSTextAlignmentCenter;
        [bgView addSubview:GoodsCount_TextField];
        self.GoodsCount_TextField = GoodsCount_TextField;

        // 减号按钮
        UIButton *Jian_Button = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [Jian_Button setImage:KImageName(@"33CCDACD-1102-4FA4-90EC-88E512B5A274") forState:(UIControlStateNormal)];
        [Jian_Button addTarget:self action:@selector(JianHao_ButtonClickAction:) forControlEvents:(UIControlEventTouchUpInside)];
        [bgView addSubview:Jian_Button];
        self.Jian_Button = Jian_Button;

        // 商品的规格
        UILabel *GoodsSulLabel = [[UILabel alloc] init];
        GoodsSulLabel.textColor = RGB(150, 150, 150);
        GoodsSulLabel.numberOfLines = 0;
        GoodsSulLabel.font = [UIFont systemFontOfSize:12.0];
        [bgView addSubview:GoodsSulLabel];
        self.GoodsSulLabel = GoodsSulLabel;

        // 商品的价格
        UILabel *GoodsPrice_Label = [[UILabel alloc] init];
        GoodsPrice_Label.textColor = RGB(150, 150, 150);
        GoodsPrice_Label.numberOfLines = 0;
        GoodsPrice_Label.font = [UIFont systemFontOfSize:12.0];
        [bgView addSubview:GoodsPrice_Label];
        self.GoodsPrice_Label = GoodsPrice_Label;
        
        // 商品的在编辑状态的数量
        UILabel *EditStateCount_Label = [[UILabel alloc] init];
        EditStateCount_Label.textColor = RGB(71, 71, 71);
        EditStateCount_Label.numberOfLines = 0;
        EditStateCount_Label.font = [UIFont systemFontOfSize:14.0];
        EditStateCount_Label.textAlignment = NSTextAlignmentCenter;
        [bgView addSubview:EditStateCount_Label];
        self.EditStateCount_Label = EditStateCount_Label;
        
        // 添加控件的约束
        [self SetValueViewLayout];
    }
    
    return self;
}


/**
 * @brief 添加控件的约束
 */
- (void)SetValueViewLayout{
    
    // 左边的小圆圈
    self.LeftRato_Button.sd_layout.leftSpaceToView(self, 0).topSpaceToView(self, 0).bottomSpaceToView(self, 0).widthIs(45);
    
    // 背景图
    self.BgView.sd_layout.leftSpaceToView(self.LeftRato_Button, 10).topSpaceToView(self, 0).rightSpaceToView(self, 10).bottomSpaceToView(self, 0);

    // 加号按钮
    self.Add_Button.sd_layout.rightSpaceToView(self.BgView, 0).topSpaceToView(self.BgView, 10).widthIs(25).heightEqualToWidth();

    // 商品的数量
    self.GoodsCount_TextField.sd_layout.rightSpaceToView(self.Add_Button, 0).topEqualToView(self.Add_Button).bottomEqualToView(self.Add_Button).widthIs(40);

    // 减号按钮
    self.Jian_Button.sd_layout.rightSpaceToView(self.GoodsCount_TextField, 0).topEqualToView(self.Add_Button).bottomEqualToView(self.Add_Button).widthEqualToHeight();

    // 商品的规格
    self.GoodsSulLabel.sd_layout.leftSpaceToView(self.BgView, 5).topSpaceToView(self.BgView, 5).rightSpaceToView(self.Jian_Button, 5).autoHeightRatio(0);

    // 商品的价格
    self.GoodsPrice_Label.sd_layout.leftEqualToView(self.GoodsSulLabel).bottomSpaceToView(self.BgView, 0).rightEqualToView(self.GoodsSulLabel).heightIs(20);
    
    // 商品的在编辑状态的数量
    self.EditStateCount_Label.sd_layout.leftEqualToView(self.Jian_Button).topEqualToView(self.Jian_Button).rightEqualToView(self.Add_Button).heightIs(20);

}

/**
 * @brief 数据
 */
- (void)setModel:(HSQShopCarGoodsTypeListModel *)model{
    
    _model = model;
    
     // 商品的规格
    self.GoodsSulLabel.text = [NSString stringWithFormat:@"%@",model.goodsFullSpecs];

    // 商品的数量
    self.GoodsCount_TextField.text = [NSString stringWithFormat:@"%@",model.buyNum];

    // 商品的价格
    self.GoodsPrice_Label.text = [NSString stringWithFormat:@"¥%.2f/%@",model.appPrice0.floatValue,model.unitName];
    
    // 判断按钮的选中状态
    if (model.IsSelect.integerValue == 0)
    {
        [self.LeftRato_Button setSelected:NO];
    }
    else
    {
        [self.LeftRato_Button setSelected:YES];
    }
    
    // 商品的在编辑状态的数量
    self.EditStateCount_Label.text =  [NSString stringWithFormat:@"%@%@",model.buyNum,model.unitName];;
    
    // 判断购物车是否处于编辑状态
    if (model.EditState.integerValue == 1)
    {
        self.EditStateCount_Label.hidden = YES;
        
        self.Jian_Button.hidden = self.GoodsCount_TextField.hidden = self.Add_Button.hidden = NO;
    }
    else
    {
        self.EditStateCount_Label.hidden = NO;
        
        self.Jian_Button.hidden = self.GoodsCount_TextField.hidden = self.Add_Button.hidden = YES;
    }
}

/**
 * @brief 小圆点的点击事件
 */
- (void)LeftRato_ButtonClickAction:(UIButton *)sender{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(LeftXiaoYuanDianButtonInShopCarGoodsListCellClickAction:)]) {
        
        [self.delegate LeftXiaoYuanDianButtonInShopCarGoodsListCellClickAction:sender];
    }
}

/**
 * @brief 加号按钮的点击事件
 */
- (void)Add_ButtonClickAction:(UIButton *)sender{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(AddButtonInShopCarGoodsListCellClickAction:)]) {
        
        [self.delegate AddButtonInShopCarGoodsListCellClickAction:sender];
    }
}

/**
 * @brief 减号按钮的点击事件
 */
- (void)JianHao_ButtonClickAction:(UIButton *)sender{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(JianHaoButtonInShopCarGoodsListCellClickAction:)]) {
        
        [self.delegate JianHaoButtonInShopCarGoodsListCellClickAction:sender];
    }
}








@end
