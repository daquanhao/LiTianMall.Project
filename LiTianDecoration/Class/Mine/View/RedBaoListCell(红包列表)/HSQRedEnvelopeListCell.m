//
//  HSQRedEnvelopeListCell.m
//  LiTianDecoration
//
//  Created by administrator on 2018/6/26.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import "HSQRedEnvelopeListCell.h"
#import "HSQRedEnvelopeListModel.h"

@interface HSQRedEnvelopeListCell ()

@property (nonatomic, strong) UILabel *redPackageCode_Label;

@property (nonatomic, strong) UILabel *endTimeText_Label;

@property (nonatomic, strong) UILabel *redPackagePrice_Label;

@property (nonatomic, strong) UILabel *limitAmount_Label; // 红包使用时的订单限额

@property (nonatomic, strong) UILabel *redPackageUsableClientTypeText_Label; //  可用客户端类型标识

@property (nonatomic, strong) UIImageView *redPackageState_imageView;

@end

@implementation HSQRedEnvelopeListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        UIImageView *redPackageState_imageView = [[UIImageView alloc] init];
        [self.contentView addSubview:redPackageState_imageView];
        self.redPackageState_imageView = redPackageState_imageView;
        
        // 红包编号
        UILabel *redPackageCode_Label = [[UILabel alloc] init];
        redPackageCode_Label.textColor = RGB(71, 71, 71);
        redPackageCode_Label.font = [UIFont systemFontOfSize:14.0];
        redPackageCode_Label.numberOfLines = 0;
        [self.contentView addSubview:redPackageCode_Label];
        self.redPackageCode_Label = redPackageCode_Label;
        
        // 红包金额
        UILabel *redPackagePrice_Label = [[UILabel alloc] init];
        redPackagePrice_Label.textColor = [UIColor whiteColor];
        redPackagePrice_Label.font = [UIFont systemFontOfSize:14.0];
        redPackagePrice_Label.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:redPackagePrice_Label];
        self.redPackagePrice_Label = redPackagePrice_Label;
        
        // 红包有限期
        UILabel *endTimeText_Label = [[UILabel alloc] init];
        endTimeText_Label.textColor = RGB(150, 150, 150);
        endTimeText_Label.font = [UIFont systemFontOfSize:12.0];
        endTimeText_Label.numberOfLines = 0;
        [self.contentView addSubview:endTimeText_Label];
        self.endTimeText_Label = endTimeText_Label;
        
        // 红包使用时的订单限额
        UILabel *limitAmount_Label = [[UILabel alloc] init];
        limitAmount_Label.textColor = [UIColor whiteColor];
        limitAmount_Label.font = [UIFont systemFontOfSize:12.0];
        limitAmount_Label.numberOfLines = 0;
        limitAmount_Label.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:limitAmount_Label];
        self.limitAmount_Label = limitAmount_Label;
        
        //  可用客户端类型标识
        UILabel *redPackageUsableClientTypeText_Label = [[UILabel alloc] init];
        redPackageUsableClientTypeText_Label.textColor = [UIColor whiteColor];
        redPackageUsableClientTypeText_Label.font = [UIFont systemFontOfSize:12.0];
        redPackageUsableClientTypeText_Label.numberOfLines = 0;
        redPackageUsableClientTypeText_Label.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:redPackageUsableClientTypeText_Label];
        self.redPackageUsableClientTypeText_Label = redPackageUsableClientTypeText_Label;
        
        // 添加约束
        [self AddLayOut];
        
    }
    
    return self;
}

/**
 * @brief 添加约束
 */
- (void)AddLayOut{

    // 红包的编号
    self.redPackageCode_Label.sd_layout.leftSpaceToView(self.contentView, 10).topSpaceToView(self.contentView, 10).autoWidthRatio(0).autoHeightRatio(0);
    [self.redPackageCode_Label setSingleLineAutoResizeWithMaxWidth:(KScreenWidth - 20) * 0.8];
    
    // 红包的金额
    self.redPackagePrice_Label.sd_layout.leftSpaceToView(self.redPackageCode_Label, 5).rightSpaceToView(self.contentView, 30).topSpaceToView(self.contentView, 10).autoHeightRatio(0);
    
    // 红包的有效期
    self.endTimeText_Label.sd_layout.leftEqualToView(self.redPackageCode_Label).topSpaceToView(self.redPackageCode_Label, 10).autoWidthRatio(0).autoHeightRatio(0);
    [self.endTimeText_Label setSingleLineAutoResizeWithMaxWidth:(KScreenWidth - 20) * 0.8];
    
    // 红包满多少可用
    self.limitAmount_Label.sd_layout.rightEqualToView(self.redPackagePrice_Label).topSpaceToView(self.redPackagePrice_Label, 10).leftSpaceToView(self.endTimeText_Label, 5).autoHeightRatio(0);
    
    // 红包的使用场景
    self.redPackageUsableClientTypeText_Label.sd_layout.rightEqualToView(self.redPackagePrice_Label).topSpaceToView(self.limitAmount_Label, 10).leftSpaceToView(self.contentView, 10).autoHeightRatio(0);
    
    // 红包的背景图片
    self.redPackageState_imageView.sd_layout.leftSpaceToView(self.contentView, 0).topSpaceToView(self.contentView, 0).rightSpaceToView(self.contentView, 20).bottomEqualToView(self.contentView);
}

/**
 * @brief 数据模型
 */
- (void)setModel:(HSQRedEnvelopeListModel *)model{
    
    _model = model;
    
    // 红包编号
    self.redPackageCode_Label.text = [NSString stringWithFormat:@"编号：%@",model.redPackageCode];
    
    // 红包有限期
    self.endTimeText_Label.text = [NSString stringWithFormat:@"有效期：%@",model.endTimeText];
    
    // 红包金额
    self.redPackagePrice_Label.text = [NSString stringWithFormat:@"¥%.2f",model.redPackagePrice.floatValue];
    
    // 红包使用时的订单限额
    self.limitAmount_Label.text = [NSString stringWithFormat:@"满%.2f元可用",model.limitAmount.floatValue];
    
    //  可用客户端类型标识
    self.redPackageUsableClientTypeText_Label.text = [NSString stringWithFormat:@"%@适用",model.redPackageUsableClientTypeText];
    
    // 红包的状态
    if (model.redPackageExpiredState.integerValue == 0)
    {
        self.redPackageState_imageView.backgroundColor = [UIColor redColor];
    }
    else
    {
        self.redPackageState_imageView.backgroundColor = [UIColor grayColor];
    }
    
    // *********************** 高度自适应cell设置步骤01 ************************
    [self setupAutoHeightWithBottomView:self.redPackageUsableClientTypeText_Label bottomMargin:10];
}

- (void)setFrame:(CGRect)frame{
    
    frame.origin.y += 5;
    
    frame.origin.x += 10;
    
    frame.size.height -= 10;
    
    frame.size.width -= 20;
    
    [super setFrame:frame];
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
