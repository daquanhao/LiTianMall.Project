//
//  HSQMembershipListModel.h
//  LiTianDecoration
//
//  Created by administrator on 2018/6/21.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HSQMembershipListModel : NSObject

/** 会员等级 */
@property (nonatomic, copy) NSString *gradeLevel;

/** 会员等级名称 */
@property (nonatomic, copy) NSString *gradeName;

/** 店铺等级编号 */
@property (nonatomic, copy) NSString *gradeId;

/** 会员经验值 */
@property (nonatomic, copy) NSString *expPoints;

@end
