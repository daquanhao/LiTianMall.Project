//
//  HSQCoupterListCell.m
//  LiTianDecoration
//
//  Created by administrator on 2018/5/10.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import "HSQCoupterListCell.h"
#import "HSQVoucherListModel.h"

@interface HSQCoupterListCell ()

@property (weak, nonatomic) IBOutlet UILabel *CoupontPrice_Label; // 优惠券的钱数

@property (weak, nonatomic) IBOutlet UILabel *limitAmount_Label; // 优惠券使用时的订单限额

@property (weak, nonatomic) IBOutlet UILabel *templateTitle_Label; // 活动名称

@property (weak, nonatomic) IBOutlet UILabel *templateDescribe_Label; // 购买范围

@property (weak, nonatomic) IBOutlet UILabel *addTime_Label; // 创建时间

@property (weak, nonatomic) IBOutlet UIButton *LingQu_Btn; // 领取按钮

@end

@implementation HSQCoupterListCell

/**
 * @brief 数据模型
 */
- (void)setModel:(HSQVoucherListModel *)model{
    
    _model = model;
    
    // 优惠券的钱数
    self.CoupontPrice_Label.text = [NSString stringWithFormat:@"¥%@",model.templatePrice];
    
    // 优惠券使用时的订单限额
    self.limitAmount_Label.text = [NSString stringWithFormat:@"满%@元可用",model.limitAmount];
    
    // 活动名称
    self.templateTitle_Label.text = model.templateTitle;
    
    // 活动的描述
    self.templateDescribe_Label.text = [NSString stringWithFormat:@"可购买%@商品",model.storeName];
    
    // 时间
    self.addTime_Label.text = [NSString stringWithFormat:@"有效期至%@",model.useEndTimeText];
    
    // 是否已经领取 0未领取 1已领取
    if (model.memberIsReceive.integerValue == 0)
    {
        self.LingQu_Btn.hidden = NO;
    }
    else
    {
        self.LingQu_Btn.hidden = YES;
    }
}

- (void)awakeFromNib {
    
    [super awakeFromNib];
   
    self.contentView.backgroundColor = KViewBackGroupColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];

    self.selectionStyle = UITableViewCellSeparatorStyleNone;
}

@end
