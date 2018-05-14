//
//  HSQMyPropertyHomeListCell.m
//  LiTianDecoration
//
//  Created by administrator on 2018/4/28.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import "HSQMyPropertyHomeListCell.h"
#import "MyPropertyListModel.h"

@interface HSQMyPropertyHomeListCell ()

@property (weak, nonatomic) IBOutlet UILabel *Title_Label;

@property (weak, nonatomic) IBOutlet UILabel *Describe_Label;

@property (weak, nonatomic) IBOutlet UILabel *Count_Label;

@end

@implementation HSQMyPropertyHomeListCell

+ (instancetype)HSQMyPropertyHomeListCellWithXIB{
    
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:self options:nil] firstObject];
}

- (void)setModel:(MyPropertyListModel *)model{
    
    _model = model;
    
    self.Title_Label.text = model.Title;
    
    self.Describe_Label.text = model.describe_string;
}

- (void)SetValueWithDiction:(NSDictionary *)diction indexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) // 账户余额
    {
        self.Count_Label.text = [NSString stringWithFormat:@"%@元",diction[@"predepositAvailable"]];
    }
    else if (indexPath.row == 1) // 店铺券
    {
        self.Count_Label.text = [NSString stringWithFormat:@"%@张",diction[@"voucher"]];
    }
    else if (indexPath.row == 2) // 平台券
    {
        self.Count_Label.text = [NSString stringWithFormat:@"%@个",diction[@"redpacket"]];
    }
    else if (indexPath.row == 3) // 会员经验值
    {
        self.Count_Label.text = [NSString stringWithFormat:@"%@经验",diction[@"expPoints"]];
    }
    else if (indexPath.row == 4) // 会员积分
    {
        self.Count_Label.text = [NSString stringWithFormat:@"%@分",diction[@"points"]];
    }
    else if (indexPath.row == 5) // 会员奖品
    {
        self.Count_Label.text = [NSString stringWithFormat:@"%@个",diction[@"prize"]];
    }
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
