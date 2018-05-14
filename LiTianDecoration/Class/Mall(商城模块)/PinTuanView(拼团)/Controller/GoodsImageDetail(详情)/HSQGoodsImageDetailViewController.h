//
//  HSQGoodsImageDetailViewController.h
//  LiTianDecoration
//
//  Created by administrator on 2018/5/9.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HSQGoodsImageDetailViewController : UIViewController

/** 商品的图文详情数据数组*/
@property (nonatomic, strong) NSArray *goodsImageList;

/** 商品的id*/
@property (nonatomic, copy) NSString *commonId;

@end
