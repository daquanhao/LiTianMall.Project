
//
//  HSQSelectGroupGoodsListHeadView.m
//  LiTianDecoration
//
//  Created by administrator on 2018/6/14.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import "HSQSelectGroupGoodsListHeadView.h"

@interface HSQSelectGroupGoodsListHeadView ()

@property (nonatomic, strong) UIView *BgView;

@property (nonatomic, strong) UIImageView *SanJiao_ImageView;

@property (nonatomic, strong) UIImageView *StorePlacher_ImageView;

@property (nonatomic, strong) UIButton *JoinStoreDetail_Button;

@end

@implementation HSQSelectGroupGoodsListHeadView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        
        self.contentView.backgroundColor = [UIColor clearColor];
        
        // 分割线
        UIView *BgView = [[UIView alloc] init];
        BgView.backgroundColor = RGB(248, 248, 248);
        [self.contentView addSubview:BgView];
        self.BgView = BgView;
        
        //店铺名字左边的展位图片
        UIImageView *StorePlacher_ImageView = [[UIImageView alloc] initWithImage:KImageName(@"3-1P106112Q1-51")];
        [BgView addSubview:StorePlacher_ImageView];
        self.StorePlacher_ImageView = StorePlacher_ImageView;
        
        // 店铺的名字
        UILabel *StoreName_Label = [[UILabel alloc] init];
        StoreName_Label.textColor = RGB(71, 71, 71);
        StoreName_Label.font = [UIFont systemFontOfSize:14.0];
        [BgView addSubview:StoreName_Label];
        self.StoreName_Label = StoreName_Label;
        
        //三角的图片
        UIImageView *SanJiao_ImageView = [[UIImageView alloc] initWithImage:KImageName(@"C7F2BC79-AC34-4AB0-AAFA-021F9AD47E36")];
        [BgView addSubview:SanJiao_ImageView];
        self.SanJiao_ImageView = SanJiao_ImageView;
        
        // 进入店铺详情
        UIButton *JoinStoreDetail_Button = [UIButton buttonWithType:(UIButtonTypeSystem)];
        [JoinStoreDetail_Button addTarget:self action:@selector(JoinStoreDetail_ButtonClickAction:) forControlEvents:(UIControlEventTouchUpInside)];
        [BgView addSubview:JoinStoreDetail_Button];
        self.JoinStoreDetail_Button = JoinStoreDetail_Button;
        
        // 分割线
        self.BgView.sd_layout.leftSpaceToView(self.contentView, 0).topSpaceToView(self.contentView, 10).rightSpaceToView(self.contentView, 0).bottomSpaceToView(self.contentView, 0);
        
        //店铺名字左边的展位图片
        self.StorePlacher_ImageView.sd_layout.leftSpaceToView(self.BgView, 10).centerYEqualToView(self.BgView).widthIs(15).heightEqualToWidth();
        
        // 店铺的名字
        self.StoreName_Label.sd_layout.leftSpaceToView(self.StorePlacher_ImageView, 10).topSpaceToView(self.BgView, 0).bottomSpaceToView(self.BgView, 0).autoWidthRatio(0);
        [self.StoreName_Label setSingleLineAutoResizeWithMaxWidth:KScreenWidth - 50];
        
        //三角的图片
        self.SanJiao_ImageView.sd_layout.leftSpaceToView(self.StoreName_Label, 10).centerYEqualToView(self.BgView).widthIs(8).heightIs(13);
        
        // 进入店铺详情
        self.JoinStoreDetail_Button.sd_layout.leftSpaceToView(self.BgView, 0).topSpaceToView(self.BgView, 0).rightSpaceToView(self.BgView, 0).bottomSpaceToView(self.BgView, 0);
    }
    
    return self;
}

/**
 * @brief 进入店铺详情
 */
- (void)JoinStoreDetail_ButtonClickAction:(UIButton *)sender{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(ClickToEnterStoreDetails:)]) {
        
        [self.delegate ClickToEnterStoreDetails:sender];
    }
}









@end
