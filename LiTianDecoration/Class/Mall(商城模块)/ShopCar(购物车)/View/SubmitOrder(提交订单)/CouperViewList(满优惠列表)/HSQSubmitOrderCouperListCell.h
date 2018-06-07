//
//  HSQSubmitOrderCouperListCell.h
//  LiTianDecoration
//
//  Created by administrator on 2018/5/25.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HSQSubmitOrderCouperListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *ShengMonery_Label; // 省多少钱

@property (weak, nonatomic) IBOutlet UILabel *ActivityName_Label; // 活动的名字

@property (weak, nonatomic) IBOutlet UIImageView *Left_ImageView; // 左边的图片

@property (weak, nonatomic) IBOutlet UILabel *Reason_Label; // 退货或者退款原因

@end
