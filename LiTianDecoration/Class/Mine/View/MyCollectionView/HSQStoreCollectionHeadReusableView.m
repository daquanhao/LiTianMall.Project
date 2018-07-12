//
//  HSQStoreCollectionHeadReusableView.m
//  LiTianDecoration
//
//  Created by administrator on 2018/6/8.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import "HSQStoreCollectionHeadReusableView.h"
#import "HSQStoreCollectionListDataModel.h"

@interface HSQStoreCollectionHeadReusableView ()

@property (nonatomic, strong) UIView *BgView;

@property (nonatomic, strong) UIImageView *StoreImageView;

@property (nonatomic, strong) UIButton *Select_Button;  // 选中的按钮

@property (nonatomic, strong) UILabel *storeName_Label; // 店铺的名字

@end

@implementation HSQStoreCollectionHeadReusableView

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
        
        // 1.店铺的图片
        UIImageView *StoreImageView = [[UIImageView alloc] init];
        [bgView addSubview:StoreImageView];
        self.StoreImageView = StoreImageView;
        
        // 2.店铺的名字
        UILabel *storeName_Label = [[UILabel alloc] init];
        storeName_Label.font = [UIFont systemFontOfSize:KLabelFont(14.0, 12.0)];
        storeName_Label.textColor = RGB(51, 51, 51);
        storeName_Label.numberOfLines = 0;
        [bgView addSubview:storeName_Label];
        self.storeName_Label = storeName_Label;
        
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
    
    // 背景图
    self.BgView.sd_layout.leftSpaceToView(self, 0).topSpaceToView(self, 1).bottomSpaceToView(self, 1).rightSpaceToView(self, 0);

    // 选中按钮
    self.Select_Button.sd_layout.leftSpaceToView(self.BgView, 0).topSpaceToView(self.BgView, 0).rightSpaceToView(self.BgView, 0).bottomSpaceToView(self.BgView, 0);

    // 1.商品的图片
    self.Select_ImageView.sd_layout.leftSpaceToView(self.BgView, 5).centerYEqualToView(self.BgView).heightIs(20).widthEqualToHeight();

    // 1.商品的图片
    self.StoreImageView.sd_layout.leftSpaceToView(self.BgView, 10).topSpaceToView(self.BgView, 10).bottomSpaceToView(self.BgView, 10).widthEqualToHeight();
    
    [self.StoreImageView setSd_cornerRadiusFromWidthRatio:@(0.5)];

    // 2.店铺的名字
    self.storeName_Label.sd_layout.leftSpaceToView(self.StoreImageView, 10).topSpaceToView(self.BgView, 1).bottomSpaceToView(self.BgView, 1).rightSpaceToView(self.BgView, 10);
}

/**
 * @brief 店铺的数据模型
 */
-(void)setStoreModel:(HSQStoreCollectionListDataModel *)StoreModel{
    
    _StoreModel = StoreModel;
    
    // 店铺的图片
    [self.StoreImageView sd_setImageWithURL:[NSURL URLWithString:StoreModel.store[@"storeAvatarUrl"]] placeholderImage:KGoodsPlacherImage];
    
    // 店铺的名字
    self.storeName_Label.text = [NSString stringWithFormat:@"%@",StoreModel.store[@"storeName"]];
    
    // 判断是否选中
    if (StoreModel.IsEditState.integerValue == 1) // 没有编辑
    {
        self.Select_ImageView.hidden = self.Select_Button.hidden = YES;
        
        // 1.店铺的图片
        self.StoreImageView.sd_resetLayout.leftSpaceToView(self.BgView, 10).topSpaceToView(self.BgView, 10).bottomSpaceToView(self.BgView, 10).widthEqualToHeight();
    }
    else
    {
        self.Select_ImageView.hidden = self.Select_Button.hidden = NO;
        
        // 1.店铺的图片 sd_resetLayout 重新设置约束
        self.StoreImageView.sd_resetLayout.leftSpaceToView(self.Select_ImageView, 10).topSpaceToView(self.BgView, 10).bottomSpaceToView(self.BgView, 10).widthEqualToHeight();
    }
    
    // 是否选中
    if (StoreModel.IsSelectState.integerValue == 1) // 没有选中
    {
        self.Select_ImageView.image = KImageName(@"878CADA4-7366-480C-856E-9DBA873C758C");
    }
    else
    {
        self.Select_ImageView.image = KImageName(@"320A9B4D-0268-49C1-845B-7E3AABAB72BC");
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
