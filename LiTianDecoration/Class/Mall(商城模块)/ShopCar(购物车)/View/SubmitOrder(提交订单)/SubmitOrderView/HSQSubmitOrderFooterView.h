//
//  HSQSubmitOrderFooterView.h
//  LiTianDecoration
//
//  Created by administrator on 2018/5/24.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HSQShopCarVCGoodsDataModel;

@protocol HSQSubmitOrderFooterViewDelegate <NSObject>

/** 选择商家的优惠活动*/
- (void)ChooseABusinessDiscountButtonClickAction:(UIButton *)sender;

/** 选择发票信息*/
- (void)SelectInvoiceInformationBtnClickAction:(UIButton *)sender;

@end

@interface HSQSubmitOrderFooterView : UITableViewHeaderFooterView

@property (nonatomic, weak) id<HSQSubmitOrderFooterViewDelegate>delegate;

@property (nonatomic, strong) NSDictionary *diction;

@property (nonatomic, strong) HSQCustomTextView *textView; // 带有提示文字的输入框

@property (nonatomic, copy) NSString *Section;

@property (weak, nonatomic) IBOutlet UILabel *YouHuiContent_Label; // 优惠内容

@property (weak, nonatomic) IBOutlet UILabel *FaPiaoInfo_Label; // 发票信息

@property (nonatomic, strong) HSQShopCarVCGoodsDataModel *ShopCarModel;

@end
