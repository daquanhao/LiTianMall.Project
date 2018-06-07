//
//  HSQContentsOfInvoiceView.h
//  LiTianDecoration
//
//  Created by administrator on 2018/6/5.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HSQContentsOfInvoiceView : UIView

/** 初始化视图 */
+ (instancetype)initContentsOfInvoiceView;

/** 显示视图 */
- (void)ShowContentsOfInvoiceView;

/** 选中的发票内容*/
@property (nonatomic, copy) NSString *FaPiaoContent_String;

/**
 * @brief 回调选中的地址
 */
@property (nonatomic,copy) void(^SelectFaPiaoContentDataBlock)(id success);

@end
