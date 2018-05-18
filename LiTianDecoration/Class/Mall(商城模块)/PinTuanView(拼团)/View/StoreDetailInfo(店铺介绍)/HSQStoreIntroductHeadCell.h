//
//  HSQStoreIntroductHeadCell.h
//  LiTianDecoration
//
//  Created by administrator on 2018/5/15.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HSQStoreIntroductHeadCellDelegate <NSObject>

/** 收藏店铺的点击事件*/
- (void)CollectStoreNotiftioncClickAction:(UIButton *)sender;

@end

@interface HSQStoreIntroductHeadCell : UITableViewCell

/** 数据*/
@property (nonatomic, strong) NSDictionary *DataDiction;

/** 设置代理*/
@property (nonatomic, weak) id<HSQStoreIntroductHeadCellDelegate>delegate;

/**
 * @brief 收藏按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *Collection_Btn;

@end
