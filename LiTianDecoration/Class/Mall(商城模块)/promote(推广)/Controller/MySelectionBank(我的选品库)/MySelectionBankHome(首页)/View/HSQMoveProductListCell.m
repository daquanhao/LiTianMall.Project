//
//  HSQMoveProductListCell.m
//  LiTianDecoration
//
//  Created by administrator on 2018/6/14.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import "HSQMoveProductListCell.h"
#import "HSQSelectionListModel.h"
#import "HSQSelectGroupImageListView.h"

@interface HSQMoveProductListCell ()

@property (nonatomic, strong) UILabel *GoodsCount_Label;

@property (nonatomic, strong) UILabel *distributorFavoritesName;

@property (nonatomic, strong) HSQSelectGroupImageListView *SelectGroupImageListView;  // 商品评价的图片

@end

@implementation HSQMoveProductListCell

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        // 分组的名字
        UILabel *distributorFavoritesName = [[UILabel alloc] init];
        distributorFavoritesName.textColor = RGB(74, 74, 74);
        distributorFavoritesName.font = [UIFont systemFontOfSize:12.0];
        [self.contentView addSubview:distributorFavoritesName];
        self.distributorFavoritesName = distributorFavoritesName;
        
        // 商品的数量
        UILabel *GoodsCount_Label = [[UILabel alloc] init];
        GoodsCount_Label.textColor = RGB(238, 58, 68);
        GoodsCount_Label.font = [UIFont systemFontOfSize:12.0];
        [self.contentView addSubview:GoodsCount_Label];
        self.GoodsCount_Label = GoodsCount_Label;
        
        // 选品库中商品
        HSQSelectGroupImageListView *SelectGroupImageListView = [[HSQSelectGroupImageListView alloc] init];
        [self.contentView addSubview:SelectGroupImageListView];
        self.SelectGroupImageListView = SelectGroupImageListView;
        
        // 分组的名字
        self.distributorFavoritesName.sd_layout.leftSpaceToView(self.contentView, 10).topSpaceToView(self.contentView, 5).rightSpaceToView(self.contentView, 10).autoHeightRatio(0);
        
        // 商品的数量
        self.GoodsCount_Label.sd_layout.leftEqualToView(self.distributorFavoritesName).topSpaceToView(self.distributorFavoritesName, 10).rightSpaceToView(self.contentView, 10).autoHeightRatio(0);
        
        // 选品库中商品
        self.SelectGroupImageListView.sd_layout.leftSpaceToView(self.contentView, 5).topSpaceToView(self.GoodsCount_Label, 10).rightSpaceToView(self.contentView, 5).bottomSpaceToView(self.contentView, 5);
        
    }
    
    return self;
}

/**
 * @brief 数据模型
 */
- (void)setModel:(HSQSelectionListModel *)model{
    
    _model = model;
    
    // 商品的名字
    self.distributorFavoritesName.text = model.distributorFavoritesName;
    
    // 商品的数量
    NSString *goodsCount = [NSString stringWithFormat:@"商品数量  %@",model.goodsCount];
    
    NSMutableAttributedString *attribe = [[NSMutableAttributedString alloc] initWithString:goodsCount];
    
    [attribe addAttribute:NSForegroundColorAttributeName value:RGB(150, 150, 150) range:NSMakeRange(0, 4)];
    
    self.GoodsCount_Label.attributedText = attribe;
    
    // 选品库中的商品
    if (model.distributionGoodsVoList.count > 0)
    {
        self.SelectGroupImageListView.hidden = NO;
        
        self.SelectGroupImageListView.photos = model.ImageArrayUrl;
    }
    else
    {
        self.SelectGroupImageListView.hidden = YES;
    }
}



@end
