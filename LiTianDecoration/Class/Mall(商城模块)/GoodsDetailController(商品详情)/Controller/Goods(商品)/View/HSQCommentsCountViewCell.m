//
//  HSQCommentsCountViewCell.m
//  LiTianDecoration
//
//  Created by administrator on 2018/7/3.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import "HSQCommentsCountViewCell.h"

@interface HSQCommentsCountViewCell ()

/**
 * @brief 评论数量
 */
@property (nonatomic, strong) UILabel *CommentsCount_Label;

/**
 * @brief 好评率
 */
@property (nonatomic, strong) UILabel *goodsRate_Label;

/**
 * @brief 三角按钮
 */
@property (nonatomic, strong) UIImageView *SanJiao_ImageView;  

@end

@implementation HSQCommentsCountViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        //
        UIImageView *SanJiao_ImageView = [[UIImageView alloc] initWithImage:KImageName(@"C7F2BC79-AC34-4AB0-AAFA-021F9AD47E36")];
        [self.contentView addSubview:SanJiao_ImageView];
        self.SanJiao_ImageView = SanJiao_ImageView;
        
        // 评论数量
        UILabel *CommentsCount_Label = [[UILabel alloc] init];
        CommentsCount_Label.textColor = RGB(150, 150, 150);
        CommentsCount_Label.font = [UIFont systemFontOfSize:KLabelFont(14.0, 12.0)];
        [self.contentView addSubview:CommentsCount_Label];
        self.CommentsCount_Label = CommentsCount_Label;
        
        // 好评论
        UILabel *goodsRate_Label = [[UILabel alloc] init];
        goodsRate_Label.textColor = RGB(238, 68, 68);
        goodsRate_Label.font = [UIFont systemFontOfSize:KLabelFont(14.0, 12.0)];
        goodsRate_Label.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:goodsRate_Label];
        self.goodsRate_Label = goodsRate_Label;
        
        // 添加约束
        self.SanJiao_ImageView.sd_layout.rightSpaceToView(self.contentView, 10).centerYEqualToView(self.contentView).widthIs(8).heightIs(13);
        
        self.CommentsCount_Label.sd_layout.leftSpaceToView(self.contentView, 10).centerYEqualToView(self.contentView).autoWidthRatio(0).autoHeightRatio(0);
        [self.CommentsCount_Label setSingleLineAutoResizeWithMaxWidth:KScreenWidth / 2];
        
        self.goodsRate_Label.sd_layout.leftSpaceToView(self.CommentsCount_Label, 10).centerYEqualToView(self.contentView).rightSpaceToView(self.SanJiao_ImageView, 10).autoHeightRatio(0);
        
    }
    
    return self;
}

/**
 * @biref 数据
 */
- (void)setDatas:(NSDictionary *)datas{
    
    _datas = datas;
    
    // 评论的数量
    NSString *evaluateGoodsTotal = [NSString stringWithFormat:@"%@",datas[@"evaluateGoodsTotal"]];
    
    if (evaluateGoodsTotal.integerValue == 0) // 没有任何评论
    {
        self.CommentsCount_Label.text = @"评论";
        
        self.goodsRate_Label.hidden = YES;
    }
    else
    {
        self.goodsRate_Label.hidden = NO;
        
        self.CommentsCount_Label.text = (evaluateGoodsTotal.length == 0 ? @"评论" : [NSString stringWithFormat:@"评价(%@)",evaluateGoodsTotal]);
        
        // 好评率
        NSString *goodsRate = [NSString stringWithFormat:@"%@",datas[@"goodsDetail"][@"goodsRate"]];
        
        NSString *GoodsRate = [NSString stringWithFormat:@"好评率 %.2f%@",goodsRate.floatValue,@"%"];
        
        NSMutableAttributedString *attribeString = [NSString attributedStringWithString:GoodsRate Color:RGB(150, 150, 150) range:NSMakeRange(0, 3)];
        
        self.goodsRate_Label.attributedText = attribeString;
    }
}

- (void)setFrame:(CGRect)frame{
    
    frame.origin.y += 10;
    
    frame.size.height -= 10;
    
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
