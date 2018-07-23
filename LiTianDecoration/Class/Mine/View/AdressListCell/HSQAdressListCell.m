//
//  HSQAdressListCell.m
//  LiTianDecoration
//
//  Created by administrator on 2018/4/25.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import "HSQAdressListCell.h"
#import "HSQAcceptAddressListModel.h"

@interface HSQAdressListCell ()

@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) UILabel *adressLabel;

@property (nonatomic, strong) UIImageView *LineView;

@property (nonatomic, strong) UIButton *Delete_Button;

@property (nonatomic, strong) UIButton *Edit_Button;

@property (nonatomic, strong) UILabel *isDefault_Label;

@end

@implementation HSQAdressListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self SetUpViews];
        
        [self SetUpViewsLayout];
    }
    
    return self;
}

/**
 * @brief 设置控件
 */
- (void)SetUpViews{
    
    // 用户的名字
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.textColor = [UIColor blackColor];
    nameLabel.font = [UIFont systemFontOfSize:15.0];
    [self.contentView addSubview:nameLabel];
    self.nameLabel = nameLabel;
    
    // 用户的地址
    UILabel *adressLabel = [[UILabel alloc] init];
    adressLabel.textColor = [UIColor blackColor];
    adressLabel.font = [UIFont systemFontOfSize:15.0];
    adressLabel.numberOfLines = 0;
    [self.contentView addSubview:adressLabel];
    self.adressLabel = adressLabel;
    
    // 地址是否是默认地址
    UILabel *isDefault_Label = [[UILabel alloc] init];
    isDefault_Label.textColor = [UIColor redColor];
    isDefault_Label.font = [UIFont systemFontOfSize:12.0];
    isDefault_Label.text = @"默认地址";
    [self.contentView addSubview:isDefault_Label];
    self.isDefault_Label = isDefault_Label;
    
    // 分割线
    UIImageView *LineView = [[UIImageView alloc] init];
    LineView.backgroundColor = RGB(180, 180, 180);
    [self.contentView addSubview:LineView];
    self.LineView = LineView;
    
    // 删除按钮
    UIButton *Delete_Button = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [Delete_Button setTitle:@"删除" forState:(UIControlStateNormal)];
    Delete_Button.titleLabel.font = [UIFont systemFontOfSize:14];
    [Delete_Button setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    [Delete_Button setImage:KImageName(@"123") forState:(UIControlStateNormal)];
    [Delete_Button setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
    [Delete_Button addTarget:self action:@selector(Delete_ButtonClickAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.contentView addSubview:Delete_Button];
    self.Delete_Button = Delete_Button;
    
    // 编辑按钮
    UIButton *Edit_Button = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [Edit_Button setTitle:@"编辑" forState:(UIControlStateNormal)];
    Edit_Button.titleLabel.font = [UIFont systemFontOfSize:14];
    [Edit_Button setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    [Edit_Button setImage:KImageName(@"123") forState:(UIControlStateNormal)];
    [Edit_Button setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
    [Edit_Button addTarget:self action:@selector(Edit_ButtonClickAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.contentView addSubview:Edit_Button];
    self.Edit_Button = Edit_Button;
    
}

/**
 * @brief 设置控件的约束
 */
- (void)SetUpViewsLayout{
    
    // 用户的名字
    self.nameLabel.sd_layout.leftSpaceToView(self.contentView, 10).topSpaceToView(self.contentView, 10).rightSpaceToView(self.contentView, 10).heightIs(20);
    
    // 用户的地址
    self.adressLabel.sd_layout.leftEqualToView(self.nameLabel).rightEqualToView(self.nameLabel).topSpaceToView(self.nameLabel, 10).autoHeightRatio(0);
    
    // 分割线
    self.LineView.sd_layout.leftSpaceToView(self.contentView, 50).topSpaceToView(self.adressLabel, 10).rightSpaceToView(self.contentView, 0).heightIs(1);
    
    // 删除按钮
    self.Delete_Button.sd_layout.rightSpaceToView(self.contentView, 15).topSpaceToView(self.LineView, 10).heightIs(30).widthIs(80);
    
    // 编辑按钮
    self.Edit_Button.sd_layout.rightSpaceToView(self.Delete_Button, 20).topEqualToView(self.Delete_Button).bottomEqualToView(self.Delete_Button).widthRatioToView(self.Delete_Button, 1.0);
    
    // 用户的地址是否是默认
    self.isDefault_Label.sd_layout.leftEqualToView(self.nameLabel).centerYEqualToView(self.Delete_Button).widthIs(80).heightIs(20);
    

}

- (void)setModel:(HSQAcceptAddressListModel *)model{
    
    _model = model;
    
    self.nameLabel.text = [NSString stringWithFormat:@"%@        %@",model.realName,model.mobPhone];
    
    self.adressLabel.text = model.adressName;
    
    if (model.isDefault.integerValue == 0) // （0否 1是
    {
        [self.isDefault_Label setHidden:YES];
    }
    else
    {
        [self.isDefault_Label setHidden:NO];
    }
    
    [self setupAutoHeightWithBottomView:self.Delete_Button bottomMargin:10];
}

- (void)setFrame:(CGRect)frame{
    
    frame.origin.y += 5;
    
    frame.size.height -= 10;
    
    [super setFrame:frame];
}

/**
 * @brief 删除按钮的点击事件
 */
- (void)Delete_ButtonClickAction:(UIButton *)sender{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(DeleteTheClickEventOfTheReceivingAddress:)]) {
        
        [self.delegate DeleteTheClickEventOfTheReceivingAddress:sender];
    }
}

/**
 * @brief 编辑按钮的点击事件
 */
- (void)Edit_ButtonClickAction:(UIButton *)sender{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(EditTheClickEventOfTheReceivingAddress:)]) {
        
        [self.delegate EditTheClickEventOfTheReceivingAddress:sender];
    }
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
