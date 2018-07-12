//
//  HSQQRCodeShareView.m
//  LiTianDecoration
//
//  Created by administrator on 2018/6/30.
//  Copyright © 2018年 administrator. All rights reserved.
//

#define KShareImageX 40

#define KShareImageW KScreenWidth - 2 * KShareImageX

#import "HSQQRCodeShareView.h"

@interface HSQQRCodeShareView ()

@property (nonatomic, strong) UIButton *dismiss_Button;

@property (nonatomic, strong) UIImageView *Share_ImageView;

@end

@implementation HSQQRCodeShareView

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
        
        UIButton *dismiss_Button = [UIButton buttonWithType:(UIButtonTypeSystem)];
        
        dismiss_Button.frame = self.bounds;
        
        [dismiss_Button addTarget:self action:@selector(dismiss_ButtonClickAction:) forControlEvents:(UIControlEventTouchUpInside)];
        
        [self addSubview:dismiss_Button];
        
        self.dismiss_Button = dismiss_Button;
        
        // 分享的商品图片
        UIImageView *Share_ImageView = [[UIImageView alloc] init];
        
        Share_ImageView.frame = CGRectMake(KShareImageX, 0, KShareImageW, (KShareImageW) * 1.5);
        
        Share_ImageView.centerY = self.centerY;
        
        [self addSubview:Share_ImageView];
        
        self.Share_ImageView = Share_ImageView;

    }
    
    return self;
}

/**
 * @brief 商品的图片
 */
- (void)setShareQRUrl:(NSString *)shareQRUrl{
    
    _shareQRUrl = shareQRUrl;
    
    [self.Share_ImageView sd_setImageWithURL:[NSURL URLWithString:shareQRUrl] placeholderImage:KGoodsPlacherImage];
}

/**
 * @brief 隐藏视图
 */
- (void)dismiss_ButtonClickAction:(UIButton *)sender{
    
    [UIView animateWithDuration:0.25 animations:^{
        
        self.Share_ImageView.alpha = 0.0;
        
        self.alpha = 0.0;
        
    }completion:^(BOOL finished) {
        
        [self.Share_ImageView removeFromSuperview];
        
        [self removeFromSuperview];
    }];
}




















@end
