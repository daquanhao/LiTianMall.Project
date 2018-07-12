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

 // 消息的内容
@property (nonatomic, strong) UILabel *MessageContent_Label;

@end

@implementation HSQMessgaeDetailDataListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        UILabel *MessageContent_Label = [[UILabel alloc] init];
        
        MessageContent_Label.textColor = RGB(71, 71, 71);
        
        MessageContent_Label.font = [UIFont systemFontOfSize:KLabelFont(14.0, 12.0)];
        
        MessageContent_Label.numberOfLines = 0;
        
        [self.contentView addSubview:MessageContent_Label];
        
        self.MessageContent_Label = MessageContent_Label;
        
        self.MessageContent_Label.sd_layout.leftSpaceToView(self.contentView, 10).rightSpaceToView(self.contentView, 20).topSpaceToView(self.contentView, 5).autoHeightRatio(0);
    }
    
    return self;
}

/**
 * @brief 数据模型
 */
- (void)setModel:(HSQClassMessageListModel *)model{
    
    _model = model;
    
    // 消息的内容
    NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
    
    [paragraphStyle1 setLineSpacing:8];
    
    NSAttributedString *string = [[NSAttributedString alloc] initWithString:model.messageContent attributes:@{NSParagraphStyleAttributeName: paragraphStyle1}];
    
    self.MessageContent_Label.attributedText = string;
    
    self.MessageContent_Label.isAttributedContent = YES;
    
    [self setupAutoHeightWithBottomView:self.MessageContent_Label bottomMargin:10];
}

- (void)setFrame:(CGRect)frame{
    
    frame.origin.y += 2;
    
    frame.origin.x += 10;
    
    frame.size.height -= 4;
    
    frame.size.width -= 20;
    
    [super setFrame:frame];
}

- (void)awakeFromNib {
    
    [super awakeFromNib];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
