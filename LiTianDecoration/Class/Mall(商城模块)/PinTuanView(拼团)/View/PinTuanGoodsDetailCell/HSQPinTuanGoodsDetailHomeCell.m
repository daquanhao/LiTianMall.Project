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

@property (weak, nonatomic) IBOutlet UILabel *RateCountLabel; // 评论数量

@property (weak, nonatomic) IBOutlet UILabel *GoodsRateLabel; // 好评率

@property (weak, nonatomic) IBOutlet UILabel *NoRatePlacherLabel; //没有评论的提示文字




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
    
    // 评论的数量
    NSString *ratecount = [NSString stringWithFormat:@"%@",DataDiction[@"evaluateGoodsTotal"]];
    
    if (ratecount.integerValue == 0) // 没有评论数
    {
        [self.RateCountLabel setHidden:YES];
        
        [self.GoodsRateLabel setHidden:YES];
        
        [self.NoRatePlacherLabel setHidden:NO];
        
        // 评论的好评率
        NSString *GoodsRate = @"评论(暂无，购买后来发表评论吧)";
        NSMutableAttributedString *attribeString = [NSString attributedStringWithString:GoodsRate font:[UIFont systemFontOfSize:14.0] range:NSMakeRange(0, 2)];
        self.NoRatePlacherLabel.attributedText = attribeString;
    }
    else
    {
        [self.RateCountLabel setHidden:NO];
        
        [self.GoodsRateLabel setHidden:NO];
        
        [self.NoRatePlacherLabel setHidden:YES];
        
        self.RateCountLabel.text = [NSString stringWithFormat:@"评价(%@)",ratecount];
        
        // 评论的好评率
        NSString *GoodsRate = [NSString stringWithFormat:@"好评率 %@%@",DataDiction[@"groupGoodsDetailVo"][@"goodsRate"],@"%"];
        NSMutableAttributedString *attribeString = [NSString attributedStringWithString:GoodsRate Color:RGB(51, 51, 51) range:NSMakeRange(0, 3)];
        self.GoodsRateLabel.attributedText = attribeString;
    }
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
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];

    self.selectionStyle = UITableViewCellSelectionStyleNone;
}


@end
