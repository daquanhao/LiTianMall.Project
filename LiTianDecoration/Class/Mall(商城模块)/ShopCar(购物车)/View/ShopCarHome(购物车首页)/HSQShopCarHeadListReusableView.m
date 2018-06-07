//
//  HSQShopCarHeadListReusableView.m
//  LiTianDecoration
//
//  Created by administrator on 2018/5/21.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import "HSQShopCarHeadListReusableView.h"
#import "HSQShopCarVCGoodsDataModel.h"

@interface HSQShopCarHeadListReusableView ()

@property (nonatomic, strong) UIButton *LeftRato_Button;

@property (nonatomic, strong) UIImageView *Midden_Image;

@property (nonatomic, strong) UILabel *StoreName_Label;

@property (nonatomic, strong) UIView *LineView;

@end

@implementation HSQShopCarHeadListReusableView

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        // 左边的小圆圈
        UIButton *LeftRato_Button = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [LeftRato_Button setImage:KImageName(@"878CADA4-7366-480C-856E-9DBA873C758C") forState:(UIControlStateNormal)];
        [LeftRato_Button setImage:KImageName(@"320A9B4D-0268-49C1-845B-7E3AABAB72BC") forState:(UIControlStateSelected)];
        [LeftRato_Button addTarget:self action:@selector(LeftRato_ButtonClickAction:) forControlEvents:(UIControlEventTouchUpInside)];
        [self addSubview:LeftRato_Button];
        self.LeftRato_Button = LeftRato_Button;
        
        //中间的图片
        UIImageView *Midden_Image = [[UIImageView alloc] initWithImage:KImageName(@"123")];
        [self addSubview:Midden_Image];
        self.Midden_Image = Midden_Image;
        
        // 店铺的名字
        UILabel *StoreName_Label = [[UILabel alloc] init];
        StoreName_Label.textColor = RGB(74, 74, 74);
        StoreName_Label.font = [UIFont systemFontOfSize:14.0];
        [self addSubview:StoreName_Label];
        self.StoreName_Label = StoreName_Label;
        
        // 分割线
        UIView *LineView = [[UIView alloc] init];
        LineView.backgroundColor = KViewBackGroupColor;
        [self addSubview:LineView];
        self.LineView = LineView;
        
        // 添加约束
        [self SetValueViewLayout];
    }
    
    return self;
}

/**
 * @brief 添加控件的约束
 */
- (void)SetValueViewLayout{
    
    // 左边的小圆圈
    self.LeftRato_Button.sd_layout.leftSpaceToView(self, 0).topSpaceToView(self, 0).bottomSpaceToView(self, 0).widthEqualToHeight();
    
    //中间的图片
    self.Midden_Image.sd_layout.leftSpaceToView(self.LeftRato_Button, 0).centerYEqualToView(self).widthIs(20).heightEqualToWidth();
    
    // 店铺的名字
    self.StoreName_Label.sd_layout.leftSpaceToView(self.Midden_Image, 10).topSpaceToView(self, 0).rightSpaceToView(self, 10).bottomSpaceToView(self, 0);
    
    // 分割线
    self.LineView.sd_layout.leftSpaceToView(self, 0).topSpaceToView(self.LeftRato_Button, 1).rightSpaceToView(self, 0).heightIs(1);
}


/**
 * @brief 接收上一个界面的模型数据
 */
- (void)setModel:(HSQShopCarVCGoodsDataModel *)Model{
    
    _Model = Model;
    
    // 店铺的名字
    self.StoreName_Label.text = Model.storeName;
    
    // 判断按钮是否被选中
    if (Model.IsSelect.integerValue == 0)
    {
        [self.LeftRato_Button setSelected:NO];
    }
    else
    {
         [self.LeftRato_Button setSelected:YES];
    }
}

/**
 * @brief 左边小圆点的点击事件
 */
- (void)LeftRato_ButtonClickAction:(UIButton *)sender{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(HeaderReusableViewLeftRato_ButtonClickAction:)]) {
        
        [self.delegate HeaderReusableViewLeftRato_ButtonClickAction:sender];
    }
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

@end
