//
//  HSQPointsExchangeFooterReusableView.h
//  LiTianDecoration
//
//  Created by administrator on 2018/6/21.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HSQMembershipListModel;

@protocol HSQPointsExchangeFooterReusableViewDelegate <NSObject>

- (void)ClickEventOfTheMembershipRankButton:(UIButton *)sender model:(HSQMembershipListModel *)ListModel;

@end

@interface HSQPointsExchangeFooterReusableView : UICollectionReusableView

/**
 * @brief 会员等级数组
 */
@property (nonatomic, strong) NSMutableArray *memberGradeList;

/**
 * @brief 设置代理
 */
@property (nonatomic, weak) id<HSQPointsExchangeFooterReusableViewDelegate>delegate;

/**
 * @brief 提示文字
 */
@property (weak, nonatomic) IBOutlet UILabel *Placher_Label;

@end
