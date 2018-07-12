//
//  HSQGoodsDetailFooterView.h
//  LiTianDecoration
//
//  Created by administrator on 2018/5/10.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HSQGoodsDetailFooterView : UITableViewHeaderFooterView

/**
 * @brief 提示文字
 */
@property (nonatomic, copy) NSString *PlacherString;

/**
 * @brief 右边的按钮
 */
@property (nonatomic, strong) UIImageView *RightImageView; 

@end
