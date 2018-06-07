//
//  HSQinvoiceFooterView.h
//  LiTianDecoration
//
//  Created by administrator on 2018/6/5.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HSQinvoiceFooterViewDelegate <NSObject>

/** 不使用发票*/
- (void)ClickEventsThatDoNotUseTheInvoiceButton:(UIButton *)sender;

/** 保存并使用发票*/
- (void)SaveAndUseTheClickEventOfTheInvoiceButton:(UIButton *)sender;

/** 选择发票的内容*/
- (void)SelectTheContentOfTheInvoiceBtnClickAction:(UIButton *)sender;

@end

@interface HSQinvoiceFooterView : UITableViewHeaderFooterView

@property (weak, nonatomic) IBOutlet UITextField *ShiBieMa_TextField; // 识别码

@property (weak, nonatomic) IBOutlet UILabel *FaPiaoContent_Label; // 发票内容

@property (weak, nonatomic) IBOutlet UIButton *NoUserFaPiao_Button; // 不使用发票

@property (weak, nonatomic) IBOutlet UIButton *SavePiao_Button; // 保存发票

@property (weak, nonatomic) id<HSQinvoiceFooterViewDelegate>delegate;

@end
