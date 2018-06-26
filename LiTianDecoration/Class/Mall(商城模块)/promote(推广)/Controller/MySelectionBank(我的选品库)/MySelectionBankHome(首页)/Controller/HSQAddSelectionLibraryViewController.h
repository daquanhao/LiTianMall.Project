//
//  HSQAddSelectionLibraryViewController.h
//  LiTianDecoration
//
//  Created by administrator on 2018/6/14.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HSQAddSelectionLibraryViewController : UIViewController

/**
 *@brief 选品库分组名称
 */
@property (nonatomic, copy) NSString *distributorFavoritesName;

/**
 *@brief 选品库分组id
 */
@property (nonatomic, copy) NSString *distributorFavoritesId;

/**
 *@brief 来源 100 代表添加  200代表修改
 */
@property (nonatomic, assign) NSInteger source;

/**
 *@brief 成功后的回调
 */
@property (nonatomic, copy) void(^TheCallbackNameBlock) (id success);

@end
