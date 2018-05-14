//
//  HSQImageListCollectionViewCell.h
//  LiTianDecoration
//
//  Created by administrator on 2018/5/8.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HSQMallHomeDataModel;

@interface HSQImageListCollectionViewCell : UICollectionViewCell

@property (nonatomic, copy) NSString *ImageUrl;

@property (nonatomic, strong) HSQMallHomeDataModel *model;

@end
