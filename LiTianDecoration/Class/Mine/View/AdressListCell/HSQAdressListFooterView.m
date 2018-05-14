//
//  HSQAdressListFooterView.m
//  LiTianDecoration
//
//  Created by administrator on 2018/4/25.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import "HSQAdressListFooterView.h"

@interface HSQAdressListFooterView ()

@property (nonatomic, strong) UIButton *AddAdress_Button;

@end

@implementation HSQAdressListFooterView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        
        self.contentView.backgroundColor = [UIColor clearColor];
        
        UIButton *AddAdress_Button = [UIButton buttonWithType:(UIButtonTypeSystem)];
        
        [AddAdress_Button setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        
        [AddAdress_Button setTitle:@"添加新地址" forState:(UIControlStateNormal)];
        
        [AddAdress_Button setBackgroundImage:[UIImage ImageWithColor:[UIColor redColor]] forState:(UIControlStateNormal)];
        
        [AddAdress_Button addTarget:self action:@selector(AddAdress_ButtonClickAction:) forControlEvents:(UIControlEventTouchUpInside)];
        
        [self.contentView addSubview:AddAdress_Button];
        
        self.AddAdress_Button = AddAdress_Button;
        
        self.AddAdress_Button.sd_layout.leftSpaceToView(self.contentView, 25).rightSpaceToView(self.contentView, 25).centerYEqualToView(self.contentView).heightIs(45);
    }
    
    return self;
}

- (void)AddAdress_ButtonClickAction:(UIButton *)sender{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(AddNewAdressWithFooterView:)]) {
        
        [self.delegate AddNewAdressWithFooterView:sender];
    }
}

@end
