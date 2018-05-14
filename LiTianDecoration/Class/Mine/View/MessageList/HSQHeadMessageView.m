
//
//  HSQHeadMessageView.m
//  LiTianDecoration
//
//  Created by administrator on 2018/4/26.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import "HSQHeadMessageView.h"
#import "HSQMessageReceiveModel.h"

@interface HSQHeadMessageView ()

@end

@implementation HSQHeadMessageView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        
        UILabel *nameLabel = [[UILabel alloc] init];
        nameLabel.font = [UIFont systemFontOfSize:14.0];
        nameLabel.textColor = RGB(33, 33, 33);
        [self.contentView addSubview:nameLabel];
        self.nameLabel = nameLabel;
        
        self.nameLabel.sd_layout.leftSpaceToView(self.contentView, 15).topSpaceToView(self.contentView, 0).rightSpaceToView(self.contentView, 0).bottomSpaceToView(self.contentView, 0);
    }
    
    return self;
}

- (void)setModel:(HSQMessageReceiveModel *)model{
    
    _model = model;
    
    self.nameLabel.text = model.name;
}














@end
