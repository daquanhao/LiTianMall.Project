//
//  HSQGoodsGuiGeFooterReusableView.m
//  LiTianDecoration
//
//  Created by administrator on 2018/5/14.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import "HSQGoodsGuiGeFooterReusableView.h"

@interface HSQGoodsGuiGeFooterReusableView ()

@property (weak, nonatomic) IBOutlet UIButton *Add_Button;

@property (weak, nonatomic) IBOutlet UIButton *Jian_Button;

@end

@implementation HSQGoodsGuiGeFooterReusableView

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

/**
 * @brief 添加商品的数量
 */
- (IBAction)TianJiaGoodsCountBtnClickAction:(UIButton *)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(AddGoodsCountToShapCarBtnClickAction:)]) {
        
        [self.delegate AddGoodsCountToShapCarBtnClickAction:sender];
    }
}

/**
 * @brief 减少商品的数量
 */
- (IBAction)JianShaoGoodsCountBtnClickAction:(UIButton *)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(JianShaoGoodsCountInShopCarBtnClickAction:)]) {
        
        [self.delegate JianShaoGoodsCountInShopCarBtnClickAction:sender];
    }
}













@end
