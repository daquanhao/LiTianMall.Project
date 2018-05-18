//
//  HSQAllGoodsModelTitleCollectionReusableView.h
//  LiTianDecoration
//
//  Created by administrator on 2018/5/16.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HSQAllGoodsModelTitleCollectionReusableViewDelegate <NSObject>

/** 顶部按钮的点击事件*/
- (void)AllGoodsModelTitleCollectionReusableViewButtonClickAction:(UIButton *)sender;

@end

@interface HSQAllGoodsModelTitleCollectionReusableView : UICollectionReusableView

/**
 * @brief 设置代理
 */
@property (nonatomic, weak) id<HSQAllGoodsModelTitleCollectionReusableViewDelegate>delegate;

@end
