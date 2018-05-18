//
//  HSQGoodsCollectionListCell.h
//  LiTianDecoration
//
//  Created by administrator on 2018/4/11.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HSQGoodsCollectionListCell : UICollectionViewCell

@property (nonatomic, strong) UILabel *OrginPrice_label;  // 原来的价格

@property (nonatomic, strong) NSDictionary *Diction; // 商品数据

@property (nonatomic, strong) NSDictionary *StoreGoodsDiction; // 店铺里面的商品数据

@end
