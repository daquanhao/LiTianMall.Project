//
//  HSQPinTuanGoodsDetailHomeCell.h
//  LiTianDecoration
//
//  Created by administrator on 2018/5/10.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HSQPinTuanGoodsDetailHomeCellDelegate <NSObject>

/** 显示领券列表*/
- (void)ShowTheCouponListClickAction:(UIButton *)sender;

/** 促销，显示满减优惠列表*/
- (void)ShowAListOfDiscountsClickAction:(UIButton *)sender;

/** 显示商品的规格列表*/
- (void)DisplaysAListOfSpecificationsForAProduct:(UIButton *)sender;

/** 选择配送的地址*/
- (void)ChooseSendAdressClickAction:(UIButton *)sender;


@end

@interface HSQPinTuanGoodsDetailHomeCell : UITableViewCell

@property (nonatomic, strong) NSDictionary *DataDiction;

@property (nonatomic, weak) id<HSQPinTuanGoodsDetailHomeCellDelegate>delegate;

@end
