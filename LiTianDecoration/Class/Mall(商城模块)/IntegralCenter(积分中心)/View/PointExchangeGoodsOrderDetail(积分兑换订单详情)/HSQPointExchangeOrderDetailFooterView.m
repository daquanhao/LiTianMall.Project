//
//  HSQPointExchangeOrderDetailFooterView.m
//  LiTianDecoration
//
//  Created by administrator on 2018/6/25.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import "HSQPointExchangeOrderDetailFooterView.h"
#import "HSQPointsOrdersListModel.h"

@interface HSQPointExchangeOrderDetailFooterView ()

@property (weak, nonatomic) IBOutlet UILabel *totalPoints_Label;

@property (weak, nonatomic) IBOutlet UILabel *OrderNumber_Label;

@property (weak, nonatomic) IBOutlet UILabel *createTime_Label;

@property (weak, nonatomic) IBOutlet UILabel *sendTime_Label;

@property (weak, nonatomic) IBOutlet UIView *SendTime_BgView;

@property (weak, nonatomic) IBOutlet UILabel *finishTime_Label;

@property (weak, nonatomic) IBOutlet UIView *finishTime_BgView;

@property (weak, nonatomic) IBOutlet UIView *BgView;

@end

@implementation HSQPointExchangeOrderDetailFooterView

- (void)awakeFromNib{
    
    [super awakeFromNib];
    
    self.BgView.backgroundColor = KViewBackGroupColor;
    
    self.totalPoints_Label.font = self.OrderNumber_Label.font = self.createTime_Label.font = self.sendTime_Label.font = self.finishTime_Label.font = [UIFont systemFontOfSize:12.0];
        
}

- (void)setModel:(HSQPointsOrdersListModel *)model{
    
    _model = model;
    
    // 订单的总积分
    self.totalPoints_Label.text = [NSString stringWithFormat:@"%@",model.totalPoints];
    
    // 订单的编号
    self.OrderNumber_Label.text = [NSString stringWithFormat:@"订单编号：%@",model.pointsOrdersSn];
    
    // 下单时间
    self.createTime_Label.text = [NSString stringWithFormat:@"下单时间：%@",model.createTime];
    
    // 发货时间
    self.sendTime_Label.text = [NSString stringWithFormat:@"发货时间：%@",model.sendTime];
    
    // 订单完成时间
    self.finishTime_Label.text = [NSString stringWithFormat:@"完成时间：%@",model.finishTime];
    
    // 积分兑换订单状态 0-已取消 10-新订单 20-已发货 30-已收货
    NSString *pointsOrdersState = [NSString stringWithFormat:@"%@",model.pointsOrdersState];
    
    if (pointsOrdersState.integerValue == 0 || pointsOrdersState.integerValue ==10)
    {
        self.SendTime_BgView.hidden = self.finishTime_BgView.hidden = YES;
    }
    else if (pointsOrdersState.integerValue == 20)
    {
        self.finishTime_BgView.hidden = YES;
    }
    else
    {
        self.SendTime_BgView.hidden = self.finishTime_BgView.hidden = NO;
    }

}









@end
