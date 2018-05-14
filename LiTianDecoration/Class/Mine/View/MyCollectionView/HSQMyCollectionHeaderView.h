//
//  HSQMyCollectionHeaderView.h
//  LiTianDecoration
//
//  Created by administrator on 2018/4/27.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HSQMyCollectionHeaderViewDelegate <NSObject>

- (void)ClickOnTheButtonInTheLowerRightCorner:(UIButton *)sender;

@end

@interface HSQMyCollectionHeaderView : UICollectionReusableView

@property (nonatomic, strong) UIButton *Like_Btn;

@property (nonatomic, weak) id<HSQMyCollectionHeaderViewDelegate>delegate;

@end
