//
//  HSQGoodsDetailFooterView.m
//  LiTianDecoration
//
//  Created by administrator on 2018/5/10.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import "HSQGoodsDetailFooterView.h"

@interface HSQGoodsDetailFooterView ()

@property (nonatomic, strong) UIView *BgView; // 白色背景图

@property (nonatomic, strong) UIImageView *RightImageView; // 右边的按钮

@property (nonatomic, strong) UILabel *PlacherLabel;  // 提示文字

@end

@implementation HSQGoodsDetailFooterView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        
        self.contentView.backgroundColor = KViewBackGroupColor;
        
        [self AddView];
        
        [self AddViewLayOut];
        
    }
    
    return self;
}

/**
 * @brief 添加视图控件
 */
- (void)AddView{
    
    // 背景视图
    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:bgView];
    self.BgView = bgView;
    
    // 右边的三角按钮
    UIImageView *RightImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"C7F2BC79-AC34-4AB0-AAFA-021F9AD47E36"]];
    [self.contentView addSubview:RightImage];
    self.RightImageView = RightImage;
    
    //  提示文字
    UILabel *PlacherLabel = [[UILabel alloc] init];
    PlacherLabel.textColor = [UIColor blackColor];
    PlacherLabel.font = [UIFont systemFontOfSize:14.0];
    PlacherLabel.text = @"有疑问? 可咨询店铺客服";
    [self.contentView addSubview:PlacherLabel];
    self.PlacherLabel = PlacherLabel;
}

/**
 * @brief 添加视图控件的约束
 */
- (void)AddViewLayOut{
    
    // 背景视图
    self.BgView.sd_layout.leftSpaceToView(self.contentView, 0).rightSpaceToView(self.contentView, 0).topSpaceToView(self.contentView, 10).bottomSpaceToView(self.contentView, 10);
    
    // 右边的三角按钮
    self.RightImageView.sd_layout.rightSpaceToView(self.contentView, 10).centerYEqualToView(self.contentView).widthIs(8).heightIs(11);
    
    //  好评率
    self.PlacherLabel.sd_layout.rightSpaceToView(self.RightImageView, 10).centerYEqualToView(self.contentView).leftSpaceToView(self.contentView, 10).heightIs(20);
}










@end
