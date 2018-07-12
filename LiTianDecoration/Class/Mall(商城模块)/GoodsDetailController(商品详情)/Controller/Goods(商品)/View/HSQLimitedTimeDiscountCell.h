//
//  HSQLimitedTimeDiscountCell.h
//  LiTianDecoration
//
//  Created by administrator on 2018/7/10.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HSQLimitedTimeDiscountCell : UITableViewCell

/**
 * @brief 折扣价格
 */
@property (weak, nonatomic) IBOutlet UILabel *appPrice0_Label;

/**
 * @brief 折扣描述
 */
@property (weak, nonatomic) IBOutlet UILabel *discountExplain_Label;

/**
 * @brief 折扣时间
 */
@property (weak, nonatomic) IBOutlet UILabel *discount_Label;

@end
