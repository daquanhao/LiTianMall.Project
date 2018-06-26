//
//  HSQPointsRedEnvelopeListCell.m
//  LiTianDecoration
//
//  Created by administrator on 2018/6/21.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import "HSQPointsRedEnvelopeListCell.h"
#import "HSQRedEnvelopeListDataModel.h"
#import "ZZCircleProgress.h"

@interface HSQPointsRedEnvelopeListCell ()

@property (weak, nonatomic) IBOutlet UILabel *templatePrice_Label; // 红包金额

@property (weak, nonatomic) IBOutlet UILabel *limitAmount_Label; // 满多少可用

@property (weak, nonatomic) IBOutlet UILabel *templateTitle_Label; // 红包的标题

@property (weak, nonatomic) IBOutlet UILabel *GetTheConditions_Label; // 领取条件

@property (weak, nonatomic) IBOutlet UILabel *useEndTimeText_Label; // 结束时间

@property (weak, nonatomic) IBOutlet UILabel *usableClientTypeText_Label; // 客户端类型

@property (weak, nonatomic) IBOutlet UIButton *hasReceived_Btn; // 会员已经领取红包标记

@property (weak, nonatomic) IBOutlet ZZCircleProgress *progressView;

@end

@implementation HSQPointsRedEnvelopeListCell

/**
 * @brief 数据模型
 */
- (void)setModel:(HSQRedEnvelopeListDataModel *)model{
    
    _model = model;
    
    // 红包金额
    self.templatePrice_Label.text = [NSString stringWithFormat:@"¥%@",model.templatePrice];
    
    // 满多少可用
    self.limitAmount_Label.text = [NSString stringWithFormat:@"满%@元可用",model.templatePrice];
    
    // 红包的标题
    self.templateTitle_Label.text = [NSString stringWithFormat:@"%@",model.templateTitle];
    
    // 领取条件
    self.GetTheConditions_Label.text = [NSString stringWithFormat:@"需(%@)会员 %@积分",model.limitMemberGradeName,model.expendPoints];
    
    // 结束时间
    self.useEndTimeText_Label.text = [NSString stringWithFormat:@"有效期至%@",model.useEndTimeText];
    
    // 客户端类型
    self.usableClientTypeText_Label.text = [NSString stringWithFormat:@"%@",model.usableClientTypeText];
    
    // 会员已经领取红包标记
    if (model.hasReceived.integerValue == 0) // 没有领取
    {
        [self.hasReceived_Btn setTitle:@"立即兑换" forState:(UIControlStateDisabled)];
    }
    else
    {
        [self.hasReceived_Btn setTitle:@"已兑换" forState:(UIControlStateDisabled)];
    }
    

    // 填充色
    self.progressView.pathFillColor = [UIColor whiteColor];
    
    self.progressView.startAngle = -90;
    
    // 改变线宽
    self.progressView.strokeWidth = 4.0;
    
    //是否显示圆点
    self.progressView.showPoint = NO;
    
    // 领取红包的数量
    CGFloat progress = model.giveoutNum.integerValue / model.totalNum.floatValue;
    
    self.progressView.progress = progress;

}

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    self.progressView.pathBackColor = RGB(150, 150, 150);
    
    // 进度值
    self.progressView.progressLabel.font = [UIFont systemFontOfSize:10.0];
}














@end
