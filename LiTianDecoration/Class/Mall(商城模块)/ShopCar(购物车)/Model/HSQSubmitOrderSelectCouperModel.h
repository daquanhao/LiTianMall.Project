//
//  HSQSubmitOrderSelectCouperModel.h
//  LiTianDecoration
//
//  Created by administrator on 2018/5/25.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HSQSubmitOrderSelectCouperModel : NSObject

/** 优惠券是否被选中*/
@property (nonatomic, copy) NSString *IsSelect;

/** 选中的优惠券*/
@property (nonatomic, strong) NSMutableArray *couper_Source;

@end
