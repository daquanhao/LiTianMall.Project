//
//  HSQSelectGroupGoodsListFooterView.m
//  LiTianDecoration
//
//  Created by administrator on 2018/6/14.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import "HSQSelectGroupGoodsListFooterView.h"

@interface HSQSelectGroupGoodsListFooterView ()

@property (nonatomic, strong) UIView *LineView;

@property (nonatomic, strong) UIButton *Delete_Button;

@property (nonatomic, strong) UIButton *Mobile_Button;

@property (nonatomic, strong) UIButton *Promotion_Button;

@end

@implementation HSQSelectGroupGoodsListFooterView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        // 分割线
        UIView *LineView = [[UIView alloc] init];
        LineView.backgroundColor = KViewBackGroupColor;
        [self.contentView addSubview:LineView];
        self.LineView = LineView;
        
        // 删除按钮
        UIButton *Delete_Button = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [Delete_Button setTitle:@"删除" forState:(UIControlStateNormal)];
        [Delete_Button setBackgroundImage:[UIImage ReturnAPictureOfStretching:@"7D99DFED-F3B6-4DB1-9F77-E24CA867DD17"] forState:(UIControlStateNormal)];
        [Delete_Button setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
        Delete_Button.titleLabel.font = [UIFont systemFontOfSize:12.0];
        [Delete_Button setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
        [Delete_Button addTarget:self action:@selector(Delete_ButtonClickAction:) forControlEvents:(UIControlEventTouchUpInside)];
        [self.contentView addSubview:Delete_Button];
        self.Delete_Button = Delete_Button;
        
        // 移动按钮
        UIButton *mobile_Button = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [mobile_Button setTitle:@"移动" forState:(UIControlStateNormal)];
        [mobile_Button setBackgroundImage:[UIImage ReturnAPictureOfStretching:@"7D99DFED-F3B6-4DB1-9F77-E24CA867DD17"] forState:(UIControlStateNormal)];
        [mobile_Button setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
        mobile_Button.titleLabel.font = [UIFont systemFontOfSize:12.0];
        [mobile_Button setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
        [mobile_Button addTarget:self action:@selector(mobile_ButtonClickAction:) forControlEvents:(UIControlEventTouchUpInside)];
        [self.contentView addSubview:mobile_Button];
        self.Mobile_Button = mobile_Button;
        
        // 立即推广按钮
        UIButton *Promotion_Button = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [Promotion_Button setTitle:@"立即推广" forState:(UIControlStateNormal)];
        [Promotion_Button setBackgroundImage:[UIImage ReturnAPictureOfStretching:@"7D99DFED-F3B6-4DB1-9F77-E24CA867DD17"] forState:(UIControlStateNormal)];
        [Promotion_Button setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
        Promotion_Button.titleLabel.font = [UIFont systemFontOfSize:12.0];
        [Promotion_Button setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
        [Promotion_Button addTarget:self action:@selector(Promotion_ButtonClickAction:) forControlEvents:(UIControlEventTouchUpInside)];
        [self.contentView addSubview:Promotion_Button];
        self.Promotion_Button = Promotion_Button;
        
        // 分割线
        self.LineView.sd_layout.leftSpaceToView(self.contentView, 0).topSpaceToView(self.contentView, 0).rightSpaceToView(self.contentView, 0).heightIs(1);
        
        // 立即推广按钮
        self.Promotion_Button.sd_layout.rightSpaceToView(self.contentView, 10).centerYEqualToView(self.contentView).widthIs(80).heightIs(25);
        
        // 移动按钮
        self.Mobile_Button.sd_layout.rightSpaceToView(self.Promotion_Button, 10).centerYEqualToView(self.contentView).widthIs(60).heightIs(25);
        
        //删除按钮
        self.Delete_Button.sd_layout.rightSpaceToView(self.Mobile_Button, 10).centerYEqualToView(self.contentView).widthIs(60).heightIs(25);
    }
    
    return self;
}

/**
 * @brief 删除按钮
 */
- (void)Delete_ButtonClickAction:(UIButton *)sender{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(DeleteItemsFromTheInventory:)]) {
        
        [self.delegate DeleteItemsFromTheInventory:sender];
    }
}

/**
 * @brief 移动按钮
 */
- (void)mobile_ButtonClickAction:(UIButton *)sender{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(MoveItemsFromTheInventory:)]) {
        
        [self.delegate MoveItemsFromTheInventory:sender];
    }
}

/**
 * @brief 立即推广按钮
 */
- (void)Promotion_ButtonClickAction:(UIButton *)sender{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(ImmediatelyPromoteTheProductsInTheSelectionBank:)]) {
        
        [self.delegate ImmediatelyPromoteTheProductsInTheSelectionBank:sender];
    }
}






@end
