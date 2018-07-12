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

/**
 * @brief 选择商家的优惠活动
 */
- (void)ChooseABusinessDiscountButtonClickAction:(UIButton *)sender;

/**
 * @brief 选择店铺券
 */
- (void)ChooseShopCouponBtnClickAction:(UIButton *)sender;


@end

@interface HSQSubmitOrderFooterView : UITableViewHeaderFooterView

@property (nonatomic, weak) id<HSQSubmitOrderFooterViewDelegate>delegate;

@property (nonatomic, strong) NSDictionary *diction;

@property (nonatomic, assign) NSInteger Section;

@property (nonatomic, strong) HSQShopCarVCGoodsDataModel *ShopCarModel;

/**
 * @brief 带有提示文字的输入框
 */
@property (nonatomic, strong) HSQCustomTextView *textView;


/**
 * @brief 店铺券
 */
@property (weak, nonatomic) IBOutlet UIView *voucherVoList_BgView;

@property (weak, nonatomic) IBOutlet UILabel *voucher_Label;

/**
 * @brief 满优惠
 */
@property (weak, nonatomic) IBOutlet UIView *CouponsView;

@property (weak, nonatomic) IBOutlet UILabel *YouHuiContent_Label; // 优惠内容

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *TopMargin;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *freightAmountTopMargin;









@end
