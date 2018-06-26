//
//  HSQPointExchangeOrderDetailHeadView.m
//  LiTianDecoration
//
//  Created by administrator on 2018/6/25.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import "HSQPointExchangeOrderDetailHeadView.h"
#import "HSQPointsOrdersListModel.h"

@interface HSQPointExchangeOrderDetailHeadView ()

@property (weak, nonatomic) IBOutlet UILabel *OrderState_Label;

@property (weak, nonatomic) IBOutlet UILabel *receiverName_Label;

@property (weak, nonatomic) IBOutlet UILabel *receiverAreaInfo_Label;

@property (weak, nonatomic) IBOutlet UILabel *receiverMessage_Label;

@property (weak, nonatomic) IBOutlet UILabel *StoreName_Label;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *receiverMessageHeight;

@end

@implementation HSQPointExchangeOrderDetailHeadView

- (void)setModel:(HSQPointsOrdersListModel *)model{
    
    _model = model;
    
    // 订单的状态
    self.OrderState_Label.text = [NSString stringWithFormat:@"%@",model.pointsOrdersStateText];
    
    // 收货人
    self.receiverName_Label.text = [NSString stringWithFormat:@"收货人：%@",model.receiverName];
    
    // 收货地址
    self.receiverAreaInfo_Label.text = [NSString stringWithFormat:@"收货地址：%@%@",model.receiverAreaInfo,model.receiverAddress];
    
    // 买家留言
    NSString *receiverMessage = [NSString stringWithFormat:@"%@",model.receiverMessage];
    
    if (receiverMessage.length == 0)
    {
        self.receiverMessage_Label.text = @"暂无";
    }
    else
    {
        self.receiverMessage_Label.text = receiverMessage;
    }
    
    CGSize receiverMessage_size = [NSString SizeOfTheText:self.receiverMessage_Label.text font:[UIFont systemFontOfSize:12.0] MaxSize:CGSizeMake(KScreenWidth - 110, MAXFLOAT)];
    
    if (receiverMessage_size.height > 40)
    {
        self.receiverMessageHeight.constant = receiverMessage_size.height + 6;
    }
    else
    {
        self.receiverMessageHeight.constant = 40;
    }
        
    // 店铺的名字
    self.StoreName_Label.text = [NSString stringWithFormat:@"%@",model.storeName];
}

/**
 * @brief 进入店铺的详情
 */
- (IBAction)JoinStoreBtnClickAction:(UIButton *)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(JoinStoreDetailButtonClickAction:)]) {
        
        [self.delegate JoinStoreDetailButtonClickAction:sender];
    }
}

















@end
