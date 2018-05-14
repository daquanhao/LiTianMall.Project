//
//  HSQCollectionViewLayout.h
//  LiTianDecoration
//
//  Created by administrator on 2018/4/17.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HSQCollectionViewLayout;

@protocol HSQCollectionViewLayoutDelegate <NSObject>

/** 一行返回几列*/
- (CGFloat)DefauilColumns:(HSQCollectionViewLayout *)waterFlowLayout;

/** 默认的行间距 */
- (CGFloat)DefauilRowMargin:(HSQCollectionViewLayout *)waterFlowLayout;

/** 默认的列间距 */
- (CGFloat)DefauilColumnsMargin:(HSQCollectionViewLayout *)waterFlowLayout;

/** cell的内边距*/
- (UIEdgeInsets)collectionViewEdgeInsets:(HSQCollectionViewLayout *)waterFlowLayout;

/** cell的大小*/
- (CGSize)waterFlowLayout:(HSQCollectionViewLayout *)waterFlowLayout atIndexPath:(NSIndexPath *)indexPath;

@end

@interface HSQCollectionViewLayout : UICollectionViewLayout

@property (nonatomic, weak) id<HSQCollectionViewLayoutDelegate>delegate;

@property (nonatomic, assign) NSInteger second;

@end
