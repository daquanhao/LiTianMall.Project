//
//  HSQSelectGroupGoodsListHeadView.h
//  LiTianDecoration
//
//  Created by administrator on 2018/6/14.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HSQSelectGroupGoodsListHeadViewDelegate <NSObject>

- (void)ClickToEnterStoreDetails:(UIButton *)sender;

@end

@interface HSQSelectGroupGoodsListHeadView : UITableViewHeaderFooterView

@property (nonatomic, strong) UILabel *StoreName_Label;

@property (nonatomic, weak) id<HSQSelectGroupGoodsListHeadViewDelegate>delegate;

/**
 * @brief 标记
 */
@property (nonatomic, assign) NSInteger section;

@end
