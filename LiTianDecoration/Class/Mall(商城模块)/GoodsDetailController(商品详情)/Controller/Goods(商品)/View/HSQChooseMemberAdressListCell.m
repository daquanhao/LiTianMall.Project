//
//  HSQChooseMemberAdressListCell.m
//  LiTianDecoration
//
//  Created by administrator on 2018/7/6.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import "HSQChooseMemberAdressListCell.h"
#import "HSQAcceptAddressListModel.h"

@interface HSQChooseMemberAdressListCell ()

@property (nonatomic, strong) UIImageView *adress_ImageView;

@property (nonatomic, strong) UIView *LineView;

@end

@implementation HSQChooseMemberAdressListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        UIView *LineView = [[UIView alloc] init];
        LineView.backgroundColor = KViewBackGroupColor;
        [self.contentView addSubview:LineView];
        self.LineView = LineView;
        
        UIImageView *adress_ImageView = [[UIImageView alloc] init];
        adress_ImageView.image = KImageName(@"DingWeiIcon");
        [self.contentView addSubview:adress_ImageView];
        self.adress_ImageView = adress_ImageView;
        
        UILabel *adress_Label = [[UILabel alloc] init];
        adress_Label.font = [UIFont systemFontOfSize:KLabelFont(14.0, 12.0)];
        adress_Label.textColor = RGB(71, 71, 71);
        adress_Label.numberOfLines = 0;
        [self.contentView addSubview:adress_Label];
        self.adress_Label = adress_Label;
        
        UIImageView *RightAdress_Image = [[UIImageView alloc] init];
        RightAdress_Image.image = KImageName(@"320A9B4D-0268-49C1-845B-7E3AABAB72BC");
        [self.contentView addSubview:RightAdress_Image];
        self.RightAdress_Image = RightAdress_Image;
        
        // 添加约束
        self.LineView.sd_layout.leftSpaceToView(self.contentView, 0).topSpaceToView(self.contentView, 0).rightSpaceToView(self.contentView, 0).heightIs(2);
        
        self.adress_ImageView.sd_layout.leftSpaceToView(self.contentView, 10).centerYEqualToView(self.contentView).widthIs(13).heightIs(16);
        
        self.RightAdress_Image.sd_layout.rightSpaceToView(self.contentView, 10).centerYEqualToView(self.contentView).widthIs(20).heightEqualToWidth();
        
        self.adress_Label.sd_layout.leftSpaceToView(self.adress_ImageView, 10).topSpaceToView(self.contentView, 10).rightSpaceToView(self.RightAdress_Image, 10).autoHeightRatio(0);
    }
    return self;
}

- (void)setModel:(HSQAcceptAddressListModel *)model{
    
    _model = model;
    
    self.adress_Label.text = model.adressName;
    
    HSQLog(@"=没有选中=%@",model.Select_string);
    
    if (model.Select_string.integerValue == 1) // 选中
    {
        self.adress_Label.textColor = RGB(238, 58, 68);
        
        self.RightAdress_Image.hidden = NO;
    }
    else
    {
        self.adress_Label.textColor = RGB(71, 71, 71);
        
        self.RightAdress_Image.hidden = YES;
    }
    
    [self setupAutoHeightWithBottomView:self.adress_Label bottomMargin:10];
    
}

//- (void)setFrame:(CGRect)frame{
//
//    frame.origin.y += 3;
//
//    frame.size.height -= 6;
//
//    [super setFrame:frame];
//}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];

    
}

@end
