//
//  HSQSubmitOrderHeadAdressView.h
//  LiTianDecoration
//
//  Created by administrator on 2018/5/25.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HSQAcceptAddressListModel;

@protocol HSQSubmitOrderHeadAdressViewDelegate <NSObject>

/** 选择用户的收货地址*/
- (void)SelectTheCustomerShippingAddressButtonClickAction:(UIButton *)sender;

@end

@interface HSQSubmitOrderHeadAdressView : UIView

@property (nonatomic, strong) HSQAcceptAddressListModel *model;

@property (nonatomic, weak) id<HSQSubmitOrderHeadAdressViewDelegate>delegate;

@end
