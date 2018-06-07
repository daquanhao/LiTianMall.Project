//
//  HSQShopCartListDataCollectionViewCell.m
//  LiTianDecoration
//
//  Created by administrator on 2018/5/21.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import "HSQShopCartListDataCollectionViewCell.h"
#import "HSQShopCarGoodsGuiGeListView.h"
#import "HSQShopCarVCGoodsDataModel.h"
#import "HSQShopCarGoodsTypeListModel.h"

@interface HSQShopCartListDataCollectionViewCell ()<HSQShopCarGoodsGuiGeListViewDelegate>

@property (nonatomic, strong) UIButton *LeftRato_Button;

@property (nonatomic, strong) UIImageView *GoodsImageView; // 商品的图片

@property (nonatomic, strong) UILabel *GoodsNameLabel; // 商品的名字

@property (nonatomic, strong) HSQShopCarGoodsGuiGeListView *GoodsGuiGeListView; // 商品的规格

@end

@implementation HSQShopCartListDataCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        // 左边的小圆圈
        UIButton *LeftRato_Button = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [LeftRato_Button setImage:KImageName(@"878CADA4-7366-480C-856E-9DBA873C758C") forState:(UIControlStateNormal)];
        [LeftRato_Button setImage:KImageName(@"320A9B4D-0268-49C1-845B-7E3AABAB72BC") forState:(UIControlStateSelected)];
        [LeftRato_Button addTarget:self action:@selector(LeftRato_ButtonClickAction:) forControlEvents:(UIControlEventTouchUpInside)];
        [self.contentView addSubview:LeftRato_Button];
        self.LeftRato_Button = LeftRato_Button;

        // 商品的图片
        UIImageView *GoodsImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:GoodsImageView];
        self.GoodsImageView = GoodsImageView;
        
        // 商品的名字
        UILabel *GoodsNameLabel = [[UILabel alloc] init];
        GoodsNameLabel.textColor = RGB(71, 71, 71);
        GoodsNameLabel.numberOfLines = 0;
        GoodsNameLabel.font = [UIFont systemFontOfSize:14.0];
        [self.contentView addSubview:GoodsNameLabel];
        self.GoodsNameLabel = GoodsNameLabel;
        
        // 商品的规格
        HSQShopCarGoodsGuiGeListView *GoodsGuiGeListView = [[HSQShopCarGoodsGuiGeListView alloc] init];
        GoodsGuiGeListView.delegate = self;
        [self.contentView addSubview:GoodsGuiGeListView];
        self.GoodsGuiGeListView = GoodsGuiGeListView;
    }
    
    return self;
}

/**
 * @brief 接收数据模型
 */
- (void)setSecondModel:(HSQShopCarVCSecondGoodsDataModel *)SecondModel{
    
    _SecondModel = SecondModel;
    
    // 商品的图片
    [self.GoodsImageView sd_setImageWithURL:[NSURL URLWithString:SecondModel.imageSrc] placeholderImage:KGoodsPlacherImage];
    self.GoodsImageView.frame = CGRectMake(45, 10, KGoodsImageShopCaHeight, KGoodsImageShopCaHeight);
    
    // 左边的小圆圈
    self.LeftRato_Button.frame = CGRectMake(0, 0, 45, 80);
    
    // 商品的名字
    self.GoodsNameLabel.text = [NSString stringWithFormat:@"%@",SecondModel.goodsName];
    CGSize GoodsName_Size = [NSString SizeOfTheText:self.GoodsNameLabel.text font:[UIFont systemFontOfSize:14] MaxSize:CGSizeMake(KScreenWidth - CGRectGetMaxX(self.GoodsImageView.frame) - 20, MAXFLOAT)];
    self.GoodsNameLabel.frame = CGRectMake(CGRectGetMaxX(self.GoodsImageView.frame)+10, 10, KScreenWidth - CGRectGetMaxX(self.GoodsImageView.frame) - 20 , GoodsName_Size.height);
    
    // 商品的规格
    self.GoodsGuiGeListView.GuiGeData_Array = SecondModel.SecondCartItemVoList;
    CGSize photosSize = [HSQShopCarGoodsGuiGeListView SizeWithDataModelArray:SecondModel.SecondCartItemVoList];
    self.GoodsGuiGeListView.frame = CGRectMake(0, CGRectGetMaxY(self.GoodsImageView.frame)+10, photosSize.width, photosSize.height);
    
    // 判断按钮是否被选中
    if (SecondModel.IsSelect.integerValue == 0)
    {
        [self.LeftRato_Button setSelected:NO];
    }
    else
    {
        [self.LeftRato_Button setSelected:YES];
    }

}


/**
 * @brief 左边小圆圈的点击事件
 */
- (void)LeftRato_ButtonClickAction:(UIButton *)sender{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(LeftXiaoYuanQuanButtonClickAction:)]) {
        
        [self.delegate LeftXiaoYuanQuanButtonClickAction:sender];
    }
}

/**
 * @brief 加好按钮的点击事件
 */
- (void)AddButtonInhopCarGoodsGuiGeListViewClickAction:(UIButton *)sender{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(AddButtonInShopCartListDataCollectionViewCellClickAction:)]) {
        
        [self.delegate AddButtonInShopCartListDataCollectionViewCellClickAction:sender];
    }
}

/**
 * @brief 减号按钮的点击事件
 */
- (void)JianHaoButtonInhopCarGoodsGuiGeListViewClickAction:(UIButton *)sender{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(JianHaoButtonInShopCartListDataCollectionViewCellClickAction:)]) {
        
        [self.delegate JianHaoButtonInShopCartListDataCollectionViewCellClickAction:sender];
    }
}

/**
 * @brief 输入框的点击事件
 */
- (void)ShopCarGoodsCountTextFieldInhopCarGoodsGuiGeListViewClickAction:(UIButton *)sender{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(ShopCarGoodsCountTextFieldInShopCartListDataCollectionViewCellClickAction:)]) {
        
        [self.delegate ShopCarGoodsCountTextFieldInShopCartListDataCollectionViewCellClickAction:sender];
    }
}

/**
 * @brief 小圆点的点击事件
 */
- (void)LeftXiaoYuanDianButtonInhopCarGoodsGuiGeListViewClickAction:(UIButton *)sender{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(LeftXiaoYuanDianButtonInShopCartListDataCollectionViewCellClickAction:)]) {
        
        [self.delegate LeftXiaoYuanDianButtonInShopCartListDataCollectionViewCellClickAction:sender];
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

@end
