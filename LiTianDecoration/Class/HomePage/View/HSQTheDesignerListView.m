//
//  HSQTheDesignerListView.m
//  LiTianDecoration
//
//  Created by administrator on 2018/7/11.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import "HSQTheDesignerListView.h"

@interface HSQTheDesignerListView ()

@property (nonatomic, strong) UIImageView *DesignerIcon_ImageView; // 设计师头像

@property (nonatomic, strong) UIView *WorksCount_BgView; // 数量背景图

@property (nonatomic, strong) UILabel *WorksCount_Label; // 作品数量

@property (nonatomic, strong) UILabel *DesignerName_Label; // 设计师的名字

@property (nonatomic, strong) UILabel *DesignerType_Label; // 设计师的类型

@property (nonatomic, strong) UILabel *DesigneriaoQian_Label; // 设计师的标签

@property (nonatomic, strong) UIButton *LookUp_Btn; // 查看设计师

@end

@implementation HSQTheDesignerListView

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = RGB(57, 63, 78);
        
        // 作品数量背景图
        UIView *WorksCount_BgView = [[UIView alloc] init];
        WorksCount_BgView.backgroundColor = RGB(220, 82, 38);
        [self addSubview:WorksCount_BgView];
        self.WorksCount_BgView = WorksCount_BgView;
        
        // 设计师头像
        UIImageView *DesignerIcon_ImageView = [[UIImageView alloc] init];
        DesignerIcon_ImageView.image = KImageName(@"icon4");
        [DesignerIcon_ImageView.layer setBorderWidth:5];
        [DesignerIcon_ImageView.layer setBorderColor:KViewBackGlobalGroupColor.CGColor];
        [self addSubview:DesignerIcon_ImageView];
        self.DesignerIcon_ImageView = DesignerIcon_ImageView;
        
        // 作品数量
        UILabel *WorksCount_Label = [[UILabel alloc] init];
        WorksCount_Label.text = @"100件作品";
        WorksCount_Label.textColor = [UIColor whiteColor];
        WorksCount_Label.font = [UIFont systemFontOfSize:10.0];
        [WorksCount_BgView addSubview:WorksCount_Label];
        self.WorksCount_Label = WorksCount_Label;
        
        // 设计师的名字
        UILabel *DesignerName_Label = [[UILabel alloc] init];
        DesignerName_Label.text = @"韩大全";
        DesignerName_Label.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
        DesignerName_Label.font = [UIFont systemFontOfSize:14.0];
        DesignerName_Label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:DesignerName_Label];
        self.DesignerName_Label = DesignerName_Label;
        
        // 设计师的类型
        UILabel *DesignerType_Label = [[UILabel alloc] init];
        DesignerType_Label.text = @"大户型设计师";
        DesignerType_Label.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
        DesignerType_Label.font = [UIFont systemFontOfSize:12.0];
        DesignerType_Label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:DesignerType_Label];
        self.DesignerType_Label = DesignerType_Label;
        
        // 设计师的标签
        UILabel *DesigneriaoQian_Label = [[UILabel alloc] init];
        DesigneriaoQian_Label.text = @"现代简约 | 北欧 | 简欧";
        DesigneriaoQian_Label.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
        DesigneriaoQian_Label.font = [UIFont systemFontOfSize:12.0];
        DesigneriaoQian_Label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:DesigneriaoQian_Label];
        self.DesigneriaoQian_Label = DesigneriaoQian_Label;
        
        // 查看设计师
        UIButton *LookUp_Btn = [UIButton buttonWithType:(UIButtonTypeSystem)];
        [LookUp_Btn setTitle:@"查看设计师" forState:(UIControlStateNormal)];
        LookUp_Btn.titleLabel.font = [UIFont systemFontOfSize:KLabelFont(14.0, 12.0)];
        LookUp_Btn.layer.borderWidth = 1;
        LookUp_Btn.layer.borderColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5].CGColor;
        [LookUp_Btn setTitleColor:[[UIColor whiteColor] colorWithAlphaComponent:0.5] forState:(UIControlStateNormal)];
        [self addSubview:LookUp_Btn];
        self.LookUp_Btn = LookUp_Btn;
        
        // 添加约束
        self.DesignerIcon_ImageView.sd_layout.centerXEqualToView(self).topSpaceToView(self, 15).widthIs(80).heightEqualToWidth();
        [self.DesignerIcon_ImageView setSd_cornerRadiusFromWidthRatio:@(0.5)];
        
        self.WorksCount_BgView.sd_layout.rightSpaceToView(self, 0).bottomEqualToView(self.DesignerIcon_ImageView).leftSpaceToView(self.DesignerIcon_ImageView, -self.DesignerIcon_ImageView.mj_w / 2).heightIs(20);
        
        self.WorksCount_Label.sd_layout.leftSpaceToView(self.WorksCount_BgView, self.DesignerIcon_ImageView.mj_w / 2 - 10).topSpaceToView(self.WorksCount_BgView, 0).rightSpaceToView(self.WorksCount_BgView, 0).bottomSpaceToView(self.WorksCount_BgView, 0);
        
        self.DesignerName_Label.sd_layout.leftSpaceToView(self, 5).topSpaceToView(self.DesignerIcon_ImageView, 10).rightSpaceToView(self, 5).autoHeightRatio(0);
        
        self.DesignerType_Label.sd_layout.leftSpaceToView(self, 5).topSpaceToView(self.DesignerName_Label, 10).rightSpaceToView(self, 5).autoHeightRatio(0);
        
        self.DesigneriaoQian_Label.sd_layout.leftSpaceToView(self, 5).topSpaceToView(self.DesignerType_Label, 10).rightSpaceToView(self, 5).autoHeightRatio(0);

        self.LookUp_Btn.sd_layout.topSpaceToView(self.DesigneriaoQian_Label, 10).centerXEqualToView(self).widthIs(90).heightIs(30);
    }
    
    return self;
}


















@end
