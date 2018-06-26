//
//  HSQMessgaeDetailDataListCell.m
//  LiTianDecoration
//
//  Created by administrator on 2018/6/20.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import "HSQMessgaeDetailDataListCell.h"
#import "HSQClassMessageListModel.h"

@interface HSQMessgaeDetailDataListCell ()

@property (nonatomic, strong) UIImageView *MessageImageView;

  // 消息的时间
@property (weak, nonatomic) IBOutlet UILabel *MessageTime_Label;

 // 消息的内容
@property (weak, nonatomic) IBOutlet UILabel *MessageContent_Label;

@end

@implementation HSQMessgaeDetailDataListCell

/**
 * @brief 数据模型
 */
- (void)setModel:(HSQClassMessageListModel *)model{
    
    _model = model;
    
    // 消息的时间
    self.MessageTime_Label.text = model.addTime;
    
    // 消息的内容
    NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
    
    [paragraphStyle1 setLineSpacing:8];
    
    NSAttributedString *string = [[NSAttributedString alloc] initWithString:model.messageContent attributes:@{NSParagraphStyleAttributeName: paragraphStyle1}];
    
    self.MessageContent_Label.attributedText =string;
}

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
//    self.MessageContent_Label.adjustsFontForContentSizeCategory = YES;
    
    if ([UIDevice iPhonesModel] == iPhone6Plus)
    {
        self.MessageContent_Label.font = [UIFont systemFontOfSize:14.0];
    }
    else
    {
        self.MessageContent_Label.font = [UIFont systemFontOfSize:12.0];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
