//
//  HSQCommissionWithdrawalListCell.m
//  LiTianDecoration
//
//  Created by administrator on 2018/6/15.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import "HSQCommissionWithdrawalListCell.h"
#import "HSQCommissionWithdrawaLlisModel.h"

@interface HSQCommissionWithdrawalListCell ()

@property (nonatomic, strong) UILabel *StatePlacher_Label;  // 状态提示文字

@property (nonatomic, strong) UILabel *cashSn_Label;  // 状态文字

@property (nonatomic, strong) UILabel *amount_Label;  // 申请金额

@property (nonatomic, strong) UILabel *addtime_Label;  // 申请时间

@property (nonatomic, strong) UIImageView *SanJiao_ImageView;  // 三角图片

@end

@implementation HSQCommissionWithdrawalListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        // 状态提示文字
        UILabel *StatePlacher_Label = [[UILabel alloc] init];
        StatePlacher_Label.font = [UIFont systemFontOfSize:14.0];
        StatePlacher_Label.numberOfLines = 0;
        [self.contentView addSubview:StatePlacher_Label];
        self.StatePlacher_Label = StatePlacher_Label;
        
        // 编号
        UILabel *cashSn_Label = [[UILabel alloc] init];
        cashSn_Label.font = [UIFont systemFontOfSize:12.0];
        cashSn_Label.textColor = RGB(150, 150, 150);
        [self.contentView addSubview:cashSn_Label];
        self.cashSn_Label = cashSn_Label;
        
        // 申请时间
        UILabel *addtime_Label = [[UILabel alloc] init];
        addtime_Label.font = [UIFont systemFontOfSize:12.0];
        addtime_Label.textColor = RGB(150, 150, 150);
        addtime_Label.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:addtime_Label];
        self.addtime_Label = addtime_Label;
        
        // 申请金额
        UILabel *amount_Label = [[UILabel alloc] init];
        amount_Label.font = [UIFont systemFontOfSize:14.0];
        amount_Label.textColor = [UIColor greenColor];
        amount_Label.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:amount_Label];
        self.amount_Label = amount_Label;
        
        // 三角图片
        UIImageView *SanJiao_ImageView = [[UIImageView alloc] initWithImage:KImageName(@"C7F2BC79-AC34-4AB0-AAFA-021F9AD47E36")];
        [self.contentView addSubview:SanJiao_ImageView];
        self.SanJiao_ImageView = SanJiao_ImageView;
    
    }
    
    return self;
}

/**
 * @brief 数据模型
 */
- (void)setModel:(HSQCommissionWithdrawaLlisModel *)model{
    
    _model = model;
    
    if (model.logId.integerValue == 0) // 余额提现列表
    {
         self.SanJiao_ImageView.hidden = NO;
        
        // 三角图片
        self.SanJiao_ImageView.sd_layout.rightSpaceToView(self.contentView, 10).centerYEqualToView(self.contentView).widthIs(8).heightIs(13);
        
        // 申请金额
        self.amount_Label.sd_layout.rightSpaceToView(self.SanJiao_ImageView, 10).topSpaceToView(self.contentView, 10).autoWidthRatio(0).autoHeightRatio(0);
        [self.amount_Label setSingleLineAutoResizeWithMaxWidth:150];
        
        // 申请时间
        self.addtime_Label.sd_layout.rightEqualToView(self.amount_Label).topSpaceToView(self.amount_Label, 10).autoWidthRatio(0).autoHeightRatio(0);
        [self.addtime_Label setSingleLineAutoResizeWithMaxWidth:KScreenWidth/2];
        
        // 状态
        self.StatePlacher_Label.sd_layout.leftSpaceToView(self.contentView, 10).topSpaceToView(self.contentView, 10).rightSpaceToView(self.addtime_Label, 5).autoHeightRatio(0);
        
        // 编号
        self.cashSn_Label.sd_layout.leftEqualToView(self.StatePlacher_Label).topSpaceToView(self.StatePlacher_Label, 10).rightSpaceToView(self.addtime_Label, 5).autoHeightRatio(0);
        
        // 状态
        self.StatePlacher_Label.text = [NSString stringWithFormat:@"提现审核：%@",model.stateText];
        
        // 金额
        self.amount_Label.text = [NSString stringWithFormat:@"%.2f元",model.amount.floatValue];
        
        // 编号
        self.cashSn_Label.text = [NSString stringWithFormat:@"单号：%@",model.cashSn];
        
        // 时间
        self.addtime_Label.text = [NSString stringWithFormat:@"%@",model.addTime];
        
        // *********************** 高度自适应cell设置步骤01 ************************
        [self setupAutoHeightWithBottomView:self.cashSn_Label bottomMargin:10];
    }
    else
    {
        self.SanJiao_ImageView.hidden = YES;
        
        // 申请金额
        self.amount_Label.sd_layout.rightSpaceToView(self.contentView, 10).topSpaceToView(self.contentView, 10).autoWidthRatio(0).autoHeightRatio(0);
        [self.amount_Label setSingleLineAutoResizeWithMaxWidth:150];
        
        // 申请时间
        self.addtime_Label.sd_layout.rightEqualToView(self.amount_Label).topSpaceToView(self.amount_Label, 10).autoWidthRatio(0).autoHeightRatio(0);
        [self.addtime_Label setSingleLineAutoResizeWithMaxWidth:KScreenWidth/2];
        
        // 状态
        self.StatePlacher_Label.sd_layout.leftSpaceToView(self.contentView, 10).topSpaceToView(self.contentView, 10).rightSpaceToView(self.addtime_Label, 5).autoHeightRatio(0);
        
        // 编号
        self.cashSn_Label.sd_layout.leftEqualToView(self.StatePlacher_Label).topSpaceToView(self.StatePlacher_Label, 10).rightSpaceToView(self.addtime_Label, 5).autoHeightRatio(0);
        
        // 状态
        self.StatePlacher_Label.text = [NSString stringWithFormat:@"%@",model.description_string];
        
        if ([model.operationStage isEqualToString:@"cashRefuse"]) // 被拒绝
        {
            // 金额
            self.amount_Label.text = [NSString stringWithFormat:@"+%.2f元",model.availableAmount.floatValue];
            
            self.amount_Label.textColor = RGB(238, 58, 68);
        }
        else
        {
            // 金额
            self.amount_Label.text = [NSString stringWithFormat:@"%.2f元",model.availableAmount.floatValue];
            
            self.amount_Label.textColor = [UIColor greenColor];
        }
        
        // 时间
        self.addtime_Label.text = [NSString stringWithFormat:@"%@",model.addTime];
        
        // *********************** 高度自适应cell设置步骤01 ************************
        [self setupAutoHeightWithBottomView:self.StatePlacher_Label bottomMargin:15];
    }

}

- (void)setFrame:(CGRect)frame{
    
    frame.origin.y += 1;
    
    frame.size.height -= 2;
    
    [super setFrame:frame];

}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
