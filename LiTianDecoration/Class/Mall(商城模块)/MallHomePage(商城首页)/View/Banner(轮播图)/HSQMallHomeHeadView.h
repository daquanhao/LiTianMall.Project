//
//  HSQMallHomeHeadView.h
//  LiTianDecoration
//
//  Created by administrator on 2018/5/7.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HSQMallHomeDataModel;

@protocol HSQMallHomeHeadViewDelegate <NSObject>

@optional
/** 点击轮播图的方法*/
- (void)didClickCycleScrollView:(SDCycleScrollView *)CycleScrollView didSelectItemAtIndex:(NSInteger)index;

@end

@interface HSQMallHomeHeadView : UICollectionReusableView

@property (nonatomic, weak) id<HSQMallHomeHeadViewDelegate>delegate;

@property (nonatomic, strong) HSQMallHomeDataModel *model;

@end
