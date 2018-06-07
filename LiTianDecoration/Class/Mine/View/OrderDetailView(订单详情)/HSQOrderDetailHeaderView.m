//
//  HSQOrderDetailHeaderView.m
//  LiTianDecoration
//
//  Created by administrator on 2018/6/1.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import "HSQOrderDetailHeaderView.h"

@interface HSQOrderDetailHeaderView ()

@property (nonatomic, strong) UIImageView *LeftImageView; // 头部的小图标

@property (nonatomic, strong) UILabel *TradingState_Label; // 交易状态

@property (nonatomic, strong) UILabel *OrderState_Label; // 订单状态

@property (nonatomic, strong) UIView *OrderStateBgView;  // 状态的背景图

@property (nonatomic, strong) UIImageView *AdressImageView; // 地址的小图标

@property (nonatomic, strong) UILabel *UserName_Label; // 地址中用户的名字

@property (nonatomic, strong) UILabel *AdressName_Label; // 地址

@property (nonatomic, strong) UIView *AdressBgView;  // 地址的背景图

@property (nonatomic, strong) UIImageView *StoreImageView; // 店铺的小图标

@property (nonatomic, strong) UILabel *StoreName_Label; // 店铺的名字

@property (nonatomic, strong) UIImageView *SanJiao_Image; // 三角图片

@property (nonatomic, strong) UIView *StoreBgView;  // 地址的背景图


@end

@implementation HSQOrderDetailHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        
        // 设置控件
        [self SetUpView];
    }
    
    return self;
}

/**
 * @brief 设置控件
 */
- (void)SetUpView{
    
    // 1.状态的背景图
    UIView *OrderStateBgView = [[UIView alloc] init];
    OrderStateBgView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:OrderStateBgView];
    self.OrderStateBgView = OrderStateBgView;
    
    // 小图标
    UIImageView *LeftImageView = [[UIImageView alloc] initWithImage:KImageName(@"123")];
    [OrderStateBgView addSubview:LeftImageView];
    self.LeftImageView = LeftImageView;
    
    //交易状态
    UILabel *TradingState_Label = [[UILabel alloc] init];
    TradingState_Label.textColor = RGB(74, 74, 74);
    TradingState_Label.text = @"交易状态";
    TradingState_Label.font = [UIFont systemFontOfSize:14.0];
    [OrderStateBgView addSubview:TradingState_Label];
    self.TradingState_Label = TradingState_Label;
    
    //订单状态
    UILabel *OrderState_Label = [[UILabel alloc] init];
    OrderState_Label.textColor = RGB(238, 68, 58);
    OrderState_Label.font = [UIFont systemFontOfSize:14.0];
    OrderState_Label.textAlignment = NSTextAlignmentRight;
    [OrderStateBgView addSubview:OrderState_Label];
    self.OrderState_Label = OrderState_Label;
    
    // .地址的背景图
    UIView *AdressBgView = [[UIView alloc] init];
    AdressBgView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:AdressBgView];
    self.AdressBgView = AdressBgView;
    
    // 地址小图标
    UIImageView *AdressImageView = [[UIImageView alloc] initWithImage:KImageName(@"DingWeiIcon")];
    [AdressBgView addSubview:AdressImageView];
    self.AdressImageView = AdressImageView;
    
    //地址中用户的名字
    UILabel *UserName_Label = [[UILabel alloc] init];
    UserName_Label.textColor = RGB(74, 74, 74);
    UserName_Label.font = [UIFont systemFontOfSize:14.0];
    [AdressBgView addSubview:UserName_Label];
    self.UserName_Label = UserName_Label;
    
    //地址
    UILabel *AdressName_Label = [[UILabel alloc] init];
    AdressName_Label.textColor = RGB(74, 74, 74);
    AdressName_Label.font = [UIFont systemFontOfSize:12.0];
    AdressName_Label.numberOfLines = 0;
    [AdressBgView addSubview:AdressName_Label];
    self.AdressName_Label = AdressName_Label;
    
    // .店铺的背景图
    UIView *StoreBgView = [[UIView alloc] init];
    StoreBgView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:StoreBgView];
    self.StoreBgView = StoreBgView;
    
    // 店铺小图标
    UIImageView *StoreImageView = [[UIImageView alloc] initWithImage:KImageName(@"123")];
    [StoreBgView addSubview:StoreImageView];
    self.StoreImageView = StoreImageView;
    
    //店铺的名字
    UILabel *StoreName_Label = [[UILabel alloc] init];
    StoreName_Label.textColor = RGB(74, 74, 74);
    StoreName_Label.font = [UIFont systemFontOfSize:12.0];
    StoreName_Label.numberOfLines = 0;
    [StoreBgView addSubview:StoreName_Label];
    self.StoreName_Label = StoreName_Label;
    
    // 店铺三角图标
    UIImageView *SanJiao_Image = [[UIImageView alloc] initWithImage:KImageName(@"C7F2BC79-AC34-4AB0-AAFA-021F9AD47E36")];
    [StoreBgView addSubview:SanJiao_Image];
    self.SanJiao_Image = SanJiao_Image;
    
}

