//
//  HSQModelViewReusableView.h
//  LiTianDecoration
//
//  Created by administrator on 2018/5/7.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HSQMallHomeDataModel;

@protocol HSQModelViewReusableViewDelegate <NSObject>

- (void)HeadModelViewClickAction:(UIButton *)sender type:(NSString *)typeString;

@end

@interface HSQModelViewReusableView : UICollectionReusableView

@property (nonatomic, strong) HSQMallHomeDataModel *model;

@property (nonatomic, weak) id<HSQModelViewReusableViewDelegate>delegate;

@end
