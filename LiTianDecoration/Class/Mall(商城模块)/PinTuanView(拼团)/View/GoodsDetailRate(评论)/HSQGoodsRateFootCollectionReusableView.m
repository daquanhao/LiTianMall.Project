//
//  HSQGoodsRateFootCollectionReusableView.m
//  LiTianDecoration
//
//  Created by administrator on 2018/5/11.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import "HSQGoodsRateFootCollectionReusableView.h"
#import "HSQGoodsRateListModel.h"
#import "HSQGoodsRateListFrameModel.h"

@interface HSQGoodsRateFootCollectionReusableView ()

@property (nonatomic, strong) UILabel *GoodsType_Label;  // 商品的类型

@end

@implementation HSQGoodsRateFootCollectionReusableView

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        UILabel *GoodsType_Label = [[UILabel alloc] init];
        
        GoodsType_Label.textColor = RGB(74, 74, 74);
        
        GoodsType_Label.font = [UIFont systemFontOfSize:KTextFont_(14)];
        
        GoodsType_Label.numberOfLines = 0;
        
        [self addSubview:GoodsType_Label];
        
        self.GoodsType_Label = GoodsType_Label;
        
        self.GoodsType_Label.sd_layout.leftSpaceToView(self, 10).rightSpaceToView(self, 10).topSpaceToView(self, 5).bottomSpaceToView(self, 5);
    }
    
    return self;
}

- (void)setFrameModel:(HSQGoodsRateListFrameModel *)FrameModel{
    
    _FrameModel = FrameModel;
    
    HSQGoodsRateListModel *RateModel = FrameModel.model;
    
    self.GoodsType_Label.text = RateModel.goodsFullSpecs;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

@end
