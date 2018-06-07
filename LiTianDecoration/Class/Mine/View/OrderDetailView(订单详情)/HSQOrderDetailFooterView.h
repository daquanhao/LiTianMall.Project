//
//  HSQOrderDetailFooterView.h
//  LiTianDecoration
//
//  Created by administrator on 2018/6/1.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HSQOrderDetailFooterViewDelegate <NSObject>

/**
 * @brief 底部按钮的点击事件
 */
- (void)ClickEventOfTheBottomButton:(UIButton *)sender;

@end

@interface HSQOrderDetailFooterView : UITableViewHeaderFooterView

/**
 * @brief 接收上一个界面的数据
 */
@property (nonatomic, strong) NSDictionary *OrderDataDiction;

/**
 * @brief 设置代理
 */
@property (nonatomic, weak) id<HSQOrderDetailFooterViewDelegate>delegate;

@end
