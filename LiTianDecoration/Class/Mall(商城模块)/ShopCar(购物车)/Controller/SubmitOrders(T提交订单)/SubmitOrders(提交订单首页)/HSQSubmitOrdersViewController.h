//
//  HSQSubmitOrdersViewController.h
//  LiTianDecoration
//
//  Created by administrator on 2018/5/23.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HSQSubmitOrdersViewController : UIViewController

/** 购买的商品(sku)的goodsId 和 购买数量组成的json串*/
@property (nonatomic, copy) NSString *buyData;

/**是否从购物车中跳转的购买（1–是 0–否） */
@property (nonatomic, copy) NSString *isCart;

/**购买的商品是否含有优惠套装（1–是 0–否） */
@property (nonatomic, copy) NSString *isExistBundling;

/**是否是拼团（1–是 0–否） */
@property (nonatomic, copy) NSString *isGroup;

@end
