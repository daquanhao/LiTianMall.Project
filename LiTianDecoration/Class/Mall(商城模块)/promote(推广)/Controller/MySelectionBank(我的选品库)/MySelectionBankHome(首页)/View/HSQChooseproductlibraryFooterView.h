//
//  HSQChooseproductlibraryFooterView.h
//  LiTianDecoration
//
//  Created by administrator on 2018/6/14.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HSQChooseproductlibraryFooterViewDelegate <NSObject>

/**
 * @brief 删除
 */
- (void)DeleteTheClickEventOfTheSelectedRepository:(UIButton *)sender;

/**
 * @brief 编辑
 */
- (void)EditTheClickEventsForTheRepository:(UIButton *)sender;

@end

@interface HSQChooseproductlibraryFooterView : UICollectionReusableView

/**
 * @brief 设置代理
 */
@property (nonatomic, weak) id<HSQChooseproductlibraryFooterViewDelegate>delegate;

/**
 * @brief 标记
 */
@property (nonatomic, assign) NSInteger section;

@end
