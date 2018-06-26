//
//  HSQChooseproductlibraryHeadView.m
//  LiTianDecoration
//
//  Created by administrator on 2018/6/14.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import "HSQChooseproductlibraryHeadView.h"
#import "HSQSelectionListModel.h"

@interface HSQChooseproductlibraryHeadView ()

@property (nonatomic, strong) UIView *BgView;

@property (nonatomic, strong) UIImageView *SanJiao_ImageView;

@property (nonatomic, strong) UILabel *GoodsCount_Label;

@property (nonatomic, strong) UILabel *GoodsName_Label;

@property (nonatomic, strong) UIButton *Join_Button;

@end

@implementation HSQChooseproductlibraryHeadView

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        // 添加控件视图
        [self SetUpView];
        
        // 添加控件视图约束
        [self SetUpViewLayOut];
        
    }
    
    return self;
}

/**
 * @brief 添加控件视图
 */
- (void)SetUpView{
    
    // 白色背景图
    UIView *BgView = [[UIView alloc] init];
    BgView.backgroundColor = [UIColor whiteColor];
    [self addSubview:BgView];
    self.BgView = BgView;
    
    //三角的图片
    UIImageView *SanJiao_ImageView = [[UIImageView alloc] initWithImage:KImageName(@"C7F2BC79-AC34-4AB0-AAFA-021F9AD47E36")];
    [self.BgView addSubview:SanJiao_ImageView];
    self.SanJiao_ImageView = SanJiao_ImageView;
    
    // 商品的名字
    UILabel *GoodsName_Label = [[UILabel alloc] init];
    GoodsName_Label.textColor = RGB(74, 74, 74);
    GoodsName_Label.font = [UIFont systemFontOfSize:14.0];
    [self.BgView addSubview:GoodsName_Label];
    self.GoodsName_Label = GoodsName_Label;
    
    // 商品的数量
    UILabel *GoodsCount_Label = [[UILabel alloc] init];
    GoodsCount_Label.textColor = RGB(238, 58, 68);
    GoodsCount_Label.font = [UIFont systemFontOfSize:14.0];
    [self.BgView addSubview:GoodsCount_Label];
    self.GoodsCount_Label = GoodsCount_Label;
    
    // 进入详情按钮
    UIButton *Join_Button = [UIButton buttonWithType:(UIButtonTypeSystem)];
    [Join_Button addTarget:self action:@selector(Join_ButtonClickAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.BgView addSubview:Join_Button];
    self.Join_Button = Join_Button;
    
}

/**
 * @brief 添加控件视图约束
 */
- (void)SetUpViewLayOut{
    
    // 白色背景图
    self.BgView.sd_layout.leftSpaceToView(self, 0).topSpaceToView(self, 10).bottomSpaceToView(self, 1).rightSpaceToView(self, 0);
    
    //三角的图片
    self.SanJiao_ImageView.sd_layout.rightSpaceToView(self.BgView, 10).centerYEqualToView(self.BgView).widthIs(8).heightIs(13);
    
    // 商品的名字
    self.GoodsName_Label.sd_layout.leftSpaceToView(self.BgView, 10).topSpaceToView(self.BgView, 0).bottomSpaceToView(self.BgView, 0).autoWidthRatio(0);
    [self.GoodsName_Label setSingleLineAutoResizeWithMaxWidth:KScreenWidth - 100];
    
    // 商品的数量
    self.GoodsCount_Label.sd_layout.rightSpaceToView(self.SanJiao_ImageView, 5).topSpaceToView(self.BgView, 0).bottomSpaceToView(self.BgView, 0).autoWidthRatio(0);
    [self.GoodsCount_Label setSingleLineAutoResizeWithMaxWidth:KScreenWidth - 100];
    
    // 进入详情按钮
    self.Join_Button.sd_layout.leftSpaceToView(self.BgView, 0).topSpaceToView(self.BgView, 0).bottomSpaceToView(self.BgView, 0).rightSpaceToView(self.BgView, 0);
}

/**
 * @brief 数据模型
 */
- (void)setModel:(HSQSelectionListModel *)model{
    
    _model = model;

    // 商品的名字
    self.GoodsName_Label.text = model.distributorFavoritesName;
    
    // 商品的数量
    NSString *goodsCount = [NSString stringWithFormat:@"商品数量  %@",model.goodsCount];
    
    NSMutableAttributedString *attribe = [[NSMutableAttributedString alloc] initWithString:goodsCount];
    
    [attribe addAttribute:NSForegroundColorAttributeName value:RGB(150, 150, 150) range:NSMakeRange(0, 4)];
    
    self.GoodsCount_Label.attributedText = attribe;
}

/**
 * @brief 进入分组详情按钮的点击事件
 */
- (void)Join_ButtonClickAction:(UIButton *)sender{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(DetailsOfAccessToTheSelectiveLibrary:)]) {
        
        [self.delegate DetailsOfAccessToTheSelectiveLibrary:sender];
    }
}


@end
