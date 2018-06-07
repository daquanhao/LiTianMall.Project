//
//  HSQInvoiceListModel.h
//  LiTianDecoration
//
//  Created by administrator on 2018/6/5.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HSQInvoiceListModel : NSObject


/** 发票抬头*/
@property (nonatomic, copy) NSString *title;

/** 纳税人识别号*/
@property (nonatomic, copy) NSString *code;

/** 用户id*/
@property (nonatomic, copy) NSString *memberId;

/**发票id*/
@property (nonatomic, copy) NSString *invoiceId;

@end