/**
 * @brief 设置控件的数据
 */
- (void)setOrderDataDiction:(NSDictionary *)OrderDataDiction{
    
    _OrderDataDiction = OrderDataDiction;
    
    // 1.状态的背景图
    self.OrderStateBgView.frame = CGRectMake(0, 0, KScreenWidth, 40);
    
    // 小图标
    self.LeftImageView.frame = CGRectMake(10, 10, 20, 20);
    
    //交易状态
    self.TradingState_Label.frame = CGRectMake(CGRectGetMaxX(self.LeftImageView.frame)+10, 0, 70, 40);
    
    // 1.地址的背景图
    NSString *adress = [NSString stringWithFormat:@"%@%@",OrderDataDiction[@"ordersVo"][@"receiverAreaInfo"],OrderDataDiction[@"ordersVo"][@"receiverAddress"]];
    CGSize AdressSize = [NSString SizeOfTheText:adress font:[UIFont systemFontOfSize:12.0] MaxSize:CGSizeMake(KScreenWidth - 43, MAXFLOAT)];
    self.AdressBgView.frame = CGRectMake(0, CGRectGetMaxY(self.OrderStateBgView.frame)+10, KScreenWidth, AdressSize.height + 50);
    
    // 小图标
    self.AdressImageView.frame = CGRectMake(10, 10, 13, 16);
    
    // 1.订单的状态
    self.OrderState_Label.text = [NSString stringWithFormat:@"%@",OrderDataDiction[@"ordersVo"][@"ordersStateName"]];
    self.OrderState_Label.frame = CGRectMake(CGRectGetMaxX(self.TradingState_Label.frame)+10, 0, KScreenWidth - CGRectGetMaxX(self.TradingState_Label.frame) - 20, self.OrderStateBgView.mj_h);
    
    // 2.地址的用户名
    self.UserName_Label.text = [NSString stringWithFormat:@"%@      %@",OrderDataDiction[@"ordersVo"][@"receiverName"],OrderDataDiction[@"ordersVo"][@"receiverPhone"]];
    self.UserName_Label.frame = CGRectMake(CGRectGetMaxX(self.AdressImageView.frame)+10, 10, KScreenWidth -CGRectGetMaxX(self.AdressImageView.frame) -20 , 20);

    // 3.地址
    self.AdressName_Label.text = [NSString stringWithFormat:@"%@%@",OrderDataDiction[@"ordersVo"][@"receiverAreaInfo"],OrderDataDiction[@"ordersVo"][@"receiverAddress"]];
    self.AdressName_Label.frame = CGRectMake(self.UserName_Label.mj_x, CGRectGetMaxY(self.UserName_Label.frame)+10, KScreenWidth - self.UserName_Label.mj_x -10, AdressSize.height);
    
    // 4.店铺的背景图
    self.StoreBgView.frame = CGRectMake(0, CGRectGetMaxY(self.AdressBgView.frame) + 10, KScreenWidth, 40);
    
    // 4.1.店铺的小图标
    self.StoreImageView.frame = CGRectMake(10, 10, 20, 20);
    
    // 4.2.店铺的名字
    NSString *StoreName = [NSString stringWithFormat:@"%@",OrderDataDiction[@"ordersVo"][@"storeName"]];
    CGSize StoreName_Size = [NSString SizeOfTheText:StoreName font:[UIFont systemFontOfSize:12.0] MaxSize:CGSizeMake(KScreenWidth - 43, MAXFLOAT)];
    self.StoreName_Label.frame = CGRectMake(40, 0, StoreName_Size.width, 40);
    self.StoreName_Label.text = StoreName;
    
    // 4.3.店铺的三角图片
    self.SanJiao_Image.frame = CGRectMake(CGRectGetMaxX(self.StoreName_Label.frame)+10, 15, 8, 11);
}




















@end
