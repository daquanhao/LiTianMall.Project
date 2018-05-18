//
//  HSQStoreDetailHomeHeadReusableView.h
//  LiTianDecoration
//
//  Created by administrator on 2018/5/15.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HSQStoreDetailHomeHeadReusableViewDelegate <NSObject>

/** 顶部模块按钮的点击事件*/
- (void)TopModelViewButtonClickInStoreDetailHomeHeadReusableView:(UIButton *)sender;

/** 头部收藏按钮的点击事件*/
- (void)HeadViewCollectionButtonClickAction:(UIButton *)sender;

@end

@interface HSQStoreDetailHomeHeadReusableView : UICollectionReusableView

/**
 * @brief 接收上一个界面的数据
 */
@property (nonatomic, strong) NSDictionary *dataDiction;

/**
 * @brief 设置代理
 */
@property (nonatomic, weak) id<HSQStoreDetailHomeHeadReusableViewDelegate>delegate;

/**
 * @brief 收藏
 */
@property (weak, nonatomic) IBOutlet UILabel *Collectionstate_Label;

@end
