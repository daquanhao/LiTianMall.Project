//
//  HSQClassMessageListCellTableViewCell.m
//  LiTianDecoration
//
//  Created by administrator on 2018/6/20.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import "HSQClassMessageListCellTableViewCell.h"
#import "HSQClassMessageListModel.h"

@interface HSQClassMessageListCellTableViewCell ()

@property (nonatomic, strong) UIImageView *MessageImageView;

@property (nonatomic, strong) UILabel *MessageName_Label;  // 消息的名字

@property (nonatomic, strong) UILabel *MessageTime_Label;  // 消息的时间

@property (nonatomic, strong) UILabel *MessageContent_Label;  // 消息的内容

@property (nonatomic, strong) UILabel *messageUnreadCount_label;  // 未读消息数

@end

@implementation HSQClassMessageListCellTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        // 消息的图片
        UIImageView *MessageImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:MessageImageView];
        self.MessageImageView = MessageImageView;
        
        //未读消息数
        UILabel *messageUnreadCount_label = [[UILabel alloc] init];
        messageUnreadCount_label.textColor = [UIColor whiteColor];
        messageUnreadCount_label.backgroundColor = [UIColor redColor];
        messageUnreadCount_label.font = [UIFont systemFontOfSize:10.0];
        messageUnreadCount_label.textAlignment = NSTextAlignmentCenter;
        [MessageImageView addSubview:messageUnreadCount_label];
        self.messageUnreadCount_label = messageUnreadCount_label;
        
        // 消息的名字
        UILabel *MessageName_Label = [[UILabel alloc] init];
        MessageName_Label.textColor = RGB(71, 71, 71);
        MessageName_Label.font = [UIFont systemFontOfSize:14.0];
        [self.contentView addSubview:MessageName_Label];
        self.MessageName_Label = MessageName_Label;
        
        // 消息的时间
        UILabel *MessageTime_Label = [[UILabel alloc] init];
        MessageTime_Label.textColor = RGB(71, 71, 71);
        MessageTime_Label.font = [UIFont systemFontOfSize:12.0];
        MessageTime_Label.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:MessageTime_Label];
        self.MessageTime_Label = MessageTime_Label;
        
        // 消息的内容
        UILabel *MessageContent_Label = [[UILabel alloc] init];
        MessageContent_Label.textColor = RGB(71, 71, 71);
        MessageContent_Label.font = [UIFont systemFontOfSize:12.0];
        [self.contentView addSubview:MessageContent_Label];
        self.MessageContent_Label = MessageContent_Label;
        
        // 消息的图片的约束
        self.MessageImageView.sd_layout.leftSpaceToView(self.contentView, 10).centerYEqualToView(self.contentView).widthIs(30).heightEqualToWidth();
        
        //未读消息数的约束
        self.messageUnreadCount_label.sd_layout.rightSpaceToView(self.MessageImageView, -5).topSpaceToView(self.MessageImageView, -5).widthIs(22).heightEqualToWidth();
        [self.messageUnreadCount_label setSd_cornerRadiusFromWidthRatio:@(0.5)];
        
        // 消息的名字的约束
        self.MessageName_Label.sd_layout.leftSpaceToView(self.MessageImageView, 10).topSpaceToView(self.contentView, 10).autoWidthRatio(0).autoHeightRatio(0);
        [self.MessageName_Label setSingleLineAutoResizeWithMaxWidth:KScreenWidth / 2];
        
        // 消息的时间的约束
        self.MessageTime_Label.sd_layout.rightSpaceToView(self.contentView, 10).topEqualToView(self.MessageName_Label).autoWidthRatio(0).autoHeightRatio(0);
        [self.MessageTime_Label setSingleLineAutoResizeWithMaxWidth:KScreenWidth / 2];
        
        // 消息的内容的约束
        self.MessageContent_Label.sd_layout.leftEqualToView(self.MessageName_Label).topSpaceToView(self.MessageName_Label, 10).rightSpaceToView(self.contentView, 10).autoHeightRatio(0);
        [self.MessageContent_Label setMaxNumberOfLinesToShow:1];
    }
    
    return self;
}

/**
 * @brief 数据模型
 */
- (void)setModel:(HSQClassMessageListModel *)model{
    
    _model = model;
    
    // 消息的图片
    self.MessageImageView.image = KImageName(@"E9EB8A8C-F280-4BDC-B704-F17FF9894360");
    
    // 未读消息
    if (model.messageUnreadCount.integerValue >= 99)
    {
        self.messageUnreadCount_label.hidden = NO;

        self.messageUnreadCount_label.text = [NSString stringWithFormat:@"%@",@"99+"];
    }
    else if (model.messageUnreadCount.integerValue < 1)
    {
        self.messageUnreadCount_label.hidden = YES;
    }
    else
    {
        self.messageUnreadCount_label.hidden = NO;

        self.messageUnreadCount_label.text = [NSString stringWithFormat:@"%@",model.messageUnreadCount];
    }
    
    // 消息的名字
    self.MessageName_Label.text = model.name;
    
    // 消息的时间
    self.MessageTime_Label.text = model.addTime;
    
    // 消息的内容
    self.MessageContent_Label.text = model.messageContent;
    
    
    // *********************** 高度自适应cell设置步骤01 ************************
    [self setupAutoHeightWithBottomView:self.MessageContent_Label bottomMargin:10];
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
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
   
}

@end
