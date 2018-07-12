//
//  HSQStoreCollectionHeadReusableView.h
//  LiTianDecoration
//
//  Created by administrator on 2018/6/8.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HSQStoreCollectionListDataModel;

@protocol HSQStoreCollectionHeadReusableViewDelegate <NSObject>

@optional

/**
 * @brief 编辑时选中按钮的点击事件
 */
- (void)SelectTheClickEventOfTheButtonWhenEditing:(UIButton *)sender;

@end

@interface HSQStoreCollectionHeadReusableView : UICollectionReusableView

@property (nonatomic, strong) HSQStoreCollectionListDataModel *StoreModel;

@property (nonatomic, assign) NSInteger section;

@property (nonatomic, strong) UIImageView *Select_ImageView;

@property (nonatomic, weak) id<HSQStoreCollectionHeadReusableViewDelegate>delegate;

@end
