//
//  HSQAvailableToPayTypeView.m
//  LiTianDecoration
//
//  Created by administrator on 2018/6/6.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import "HSQAvailableToPayTypeView.h"


@interface HSQAvailableToPayTypeView ()

@property (weak, nonatomic) IBOutlet UIButton *PayLater_Button; // 稍后支付

@property (weak, nonatomic) IBOutlet UILabel *TotalMonery_Label; // 支付的总金额

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation HSQAvailableToPayTypeView

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    
    if (self = [super initWithCoder:aDecoder]) {

        
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
    }
    
    return self;
}

- (void)awakeFromNib{
    
    [super awakeFromNib];
    
    // 添加边框
    self.PayLater_Button.layer.borderWidth = 1;
    self.PayLater_Button.layer.borderColor = RGB(74, 74, 74).CGColor;
    
    // 设置边角
    self.PayLater_Button.layer.cornerRadius = 5;
    self.PayLater_Button.clipsToBounds = YES;
    
   
    
}

/**
 * @brief 商品的总金额
 */
- (void)setTotal_monery:(NSString *)total_monery{
    
    _total_monery = total_monery;
    
    NSString *title = [NSString stringWithFormat:@"本次交易需在线支付%@元",total_monery];
    
    NSMutableAttributedString *attribe = [[NSMutableAttributedString alloc] initWithString:title];
    
    [attribe addAttribute:NSForegroundColorAttributeName value:RGB(238, 58, 68) range:NSMakeRange(9, total_monery.length)];
    
    self.TotalMonery_Label.attributedText = attribe;
}

/**
 * @brief 稍后支付的点击事件
 */
- (IBAction)ShaoHouPayMoneryBtnClickAction:(UIButton *)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(TheClickEventOfThePayButtonLater:)]) {
        
        [self.delegate TheClickEventOfThePayButtonLater:sender];
    }
}

/**
 * @brief 确认支付的点击事件
 */
- (IBAction)QueRenPayMoneryButtonClickAction:(UIButton *)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(ConfirmTheClickEventOfThePaymentButton:)]) {
        
        [self.delegate ConfirmTheClickEventOfThePaymentButton:sender];
    }
}








@end
