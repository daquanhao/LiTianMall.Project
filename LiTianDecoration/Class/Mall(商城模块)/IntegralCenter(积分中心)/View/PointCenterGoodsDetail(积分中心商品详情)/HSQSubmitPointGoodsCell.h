//
//  HSQSubmitPointGoodsCell.h
//  LiTianDecoration
//
//  Created by administrator on 2018/6/22.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HSQSubmitPointGoodsCell : UITableViewCell

/**
 * @brief 数据
 */
@property (nonatomic, strong) NSDictionary *diction;

/**
 * @brief 带有提示文字的输入框
 */
@property (nonatomic, strong) HSQCustomTextView *textView;

@end
