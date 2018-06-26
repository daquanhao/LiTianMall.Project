//
//  HSQPredepositAvailableListCell.m
//  LiTianDecoration
//
//  Created by administrator on 2018/6/10.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import "HSQPredepositAvailableListCell.h"
#import "HSQIntegralListModel.h"

@interface HSQPredepositAvailableListCell ()

@property (nonatomic, strong) UILabel *description_Label;  // 描述

@property (nonatomic, strong) UILabel *Monery_Label;  // 钱数

@property (nonatomic, strong) UILabel *addTime_Label;  // 时间

@property (nonatomic, strong) UIView *Line_View;  // 分割线

@end

@implementation HSQPredepositAvailableListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        // 添加控件视图
        [self SetUpView];
        
        // 添加控件视图的约束
        [self SetUpViewLayOut];
    }
    
    return self;
}

/**
 * @brief 添加控件视图
 */
- (void)SetUpView{
    
    // 分割线
    UIView *Line_View = [[UIView alloc] init];
    Line_View.backgroundColor = KViewBackGroupColor;
    [self.contentView addSubview:Line_View];
    self.Line_View = Line_View;
    
    // 钱数
    UILabel *Monery_Label = [[UILabel alloc] init];
    Monery_Label.textColor = [UIColor greenColor];
    Monery_Label.font = [UIFont systemFontOfSize:14.0];
    Monery_Label.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:Monery_Label];
    self.Monery_Label = Monery_Label;
    
    // 描述
    UILabel *description_Label = [[UILabel alloc] init];
    description_Label.textColor = RGB(71, 71, 71);
    description_Label.font = [UIFont systemFontOfSize:12.0];
    description_Label.numberOfLines = 0;
    [self.contentView addSubview:description_Label];
    self.description_Label = description_Label;
    
    // 时间
    UILabel *addTime_Label = [[UILabel alloc] init];
    addTime_Label.textColor = [UIColor grayColor];
    addTime_Label.font = [UIFont systemFontOfSize:12.0];
    addTime_Label.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:addTime_Label];
    self.addTime_Label = addTime_Label;
}

/**
 * @brief 添加控件视图的约束
 */
- (void)SetUpViewLayOut{
    
    // 钱数
    self.Monery_Label.sd_layout.rightSpaceToView(self.contentView, 10).topSpaceToView(self.contentView, 10).autoWidthRatio(0).autoHeightRatio(0);
    [self.Monery_Label setSingleLineAutoResizeWithMaxWidth:KScreenWidth * 0.4];
    
    // 描述
    self.description_Label.sd_layout.leftSpaceToView(self.contentView, 10).topSpaceToView(self.contentView, 10).rightSpaceToView(self.Monery_Label, 5).autoHeightRatio(0);

    // 时间
    self.addTime_Label.sd_layout.leftSpaceToView(self.contentView, 10).rightSpaceToView(self.contentView, 10).topSpaceToView(self.Monery_Label, 10).heightIs(20);
    
    // 分割线
    self.Line_View.sd_layout.leftSpaceToView(self.contentView, 0).topSpaceToView(self.addTime_Label, 5).rightSpaceToView(self.contentView, 0).heightIs(5);

}

/**
 *@brief 数据模型
 */
- (void)setModel:(HSQIntegralListModel *)model{
    
    _model = model;
    
    // 钱数
    if ([model.operationStage isEqualToString:@"refund"])
    {
        self.Monery_Label.textColor = [UIColor redColor];
        self.Monery_Label.text = [NSString stringWithFormat:@"+%@元",model.availableAmount];
    }
    else
    {
        self.Monery_Label.textColor = [UIColor greenColor];
        self.Monery_Label.text = [NSString stringWithFormat:@"%@元",model.availableAmount];
    }
    
    // 描述
    self.description_Label.text = model.descriptionString;
    
    // 时间
    self.addTime_Label.text = model.addTime;
    
    // *********************** 高度自适应cell设置步骤01 ************************
    [self setupAutoHeightWithBottomView:self.Line_View bottomMargin:0];
}




















- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
