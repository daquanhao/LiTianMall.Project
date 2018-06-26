//
//  HSQOrderDetailFooterView.m
//  LiTianDecoration
//
//  Created by administrator on 2018/6/1.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import "HSQOrderDetailFooterView.h"

@interface HSQOrderDetailFooterView ()

@property (weak, nonatomic) IBOutlet UILabel *YuCunKuanPay_Label; // 预存款支付
@property (weak, nonatomic) IBOutlet UIView *YuCunKuan_BgView;

@property (weak, nonatomic) IBOutlet UILabel *OrderMonery_label; // 订单金额

@property (weak, nonatomic) IBOutlet UILabel *FaBiaoInfo_Label; // 发票信息

@property (weak, nonatomic) IBOutlet UILabel *PayMoneryType_Label; // 付款方式

@property (weak, nonatomic) IBOutlet UILabel *OrderNumber_Label; // 订单编号

@property (weak, nonatomic) IBOutlet UILabel *OrderCreatTime_Label; // 订单创建时间

@property (weak, nonatomic) IBOutlet UILabel *OrderPayMoneryTime_Label; // 付款时间
@property (weak, nonatomic) IBOutlet UIView *OrderPayTime_BgView; // 付款时间的背景图

@property (weak, nonatomic) IBOutlet UILabel *OrderSendGoodsTime_Label; // 发货时间
@property (weak, nonatomic) IBOutlet UIView *SendGoodsTime_BgView; // 发货时间的背景图

@property (weak, nonatomic) IBOutlet UILabel *OrderFinshTime_Label; // 完成时间
@property (weak, nonatomic) IBOutlet UIView *FinshTime_BgView; // 完成时间的背景图

// 发票的信息
@property (weak, nonatomic) IBOutlet UIView *FaPiaoTaiTou_BgvIEW;
@property (weak, nonatomic) IBOutlet UILabel *FaPiaoTaiTou_Label;

@property (weak, nonatomic) IBOutlet UIView *NaShuiRenBgView;
@property (weak, nonatomic) IBOutlet UILabel *NaShuiRen_Label;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *TopMargin;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *OrderMoneryTopMargin;

@property (weak, nonatomic) IBOutlet UILabel *Placher_Label; // 提示标语
@property (weak, nonatomic) IBOutlet UIView *PlacherView;

@property (weak, nonatomic) IBOutlet UIButton *CancelOrder_Button;

@property (weak, nonatomic) IBOutlet UILabel *BottomPlacher_Label;

@end

@implementation HSQOrderDetailFooterView

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    
    if (self = [super initWithCoder:aDecoder]) {
        
        
    }
    
    return self;
}

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
}

/**
 * @Brief 数据赋值
 */
- (void)setOrderDataDiction:(NSDictionary *)OrderDataDiction{
    
    _OrderDataDiction = OrderDataDiction;
    
    // 1.订单金额
    [self OrderMonerywithDiction:OrderDataDiction];

    // 发票信息
    [self FaPiaoxinXiWithDiction:OrderDataDiction];
    
    // 付款方式
    self.PayMoneryType_Label.text = [NSString stringWithFormat:@"%@",OrderDataDiction[@"ordersVo"][@"paymentName"]];
    
    // 订单编号
    self.OrderNumber_Label.text = [NSString stringWithFormat:@"订单编号：%@",OrderDataDiction[@"ordersVo"][@"ordersSn"]];
    
    // 订单创建时间
    self.OrderCreatTime_Label.text = [NSString stringWithFormat:@"创建时间：%@",OrderDataDiction[@"ordersVo"][@"createTime"]];

    // 判断预存款是否存在
    NSString *Order_Type = [NSString stringWithFormat:@"%@",OrderDataDiction[@"ordersVo"][@"ordersState"]];
    
    if (Order_Type.integerValue == 10)  // 待支付
    {
        self.YuCunKuan_BgView.hidden = YES;
        
        self.PlacherView.hidden = NO;
        
        self.OrderMoneryTopMargin.constant = -41;
        
        self.Placher_Label.text = [NSString stringWithFormat:@"%@",OrderDataDiction[@"ordersTips"]];
    }
    else if (Order_Type.integerValue == 0)  // 已取消
    {
        self.YuCunKuan_BgView.hidden = YES;
        
        self.PlacherView.hidden = YES;
        
        self.OrderMoneryTopMargin.constant = -41;
        
        self.Placher_Label.text = @"";
    }
    else
    {
        self.YuCunKuan_BgView.hidden = NO;
        
        self.PlacherView.hidden = YES;
        
        self.OrderMoneryTopMargin.constant = 1;
        
        // 预存款
        self.YuCunKuanPay_Label.text = [NSString stringWithFormat:@"¥%@",OrderDataDiction[@"ordersVo"][@"predepositAmount"]];
    }
    
    // 判断订单的类型
    [self JudeOrderStateWithDiction:OrderDataDiction];
}

