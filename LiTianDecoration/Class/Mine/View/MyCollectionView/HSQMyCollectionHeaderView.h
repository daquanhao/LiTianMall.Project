//
//  HSQMyCollectionHeaderView.h
//  LiTianDecoration
//
//  Created by administrator on 2018/4/27.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HSQGoodsDataListModel;

@protocol HSQMyCollectionHeaderViewDelegate <NSObject>

@optional

- (void)ClickOnTheButtonInTheLowerRightCorner:(UIButton *)sender;

/** 立即分享的按钮点击事件*/
- (void)ShareTheButtonImmediatelyByClickingTheEvent:(UIButton *)sender;

/** 加入购物车的按钮点击事件*/
- (void)AddTheCartButtonClickEvent:(UIButton *)sender;

/**编辑时选中按钮的点击事件*/
- (void)SelectTheClickEventOfTheButtonWhenEditing:(UIButton *)sender;

@end

@interface HSQMyCollectionHeaderView : UICollectionReusableView

@property (nonatomic, strong) UIButton *Like_Btn;

@property (nonatomic, weak) id<HSQMyCollectionHeaderViewDelegate>delegate;

@property (nonatomic, assign) NSInteger section;

@property (nonatomic, strong) HSQGoodsDataListModel *model;

@property (nonatomic, strong) UIImageView *Select_ImageView;

@end
