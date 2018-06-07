//
//  HSQTuiMoneryListFooterView.h
//  LiTianDecoration
//
//  Created by administrator on 2018/6/4.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HSQTuiMoneryListFooterViewDelegate <NSObject>

- (void)RefundDetailsButtonClickEvent:(UIButton *)sender;

@end

@interface HSQTuiMoneryListFooterView : UITableViewHeaderFooterView

@property (weak, nonatomic) IBOutlet UILabel *CreatTime_Label;

@property (weak, nonatomic) IBOutlet UILabel *OrderMonery_Label;

@property (weak, nonatomic) IBOutlet UIButton *TuiKuanDetail_Btn;

@property (weak, nonatomic) IBOutlet UIView *CountBgView;

@property (weak, nonatomic) IBOutlet UILabel *TuiHuoCount_Label;

@property (weak, nonatomic) id <HSQTuiMoneryListFooterViewDelegate>delegate;

@property (assign, nonatomic) NSInteger section;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *TopMargin;
@end
