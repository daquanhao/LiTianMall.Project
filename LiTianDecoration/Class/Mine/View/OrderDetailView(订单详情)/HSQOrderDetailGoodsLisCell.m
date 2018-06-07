
//
//  HSQOrderDetailGoodsLisCell.m
//  LiTianDecoration
//
//  Created by administrator on 2018/6/1.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import "HSQOrderDetailGoodsLisCell.h"
#import "HSQShopCarGoodsTypeListModel.h"

@interface HSQOrderDetailGoodsLisCell ()

@property (weak, nonatomic) IBOutlet UIImageView *GoodsImageView;

@property (weak, nonatomic) IBOutlet UILabel *GoodsName_Label;

@property (weak, nonatomic) IBOutlet UILabel *GoodsPrice_Label;

@property (weak, nonatomic) IBOutlet UILabel *GoodsGuiGe_Label;

@property (weak, nonatomic) IBOutlet UILabel *GoodsCount_Label;

@property (weak, nonatomic) IBOutlet UIView *BgView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *BottomMargin;

@end

@implementation HSQOrderDetailGoodsLisCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    
}

/**
 * @brief 数据模型
 */
- (void)setModel:(HSQShopCarGoodsTypeListModel *)model{
    
    _model = model;
    
    // 商品的图片
    [self.GoodsImageView sd_setImageWithURL:[NSURL URLWithString:model.imageSrc] placeholderImage:KGoodsPlacherImage];
    
    // 商品的名字
    self.GoodsName_Label.text = model.goodsName;
    
    // 商品的价格
    self.GoodsPrice_Label.text = [NSString stringWithFormat:@"¥%@",model.goodsPrice];
    
    // 商品的规格
    self.GoodsGuiGe_Label.text = model.goodsFullSpecs;
    
    // 商品的购买数量
    self.GoodsCount_Label.text = [NSString stringWithFormat:@"X%@",model.buyNum];
    
    // 商品的投诉状态
    if (model.complainId.integerValue > 0)
    {
        [self.TouSu_Btn setTitle:@"投诉中" forState:(UIControlStateNormal)];
    }
    else
    {
        [self.TouSu_Btn setTitle:@"投诉" forState:(UIControlStateNormal)];
    }
    
    // 商品是否处在退货退款中
    if (model.refundType.integerValue == 1)
    {
        self.TuiKuang_Btn.hidden = YES;
        
        [self.TuiHuo_Btn setTitle:@"查看退款" forState:(UIControlStateNormal)];
    }
    else if (model.refundType.integerValue == 2)
    {
        self.TuiKuang_Btn.hidden = YES;
        
        [self.TuiHuo_Btn setTitle:@"查看退货" forState:(UIControlStateNormal)];
    }
    else
    {
        self.TuiKuang_Btn.hidden = NO;
        
        [self.TuiHuo_Btn setTitle:@"退货" forState:(UIControlStateNormal)];
    }

}

/**
 * @brief 判断订单的状态
 */
- (void)setDataDiction:(NSDictionary *)dataDiction{
    
    _dataDiction = dataDiction;
    
    NSString *OrderState = [NSString stringWithFormat:@"%@",self.dataDiction[@"ordersVo"][@"ordersState"]];
    
    NSString *ordersStateName = [NSString stringWithFormat:@"%@",self.dataDiction[@"ordersVo"][@"ordersStateName"]];
    
    if (OrderState.integerValue == 10) // 待支付
    {
        self.BgView.hidden = YES;
        
        self.TouSu_Btn.hidden = self.TuiHuo_Btn.hidden  = self.TuiKuang_Btn.hidden  = YES;
        
        self.BottomMargin.constant = 0;
    }
    else if (OrderState.integerValue == 0)  // 已取消
    {
        self.BgView.hidden = YES;
        
        self.TouSu_Btn.hidden = self.TuiHuo_Btn.hidden  = self.TuiKuang_Btn.hidden  = YES;
        
        self.BottomMargin.constant = 0;
    }
    else if (OrderState.integerValue == 20) // 代发货
    {
        if ([ordersStateName isEqualToString:@"拼团失败"])
        {
            self.BgView.hidden = YES;
            
            self.TouSu_Btn.hidden = self.TuiHuo_Btn.hidden  = self.TuiKuang_Btn.hidden  = YES;
            
            self.BottomMargin.constant = 0;
        }
        else
        {
            self.BgView.hidden = NO;
            
            self.TouSu_Btn.hidden = NO;
            
            self.TuiHuo_Btn.hidden = YES;
            
            self.TuiKuang_Btn.hidden = YES;
            
            self.BottomMargin.constant = 40;
        }
    }
    else if (OrderState.integerValue == 30) // 已发货
    {
        self.BgView.hidden = NO;
        
        self.TouSu_Btn.hidden = self.TuiHuo_Btn.hidden   = NO;
        
        self.BottomMargin.constant = 40;
    }
    else if (OrderState.integerValue == 40) // 待评价
    {
        self.BgView.hidden = NO;
        
        self.TouSu_Btn.hidden = self.TuiHuo_Btn.hidden   = NO;
        
        self.BottomMargin.constant = 40;
    }
}

/**
 * @brief 投诉按钮的点击
 */
- (IBAction)TouSuAnNiuDeClickAction:(UIButton *)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(ComplaintsButtonClickEvent:)]) {
        
        [self.delegate ComplaintsButtonClickEvent:sender];
    }
}

/**
 * @brief 退货按钮的点击
 */
- (IBAction)TuiHuoAnNiuClickAction:(UIButton *)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(ClickEventOnTheReturnButton:)]) {
        
        [self.delegate ClickEventOnTheReturnButton:sender];
    }
}

/**
 * @brief 退款按钮的点击
 */
- (IBAction)TuiKuanAnNiuClickAction:(UIButton *)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(RefundMoneryButtonClickAction:)]) {
        
        [self.delegate RefundMoneryButtonClickAction:sender];
    }
}




























- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

@end
