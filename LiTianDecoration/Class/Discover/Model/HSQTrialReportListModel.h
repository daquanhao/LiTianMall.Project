//
//  HSQTrialReportListModel.h
//  LiTianDecoration
//
//  Created by administrator on 2018/4/17.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HWPhoto;

@interface HSQTrialReportListModel : NSObject

@property (nonatomic, copy) NSString *iconImagePath;

@property (nonatomic, strong) HWPhoto *photo;

/** 使用报告的内容*/
@property (nonatomic, copy) NSString *reportContent;

/** 使用报告,用户评论的图片*/
@property (nonatomic, strong) NSArray *images;


@end
