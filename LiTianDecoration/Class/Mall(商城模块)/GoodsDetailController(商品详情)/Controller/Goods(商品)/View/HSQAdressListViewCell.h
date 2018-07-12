//
//  HSQAdressListViewCell.h
//  LiTianDecoration
//
//  Created by administrator on 2018/7/3.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HSQAdressListViewCell : UITableViewCell

/**
 * @brief 地址
 */
@property (weak, nonatomic) IBOutlet UILabel *Adress_Label;

/**
 * @brief 提示语
 */
@property (weak, nonatomic) IBOutlet UILabel *placher_Label;

/**
 * @brief 有没有货
 */
@property (weak, nonatomic) IBOutlet UILabel *Goods_label;

@end
