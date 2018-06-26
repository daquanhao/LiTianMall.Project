//
//  HSQPointsExchangeHeadReusableView.h
//  LiTianDecoration
//
//  Created by administrator on 2018/6/21.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HSQPointsExchangeHeadReusableViewDelegate <NSObject>

- (void)HeaderLoginButtonClickEvent:(UIButton *)sender;

@end

@interface HSQPointsExchangeHeadReusableView : UICollectionReusableView

/**
 * @brief 用户的信息
 */
@property (nonatomic, strong) NSDictionary *UserInfoDiction;

/**
 * @brief 设置代理
 */
@property (nonatomic, weak) id<HSQPointsExchangeHeadReusableViewDelegate>delegate;

/**
 * @brief 昵称的背景视图
 */
@property (weak, nonatomic) IBOutlet UIView *NickName_BgView; 

@end
