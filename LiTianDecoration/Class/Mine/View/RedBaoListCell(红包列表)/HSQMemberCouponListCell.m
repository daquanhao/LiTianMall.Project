//
//  HSQRedEnvelopeListCell.m
//  LiTianDecoration
//
//  Created by administrator on 2018/6/26.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import "HSQMemberCouponListCell.h"
#import "HSQVoucherListModel.h"

@interface HSQMemberCouponListCell ()

@property (nonatomic, strong) UIImageView *storeAvatarUrl_imageView;

@property (nonatomic, strong) UILabel *storeName_Label;

@property (nonatomic, strong) UILabel *endTimeText_Label;

@property (nonatomic, strong) UILabel *voucherPrice_Label;

@property (nonatomic, strong) UILabel *limitAmount_Label; // 优惠券使用时的订单限额

@property (nonatomic, strong) UILabel *voucherUsableClientTypeText_Label; //  可用客户端类型标识

@property (nonatomic, strong) UIImageView *voucherState_imageView;

@end

@implementation HSQMemberCouponListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        UIImageView *voucherState_imageView = [[UIImageView alloc] init];
        [self.contentView addSubview:voucherState_imageView];
        self.voucherState_imageView = voucherState_imageView;
        
        // 店铺的头像
        UIImageView *storeAvatarUrl_imageView = [[UIImageView alloc] init];
        [self.contentView addSubview:storeAvatarUrl_imageView];
        self.storeAvatarUrl_imageView = storeAvatarUrl_imageView;
        
        // 店铺的名字
        UILabel *storeName_Label = [[UILabel alloc] init];
        storeName_Label.textColor = RGB(71, 71, 71);
        storeName_Label.font = [UIFont systemFontOfSize:14.0];
        storeName_Label.numberOfLines = 0;
        [self.contentView addSubview:storeName_Label];
        self.storeName_Label = storeName_Label;
        
        // 优惠券金额
        UILabel *voucherPrice_Label = [[UILabel alloc] init];
        voucherPrice_Label.textColor = [UIColor whiteColor];
        voucherPrice_Label.font = [UIFont systemFontOfSize:14.0];
        voucherPrice_Label.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:voucherPrice_Label];
        self.voucherPrice_Label = voucherPrice_Label;
        
        // 优惠券有限期
        UILabel *endTimeText_Label = [[UILabel alloc] init];
        endTimeText_Label.textColor = RGB(150, 150, 150);
        endTimeText_Label.font = [UIFont systemFontOfSize:12.0];
        endTimeText_Label.numberOfLines = 0;
        [self.contentView addSubview:endTimeText_Label];
        self.endTimeText_Label = endTimeText_Label;
        
        // 优惠券使用时的订单限额
        UILabel *limitAmount_Label = [[UILabel alloc] init];
        limitAmount_Label.textColor = [UIColor whiteColor];
        limitAmount_Label.font = [UIFont systemFontOfSize:12.0];
        limitAmount_Label.numberOfLines = 0;
        limitAmount_Label.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:limitAmount_Label];
        self.limitAmount_Label = limitAmount_Label;
        
        //  可用客户端类型标识
        UILabel *voucherUsableClientTypeText_Label = [[UILabel alloc] init];
        voucherUsableClientTypeText_Label.textColor = [UIColor whiteColor];
        voucherUsableClientTypeText_Label.font = [UIFont systemFontOfSize:12.0];
        voucherUsableClientTypeText_Label.numberOfLines = 0;
        voucherUsableClientTypeText_Label.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:voucherUsableClientTypeText_Label];
        self.voucherUsableClientTypeText_Label = voucherUsableClientTypeText_Label;
        
        // 添加约束
        [self AddLayOut];
        
    }
    
    return self;
}

/**
 * @brief 添加约束
 */
- (void)AddLayOut{
    
    // 店铺的头像
    self.storeAvatarUrl_imageView.sd_layout.leftSpaceToView(self.contentView, 10).centerYEqualToView(self.contentView).widthIs(40).heightEqualToWidth();
    
    // 店铺的名字
    self.storeName_Label.sd_layout.leftSpaceToView(self.storeAvatarUrl_imageView, 10).topSpaceToView(self.contentView, 10).autoWidthRatio(0).autoHeightRatio(0);
    [self.storeName_Label setSingleLineAutoResizeWithMaxWidth:(KScreenWidth - 20) * 0.8];
    
    // 优惠券的金额
    self.voucherPrice_Label.sd_layout.leftSpaceToView(self.storeName_Label, 5).rightSpaceToView(self.contentView, 30).topSpaceToView(self.contentView, 10).autoHeightRatio(0);
    
    // 优惠券的有效期
    self.endTimeText_Label.sd_layout.leftEqualToView(self.storeName_Label).topSpaceToView(self.storeName_Label, 10).autoWidthRatio(0).autoHeightRatio(0);
    [self.endTimeText_Label setSingleLineAutoResizeWithMaxWidth:(KScreenWidth - 20) * 0.8];
    
    // 优惠券满多少可用
    self.limitAmount_Label.sd_layout.rightEqualToView(self.voucherPrice_Label).topSpaceToView(self.voucherPrice_Label, 5).leftSpaceToView(self.endTimeText_Label, 5).autoHeightRatio(0);
    
    // 优惠券的使用场景
    self.voucherUsableClientTypeText_Label.sd_layout.rightEqualToView(self.voucherPrice_Label).topSpaceToView(self.limitAmount_Label, 5).leftSpaceToView(self.contentView, 10).autoHeightRatio(0);
    
    // 优惠券的背景图片
    self.voucherState_imageView.sd_layout.leftSpaceToView(self.contentView, 0).topSpaceToView(self.contentView, 0).rightSpaceToView(self.contentView, 20).bottomEqualToView(self.contentView);
}

/**
 * @brief 数据模型
 */
- (void)setModel:(HSQVoucherListModel *)model{
    
    _model = model;
    
    // 店铺的头像
    [self.storeAvatarUrl_imageView sd_setImageWithURL:[NSURL URLWithString:model.store[@"storeAvatarUrl"]] placeholderImage:KIconPlacherImage];
    
    // 店铺的名字
    self.storeName_Label.text = model.storeName;
    
    // 优惠券有限期
    self.endTimeText_Label.text = [NSString stringWithFormat:@"有效期：%@",model.endTimeText];
    
    // 优惠券金额
    self.voucherPrice_Label.text = [NSString stringWithFormat:@"¥%.2f",model.price.floatValue];
    
    // 优惠券使用时的订单限额
    self.limitAmount_Label.text = [NSString stringWithFormat:@"满%.2f元可用",model.limitAmount.floatValue];
    
    //  可用客户端类型标识
    self.voucherUsableClientTypeText_Label.text = [NSString stringWithFormat:@"%@适用",model.voucherUsableClientTypeText];
    
    // 优惠券的状态
    if (model.voucherState.integerValue == 0)
    {
        self.voucherState_imageView.backgroundColor = [UIColor redColor];
    }
    else
    {
        self.voucherState_imageView.backgroundColor = [UIColor grayColor];
    }
    
    // *********************** 高度自适应cell设置步骤01 ************************
    [self setupAutoHeightWithBottomView:self.voucherUsableClientTypeText_Label bottomMargin:10];
}

- (void)setFrame:(CGRect)frame{
    
    frame.origin.y += 5;
    
    frame.origin.x += 10;
    
    frame.size.height -= 10;
    
    frame.size.width -= 20;
    
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
