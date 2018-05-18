//
//  HSQRateCountCell.m
//  LiTianDecoration
//
//  Created by administrator on 2018/5/15.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import "HSQRateCountCell.h"

@interface HSQRateCountCell ()

@property (nonatomic, strong) UIImageView *RightImageView; // 右边的按钮

@property (nonatomic, strong) UILabel *RateCountLabel;  // 评论数量

@property (nonatomic, strong) UILabel *GoodsRateLabel;  // 好评率

@property (nonatomic, strong) UILabel *NoRatePlacherLabel;  //没有评论的提示文字


@end

@implementation HSQRateCountCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        // 创建视图控件
        [self SetUpView];
        
        // 添加控件约束
        [self SetUpViewLayOut];
    }
    return self;
}
/**
 * @brief 创建视图控件
 */
- (void)SetUpView{
    
    // 右边的三角按钮
    UIImageView *RightImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"C7F2BC79-AC34-4AB0-AAFA-021F9AD47E36"]];
    [self.contentView addSubview:RightImage];
    self.RightImageView = RightImage;
    
    //  好评率
    UILabel *GoodsRateLabel = [[UILabel alloc] init];
    GoodsRateLabel.textColor = [UIColor redColor];
    GoodsRateLabel.font = [UIFont systemFontOfSize:14.0];
    [self.contentView addSubview:GoodsRateLabel];
    self.GoodsRateLabel = GoodsRateLabel;
    
    // 评论数量
    UILabel *RateCountLabel = [[UILabel alloc] init];
    RateCountLabel.textColor = [UIColor blackColor];
    RateCountLabel.font = [UIFont systemFontOfSize:14.0];
    [self.contentView addSubview:RateCountLabel];
    self.RateCountLabel = RateCountLabel;
    
    // 评论数量
    UILabel *NoRatePlacherLabel = [[UILabel alloc] init];
    NoRatePlacherLabel.textColor = [UIColor blackColor];
    NoRatePlacherLabel.font = [UIFont systemFontOfSize:12.0];
    [self.contentView addSubview:NoRatePlacherLabel];
    self.NoRatePlacherLabel = NoRatePlacherLabel;
}

/**
 * @brief 添加控件约束
 */
- (void)SetUpViewLayOut{
    
    // 右边的三角按钮
    self.RightImageView.sd_layout.rightSpaceToView(self.contentView, 10).centerYEqualToView(self.contentView).widthIs(8).heightIs(11);
    
    //  好评率
    self.GoodsRateLabel.sd_layout.rightSpaceToView(self.RightImageView, 10).centerYEqualToView(self.contentView).autoWidthRatio(0).heightIs(20);
    [self.GoodsRateLabel setSingleLineAutoResizeWithMaxWidth:KScreenWidth/2];
    
    // 评论数量
    self.RateCountLabel.sd_layout.leftSpaceToView(self.contentView, 10).centerYEqualToView(self.contentView).autoWidthRatio(0).heightIs(20);
    [self.RateCountLabel setSingleLineAutoResizeWithMaxWidth:KScreenWidth/2];
    
    // 评论数量
    self.NoRatePlacherLabel.sd_layout.leftSpaceToView(self.contentView, 10).rightSpaceToView(self.RightImageView, 10).centerYEqualToView(self.contentView).heightIs(20);
}

/**
 * @brief 数据赋值
 */
- (void)setDataDiction:(NSDictionary *)DataDiction{
    
    _DataDiction = DataDiction;
        
    // 评论的数量
    NSString *ratecount = [NSString stringWithFormat:@"%@",DataDiction[@"evaluateGoodsTotal"]];
    
    if (ratecount.integerValue == 0) // 没有评论数
    {
        [self.RateCountLabel setHidden:YES];
        
        [self.GoodsRateLabel setHidden:YES];
        
        [self.NoRatePlacherLabel setHidden:NO];
        
        // 评论的好评率
        NSString *GoodsRate = @"评论(暂无，购买后来发表评论吧)";
        NSMutableAttributedString *attribeString = [NSString attributedStringWithString:GoodsRate font:[UIFont systemFontOfSize:14.0] range:NSMakeRange(0, 2)];
        self.NoRatePlacherLabel.attributedText = attribeString;
    }
    else
    {
        [self.RateCountLabel setHidden:NO];
        
        [self.GoodsRateLabel setHidden:NO];
        
        [self.NoRatePlacherLabel setHidden:YES];
        
        self.RateCountLabel.text = [NSString stringWithFormat:@"评价(%@)",ratecount];
        
        // 评论的好评率
        NSString *GoodsRate = [NSString stringWithFormat:@"好评率 %@%@",DataDiction[@"groupGoodsDetailVo"][@"goodsRate"],@"%"];
        NSMutableAttributedString *attribeString = [NSString attributedStringWithString:GoodsRate Color:RGB(51, 51, 51) range:NSMakeRange(0, 3)];
        self.GoodsRateLabel.attributedText = attribeString;
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
