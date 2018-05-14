//
//  HSQMessageSetListCell.m
//  LiTianDecoration
//
//  Created by administrator on 2018/4/26.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import "HSQMessageSetListCell.h"
#import "HSQMessageReceiveModel.h"

@interface HSQMessageSetListCell ()

@property (weak, nonatomic) IBOutlet UILabel *Message_Label;

@property (weak, nonatomic) IBOutlet UISwitch *IsDefaul;

@end

@implementation HSQMessageSetListCell

- (void)setModel:(HSQMessageListModel *)model{
    
    _model = model;
    
    self.Message_Label.text = model.tplName;
    
    // 是否接收消息 1是 0否
    NSString *isReceive = model.isReceive;
    
    if (isReceive.integerValue == 1)
    {
        [self.IsDefaul setOn:YES];
    }
    else
    {
        [self.IsDefaul setOn:NO];
    }
}


- (IBAction)StateChangeButtonClickAction:(UISwitch *)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(ChangeTheReceivingStateOfTheMessage:)]) {
        
        [self.delegate ChangeTheReceivingStateOfTheMessage:sender];
    }
}



- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];


}

@end
