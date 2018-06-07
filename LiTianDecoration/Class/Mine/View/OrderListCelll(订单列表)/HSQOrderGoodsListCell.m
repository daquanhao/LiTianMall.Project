//
//  HSQOrderGoodsListCell.m
//  LiTianDecoration
//
//  Created by administrator on 2018/5/26.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import "HSQOrderGoodsListCell.h"
#import "HSQOrderListFirstCengModel.h"
#import "HSQShopCarGoodsTypeListModel.h"  // 商品列表的数据模型
#import "HSQOrderGoodsListBgView.h"  // 商品列表

@interface HSQOrderGoodsListCell ()

@property (weak, nonatomic) IBOutlet UILabel *StoreName_Label; // 店铺的名字

@property (weak, nonatomic) IBOutlet UILabel *OrderState_Label; // 支付状态

@property (weak, nonatomic) IBOutlet UIView *GoodsListBgView; // 商品列表背景图

@property (weak, nonatomic) IBOutlet UILabel *OrderTotalMonery_Label; // 订单的总价格

@property (nonatomic, strong) HSQOrderGoodsListBgView *GoodsBgView; // 商品的列表

@property (weak, nonatomic) IBOutlet UIView *BgView;

@property (weak, nonatomic) IBOutlet UILabel *OrderTealState_Label; // 订单的处理状态

@property (weak, nonatomic) IBOutlet UIButton *CancelOrder_Btn;

@property (weak, nonatomic) IBOutlet UIView *BottomBtnView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *TotalMoneryViewBottomLayout;

@property (weak, nonatomic) IBOutlet UIButton *RateOrder_Btn; // 评价订单

@property (weak, nonatomic) IBOutlet UIButton *DeleteOrder_Btn; // 删除订单按钮

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *BottomMargin;

@end

@implementation HSQOrderGoodsListCell

