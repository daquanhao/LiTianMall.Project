//
//  HSQHeaderCollectionReusableView.h
//  LiTianDecoration
//
//  Created by administrator on 2018/4/10.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HSQHeaderCollectionReusableViewDelegate <NSObject>

- (void)LoginActionClickWithMineHomeHead:(UIButton *)sender;

- (void)ToPrepareLoginAction:(UIButton *)sender;

- (void)UnderLogineCustomeButtonClickAction:(UIButton *)sender;

@end

@interface HSQHeaderCollectionReusableView : UICollectionReusableView

@property (nonatomic, weak) id<HSQHeaderCollectionReusableViewDelegate>delegate;

@property (nonatomic, strong) NSMutableDictionary *UserInfoDiction;

@end
