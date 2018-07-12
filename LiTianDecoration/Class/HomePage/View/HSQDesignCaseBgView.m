//
//  HSQDesignCaseBgView.m
//  LiTianDecoration
//
//  Created by administrator on 2018/7/11.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import "HSQDesignCaseBgView.h"

@interface HSQDesignCaseBgView ()

@property (nonatomic, strong) UIImageView *Case_ImageView; // 案例图片

@property (nonatomic, strong) UILabel *CaseName_Label; // 案例名字

@property (nonatomic, strong) UIImageView *CaseIcon_ImageView; // 设计师头像

@property (nonatomic, strong) UILabel *designer_Label; // 设计师名字

@end

@implementation HSQDesignCaseBgView

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = RGB(57, 63, 78);
        
        // 案例图片
        UIImageView *Case_ImageView = [[UIImageView alloc] init];
        Case_ImageView.image = KImageName(@"EA4033CF-CCD9-41DC-BEE9-0128E0CEF646");
        [self addSubview:Case_ImageView];
        self.Case_ImageView = Case_ImageView;
        
        // 案例名字
        UILabel *CaseName_Label = [[UILabel alloc] init];
        CaseName_Label.text = @"北京遇上西雅图，打劫";
        CaseName_Label.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
        CaseName_Label.font = [UIFont systemFontOfSize:14.0];
        [self addSubview:CaseName_Label];
        self.CaseName_Label = CaseName_Label;
        
        // 设计师头像
        UIImageView *CaseIcon_ImageView = [[UIImageView alloc] init];
        CaseIcon_ImageView.image = KImageName(@"icon4");
        [self addSubview:CaseIcon_ImageView];
        self.CaseIcon_ImageView = CaseIcon_ImageView;
        
        // 设计师名字
        UILabel *designer_Label = [[UILabel alloc] init];
        designer_Label.text = @"韩大全";
        designer_Label.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
        designer_Label.font = [UIFont systemFontOfSize:12.0];
        [self addSubview:designer_Label];
        self.designer_Label = designer_Label;
        
        // 添加约束
        self.Case_ImageView.sd_layout.leftSpaceToView(self, 0).topSpaceToView(self, 0).rightSpaceToView(self, 0).heightEqualToWidth();
        
        self.CaseName_Label.sd_layout.leftSpaceToView(self, 5).topSpaceToView(self.Case_ImageView, 5).rightSpaceToView(self, 5).autoHeightRatio(0);
        [self.CaseName_Label setMaxNumberOfLinesToShow:1];
        
        self.CaseIcon_ImageView.sd_layout.leftSpaceToView(self, 10).topSpaceToView(self.CaseName_Label, 5).widthIs(26).heightEqualToWidth();
        [self.CaseIcon_ImageView setSd_cornerRadiusFromWidthRatio:@(0.5)];
        
        self.designer_Label.sd_layout.leftSpaceToView(self.CaseIcon_ImageView, 5).centerYEqualToView(self.CaseIcon_ImageView).rightSpaceToView(self, 5).autoHeightRatio(0);
        [self.designer_Label setMaxNumberOfLinesToShow:1];
    }
    
    return self;
}











@end
