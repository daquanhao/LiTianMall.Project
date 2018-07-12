//
//  HSQCouponRedemptionViewCell.m
//  LiTianDecoration
//
//  Created by administrator on 2018/7/3.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import "HSQCouponRedemptionViewCell.h"
#import "HSQVoucherListModel.h"  // 店铺优惠券数据模型

@interface HSQCouponRedemptionViewCell ()

@property (nonatomic, strong) UILabel *Placher_Label; // 领券的提示语

@property (nonatomic, strong) UIImageView *SanDian_ImageView; // 右边的图片

@property (nonatomic, strong) UILabel *FirstCoupon_Label; // 第一张优惠券

@property (nonatomic, strong) UILabel *SecondCoupon_Label; // 第二张优惠券

@property (nonatomic, strong) UILabel *ThirdCoupon_Label; // 第三张优惠券

@end

@implementation HSQCouponRedemptionViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        // 提示语
        UILabel *Placher_Label = [[UILabel alloc] init];
        Placher_Label.textColor = RGB(150, 150, 150);
        Placher_Label.font = [UIFont systemFontOfSize:KLabelFont(14.0, 12.0)];
        Placher_Label.text = @"领券";
        [self.contentView addSubview:Placher_Label];
        self.Placher_Label = Placher_Label;
        
        // 右边的图片
        UIImageView *SanDian_ImageView = [[UIImageView alloc] initWithImage:KImageName(@"RightItemImage")];
        [self.contentView addSubview:SanDian_ImageView];
        self.SanDian_ImageView = SanDian_ImageView;
        
        // 第一张优惠券
        UILabel *FirstCoupon_Label = [[UILabel alloc] init];
        FirstCoupon_Label.textColor = [UIColor blackColor];
        FirstCoupon_Label.font = [UIFont systemFontOfSize:KLabelFont(14.0, 12.0)];
        [self.contentView addSubview:FirstCoupon_Label];
        self.FirstCoupon_Label = FirstCoupon_Label;
        
        // 第二张优惠券
        UILabel *SecondCoupon_Label = [[UILabel alloc] init];
        SecondCoupon_Label.textColor = [UIColor blackColor];
        SecondCoupon_Label.font = [UIFont systemFontOfSize:KLabelFont(14.0, 12.0)];
        [self.contentView addSubview:SecondCoupon_Label];
        self.SecondCoupon_Label = SecondCoupon_Label;
        
        // 第三张优惠券
        UILabel *ThirdCoupon_Label = [[UILabel alloc] init];
        ThirdCoupon_Label.textColor = [UIColor blackColor];
        ThirdCoupon_Label.font = [UIFont systemFontOfSize:KLabelFont(14.0, 12.0)];
        [self.contentView addSubview:ThirdCoupon_Label];
        self.ThirdCoupon_Label = ThirdCoupon_Label;
        
        // 提示语的约束
        self.Placher_Label.sd_layout.leftSpaceToView(self.contentView, 10).centerYEqualToView(self.contentView).autoWidthRatio(0).autoHeightRatio(0);
        [self.Placher_Label setSingleLineAutoResizeWithMaxWidth:100];
        
        // 右边的图片的约束
        self.SanDian_ImageView.sd_layout.rightSpaceToView(self.contentView, 10).centerYEqualToView(self.contentView).widthIs(25).heightIs(5);
        
        // 第一张优惠券
        self.FirstCoupon_Label.sd_layout.leftSpaceToView(self.Placher_Label, 5).centerYEqualToView(self.contentView).autoWidthRatio(0).autoHeightRatio(0);
        [self.FirstCoupon_Label setSingleLineAutoResizeWithMaxWidth:(KScreenWidth - 100) / 3];
        
        // 第二张优惠券
        self.SecondCoupon_Label.sd_layout.leftSpaceToView(self.FirstCoupon_Label, 5).centerYEqualToView(self.contentView).autoWidthRatio(0).autoHeightRatio(0);
        [self.SecondCoupon_Label setSingleLineAutoResizeWithMaxWidth:(KScreenWidth - 100) / 3];

        // 第三张优惠券
        self.ThirdCoupon_Label.sd_layout.leftSpaceToView(self.SecondCoupon_Label, 5).centerYEqualToView(self.contentView).rightSpaceToView(self.SanDian_ImageView, 5).autoHeightRatio(0);
    }
    
    return self;
}

/**
 * @brief 优惠券数据数组
 */
- (void)setVoucherTemplateList:(NSMutableArray *)voucherTemplateList{
    
    _voucherTemplateList = voucherTemplateList;
    
    if (voucherTemplateList.count == 1)
    {
        HSQVoucherListModel *model = voucherTemplateList[0];
        self.FirstCoupon_Label.text = [NSString stringWithFormat:@"满%@减%@",model.templatePrice,model.limitAmount];
    }
    else if (voucherTemplateList.count == 2)
    {
        HSQVoucherListModel *model = voucherTemplateList[0];
        self.FirstCoupon_Label.text = [NSString stringWithFormat:@"满%@减%@",model.templatePrice,model.limitAmount];
        
        HSQVoucherListModel *model02 = voucherTemplateList[1];
        self.SecondCoupon_Label.text = [NSString stringWithFormat:@"满%@减%@",model02.templatePrice,model02.limitAmount];
    }
    else if (voucherTemplateList.count == 3)
    {
        HSQVoucherListModel *model = voucherTemplateList[0];
        self.FirstCoupon_Label.text = [NSString stringWithFormat:@"满%@减%@",model.templatePrice,model.limitAmount];
        
        HSQVoucherListModel *model02 = voucherTemplateList[1];
        self.SecondCoupon_Label.text = [NSString stringWithFormat:@"满%@减%@",model02.templatePrice,model02.limitAmount];
        
        HSQVoucherListModel *model03 = voucherTemplateList[2];
        self.ThirdCoupon_Label.text = [NSString stringWithFormat:@"满%@减%@",model03.templatePrice,model03.limitAmount];
    }
    
}

- (void)setFrame:(CGRect)frame{
    
    frame.origin.y += 5;
    
    frame.size.height -= 10;
    
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
