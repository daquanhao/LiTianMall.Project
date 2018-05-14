//
//  HSQDiscoverHeadView.h
//  LiTianDecoration
//
//  Created by administrator on 2018/4/10.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HSQDiscoverHeadViewDelegate <NSObject>

- (void)headerViewButtonClickAction:(UIButton *)sender;

@end

@interface HSQDiscoverHeadView : UIView

@property (nonatomic, strong) NSMutableArray <NSDictionary *> *dataSource;

@property (nonatomic, weak) id <HSQDiscoverHeadViewDelegate>delegate;

@end
