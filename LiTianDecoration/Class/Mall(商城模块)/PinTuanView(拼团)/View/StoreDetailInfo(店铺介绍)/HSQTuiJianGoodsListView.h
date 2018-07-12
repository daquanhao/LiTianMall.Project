//
//  HSQTuiJianGoodsListView.h
//  LiTianDecoration
//
//  Created by administrator on 2018/5/16.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HSQTuiJianGoodsListViewDelegate <NSObject>

- (void)ClickOnTheStoreRankingItems:(UIButton *)sender Commid:(NSString *)commid;

@end

@interface HSQTuiJianGoodsListView : UIView

/**
 * @brief 初始化视图
 */
- (instancetype)initTuiJianGoodsListView;

/**
 * @brief 接收上一个界面的数据
 */
@property (nonatomic, strong) NSArray *data_Array;

/**
 * @brief 设置代理
 */
@property (nonatomic, weak) id<HSQTuiJianGoodsListViewDelegate>delegate;

@end
