//
//  HSQMessageDetailListHeaderView.m
//  LiTianDecoration
//
//  Created by administrator on 2018/7/2.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import "HSQMessageDetailListHeaderView.h"

@implementation HSQMessageDetailListHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        
        UILabel *MessageTime_Label = [[UILabel alloc] init];
        
        MessageTime_Label.font = [UIFont systemFontOfSize:KLabelFont(14.0, 12.0)];
        
        MessageTime_Label.textColor = RGB(71, 71, 71);
        
        [self.contentView addSubview:MessageTime_Label];
        
        self.MessageTime_Label = MessageTime_Label;
        
        self.MessageTime_Label.sd_layout.leftSpaceToView(self.contentView, 10).topSpaceToView(self.contentView, 0).rightSpaceToView(self.contentView, 10).bottomSpaceToView(self.contentView, 0);
    }
    
    return self;
}

@end
