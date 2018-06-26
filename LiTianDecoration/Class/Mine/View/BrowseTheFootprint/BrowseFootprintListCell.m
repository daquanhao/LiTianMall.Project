//
//  BrowseFootprintListCell.m
//  LiTianDecoration
//
//  Created by administrator on 2018/4/27.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import "BrowseFootprintListCell.h"
#import "BrowseFootprintListModel.h"

@interface BrowseFootprintListCell ()

@property (nonatomic, strong) UIImageView *GoodsImageView;

@property (nonatomic, strong) UILabel *GoodsName_Label;

@property (nonatomic, strong) UILabel *GoodsPrice_Label;

@end

@implementation BrowseFootprintListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        // 1.商品的图片
        UIImageView *GoodsImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:GoodsImageView];
        self.GoodsImageView = GoodsImageView;
        
        // 2.商品的名字
        UILabel *nameLabel = [[UILabel alloc] init];
        nameLabel.font = [UIFont systemFontOfSize:12.0];
        nameLabel.textColor = RGB(51, 51, 51);
        nameLabel.numberOfLines = 0;
        nameLabel.text = @"我的苹果手机";
        [self.contentView addSubview:nameLabel];
        self.GoodsName_Label = nameLabel;
        
        // 3.商品的价格
        UILabel *GoodsPriceLabel = [[UILabel alloc] init];
        GoodsPriceLabel.font = [UIFont systemFontOfSize:14.0];
        GoodsPriceLabel.textColor = RGB(238, 48, 51);
        GoodsPriceLabel.numberOfLines = 0;
        [self.contentView addSubview:GoodsPriceLabel];
        self.GoodsPrice_Label = GoodsPriceLabel;
        
        // 6.设置控件的约束
        [self SetsTheConstraintForTheControl];
    }
    
    return self;
}

/**
 * @brief 设置控件的约束
 */
- (void)SetsTheConstraintForTheControl{
    
    // 1.商品的图片
    self.GoodsImageView.sd_layout.leftSpaceToView(self.contentView, 5).topSpaceToView(self.contentView, 5).bottomSpaceToView(self.contentView, 5).widthEqualToHeight();
    
    // 2.商品的名字
    self.GoodsName_Label.sd_layout.leftSpaceToView(self.GoodsImageView, 10).topEqualToView(self.GoodsImageView).rightSpaceToView(self.contentView, 10).autoHeightRatio(0);
    
    // 3.商品的价格
    self.GoodsPrice_Label.sd_layout.leftSpaceToView(self.GoodsImageView, 10).bottomEqualToView(self.GoodsImageView).rightSpaceToView(self.contentView, 10).autoHeightRatio(0);
    
    
}

- (void)setModel:(BrowseFootprintListModel *)model{
    
    _model = model;
    
    // 商品的图片
    [self.GoodsImageView sd_setImageWithURL:[NSURL URLWithString:model.goodsCommon[@"imageSrc"]] placeholderImage:KGoodsPlacherImage];
    
    // 商品的名字
    self.GoodsName_Label.text = model.goodsName;
    
    // 商品的价格
    self.GoodsPrice_Label.text = [NSString stringWithFormat:@"¥%@",model.goodsCommon[@"appPrice0"]];
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
