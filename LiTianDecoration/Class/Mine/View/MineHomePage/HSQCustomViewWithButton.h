//
//  HSQCustomViewWithButton.h
//  LiTianDecoration
//
//  Created by administrator on 2018/4/11.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HSQCustomViewWithButtonDelegate <NSObject>

@optional

- (void)CustomViewWithButtonClickAction:(UIButton *)sender;

@end

@interface HSQCustomViewWithButton : UIView

/**
 * @brief 数据源数据
 */
@property (nonatomic, strong) NSMutableArray <NSDictionary *> *dataSource;

@property (nonatomic, weak) id<HSQCustomViewWithButtonDelegate>delegate;

@end
