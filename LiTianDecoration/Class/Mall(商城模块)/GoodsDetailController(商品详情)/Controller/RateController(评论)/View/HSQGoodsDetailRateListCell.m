//
//  HSQGoodsDetailRateListCell.m
//  LiTianDecoration
//
//  Created by administrator on 2018/5/12.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import "HSQGoodsDetailRateListCell.h"
#import "HSQStarsView.h"
#import "HSQGoodsRateImageView.h"
#import "HSQGoodsRateListModel.h"

@interface HSQGoodsDetailRateListCell ()

@property (nonatomic, strong) UILabel *RateTimeLabel;  // 评论的时间

@property (nonatomic, strong) HSQStarsView *StarView;  // 星星等级

@property (nonatomic, strong) UILabel *GoodsRateContent_Label;  // 商品评价的内容

@property (nonatomic, strong) HSQGoodsRateImageView *GoodsRateImageView;  // 商品评价的图片

@end

@implementation HSQGoodsDetailRateListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        // 1.评论的时间
        UILabel *RateTimeLabel = [[UILabel alloc] init];
        RateTimeLabel.textColor = RGB(150, 150, 150);
        RateTimeLabel.font = [UIFont systemFontOfSize:14];
        RateTimeLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:RateTimeLabel];
        self.RateTimeLabel = RateTimeLabel;
        
        // 2.评论的星星
        HSQStarsView *StarView = [[HSQStarsView alloc] init];
        [self.contentView addSubview:StarView];
        self.StarView = StarView;
        
        // 3商品的评价内容
        UILabel *GoodsRateContent_Label = [[UILabel alloc] init];
        GoodsRateContent_Label.font = [UIFont systemFontOfSize:14];
        GoodsRateContent_Label.numberOfLines = 0;
        [self.contentView addSubview:GoodsRateContent_Label];
        self.GoodsRateContent_Label = GoodsRateContent_Label;
        
        // 4.商品评价的图片
        HSQGoodsRateImageView *GoodsRateImageView = [[HSQGoodsRateImageView alloc] init];
        [self.contentView addSubview:GoodsRateImageView];
        self.GoodsRateImageView = GoodsRateImageView;
        
        [self AddViewLayOut];
    }
    
    return self;
}

/**
 * @brief 添加约束
 */
- (void)AddViewLayOut{
    
    // 商品评论的星级
    self.StarView.sd_layout.leftSpaceToView(self.contentView, 10).topSpaceToView(self.contentView, 10).widthIs((KScreenWidth - 20)/2).heightIs(20);
    
    // 商品的评论时间
    self.RateTimeLabel.sd_layout.leftSpaceToView(self.StarView, 5).rightSpaceToView(self.contentView, 10).centerYEqualToView(self.StarView).heightRatioToView(self.StarView, 1.0);
    
    // 商品的评价内容
    self.GoodsRateContent_Label.sd_layout.leftSpaceToView(self.contentView, 10).topSpaceToView(self.StarView, 10).rightSpaceToView(self.contentView, 10).autoHeightRatio(0);
    
    // 商品的评价图片
    self.GoodsRateImageView.sd_layout.leftSpaceToView(self.contentView, 10).topSpaceToView(self.GoodsRateContent_Label, 10).rightSpaceToView(self.contentView, 10).bottomSpaceToView(self.contentView, 10);
    
    
}

- (void)setModel:(HSQGoodsRateListModel *)model{
    
    _model = model;
    
    // 商品评论的星级
    self.StarView.StarsCount = model.scores;
    
    // 商品的评论时间
    self.RateTimeLabel.text = model.evaluateTimeStr;
    
    // 商品的评价内容
    self.GoodsRateContent_Label.text = model.evaluateContent1;
    
    // 商品的评价图片
    if (model.image1FullList.count != 0)
    {
        self.GoodsRateImageView.hidden = NO;
        self.GoodsRateImageView.photos = model.image1FullList;
    }
    else
    {
        self.GoodsRateImageView.hidden = YES;
    }
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

    // Configure the view for the selected state
}

@end
