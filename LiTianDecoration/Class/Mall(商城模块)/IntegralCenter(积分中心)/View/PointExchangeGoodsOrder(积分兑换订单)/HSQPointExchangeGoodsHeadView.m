//
//  HSQPointExchangeGoodsHeadView.m
//  LiTianDecoration
//
//  Created by administrator on 2018/6/25.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import "HSQPointExchangeGoodsHeadView.h"
#import "HSQPointsOrdersListModel.h"

@interface HSQPointExchangeGoodsHeadView ()

@property (nonatomic ,strong) UIView *BgView;

@property (nonatomic, strong) UIImageView *Store_ImageView;

@property (nonatomic, strong) UILabel *StoreName_Label;

@property (nonatomic, strong) UIImageView *SanJiao_ImageView;

@property (nonatomic, strong) UILabel *OrderState_Label;

@property (nonatomic, strong) UIButton *JoinStore_Button;

@end

@implementation HSQPointExchangeGoodsHeadView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        
        self.contentView.backgroundColor = KViewBackGroupColor;
        
        // 背景图
        UIView *BgView = [[UIView alloc] init];
        BgView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:BgView];
        self.BgView = BgView;
        
        // 店铺的图标
        UIImageView *Store_ImageView = [[UIImageView alloc] initWithImage:KImageName(@"3-1P106112Q1-51")];
        [BgView addSubview:Store_ImageView];
        self.Store_ImageView = Store_ImageView;
        
        // 店铺的名字
        UILabel *StoreName_Label = [[UILabel alloc] init];
        StoreName_Label.textColor = [UIColor blackColor];
        StoreName_Label.font = [UIFont systemFontOfSize:12.0];
        [BgView addSubview:StoreName_Label];
        self.StoreName_Label = StoreName_Label;
        
        // 三角的图标
        UIImageView *SanJiao_ImageView = [[UIImageView alloc] initWithImage:KImageName(@"C7F2BC79-AC34-4AB0-AAFA-021F9AD47E36")];
        [BgView addSubview:SanJiao_ImageView];
        self.SanJiao_ImageView = SanJiao_ImageView;
        
        // 订单的状态
        UILabel *OrderState_Label = [[UILabel alloc] init];
        OrderState_Label.textColor = RGB(238, 58, 68);
        OrderState_Label.textAlignment = NSTextAlignmentRight;
        OrderState_Label.font = [UIFont systemFontOfSize:12.0];
        [BgView addSubview:OrderState_Label];
        self.OrderState_Label = OrderState_Label;
        
        // 进入店铺详情的按钮
        UIButton *JoinStore_Btn = [UIButton buttonWithType:(UIButtonTypeSystem)];
        [JoinStore_Btn addTarget:self action:@selector(JoinStore_ButtonClickAction:) forControlEvents:(UIControlEventTouchUpInside)];
        [BgView addSubview:JoinStore_Btn];
        self.JoinStore_Button = JoinStore_Btn;
        
        // 添加约束
        self.BgView.sd_layout.leftSpaceToView(self.contentView, 0).topSpaceToView(self.contentView, 10).rightSpaceToView(self.contentView, 0).bottomSpaceToView(self.contentView, 0);
        
        self.Store_ImageView.sd_layout.leftSpaceToView(self.BgView, 10).centerYEqualToView(self.BgView).widthIs(20).heightEqualToWidth();
        
        self.StoreName_Label.sd_layout.leftSpaceToView(self.Store_ImageView, 10).centerYEqualToView(self.BgView).autoWidthRatio(0).autoHeightRatio(0);
        [self.StoreName_Label setSingleLineAutoResizeWithMaxWidth:200];
        
        self.SanJiao_ImageView.sd_layout.leftSpaceToView(self.StoreName_Label, 10).centerYEqualToView(self.BgView).widthIs(8).heightIs(13);
        
        self.OrderState_Label.sd_layout.rightSpaceToView(self.BgView, 10).centerYEqualToView(self.BgView).leftSpaceToView(self.SanJiao_ImageView, 5).autoHeightRatio(0);
        
        self.JoinStore_Button.sd_layout.leftSpaceToView(self.BgView, 0).topSpaceToView(self.BgView, 0).rightSpaceToView(self.BgView, 0).bottomSpaceToView(self.BgView, 0);
        
    }
    
    return self;
}

- (void)setModel:(HSQPointsOrdersListModel *)model{
    
    _model = model;
    
    // 店铺的名字
    self.StoreName_Label.text = model.storeName;
    
    // 订单的状态
    self.OrderState_Label.text = model.pointsOrdersStateText;
    
}

/**
 * @brief 进入店铺详情
 */
- (void)JoinStore_ButtonClickAction:(UIButton *)sender{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(JoinGoodsInStoreHomePageWithBtnClickAction:)]) {
        
        [self.delegate JoinGoodsInStoreHomePageWithBtnClickAction:sender];
    }
}















@end
