//
//  HSQGraphicDetailsView.h
//  LiTianDecoration
//
//  Created by administrator on 2018/7/9.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HSQGraphicDetailsViewDelegate <NSObject>

/**
 * @brief 下拉的操作
 */
- (void)TheDropDownShowsTheProductDetails;

/**
 * @brief 进入电脑版的图文详情
 */
- (void)JoinComputerGoodsDetail:(UIButton *)sender;

@end

@interface HSQGraphicDetailsView : UIView

/**
 * @brief 商品的id
 */
@property (nonatomic, copy) NSString *commonId;

/**
 * @brief 设置代理
 */
@property (nonatomic, weak) id<HSQGraphicDetailsViewDelegate>delegate;

@end
