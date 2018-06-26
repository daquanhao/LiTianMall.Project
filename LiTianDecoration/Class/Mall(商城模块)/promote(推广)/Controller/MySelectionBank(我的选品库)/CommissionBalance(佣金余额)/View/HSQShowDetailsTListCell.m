//
//  HSQShowDetailsTListCell.m
//  LiTianDecoration
//
//  Created by administrator on 2018/6/15.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import "HSQShowDetailsTListCell.h"

@interface HSQShowDetailsTListCell ()

@end

@implementation HSQShowDetailsTListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        // 状态提示文字
        UILabel *StatePlacher_Label = [[UILabel alloc] init];
        StatePlacher_Label.font = [UIFont systemFontOfSize:12.0];
        [self.contentView addSubview:StatePlacher_Label];
        self.StatePlacher_Label = StatePlacher_Label;
        
        // 状态提示文字
        UILabel *State_Label = [[UILabel alloc] init];
        State_Label.font = [UIFont systemFontOfSize:12.0];
        State_Label.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:State_Label];
        self.State_Label = State_Label;
        
        self.StatePlacher_Label.sd_layout.leftSpaceToView(self.contentView, 10).topSpaceToView(self.contentView, 0).bottomSpaceToView(self.contentView, 0).autoWidthRatio(0);
        [self.StatePlacher_Label setSingleLineAutoResizeWithMaxWidth:120];
        
        self.State_Label.sd_layout.leftSpaceToView(self.StatePlacher_Label, 10).topSpaceToView(self.contentView, 0).bottomSpaceToView(self.contentView, 0).rightSpaceToView(self.contentView, 10);
    }
    
    return self;
}


















- (void)setFrame:(CGRect)frame{
    
    frame.origin.y += 1;
    
    frame.size.height -= 2;
    
    [super setFrame:frame];
}

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];

    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

@end
