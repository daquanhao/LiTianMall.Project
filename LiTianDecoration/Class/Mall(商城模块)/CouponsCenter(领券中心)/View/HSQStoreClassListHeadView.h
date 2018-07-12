//
//  HSQStoreClassListHeadView.h
//  LiTianDecoration
//
//  Created by administrator on 2018/6/27.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HSQStoreClassListHeadViewDelelgate <NSObject>

- (void)StoreClassBtnClickAction:(UIButton *)sender;

@end

@interface HSQStoreClassListHeadView : UITableViewHeaderFooterView

/**
 * @brief 数据源
 */
@property (nonatomic, strong) NSMutableArray *storeClassList;

/**
 * @brief 设置代理
 */
@property (nonatomic, weak) id <HSQStoreClassListHeadViewDelelgate>delegate;

@end