- (void)setModel:(HSQOrderListSecondCengModel *)model{
    
    _model = model;
    
    // 店铺的名字
    self.OrderState_Label.text = model.storeName;
    
    // 订单的状态
    if (model.ordersTypeName.length == 0)
    {
        self.OrderState_Label.text = model.ordersStateName;
    }
    else
    {
        NSString *OrderStateName = [NSString stringWithFormat:@"(%@) %@",model.ordersTypeName,model.ordersStateName];
        
        NSMutableAttributedString *attribe_string = [[NSMutableAttributedString alloc] initWithString:OrderStateName];
        
        [attribe_string addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, model.ordersTypeName.length+3)];
        
        self.OrderState_Label.attributedText = attribe_string;
    }

    // 商品列表
    self.GoodsBgView.OrderGoodsList_Array = model.ordersGoodsVoList_array;
    
    // 商品的总价
    NSString *ordersAmount = [NSString stringWithFormat:@"¥%.2f",model.ordersAmount.floatValue];
    
    // 是否含有运费
    NSString *freightAmount = nil;
    
    if (model.freightAmount.integerValue == 0)
    {
        freightAmount = @"  (包邮)";
    }
    else
    {
        freightAmount = [NSString stringWithFormat:@"   含运费(¥%.2f)",model.freightAmount.floatValue];
    }
    
    // 商品购买的数量
    CGFloat GoodsCount = 0;
    
    NSString *GoodsCountString = nil;
    
    for (NSInteger i = 0; i < model.ordersGoodsVoList_array.count; i++) {
        
        HSQShopCarGoodsTypeListModel *TypeModel = model.ordersGoodsVoList_array[i];
        
        GoodsCount = GoodsCount + TypeModel.buyNum.floatValue;
    }
    
    GoodsCountString = [NSString stringWithFormat:@"共%.f件商品，",GoodsCount];
    
    // 商品的购买数量和总的价钱
   NSString *TotalMoneryString = [NSString stringWithFormat:@"%@%@%@",GoodsCountString,ordersAmount,freightAmount];
    
    NSMutableAttributedString *attribe = [[NSMutableAttributedString alloc] initWithString:TotalMoneryString];
    
    [attribe addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14.0] range:NSMakeRange(GoodsCountString.length, ordersAmount.length)];
        
     [attribe addAttribute:NSForegroundColorAttributeName value:RGB(238, 58, 68) range:NSMakeRange(GoodsCountString.length, ordersAmount.length)];
    
    self.OrderTotalMonery_Label.attributedText = attribe;
    
    // 订单的状态
    if (model.ordersState.integerValue == 0) // 已取消
    {
        [self.CancelOrder_Btn setHidden:NO];
        
        self.BottomBtnView.hidden = NO;
        
        self.TotalMoneryViewBottomLayout.constant = 52;
        
        [self.CancelOrder_Btn setTitle:@"再次购买" forState:(UIControlStateNormal)];
        
        [self.DeleteOrder_Btn setHidden:NO]; // 删除订单按钮
        
        [self.RateOrder_Btn setHidden:YES]; // 评价订单按钮
        
        self.OrderTealState_Label.text = @"";
    }
    else if (model.ordersState.integerValue == 10) // 待支付
    {
        self.TotalMoneryViewBottomLayout.constant = 52;
        
        [self.CancelOrder_Btn setHidden:NO];
        
        [self.BottomBtnView setHidden:NO];
        
        [self.DeleteOrder_Btn setHidden:YES]; // 删除订单按钮
        
        [self.RateOrder_Btn setHidden:YES]; // 评价订单按钮

        [self.CancelOrder_Btn setTitle:@"取消订单" forState:(UIControlStateNormal)];
    }
    else if (model.ordersState.integerValue == 20) // 待发货
    {
        [self.CancelOrder_Btn setHidden:YES];
        self.OrderTealState_Label.text = (model.showRefundWaiting.integerValue == 1 ? @"退款/退货中..." :@""); // 是否处于退款退货中，0-否/1-是
        self.BottomBtnView.hidden = (model.showRefundWaiting.integerValue == 1 ? NO :YES);
        self.TotalMoneryViewBottomLayout.constant = (model.showRefundWaiting.integerValue == 1 ? 52 :12);
        [self.DeleteOrder_Btn setHidden:YES]; // 删除订单按钮
        [self.RateOrder_Btn setHidden:YES]; // 评价订单按钮
    }
    else if (model.ordersState.integerValue == 30) // 待收货或者取货
    {
        if (model.showRefundWaiting.integerValue == 1)// 是否处于退款退货中，0-否/1-是
        {
            self.OrderTealState_Label.text = @"退款/退货中...";
            
            [self.DeleteOrder_Btn setHidden:YES]; // 删除订单按钮
            
            [self.RateOrder_Btn setHidden:YES]; // 评价订单按钮
            
            [self.CancelOrder_Btn setHidden:YES];
            
            self.BottomBtnView.hidden = NO;
        }
        else
        {
            self.OrderTealState_Label.text = @"";
            
            [self.CancelOrder_Btn setHidden:YES];
            
            self.BottomBtnView.hidden = NO;
            
            [self.CancelOrder_Btn setHidden:NO];
            
            self.BottomBtnView.hidden = NO;
            
            self.TotalMoneryViewBottomLayout.constant = 52;
            
            [self.CancelOrder_Btn setTitle:@"确认收货" forState:(UIControlStateNormal)];
            
            [self.CancelOrder_Btn setTitleColor:RGB(238, 58, 68) forState:(UIControlStateNormal)];
            
            [self.DeleteOrder_Btn setHidden:YES]; // 删除订单按钮
            
            [self.RateOrder_Btn setHidden:YES]; // 评价订单按钮
        }
    }
    else if (model.ordersState.integerValue == 40) // 交易完成，等待评价
    {
        if (model.showEvaluationAppend.integerValue == 0)
        {
            [self.RateOrder_Btn setTitle:@"评论订单" forState:(UIControlStateNormal)];
        }
        else
        {
            [self.RateOrder_Btn setTitle:@"追加评论" forState:(UIControlStateNormal)];
        }
        
        if (model.showRefundWaiting.integerValue == 1)// 是否处于退款退货中，0-否/1-是
        {
            self.OrderTealState_Label.text = @"退款/退货中...";
            
            [self.DeleteOrder_Btn setHidden:YES]; // 删除订单按钮
            
            [self.RateOrder_Btn setHidden:YES]; // 评价订单按钮
            
            [self.CancelOrder_Btn setHidden:YES];
            
            self.BottomBtnView.hidden = NO;
        }
        else
        {
            [self.DeleteOrder_Btn setHidden:NO]; // 删除订单按钮
            
            [self.CancelOrder_Btn setHidden:NO];
            
            self.BottomBtnView.hidden = NO;
            
            [self.CancelOrder_Btn setHidden:NO];
            
            [self.RateOrder_Btn setHidden:NO]; // 评价订单按钮
            
             self.OrderTealState_Label.text = @"";
            
            self.TotalMoneryViewBottomLayout.constant = 52;
            
            [self.CancelOrder_Btn setTitle:@"再次购买" forState:(UIControlStateNormal)];
        }
    }
    
}

/**
 * @brief 删除订单
 */
- (IBAction)ShanChuOrderBtnClickAction:(UIButton *)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(DeleteOrderButtonClickAction:)]) {
        
        [self.delegate DeleteOrderButtonClickAction:sender];
    }
}

/**
 * @brief 进入店铺
 */
- (IBAction)JinRuOrderStoreBtnClickAction:(UIButton *)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(JoinStoreButtonClickAction:)]) {
        
        [self.delegate JoinStoreButtonClickAction:sender];
    }
}

/**
 * @brief 取消订单，再次购买，确认收货三种情况的点击事件
 */
- (IBAction)CellRightOrderBtnClickAction:(UIButton *)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(OrderCancelBtnClickAction:)]) {
        
        [self.delegate OrderCancelBtnClickAction:sender];
    }
}

/**
 * @brief 评价订单的点击事件
 */
- (IBAction)RateOrderButtonClickAction:(UIButton *)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(EvaluationOfTheOrderButtonClickAction:)]) {
        
        [self.delegate EvaluationOfTheOrderButtonClickAction:sender];
    }
}








- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    // 商品的列表
    HSQOrderGoodsListBgView *GoodsBgView = [[HSQOrderGoodsListBgView alloc] init];
    [self.BgView addSubview:GoodsBgView];
    self.GoodsBgView = GoodsBgView;
    
    // 商品列表的约束
    self.GoodsBgView.sd_layout.leftSpaceToView(self.BgView, 0).topSpaceToView(self.BgView, 0).rightSpaceToView(self.BgView, 0).bottomSpaceToView(self.BgView, 0);
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
