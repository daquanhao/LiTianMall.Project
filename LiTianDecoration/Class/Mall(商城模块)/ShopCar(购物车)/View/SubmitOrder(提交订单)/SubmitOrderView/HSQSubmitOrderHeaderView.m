//
//  HSQSubmitOrderHeaderView.m
//  LiTianDecoration
//
//  Created by administrator on 2018/5/24.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import "HSQSubmitOrderHeaderView.h"
#import "HSQShopCarVCGoodsDataModel.h"


@interface HSQSubmitOrderHeaderView ()

@property (nonatomic, strong) UILabel *StoreName_Label;

@end

@implementation HSQSubmitOrderHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        UILabel *StoreName_Label = [[UILabel alloc] init];
        
        StoreName_Label.textColor = RGB(71, 71, 71);
        
        StoreName_Label.font = [UIFont systemFontOfSize:KLabelFont(14.0, 12.0)];
        
        [self.contentView addSubview:StoreName_Label];
        
        self.StoreName_Label = StoreName_Label;
        
        self.StoreName_Label.sd_layout.leftSpaceToView(self.contentView, 10).topSpaceToView(self.contentView, 0).bottomSpaceToView(self.contentView, 0).rightSpaceToView(self.contentView, 10);
    }
    
    return self;
}

- (void)setModel:(HSQShopCarVCGoodsDataModel *)model{
    
    _model = model;
    
    self.StoreName_Label.text = model.storeName;
}

@end
