//
//  HSQPinTuanGoodsDetailHomeCell.m
//  LiTianDecoration
//
//  Created by administrator on 2018/5/10.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import "HSQPinTuanGoodsDetailHomeCell.h"

@interface HSQPinTuanGoodsDetailHomeCell ()

@property (weak, nonatomic) IBOutlet UILabel *YiXuan_Label; // 已选

@property (weak, nonatomic) IBOutlet UILabel *VolumeLabel; // 体积

@property (weak, nonatomic) IBOutlet UILabel *weightLabel; // 重量

@end

@implementation HSQPinTuanGoodsDetailHomeCell

+ (instancetype)HSQPinTuanGoodsDetailHomeCellWithXIB{
    
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:self options:nil]firstObject];
}

/**
 * @brief 数据赋值
 */
- (void)setDataDiction:(NSDictionary *)DataDiction{
    
    _DataDiction = DataDiction;
    
    // 已选
    NSArray *array = DataDiction[@"groupGoodsDetailVo"][@"goodsList"];
    self.YiXuan_Label.text = [NSString stringWithFormat:@"%@",array[0][@"goodsSpecString"]];
    
    // 重量
    self.weightLabel.text = @"数据待找";
    
    // 体积
     self.VolumeLabel.text = @"数据待找";
    
}

/**
 * @brief 领券按钮的点击
 */
- (IBAction)LingQuanButtonClickAction:(UIButton *)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(ShowTheCouponListClickAction:)]) {
        
        [self.delegate ShowTheCouponListClickAction:sender];
    }
}

/**
 * @brief 促销按钮的点击
 */
- (IBAction)CuXiaoButtonClickAction:(UIButton *)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(ShowAListOfDiscountsClickAction:)]) {
        
        [self.delegate ShowAListOfDiscountsClickAction:sender];
    }
}

/**
 * @brief 已选规格按钮的点击
 */
- (IBAction)YiXuanButtonClickAction:(UIButton *)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(DisplaysAListOfSpecificationsForAProduct:)]) {
        
        [self.delegate DisplaysAListOfSpecificationsForAProduct:sender];
    }
}

/**
 * @brief 选择配送的地址
 */
- (IBAction)XuanZeSendAdressClickAction:(UIButton *)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(ChooseSendAdressClickAction:)]) {
        
        [self.delegate ChooseSendAdressClickAction:sender];
    }
}








- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    self.selectionStyle = UITableViewCellSelectionStyleNone;
}


@end
