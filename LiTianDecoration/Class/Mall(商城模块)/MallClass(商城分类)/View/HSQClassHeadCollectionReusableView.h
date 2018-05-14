//
//  HSQClassHeadCollectionReusableView.h
//  LiTianDecoration
//
//  Created by administrator on 2018/4/12.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HSQClassHeadCollectionReusableViewDelegate <NSObject>

- (void)ClearSearchHistoryButtonClickAction:(UIButton *)sender;

@end

@interface HSQClassHeadCollectionReusableView : UICollectionReusableView

@property (nonatomic, strong) UIImageView *head_imageView;

@property (nonatomic, strong) UILabel *title_label;

@property (nonatomic, strong) UIView *BottomView;

@property (nonatomic, weak) id <HSQClassHeadCollectionReusableViewDelegate>delegate;

@end
