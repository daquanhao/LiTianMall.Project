//
//  HSQGuiGeAndCouperView.h
//  LiTianDecoration
//
//  Created by administrator on 2018/5/10.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HSQGuiGeAndCouperViewDelegate <NSObject>

- (void)ChooseGuiGeAndCoupter:(NSIndexPath *)indexPath;

@end

@interface HSQGuiGeAndCouperView : UIView

/** 初始化视图 */
+ (instancetype)initGuiGeAndCouperView;

/** 区分视图的类型 100代表 优惠券 200代表 规格*/
@property (nonatomic, copy) NSString *TypeString;

/** 头部的标题*/
@property (nonatomic, copy) NSString *placherString;

/** 显示视图 */
- (void)ShowGuiGeAndCouperView;

@property (nonatomic, weak) id<HSQGuiGeAndCouperViewDelegate>delegate;

@end
