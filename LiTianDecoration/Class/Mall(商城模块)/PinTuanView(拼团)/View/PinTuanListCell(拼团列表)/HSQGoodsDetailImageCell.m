//
//  HSQGoodsDetailImageCell.m
//  LiTianDecoration
//
//  Created by administrator on 2018/5/9.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import "HSQGoodsDetailImageCell.h"

@interface HSQGoodsDetailImageCell ()

@property (weak, nonatomic) IBOutlet UIImageView *GoodsImageView;

@property (weak, nonatomic) IBOutlet UIWebView *WebView;

@end

@implementation HSQGoodsDetailImageCell

- (void)setImageUrl:(NSString *)ImageUrl{
    
    _ImageUrl = ImageUrl;
    
    [self.WebView setHidden:YES];
    
    [self.GoodsImageView setHidden:NO];
    
    [self.GoodsImageView sd_setImageWithURL:[NSURL URLWithString:self.ImageUrl] placeholderImage:KGoodsPlacherImage];
}

- (void)setProtection:(NSString *)protection{
    
    _protection = protection;
    
    [self.WebView setHidden:NO];
    
    [self.GoodsImageView setHidden:YES];
    
    [self.WebView loadHTMLString:self.protection baseURL:nil];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

@end
