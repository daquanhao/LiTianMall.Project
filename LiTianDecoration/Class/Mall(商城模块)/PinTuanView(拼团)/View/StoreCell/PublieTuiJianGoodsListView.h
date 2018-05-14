//
//  PublieTuiJianGoodsListView.h
//  LiTianDecoration
//
//  Created by administrator on 2018/5/11.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PublieTuiJianGoodsListViewDelegate <NSObject>

@optional

/** 为你推荐商品的点击 */
- (void)TuiJianGoodsListClickAction:(UIButton *)sender commonId:(NSString *)GoodsId;

@end

@interface PublieTuiJianGoodsListView : UIView

@property (nonatomic, strong) NSDictionary *dataDiction;

@property (nonatomic, weak) id<PublieTuiJianGoodsListViewDelegate>delegate;

@end
