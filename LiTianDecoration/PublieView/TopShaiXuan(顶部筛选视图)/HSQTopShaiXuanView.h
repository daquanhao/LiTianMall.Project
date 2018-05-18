//
//  HSQTopShaiXuanView.h
//  LiTianDecoration
//
//  Created by administrator on 2018/5/17.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HSQTopShaiXuanViewDelegate <NSObject>

/** 顶部筛选的按钮的点击*/
- (void)ClickTheButtonOnTheTopScreen:(UIButton *)sender;

@end

@interface HSQTopShaiXuanView : UIView

@property (nonatomic, weak) id<HSQTopShaiXuanViewDelegate>delegate;

@end