/**
 * @brief 订单的金额
 */
- (void)OrderMonerywithDiction:(NSDictionary *)OrderDataDiction{
    
    NSString *freight = [NSString stringWithFormat:@"%@",OrderDataDiction[@"ordersVo"][@"freightAmount"]];
    
    NSString *freightAmount = nil;
    
    if (freight.integerValue == 0)
    {
        freightAmount = @"  (包邮)";
    }
    else
    {
        freightAmount = [NSString stringWithFormat:@"   (含运费¥%.2f)",freight.floatValue];
    }
    
    NSString *ordersAmount = [NSString stringWithFormat:@"¥%@",OrderDataDiction[@"ordersVo"][@"ordersAmount"]];
    
    NSString *TheOrderAmount = [NSString stringWithFormat:@"%@%@",ordersAmount,freightAmount];
    
    NSMutableAttributedString *attribe = [[NSMutableAttributedString alloc] initWithString:TheOrderAmount];
    
    [attribe addAttribute:NSForegroundColorAttributeName value:RGB(150, 150, 150) range:NSMakeRange(ordersAmount.length, freightAmount.length)];
    
    self.OrderMonery_label.attributedText = attribe;
}

/**
 * @brief 发票的信息
 */
- (void)FaPiaoxinXiWithDiction:(NSDictionary *)OrderDataDiction{
    
    NSString *invoiceTitle = [NSString stringWithFormat:@"%@",OrderDataDiction[@"ordersVo"][@"invoiceContent"]];
    
    if ([invoiceTitle isEqualToString:@"<null>"])
    {
        self.FaBiaoInfo_Label.text = @"不开发票";
        self.FaPiaoTaiTou_BgvIEW.hidden = self.NaShuiRenBgView.hidden = YES;
        
        self.TopMargin.constant = -82;
    }
    else
    {
        self.TopMargin.constant = -1;
        
        self.FaPiaoTaiTou_BgvIEW.hidden = self.NaShuiRenBgView.hidden = YES;
        
        self.FaBiaoInfo_Label.text = invoiceTitle;  // 发票内容
        
        self.FaPiaoTaiTou_Label.text = [NSString stringWithFormat:@"%@",OrderDataDiction[@"ordersVo"][@"invoiceTitle"]];  // 发票抬头
        
        self.NaShuiRen_Label.text = [NSString stringWithFormat:@"%@",OrderDataDiction[@"ordersVo"][@"invoiceCode"]];  // 纳税人识别号
        
    }
}

/**
 * @brief 判断订单的状态
 */
