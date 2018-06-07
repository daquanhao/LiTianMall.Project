//
//  HSQTuiMoneryListHeadView.m
//  LiTianDecoration
//
//  Created by administrator on 2018/6/4.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import "HSQTuiMoneryListHeadView.h"

@interface HSQTuiMoneryListHeadView ()

@property (nonatomic, strong) UIImageView *Left_ImageView;

@end

@implementation HSQTuiMoneryListHeadView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        
        UIView *BgView = [[UIView alloc] init];
        BgView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:BgView];
        self.BgView = BgView;
        
        UIImageView *left_ImageView = [[UIImageView alloc] initWithImage:KImageName(@"123")];
        [BgView addSubview:left_ImageView];
        self.Left_ImageView = left_ImageView;
        
        UILabel *StoreName_Label = [[UILabel alloc] init];
        StoreName_Label.textColor = RGB(74, 74, 74);
        StoreName_Label.font = [UIFont systemFontOfSize:12.0];
        [BgView addSubview:StoreName_Label];
        self.StoreName_Label = StoreName_Label;
        
        UILabel *OrderState_Label = [[UILabel alloc] init];
        OrderState_Label.textColor = RGB(238, 58, 68);
        OrderState_Label.font = [UIFont systemFontOfSize:12.0];
        OrderState_Label.textAlignment = NSTextAlignmentRight;
        [BgView addSubview:OrderState_Label];
        self.OrderState_Label = OrderState_Label;
        
        UILabel *Placher_Label = [[UILabel alloc] init];
        Placher_Label.textColor = RGB(150, 150, 150);
        Placher_Label.font = [UIFont systemFontOfSize:12.0];
        [self.contentView addSubview:Placher_Label];
        self.Placher_Label = Placher_Label;
        
        // 添加约束
        self.BgView.sd_layout.leftSpaceToView(self.contentView, 0).topSpaceToView(self.contentView, 1).rightSpaceToView(self.contentView, 0).bottomSpaceToView(self.contentView, 1);
        
        self.Left_ImageView.sd_layout.leftSpaceToView(self.BgView, 10).centerYEqualToView(self.BgView).widthIs(20).heightEqualToWidth();
        
        self.StoreName_Label.sd_layout.leftSpaceToView(self.Left_ImageView, 10).centerYEqualToView(self.BgView).autoHeightRatio(0).autoWidthRatio(0);
        [self.StoreName_Label setSingleLineAutoResizeWithMaxWidth:KScreenWidth * 0.5];
        
        self.OrderState_Label.sd_layout.leftSpaceToView(self.StoreName_Label, 5).rightSpaceToView(self.BgView, 10).centerYEqualToView(self.BgView).autoHeightRatio(0);
        
        self.Placher_Label.sd_layout.leftSpaceToView(self.contentView, 10).topSpaceToView(self.contentView, 0).rightSpaceToView(self.contentView, 10).bottomSpaceToView(self.contentView, 0);
    }
    
    return self;
}

@end
