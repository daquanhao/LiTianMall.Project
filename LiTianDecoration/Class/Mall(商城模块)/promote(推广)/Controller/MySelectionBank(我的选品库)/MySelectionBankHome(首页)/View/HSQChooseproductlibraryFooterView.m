//
//  HSQChooseproductlibraryFooterView.m
//  LiTianDecoration
//
//  Created by administrator on 2018/6/14.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import "HSQChooseproductlibraryFooterView.h"

@interface HSQChooseproductlibraryFooterView ()

@property (nonatomic, strong) UIView *BgView;

@property (nonatomic, strong) UIButton *Delete_Button;

@property (nonatomic, strong) UIButton *Edit_Button;

@end

@implementation HSQChooseproductlibraryFooterView

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        // 白色背景图
        UIView *BgView = [[UIView alloc] init];
        BgView.backgroundColor = [UIColor whiteColor];
        [self addSubview:BgView];
        self.BgView = BgView;
        
        // 删除按钮
        UIButton *Delete_Button = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [Delete_Button setTitle:@"删除" forState:(UIControlStateNormal)];
        [Delete_Button setImage:KImageName(@"E40551FD-B428-45CB-B91D-FF4D678D0EF7") forState:(UIControlStateNormal)];
        [Delete_Button setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
        Delete_Button.titleLabel.font = [UIFont systemFontOfSize:12.0];
        [Delete_Button setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
        [Delete_Button addTarget:self action:@selector(Delete_ButtonClickAction:) forControlEvents:(UIControlEventTouchUpInside)];
        [BgView addSubview:Delete_Button];
        self.Delete_Button = Delete_Button;
        
        // 编辑按钮
        UIButton *Edit_Button = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [Edit_Button setTitle:@"编辑" forState:(UIControlStateNormal)];
        [Edit_Button setImage:KImageName(@"E40551FD-B428-45CB-B91D-FF4D678D0EF7") forState:(UIControlStateNormal)];
        [Edit_Button setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
        Edit_Button.titleLabel.font = [UIFont systemFontOfSize:12.0];
        [Edit_Button setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
        [Edit_Button addTarget:self action:@selector(Edit_ButtonClickAction:) forControlEvents:(UIControlEventTouchUpInside)];
        [BgView addSubview:Edit_Button];
        self.Edit_Button = Edit_Button;
        
        // 白色背景图
        self.BgView.sd_layout.leftSpaceToView(self, 0).topSpaceToView(self, 1).bottomSpaceToView(self, 1).rightSpaceToView(self, 0);
        
        // 删除按钮
        self.Delete_Button.sd_layout.rightSpaceToView(self.BgView, 10).topSpaceToView(self.BgView, 0).bottomSpaceToView(self.BgView, 0).widthEqualToHeight();
        
        // 编辑按钮
        self.Edit_Button.sd_layout.rightSpaceToView(self.Delete_Button, 10).topSpaceToView(self.BgView, 0).bottomSpaceToView(self.BgView, 0).widthEqualToHeight();
    }
    
    return self;
}

/**
 * @brief 删除按钮
 */
- (void)Delete_ButtonClickAction:(UIButton *)sender{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(DeleteTheClickEventOfTheSelectedRepository:)]) {
        
        [self.delegate DeleteTheClickEventOfTheSelectedRepository:sender];
    }
}

/**
 * @brief 编辑按钮
 */
- (void)Edit_ButtonClickAction:(UIButton *)sender{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(EditTheClickEventsForTheRepository:)]) {
        
        [self.delegate EditTheClickEventsForTheRepository:sender];
    }
}










@end
