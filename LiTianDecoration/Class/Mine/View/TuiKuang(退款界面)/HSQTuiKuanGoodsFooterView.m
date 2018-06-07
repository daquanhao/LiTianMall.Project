//
//  HSQTuiKuanGoodsFooterView.m
//  LiTianDecoration
//
//  Created by administrator on 2018/6/7.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import "HSQTuiKuanGoodsFooterView.h"

@interface HSQTuiKuanGoodsFooterView ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *PlacherView_H;

@property (weak, nonatomic) IBOutlet UILabel *TuiHuoReason_Label; // 退款原因

@property (weak, nonatomic) IBOutlet UILabel *LeftTuiKuanMonery_Label; // 左边的金额

@property (weak, nonatomic) IBOutlet UIImageView *First_ImageView;

@property (weak, nonatomic) IBOutlet UIImageView *Second_ImageView;

@property (weak, nonatomic) IBOutlet UIImageView *Third_imageView;

@end

@implementation HSQTuiKuanGoodsFooterView

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    
    if (self = [super initWithCoder:aDecoder]) {
        
        
    }
    
    return self;
}

- (void)setOrderDataDiction:(NSDictionary *)OrderDataDiction{
    
    _OrderDataDiction = OrderDataDiction;
    
    NSString *PlacherString = @"特别提示：投诉凭证选择直接拍照或从手机相册上传图片时，请注意图片尺寸控制在1M以内，超出请压缩裁剪后再选择上传！";
    CGSize PlacherSize = [NSString SizeOfTheText:PlacherString font:[UIFont systemFontOfSize:12.0] MaxSize:CGSizeMake(KScreenWidth - 30, MAXFLOAT)];
    self.PlacherView_H.constant = PlacherSize.height;
    
    // 退款的原因
    self.TuiHuoReason_Label.text = @"取消订单，全部退款";
    
    // 退款的金额
    NSString *monery = [NSString stringWithFormat:@"%@",OrderDataDiction[@"ordersVo"][@"ordersAmount"]];
    self.LeftTuiKuanMonery_Label.text = [NSString stringWithFormat:@"¥%.2f",monery.floatValue];

}

- (void)setPicture_array:(NSMutableArray *)Picture_array{
    
    _Picture_array = Picture_array;
    
    self.First_ImageView.image = Picture_array[0];
    
    self.Second_ImageView.image = Picture_array[1];
    
    self.Third_imageView.image = Picture_array[2];
}




/**
 * @brief 选择退款凭证
 */
- (IBAction)XuanZeTuiKuanPingZhengBtnClickAction:(UIButton *)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(ChooseRefundImageViewButtonClickAction:)]) {
        
        [self.delegate ChooseRefundImageViewButtonClickAction:sender];
    }
}

/**
 * @brief 提交
 */
- (IBAction)TiJiaoAnnIuClickAction:(UIButton *)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(SubmitButtonClickAction:)]) {
        
        [self.delegate SubmitButtonClickAction:sender];
    }
}












@end
