//
//  HSQMallHeiperTool.h
//  LiTianDecoration
//
//  Created by administrator on 2018/5/8.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HSQMallHomeDataModel;

@interface HSQMallHeiperTool : NSObject

/** 返回item的个数 */
+ (NSInteger)returnNumberWithModel:(HSQMallHomeDataModel *)dataModel;

/** 返回item的大小*/
+(CGSize)sizeForItemInModel:(HSQMallHomeDataModel *)dataModel index:(NSIndexPath *)indexPath;

/** 返回分区的大小*/
+(CGSize)referenceSizeForHeaderInSection:(HSQMallHomeDataModel *)dataModel;

@end
