//
//  HSQRealNameAuthenticaViewController.h
//  LiTianDecoration
//
//  Created by administrator on 2018/6/11.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HSQRealNameAuthenticaViewController : UIViewController

/**
 * @brief 回调选中的地址
 */
@property (nonatomic,copy) void(^SelectNameCertificationDataBlock)(id success);

/**
 * @brief 认证信息
 */
@property (nonatomic, strong) NSMutableDictionary *CertificationDiction;

@end
