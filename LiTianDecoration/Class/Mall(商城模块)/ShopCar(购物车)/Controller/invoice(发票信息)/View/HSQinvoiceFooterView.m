//
//  HSQinvoiceFooterView.m
//  LiTianDecoration
//
//  Created by administrator on 2018/6/5.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import "HSQinvoiceFooterView.h"

@interface HSQinvoiceFooterView ()


@end

@implementation HSQinvoiceFooterView

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    
    if (self = [super initWithCoder:aDecoder]) {
        
        
    }
    
    return self;
}

/**
 * @brief 不使用发票
 */
- (IBAction)NoUserFaPiaoBtnClickAction:(UIButton *)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(ClickEventsThatDoNotUseTheInvoiceButton:)]) {
        
        [self.delegate ClickEventsThatDoNotUseTheInvoiceButton:sender];
    }
}

/**
 * @brief 保存并使用发票
 */
- (IBAction)SaveFaPiaoAndUserBtnClickAction:(UIButton *)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(SaveAndUseTheClickEventOfTheInvoiceButton:)]) {
        
        [self.delegate SaveAndUseTheClickEventOfTheInvoiceButton:sender];
    }
}

/**
 * @brief 选择发票的内容
 */
- (IBAction)ChooseFPiaoContentBtnClickAction:(UIButton *)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(SelectTheContentOfTheInvoiceBtnClickAction:)]) {
        
        [self.delegate SelectTheContentOfTheInvoiceBtnClickAction:sender];
    }
}



@end
