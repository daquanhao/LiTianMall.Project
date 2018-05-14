//
//  HSQSelectDatePickerView.h
//  LiTianDecoration
//
//  Created by administrator on 2018/4/18.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    DatePickerViewDateTimeMode,//年月日,时分
    DatePickerViewDateMode,//年月日
    DatePickerViewTimeMode//时分
} DatePickerViewMode;

@protocol HSQSelectDatePickerViewDelegate <NSObject>

@optional
/**
 * 确定按钮
 */
-(void)didClickFinishHSQSelectDatePickerView:(NSString*)date;

/**
 * 取消按钮
 */
-(void)didClickCancelHSQSelectDatePickerView;

@end


@interface HSQSelectDatePickerView : UIView
/**
 * 设置当前时间
 */
@property(nonatomic, strong)NSDate*currentDate;
/**
 * 设置中心标题文字
 */
@property(nonatomic, strong)UILabel *titleL;

@property(nonatomic, strong)id<HSQSelectDatePickerViewDelegate>delegate;
/**
 * 模式
 */
@property (nonatomic, assign) DatePickerViewMode pickerViewMode;


/**
 * 掩藏
 */
- (void)hideHSQSelectDatePickerView;
/**
 * 显示
 */
- (void)showHSQSelectDatePickerView;


@end

