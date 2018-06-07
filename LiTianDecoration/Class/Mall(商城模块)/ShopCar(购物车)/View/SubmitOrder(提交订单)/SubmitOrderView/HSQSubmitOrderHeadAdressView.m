//
//  HSQSubmitOrderHeadAdressView.m
//  LiTianDecoration
//
//  Created by administrator on 2018/5/25.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import "HSQSubmitOrderHeadAdressView.h"
#import "HSQAcceptAddressListModel.h"

@interface HSQSubmitOrderHeadAdressView ()

@property (nonatomic, strong) UILabel *realNameLabel;  // 配送地址的名字

@property (nonatomic, strong) UIImageView *AdressImageView; // 地址的小图标

@property (nonatomic, strong) UILabel *IsDeafulLabel; // 是否是默认地址

@property (nonatomic, strong) UILabel *DetailAdress_Label; // 详细地址

@property (nonatomic, strong) UIImageView *SanJiaoImageView; // 三角的小图标

@property (nonatomic, strong) UILabel *Placher_Label; // 没有地址的时候的提示label

@property (nonatomic, strong) UIButton *SelectAdress_Btn; // 选择地址的按钮

@end

@implementation HSQSubmitOrderHeadAdressView

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        [self SetUpView];
        
        [self SetUpViewLayOut];
    }
    
    return self;
}

/**
 * @brief 创建控件
 */
- (void)SetUpView{
    
    // 地址的小图标
    UIImageView *SanJiaoImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"C7F2BC79-AC34-4AB0-AAFA-021F9AD47E36"]];
    [self addSubview:SanJiaoImageView];
    self.SanJiaoImageView = SanJiaoImageView;
    
    // 地址的名字
    UILabel *realNameLabel = [[UILabel alloc] init];
    realNameLabel.textColor = RGB(71, 71, 71);
    realNameLabel.font = [UIFont systemFontOfSize:14.0];
    [self addSubview:realNameLabel];
    self.realNameLabel = realNameLabel;
    
    // 地址的小图标
    UIImageView *AdressImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"123"]];
    [self addSubview:AdressImageView];
    self.AdressImageView = AdressImageView;
    
    // 是不是默认的地址
    UILabel *IsDeafulLabel = [[UILabel alloc] init];
    IsDeafulLabel.textColor = RGB(71, 71, 71);
    IsDeafulLabel.textAlignment = NSTextAlignmentCenter;
    IsDeafulLabel.backgroundColor = [UIColor redColor];
    IsDeafulLabel.textColor = [UIColor whiteColor];
    IsDeafulLabel.font = [UIFont systemFontOfSize:12.0];
    [self addSubview:IsDeafulLabel];
    self.IsDeafulLabel = IsDeafulLabel;
    
    // 详细地址
    UILabel *DetailAdress_Label = [[UILabel alloc] init];
    DetailAdress_Label.textColor = RGB(71, 71, 71);
    DetailAdress_Label.font = [UIFont systemFontOfSize:14.0];
    [self addSubview:DetailAdress_Label];
    self.DetailAdress_Label = DetailAdress_Label;
    
    // 没有地址的时候的提示label
    UILabel *Placher_Label = [[UILabel alloc] init];
    Placher_Label.textColor = RGB(71, 71, 71);
    Placher_Label.text = @"请先选择您的收货地址";
    Placher_Label.backgroundColor = [UIColor whiteColor];
    Placher_Label.font = [UIFont systemFontOfSize:14.0];
    [self addSubview:Placher_Label];
    self.Placher_Label = Placher_Label;
    
    // 选择地址的按钮
    UIButton *SelectAdress_Btn = [UIButton buttonWithType:(UIButtonTypeSystem)];
    [SelectAdress_Btn addTarget:self action:@selector(XuanzeShouHuoAdressBtn:) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:SelectAdress_Btn];
    self.SelectAdress_Btn = SelectAdress_Btn;
}

/**
 * @brief 添加约束
 */
- (void)SetUpViewLayOut{
    
    // 地址的小图标
    self.SanJiaoImageView.sd_layout.rightSpaceToView(self, 10).centerYEqualToView(self).widthIs(8).heightIs(11);
    
    // 地址的名字
    self.realNameLabel.sd_layout.leftSpaceToView(self, 10).rightSpaceToView(self.SanJiaoImageView, 10).topSpaceToView(self, 10).autoHeightRatio(0);
    
    // 地址的小图标
    self.AdressImageView.sd_layout.leftSpaceToView(self, 10).topSpaceToView(self.realNameLabel, 10).widthIs(10).heightIs(17);
    
    // 是不是默认的地址
    self.IsDeafulLabel.sd_layout.leftSpaceToView(self.AdressImageView, 5).centerYEqualToView(self.AdressImageView).autoWidthRatio(0).heightIs(20);
    [self.IsDeafulLabel setSingleLineAutoResizeWithMaxWidth:40];
    
    // 详细地址
    self.DetailAdress_Label.sd_layout.leftSpaceToView(self.IsDeafulLabel, 5).rightSpaceToView(self.SanJiaoImageView, 10).topEqualToView(self.AdressImageView).autoHeightRatio(0);
    
    // 没有地址的时候的提示label
    self.Placher_Label.sd_layout.leftSpaceToView(self, 10).topSpaceToView(self, 10).rightSpaceToView(self.SanJiaoImageView, 10).bottomSpaceToView(self, 0);
    
    // 选择地址的按钮
    self.SelectAdress_Btn.sd_layout.leftSpaceToView(self, 0).topSpaceToView(self, 0).rightSpaceToView(self, 0).bottomSpaceToView(self, 0);
}

- (void)setModel:(HSQAcceptAddressListModel *)model{
    
    _model = model;
    
    if (model.realName.length == 0) // 表明没有地址
    {
        [self.Placher_Label setHidden:NO];
        
        // 设置底部约束
        [self setupAutoHeightWithBottomView:self.Placher_Label bottomMargin:20];
    }
    else
    {
        [self.Placher_Label setHidden:YES];
        
        // 地址的名字
        self.realNameLabel.text = [NSString stringWithFormat:@"%@      %@",model.realName,model.mobPhone];
        
        // 是不是默认的地址 0不是 1是
        if (model.isDefault.integerValue == 0)
        {
            [self.IsDeafulLabel setHidden:YES];
        }
        else
        {
            [self.IsDeafulLabel setHidden:NO];
            self.IsDeafulLabel.text = @"  默认  ";
        }
        
        // 详细地址
        self.DetailAdress_Label.text = [NSString stringWithFormat:@"%@%@",model.areaInfo,model.address];
        
        // 设置底部约束
        [self setupAutoHeightWithBottomView:self.DetailAdress_Label bottomMargin:10];
    }
}

/**
 * @brief 选择地址的按钮
 */
- (void)XuanzeShouHuoAdressBtn:(UIButton *)sender{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(SelectTheCustomerShippingAddressButtonClickAction:)]) {
        
        [self.delegate SelectTheCustomerShippingAddressButtonClickAction:sender];
    }
}


@end
