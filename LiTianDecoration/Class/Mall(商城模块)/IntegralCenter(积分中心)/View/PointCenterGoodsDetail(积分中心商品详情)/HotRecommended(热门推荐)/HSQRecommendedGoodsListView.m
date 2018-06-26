//
//  HSQRecommendedGoodsListView.m
//  LiTianDecoration
//
//  Created by administrator on 2018/6/21.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import "HSQRecommendedGoodsListView.h"
#import "HSQPointsExchangeGoodsListModel.h"

@interface HSQRecommendedGoodsListView ()

@property (nonatomic, strong) UIImageView *GoodsImageView;

@property (nonatomic, strong) UILabel *GoodsName_label;

@property (nonatomic, strong) UILabel *Point_Label;


@end

@implementation HSQRecommendedGoodsListView

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        // 商品的图片
        UIImageView *GoodsImageView = [[UIImageView alloc] init];
        [self addSubview:GoodsImageView];
        self.GoodsImageView = GoodsImageView;
        
        // 商品的名字
        UILabel *GoodsName_label = [[UILabel alloc] init];
        GoodsName_label.textColor = RGB(71, 71, 71);
        GoodsName_label.font = [UIFont systemFontOfSize:12.0];
        [self addSubview:GoodsName_label];
        self.GoodsName_label = GoodsName_label;
        
        // 商品的积分
        UILabel *Point_Label = [[UILabel alloc] init];
        Point_Label.textColor = [UIColor blackColor];
        Point_Label.font = [UIFont systemFontOfSize:12.0];
        [self addSubview:Point_Label];
        self.Point_Label = Point_Label;
        
        
        // 商品的图片的约束
        self.GoodsImageView.sd_layout.topSpaceToView(self, 0).leftSpaceToView(self, 5).rightSpaceToView(self, 5).heightEqualToWidth();
        
        // 商品的名字的约束
        self.GoodsName_label.sd_layout.leftSpaceToView(self, 5).topSpaceToView(self.GoodsImageView, 5).rightSpaceToView(self, 5).autoHeightRatio(0);
        
        [self.GoodsName_label setMaxNumberOfLinesToShow:1];
        
        // 商品的积分的约束
        self.Point_Label.sd_layout.leftEqualToView(self.GoodsName_label).topSpaceToView(self.GoodsName_label, 5).rightEqualToView(self.GoodsName_label).autoHeightRatio(0);

    }
    
    return self;
}

/**
 * @brief 数据模型
 */
- (void)setModel:(HSQPointsExchangeGoodsListModel *)model{
    
    _model = model;
    
    // 商品的图片
    [self.GoodsImageView sd_setImageWithURL:[NSURL URLWithString:model.imageSrc] placeholderImage:KGoodsPlacherImage];
    
    // 商品的名字
    self.GoodsName_label.text = model.goodsName;
    
    // 兑换商品所需的积分
    self.Point_Label.text = [NSString stringWithFormat:@"%@积分",model.expendPoints];
}








@end
