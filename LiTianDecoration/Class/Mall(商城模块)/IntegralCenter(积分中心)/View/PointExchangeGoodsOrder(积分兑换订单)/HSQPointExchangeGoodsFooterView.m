//
//  HSQPointExchangeGoodsFooterView.m
//  LiTianDecoration
//
//  Created by administrator on 2018/6/25.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import "HSQPointExchangeGoodsFooterView.h"
#import "HSQPointsOrdersListModel.h"

@interface HSQPointExchangeGoodsFooterView ()

@property (nonatomic ,strong) UIView *BgView;

@property (nonatomic, strong) UILabel *OrderTotalMonery_Label;

@property (nonatomic ,strong) UIView *Button_BgView;

@property (nonatomic, strong) UIButton *Cancel_Button;

@end

@implementation HSQPointExchangeGoodsFooterView


- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        
        self.contentView.backgroundColor = KViewBackGroupColor;
        
        // 背景图
        UIView *BgView = [[UIView alloc] init];
        BgView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:BgView];
        self.BgView = BgView;
        
        // 订单的总积分
        UILabel *OrderTotalMonery_Label = [[UILabel alloc] init];
        OrderTotalMonery_Label.textColor = [UIColor blackColor];
        OrderTotalMonery_Label.font = [UIFont systemFontOfSize:12.0];
        OrderTotalMonery_Label.textAlignment = NSTextAlignmentRight;
        OrderTotalMonery_Label.textColor = RGB(238, 58, 68);
        [BgView addSubview:OrderTotalMonery_Label];
        self.OrderTotalMonery_Label = OrderTotalMonery_Label;
        
        // 按钮背景图
        UIView *Button_BgView = [[UIView alloc] init];
        Button_BgView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:Button_BgView];
        self.Button_BgView = Button_BgView;
        
        // 进入店铺详情的按钮
        UIButton *Cancel_Button = [UIButton buttonWithType:(UIButtonTypeSystem)];
        [Cancel_Button setBackgroundImage:[UIImage ReturnAPictureOfStretching:@"7D99DFED-F3B6-4DB1-9F77-E24CA867DD17"] forState:(UIControlStateNormal)];
        Cancel_Button.titleLabel.font = [UIFont systemFontOfSize:12.0];
        [Cancel_Button setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
        [Cancel_Button addTarget:self action:@selector(Cancel_ButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
        [Button_BgView addSubview:Cancel_Button];
        self.Cancel_Button = Cancel_Button;
        
        // 添加约束
        self.BgView.sd_layout.leftSpaceToView(self.contentView, 0).topSpaceToView(self.contentView, 1).rightSpaceToView(self.contentView, 0).heightIs(40);
        
        self.OrderTotalMonery_Label.sd_layout.leftSpaceToView(self.BgView, 10).rightSpaceToView(self.BgView, 10).topSpaceToView(self.BgView, 0).bottomSpaceToView(self.BgView, 0);
        
        self.Button_BgView.sd_layout.leftSpaceToView(self.contentView, 0).topSpaceToView(self.BgView, 1).rightSpaceToView(self.contentView, 0).heightIs(40);
        
         self.Cancel_Button.sd_layout.rightSpaceToView(self.Button_BgView, 10).centerYEqualToView(self.Button_BgView).widthIs(80).heightIs(30);
        
        
    }
    
    return self;
}

- (void)setModel:(HSQPointsOrdersListModel *)model{
    
    _model = model;
    
    // 商品的总积分
    NSString *totalPoints = [NSString stringWithFormat:@"兑换总积分 %@",model.totalPoints];
    
    NSMutableAttributedString *attribe = [[NSMutableAttributedString alloc] initWithString:totalPoints];
    
    [attribe addAttribute:NSForegroundColorAttributeName value:RGB(71, 71, 71) range:NSMakeRange(0 , 5)];
    
    self.OrderTotalMonery_Label.attributedText = attribe;
    
    // 积分兑换订单状态 0-已取消 10-新订单 20-已发货 30-已收货
    if (model.pointsOrdersState.integerValue == 0 || model.pointsOrdersState.integerValue == 30)
    {
        self.Button_BgView.hidden = YES;
    }
    else if (model.pointsOrdersState.integerValue == 20)
    {
        [self.Cancel_Button setTitle:@"确认收货" forState:(UIControlStateNormal)];
        
        self.Button_BgView.hidden = NO;
    }
    else if (model.pointsOrdersState.integerValue == 10)
    {
        [self.Cancel_Button setTitle:@"取消订单" forState:(UIControlStateNormal)];
        
        self.Button_BgView.hidden = NO;
    }
    
}

/**
 * @brief 进入店铺详情
 */
- (void)Cancel_ButtonAction:(UIButton *)sender{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(CancelPointExchangeGoodsOrderButtonClickAction:)]) {
        
        [self.delegate CancelPointExchangeGoodsOrderButtonClickAction:sender];
    }
}




@end
