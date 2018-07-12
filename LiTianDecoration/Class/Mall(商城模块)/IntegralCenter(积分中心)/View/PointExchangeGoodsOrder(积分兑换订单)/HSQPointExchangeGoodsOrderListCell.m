//
//  HSQPointExchangeGoodsOrderListCell.m
//  LiTianDecoration
//
//  Created by administrator on 2018/6/22.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import "HSQPointExchangeGoodsOrderListCell.h"
#import "HSQPointsOrdersListModel.h"

@interface HSQPointExchangeGoodsOrderListCell ()

@property (nonatomic, strong) UIImageView *Goods_ImageView;

@property (nonatomic, strong) UILabel *GoodsName_Label;

@property (nonatomic, strong) UILabel *goodsFullSpecs_Label;

@property (nonatomic, strong) UILabel *BuyNum_Label;

@property (nonatomic, strong) UILabel *expendPoints_Label;

@end

@implementation HSQPointExchangeGoodsOrderListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        // 店铺的图片
        UIImageView *Goods_ImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:Goods_ImageView];
        self.Goods_ImageView = Goods_ImageView;
        
        // 商品的名字
        UILabel *GoodsName_Label = [[UILabel alloc] init];
        GoodsName_Label.textColor = [UIColor blackColor];
        GoodsName_Label.font = [UIFont systemFontOfSize:12.0];
        GoodsName_Label.numberOfLines = 0;
        [self.contentView addSubview:GoodsName_Label];
        self.GoodsName_Label = GoodsName_Label;
        
        // 商品的兑换积分
        UILabel *expendPoints_Label = [[UILabel alloc] init];
        expendPoints_Label.textColor = [UIColor blackColor];
        expendPoints_Label.font = [UIFont systemFontOfSize:12.0];
        expendPoints_Label.numberOfLines = 0;
        [self.contentView addSubview:expendPoints_Label];
        self.expendPoints_Label = expendPoints_Label;
        
        // 商品的规格
        UILabel *goodsFullSpecs_Label = [[UILabel alloc] init];
        goodsFullSpecs_Label.textColor = RGB(150, 150, 150);
        goodsFullSpecs_Label.font = [UIFont systemFontOfSize:10.0];
        goodsFullSpecs_Label.numberOfLines = 0;
        [self.contentView addSubview:goodsFullSpecs_Label];
        self.goodsFullSpecs_Label = goodsFullSpecs_Label;
        
        // 商品的购买数量
        UILabel *BuyNum_Label = [[UILabel alloc] init];
        BuyNum_Label.textColor = RGB(150, 150, 150);
        BuyNum_Label.font = [UIFont systemFontOfSize:12.0];
        BuyNum_Label.numberOfLines = 0;
        [self.contentView addSubview:BuyNum_Label];
        self.BuyNum_Label = BuyNum_Label;
        
        // 添加的约束
        self.Goods_ImageView.sd_layout.leftSpaceToView(self.contentView, 10).centerYEqualToView(self.contentView).heightIs(60).widthEqualToHeight();
        
        self.expendPoints_Label.sd_layout.rightSpaceToView(self.contentView, 10).topSpaceToView(self.contentView, 10).autoHeightRatio(0).autoWidthRatio(0);
        [self.expendPoints_Label setSingleLineAutoResizeWithMaxWidth:120];
        
        self.GoodsName_Label.sd_layout.leftSpaceToView(self.Goods_ImageView, 5).topSpaceToView(self.contentView, 10).rightSpaceToView(self.expendPoints_Label, 5).autoHeightRatio(0);
        
        self.BuyNum_Label.sd_layout.rightEqualToView(self.expendPoints_Label).topSpaceToView(self.GoodsName_Label, 10).autoHeightRatio(0).autoWidthRatio(0);
        [self.BuyNum_Label setSingleLineAutoResizeWithMaxWidth:120];
        
        self.goodsFullSpecs_Label.sd_layout.leftEqualToView(self.GoodsName_Label).topEqualToView(self.BuyNum_Label).rightSpaceToView(self.BuyNum_Label, 10).autoHeightRatio(0);
        
    }
    
    return self;
}



- (void)setModel:(HSQPointsOrdersListModel *)model{
    
    _model = model;
    
    // 商品的图片
    [self.Goods_ImageView sd_setImageWithURL:[NSURL URLWithString:model.imageSrc] placeholderImage:KGoodsPlacherImage];
    
    // 商品的名字
    self.GoodsName_Label.text = model.goodsName;
    
    // 商品的规格
    self.goodsFullSpecs_Label.text = model.goodsFullSpecs;
    
    // 商品的兑换积分
    self.expendPoints_Label.text = [NSString stringWithFormat:@"%@积分",model.expendPoints];
    
    // 商品的购买数量
    self.BuyNum_Label.text = [NSString stringWithFormat:@"X%@",model.buyNum];
    
     [self setupAutoHeightWithBottomView:self.goodsFullSpecs_Label bottomMargin:10];
    
}

- (void)setFrame:(CGRect)frame{
    
    frame.origin.y += 1;
    
    frame.size.height -= 2;
    
    [super setFrame:frame];
}

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
