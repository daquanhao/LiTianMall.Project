//
//  HSQSubmitGoodsFooterCell.m
//  LiTianDecoration
//
//  Created by administrator on 2018/7/10.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import "HSQSubmitGoodsFooterCell.h"

@interface HSQSubmitGoodsFooterCell ()

@end

@implementation HSQSubmitGoodsFooterCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        // 提示图标
        UIImageView *Right_ImageView = [[UIImageView alloc] init];
        Right_ImageView.image = KImageName(@"C7F2BC79-AC34-4AB0-AAFA-021F9AD47E36");
        [self.contentView addSubview:Right_ImageView];
        self.Right_ImageView = Right_ImageView;
        
        // 左边的提示label
        UILabel *Placher_Label = [[UILabel alloc] init];
        Placher_Label.textColor = [UIColor blackColor];
        Placher_Label.font = [UIFont systemFontOfSize:KLabelFont(14.0, 12.0)];
        [self.contentView addSubview:Placher_Label];
        self.Placher_Label = Placher_Label;
        
        // 左边的提示label
        UILabel *Text_Label = [[UILabel alloc] init];
        Text_Label.textColor = [UIColor blackColor];
        Text_Label.textAlignment = NSTextAlignmentRight;
        Text_Label.font = [UIFont systemFontOfSize:KLabelFont(14.0, 12.0)];
        [self.contentView addSubview:Text_Label];
        self.Text_Label = Text_Label;
        
        // 添加约束
        self.Right_ImageView.sd_layout.rightSpaceToView(self.contentView, 10).centerYEqualToView(self.contentView).widthIs(8).heightIs(13);
        
        self.Placher_Label.sd_layout.leftSpaceToView(self.contentView, 10).centerYEqualToView(self.contentView).autoWidthRatio(0).autoHeightRatio(0);
        [self.Placher_Label setSingleLineAutoResizeWithMaxWidth:200];
        
        self.Text_Label.sd_layout.leftSpaceToView(self.Placher_Label, 10).centerYEqualToView(self.contentView).rightSpaceToView(self.Right_ImageView, 10).autoHeightRatio(0);
    }
    
    return self;
}

- (void)setFrame:(CGRect)frame{
    
    frame.origin.y += 2;
    
    frame.size.height -= 4;
    
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
