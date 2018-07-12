//
//  HSQLookUpAllCommentViewCell.m
//  LiTianDecoration
//
//  Created by administrator on 2018/7/3.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import "HSQLookUpAllCommentViewCell.h"

@interface HSQLookUpAllCommentViewCell ()

@property (nonatomic, strong) UIButton *LookUp_Btn;

@end

@implementation HSQLookUpAllCommentViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        UIButton *LookUp_Btn = [UIButton buttonWithType:(UIButtonTypeSystem)];
        
        LookUp_Btn.layer.borderWidth = 1;
        
        LookUp_Btn.layer.borderColor = RGB(150, 150, 150).CGColor;
        
        [LookUp_Btn setTitle:@"" forState:(UIControlStateDisabled)];
        
        LookUp_Btn.enabled = NO;
        
        [LookUp_Btn setTitleColor:RGB(150, 150, 150) forState:(UIControlStateDisabled)];
        
        LookUp_Btn.titleLabel.font = [UIFont systemFontOfSize:KLabelFont(14.0, 12.0)];
        
        [self.contentView addSubview:LookUp_Btn];
        
        self.LookUp_Btn = LookUp_Btn;
        
        self.LookUp_Btn.sd_layout.leftSpaceToView(self.contentView, 20).rightSpaceToView(self.contentView, 20).centerYEqualToView(self.contentView).heightIs(30);
    }
    
    return self;
}

/**
 * @biref 数据
 */
- (void)setDatas:(NSDictionary *)datas{
    
    _datas = datas;
    
    [self.LookUp_Btn setTitle:[NSString stringWithFormat:@"全部评论（%@）",datas[@"evaluateGoodsTotal"]] forState:(UIControlStateDisabled)];
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
