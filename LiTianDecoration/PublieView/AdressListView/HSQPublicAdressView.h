//
//  HSQPublicAdressView.h
//  LiTianDecoration
//
//  Created by administrator on 2018/4/18.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HSQPublicAdressView : UIView

/** 初始化视图 */
+ (instancetype)initAdressView;

/** 顶部的提示文字*/
@property (nonatomic, copy) NSString *placherString;

/**省级别数据源*/
@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, copy) void(^chooseFinish)(id string, id proId, id cityId, id areaId);

@property (nonatomic, copy) NSString * address;

/** 显示视图 */
- (void)ShowAdressView;

@end
