//
//  HSQIntegralListCell.m
//  LiTianDecoration
//
//  Created by administrator on 2018/4/28.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import "HSQIntegralListCell.h"
#import "HSQIntegralListModel.h"

@interface HSQIntegralListCell ()

@property (weak, nonatomic) IBOutlet UILabel *NameLabel;

@property (weak, nonatomic) IBOutlet UILabel *CountLabel;

@property (weak, nonatomic) IBOutlet UILabel *DescribeLabel;

@property (weak, nonatomic) IBOutlet UILabel *DateTimeLabel;

@end

@implementation HSQIntegralListCell

+ (instancetype)HSQIntegralListCellWithXIB{
    
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:self options:nil]firstObject];
}

- (void)setModel:(HSQIntegralListModel *)model{
    
    _model = model;
    
    // 1.名字
    self.NameLabel.text = model.descriptionString;
    
    // 2.描述
    self.DescribeLabel.text = model.operationStageText;
    
    // 3.时间
    self.DateTimeLabel.text = model.addTime;
    
    // 4.数量
    self.CountLabel.text = model.points.integerValue > 0 ? [NSString stringWithFormat:@"+%@",model.points] : [NSString stringWithFormat:@"%@",model.points];
}

- (void)setFrame:(CGRect)frame{
    
    frame.origin.y += 2;
    
    frame.size.height -= 4;
    
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
