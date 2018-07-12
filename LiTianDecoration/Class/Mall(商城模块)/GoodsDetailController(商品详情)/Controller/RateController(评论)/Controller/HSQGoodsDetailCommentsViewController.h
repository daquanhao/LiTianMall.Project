//
//  HSQGoodsDetailCommentsViewController.h
//  LiTianDecoration
//
//  Created by administrator on 2018/5/11.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HSQGoodsDetailCommentsViewController : UIViewController

/**
 * @brief 商品的详情数据
 */
@property (nonatomic, strong) NSDictionary *dataDiction;

/**
 * @brief 商品的SKU
 */
@property (nonatomic, copy) NSString *commonId;

@end
