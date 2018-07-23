
//
//  HSQOrderListFooterView.m
//  LiTianDecoration
//
//  Created by administrator on 2018/5/26.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import "HSQOrderListFooterView.h"
#import "HSQOrderListFirstCengModel.h"

@interface HSQOrderListFooterView ()

@property (nonatomic, strong) UIButton *PayMonery_Btn;

@end


@implementation HSQOrderListFooterView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        
        // 支付按钮
        UIButton *PayMonery_Btn = [UIButton buttonWithType:(UIButtonTypeSystem)];
        [PayMonery_Btn setTitle:@"支付订单" forState:(UIControlStateNormal)];
        [PayMonery_Btn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        PayMonery_Btn.titleLabel.font = [UIFont systemFontOfSize:14.0];
        [PayMonery_Btn setBackgroundImage:KImageName(@"LoginButton_Image") forState:(UIControlStateNormal)];
        [PayMonery_Btn addTarget:self action:@selector(PayMonery_BtnClickAction:) forControlEvents:(UIControlEventTouchUpInside)];
        [self.contentView addSubview:PayMonery_Btn];
        self.PayMonery_Btn = PayMonery_Btn;
        
        // 设置约束
        self.PayMonery_Btn.sd_layout.leftSpaceToView(self.contentView, 10).topSpaceToView(self.contentView, 5).bottomSpaceToView(self.contentView, 5).rightSpaceToView(self.contentView, 10);
    }
    
    return self;
}

- (void)setModel:(HSQOrderListFirstCengModel *)model{
    
    _model = model;
    
    // 支付按钮
    if (model.ordersOnlineDiffAmount.integerValue > 0)
    {
        NSString *Total_Monery = [NSString stringWithFormat:@"%.2f",model.ordersOnlineDiffAmount.floatValue];
        [self.PayMonery_Btn setTitle:[NSString stringWithFormat:@"支付订单 ¥%@",Total_Monery] forState:(UIControlStateNormal)];
        
        [self.PayMonery_Btn setHidden:NO];
    }
    else
    {
         [self.PayMonery_Btn setTitle:@"支付订单" forState:(UIControlStateNormal)];
        
        [self.PayMonery_Btn setHidden:YES];
    }
}

- (void)PayMonery_BtnClickAction:(UIButton *)sender{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(hsqOrderListFooterViewBottomButtonClickAction:)]) {
        
        [self.delegate hsqOrderListFooterViewBottomButtonClickAction:sender];
    }
}







@end
