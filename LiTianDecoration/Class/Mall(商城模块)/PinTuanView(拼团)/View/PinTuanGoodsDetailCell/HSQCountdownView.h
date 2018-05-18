//
//  HSQCountdownView.h
//  LiTianDecoration
//
//  Created by administrator on 2018/5/14.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HSQCountdownView : UIView

- (HSQCountdownView *)initCountdownViewWithXIB;

/** 接收上面的数据*/
@property (nonatomic, strong) NSDictionary *dataDiction;

@property (weak, nonatomic) IBOutlet UILabel *dayLabel;

@property (weak, nonatomic) IBOutlet UILabel *hourLabel;

@property (weak, nonatomic) IBOutlet UILabel *minuteLabel;

@property (weak, nonatomic) IBOutlet UILabel *secondLabel;

@end
