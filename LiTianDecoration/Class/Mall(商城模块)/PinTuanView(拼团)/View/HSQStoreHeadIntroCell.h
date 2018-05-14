//
//  HSQStoreHeadIntroCell.h
//  LiTianDecoration
//
//  Created by administrator on 2018/5/10.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HSQStoreHeadIntroCellDelegate <NSObject>

/** 联系商家*/
- (void)ContactTheMerchantButtonClickAction:(UIButton *)sender;

/** 进入店铺*/
- (void)EnterTheStoreButtonClickAction:(UIButton *)sender;

@end

@interface HSQStoreHeadIntroCell : UITableViewCell

@property (nonatomic, strong) NSDictionary *DataDiction;

@property (nonatomic, weak) id<HSQStoreHeadIntroCellDelegate>delegate;

@end
