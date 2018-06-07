//
//  HSQSubmitOrderGoodsListCell.m
//  LiTianDecoration
//
//  Created by administrator on 2018/5/24.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import "HSQSubmitOrderGoodsListCell.h"
#import "HSQShopCarVCGoodsDataModel.h"
#import "HSQShopCarGoodsTypeListModel.h"
#import "HSQSubmitOrderHomeView.h"

@interface HSQSubmitOrderGoodsListCell ()

@property (nonatomic, strong) UIImageView *GoodsImageView; // 商品的图片

@property (nonatomic, strong) UILabel *GoodsNameLabel; // 商品的名字

@property (nonatomic, strong) HSQSubmitOrderHomeView *GoodsGuiGeListView; // 商品的规格

@end

@implementation HSQSubmitOrderGoodsListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        // 商品的图片
        UIImageView *GoodsImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:GoodsImageView];
        self.GoodsImageView = GoodsImageView;
        
        // 商品的名字
        UILabel *GoodsNameLabel = [[UILabel alloc] init];
        GoodsNameLabel.textColor = RGB(71, 71, 71);
        GoodsNameLabel.numberOfLines = 0;
        GoodsNameLabel.font = [UIFont systemFontOfSize:14.0];
        [self.contentView addSubview:GoodsNameLabel];
        self.GoodsNameLabel = GoodsNameLabel;
        
        // 商品的规格
        HSQSubmitOrderHomeView *GoodsGuiGeListView = [[HSQSubmitOrderHomeView alloc] init];
        [self.contentView addSubview:GoodsGuiGeListView];
        self.GoodsGuiGeListView = GoodsGuiGeListView;
    }
    
    return self;
}


/**
 * @brief 接收数据模型
 */
- (void)setSecondModel:(HSQShopCarVCSecondGoodsDataModel *)SecondModel{
    
    _SecondModel = SecondModel;
    
    // 商品的图片
    [self.GoodsImageView sd_setImageWithURL:[NSURL URLWithString:SecondModel.imageSrc] placeholderImage:KGoodsPlacherImage];
    self.GoodsImageView.frame = CGRectMake(10, 10, KGoodsImageShopCaHeight, KGoodsImageShopCaHeight);
    
    // 商品的名字
    self.GoodsNameLabel.text = [NSString stringWithFormat:@"%@",SecondModel.goodsName];
    CGSize GoodsName_Size = [NSString SizeOfTheText:self.GoodsNameLabel.text font:[UIFont systemFontOfSize:14] MaxSize:CGSizeMake(KScreenWidth - CGRectGetMaxX(self.GoodsImageView.frame) - 20, MAXFLOAT)];
    self.GoodsNameLabel.frame = CGRectMake(CGRectGetMaxX(self.GoodsImageView.frame)+10, 10, KScreenWidth - CGRectGetMaxX(self.GoodsImageView.frame) - 20 , GoodsName_Size.height);
    
    // 商品的规格
    self.GoodsGuiGeListView.GuiGeData_Array = SecondModel.buyGoodsItemVoListSource;
    CGSize photosSize = [HSQSubmitOrderHomeView SizeWithDataModelArray:SecondModel.buyGoodsItemVoListSource];
    self.GoodsGuiGeListView.frame = CGRectMake(0, CGRectGetMaxY(self.GoodsImageView.frame)+10, photosSize.width, photosSize.height);
    
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
