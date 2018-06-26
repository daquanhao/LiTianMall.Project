//
//  HSQStoreSearchHeadReusableView.m
//  LiTianDecoration
//
//  Created by administrator on 2018/6/18.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import "HSQStoreSearchHeadReusableView.h"
#import "HSQStoreSearchListDataModel.h"

@interface HSQStoreSearchHeadReusableView ()

@property (nonatomic, strong) UIButton *JoinStore_Button;

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UIImageView *Store_ImageView;

@property (nonatomic, strong) UILabel *StoreName_Label;

@property (nonatomic, strong) UILabel *storeSales_Label;

@property (nonatomic, strong) UILabel *GoodsType_Label;

@end

@implementation HSQStoreSearchHeadReusableView

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        // 背景图
        UIView *bgView = [[UIView alloc] init];
        bgView.backgroundColor = [UIColor whiteColor];
        [self addSubview:bgView];
        self.bgView = bgView;

        // 店铺的图片
        UIImageView *Store_ImageView = [[UIImageView alloc] init];
        [bgView addSubview:Store_ImageView];
        self.Store_ImageView = Store_ImageView;
        
        // 店铺的名字
        UILabel *StoreName_Label = [[UILabel alloc] init];
        StoreName_Label.font = [UIFont systemFontOfSize:14.0];
        [bgView addSubview:StoreName_Label];
        self.StoreName_Label = StoreName_Label;
        
        // 店铺的销量
        UILabel *storeSales_Label = [[UILabel alloc] init];
        storeSales_Label.font = [UIFont systemFontOfSize:12.0];
        storeSales_Label.textColor = RGB(150, 150, 150);
        [bgView addSubview:storeSales_Label];
        self.storeSales_Label = storeSales_Label;
        
        // 主营商品
        UILabel *GoodsType_Label = [[UILabel alloc] init];
        GoodsType_Label.font = [UIFont systemFontOfSize:12.0];
        GoodsType_Label.textColor = RGB(150, 150, 150);
        [bgView addSubview:GoodsType_Label];
        self.GoodsType_Label = GoodsType_Label;
        
        // 进入店铺按钮
        UIButton *JoinStore_Button = [UIButton buttonWithType:(UIButtonTypeSystem)];
        [JoinStore_Button addTarget:self action:@selector(JoinStore_ButtonClickAction:) forControlEvents:(UIControlEventTouchUpInside)];
        [bgView addSubview:JoinStore_Button];
        self.JoinStore_Button = JoinStore_Button;
        
        // 添加约束
        self.bgView.sd_layout.leftSpaceToView(self, 0).topSpaceToView(self, 0).rightSpaceToView(self, 0).bottomSpaceToView(self, 0);
        
        self.Store_ImageView.sd_layout.leftSpaceToView(self.bgView, 10).topSpaceToView(self.bgView, 10).widthIs(60).heightEqualToWidth();
        
        self.StoreName_Label.sd_layout.leftSpaceToView(self.Store_ImageView, 10).topEqualToView(self.Store_ImageView).rightSpaceToView(self.bgView, 10).autoHeightRatio(0);
        
        self.storeSales_Label.sd_layout.leftEqualToView(self.StoreName_Label).topSpaceToView(self.StoreName_Label, 5).rightSpaceToView(self.bgView, 10).autoHeightRatio(0);
        
        self.GoodsType_Label.sd_layout.leftEqualToView(self.StoreName_Label).topSpaceToView(self.storeSales_Label, 5).rightSpaceToView(self.bgView, 10).autoHeightRatio(0);
        
        self.JoinStore_Button.sd_layout.leftSpaceToView(self.bgView, 0).topSpaceToView(self.bgView, 0).rightSpaceToView(self.bgView, 0).bottomSpaceToView(self.bgView, 0);
    }
    
    return self;
}

/**
 * @brief 数据模型
 */
- (void)setModel:(HSQStoreSearchListDataModel *)model{
    
    _model = model;
    
    // 店铺的图片
    [self.Store_ImageView sd_setImageWithURL:[NSURL URLWithString:model.storeAvatarUrl] placeholderImage:KGoodsPlacherImage];
    
    // 店铺的名字
    self.StoreName_Label.text = model.storeName;
    
    // 店铺的销量
    self.storeSales_Label.text = [NSString stringWithFormat:@"销量%@ 共%@件商品 共%@人收藏",model.storeSales,model.goodsCommonCount,model.storeCollect];
    
    // 主营商品
    self.GoodsType_Label.text = [NSString stringWithFormat:@"主营产品：%@",model.storeZy];
}

/**
 * @brief 进入店铺
 */
- (void)JoinStore_ButtonClickAction:(UIButton *)sender{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(JoinStoreDetailDataWithButton:)]) {
        
        [self.delegate JoinStoreDetailDataWithButton:sender];
    }
}


@end
