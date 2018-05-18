//
//  HSQGoodsGuiGeFooterReusableView.h
//  LiTianDecoration
//
//  Created by administrator on 2018/5/14.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HSQGoodsGuiGeFooterReusableViewDelegate <NSObject>

/** 添加商品*/
- (void)AddGoodsCountToShapCarBtnClickAction:(UIButton *)sender;

/** 减少商品*/
- (void)JianShaoGoodsCountInShopCarBtnClickAction:(UIButton *)sender;

@end

@interface HSQGoodsGuiGeFooterReusableView : UICollectionReusableView

@property (nonatomic, weak) id<HSQGoodsGuiGeFooterReusableViewDelegate>delegate;

@property (weak, nonatomic) IBOutlet UITextField *Count_TextField;

@end