- (void)JudeOrderStateWithDiction:(NSDictionary *)OrderDataDiction{
    
    NSString *Order_Type = [NSString stringWithFormat:@"%@",OrderDataDiction[@"ordersVo"][@"ordersState"]];
    
    if (Order_Type.integerValue == 0) // 已取消
    {
        self.OrderPayTime_BgView.hidden = self.SendGoodsTime_BgView.hidden = self.FinshTime_BgView.hidden = YES;
        
        self.BottomPlacher_Label.hidden = YES;
        
        self.CancelOrder_Button.hidden = YES;
        
        HSQLog(@"==订单详情===%@",Order_Type);
    }
    else if (Order_Type.integerValue == 10) // 待支付
    {
        self.CancelOrder_Button.hidden = NO;
        
        self.OrderPayTime_BgView.hidden = self.SendGoodsTime_BgView.hidden = self.FinshTime_BgView.hidden = YES;
        
        // 底部的按钮
        [self.CancelOrder_Button setTitle:@"取消订单" forState:(UIControlStateNormal)];
        
        self.BottomPlacher_Label.hidden = YES;
    }
    else if (Order_Type.integerValue == 20) // 待发货
    {
        self.OrderPayTime_BgView.hidden = NO;
        
        self.CancelOrder_Button.hidden = NO;
        
        self.SendGoodsTime_BgView.hidden = self.FinshTime_BgView.hidden = YES;
        
        // 订单付款时间
        self.OrderPayMoneryTime_Label.text = [NSString stringWithFormat:@"付款时间：%@",OrderDataDiction[@"ordersVo"][@"paymentTime"]];
        
        // 底部的按钮
        [self.CancelOrder_Button setTitle:@"订单退款" forState:(UIControlStateNormal)];
    }
    else if (Order_Type.integerValue == 30) // 待收货或者取货
    {
        self.OrderPayTime_BgView.hidden = self.SendGoodsTime_BgView.hidden = NO;
        
        self.FinshTime_BgView.hidden = YES;
        
        self.CancelOrder_Button.hidden = NO;
        
        // 订单付款时间
        self.OrderPayMoneryTime_Label.text = [NSString stringWithFormat:@"付款时间：%@",OrderDataDiction[@"ordersVo"][@"paymentTime"]];
        
        // 订单发货时间
        self.OrderSendGoodsTime_Label.text = [NSString stringWithFormat:@"发货时间：%@",OrderDataDiction[@"ordersVo"][@"sendTime"]];
        
        self.BottomPlacher_Label.hidden = YES;
        
        // 底部的按钮
        [self.CancelOrder_Button setTitle:@"确认收货" forState:(UIControlStateNormal)];
        
    }
    else if (Order_Type.integerValue == 40) // 交易完成，等待评价
    {
         self.CancelOrder_Button.hidden = NO;
        
        self.OrderPayTime_BgView.hidden = self.SendGoodsTime_BgView.hidden = self.FinshTime_BgView.hidden = NO;
        
        // 订单付款时间
        self.OrderPayMoneryTime_Label.text = [NSString stringWithFormat:@"付款时间：%@",OrderDataDiction[@"ordersVo"][@"paymentTime"]];
        
        // 订单发货时间
        self.OrderSendGoodsTime_Label.text = [NSString stringWithFormat:@"发货时间：%@",OrderDataDiction[@"ordersVo"][@"sendTime"]];
        
        // 订单完成时间
        self.OrderPayMoneryTime_Label.text = [NSString stringWithFormat:@"完成时间：%@",OrderDataDiction[@"ordersVo"][@"finishTime"]];
        
        // 判断是否已经评价
        NSString *evaluationState = [NSString stringWithFormat:@"%@",OrderDataDiction[@"ordersVo"][@"showEvaluationAppend"]];
        
        if (evaluationState.integerValue == 0) // 评价
        {
            [self.CancelOrder_Button setTitle:@"评价订单" forState:(UIControlStateNormal)];
        }
        else // 追加评论
        {
            [self.CancelOrder_Button setTitle:@"追加评论" forState:(UIControlStateNormal)];
        }
        
        self.BottomPlacher_Label.hidden = YES;
        
    }
    
    // 判断订单是否在退货中
    NSString *showRefundWaiting = [NSString stringWithFormat:@"%@",OrderDataDiction[@"ordersVo"][@"showRefundWaiting"]];
    
    if (showRefundWaiting.integerValue == 0) // 不是
    {
        self.CancelOrder_Button.hidden = YES;
        
        self.BottomPlacher_Label.hidden = YES;
    }
    else
    {
        self.CancelOrder_Button.hidden = YES;
        
        self.BottomPlacher_Label.hidden = NO;
        
        self.BottomPlacher_Label.text = @"退款/退货中...";
    }
    
    // 判断是否是拼团商品
    NSString *ordersStateName = [NSString stringWithFormat:@"%@",OrderDataDiction[@"ordersVo"][@"ordersStateName"]];
    
    if ([ordersStateName isEqualToString:@"拼团失败"])
    {
        self.CancelOrder_Button.hidden = NO;
        
        self.OrderPayTime_BgView.hidden = NO;
        
        // 订单付款时间
        self.OrderPayMoneryTime_Label.text = [NSString stringWithFormat:@"创建时间：%@",OrderDataDiction[@"ordersVo"][@"createTime"]];
        
        [self.CancelOrder_Button setTitle:@"查看团详情" forState:(UIControlStateNormal)];
    }
    else
    {
        self.CancelOrder_Button.hidden = YES;
    }
}





/**
 * @brief 联系客服
 */
- (IBAction)LianXiKeFuBtnClickAction:(UIButton *)sender {
    
    
}

/**
 * @brief 底部按钮的点击
 */
- (IBAction)CancelOrderBtnClickAction:(UIButton *)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(ClickEventOfTheBottomButton:)]) {
        
        [self.delegate ClickEventOfTheBottomButton:sender];
    }
}











@end
