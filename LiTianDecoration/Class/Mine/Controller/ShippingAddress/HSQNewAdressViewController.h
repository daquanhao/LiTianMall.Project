//
//  HSQNewAdressViewController.h
//  LiTianDecoration
//
//  Created by administrator on 2018/4/25.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HSQAcceptAddressListModel;

@interface HSQNewAdressViewController : UIViewController

@property (nonatomic,copy) void(^addNewAdressSuccess)(id success);

@property (nonatomic, strong) HSQAcceptAddressListModel *model;

/**
 * @brief 区分是修改地址，还是编辑地址
 */
@property (nonatomic, copy) NSString *Adress_Url;

@end
