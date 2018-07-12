//
//  HSQNoDataView.m
//  ReservationBusiness
//
//  Created by nian on 2016/12/5.
//  Copyright © 2016年 hanshanquan. All rights reserved.
//

#import "HSQNoDataView.h"

#define KlogImageHW 80

@interface HSQNoDataView ()

@property (nonatomic, strong) UIImageView *Logo;

@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation HSQNoDataView

- (instancetype)initWithTitle:(NSString *)title imageName:(NSString *)Name height:(CGFloat)Loginheight TopMargin:(CGFloat)TopY{
    
    if (self = [super initWithFrame:CGRectMake(0, TopY, KScreenWidth, KScreenHeight - KSafeBottomHeight - KSafeTopeHeight)]) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        // 提示图片
        UIImageView *Logo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:Name]];
        [self addSubview:Logo];
        self.Logo = Logo;
        
        // 提示文字
        UILabel *titleLabel = [[UILabel alloc] init];
        
        titleLabel.textColor = RGB(148, 178, 200);
        
        titleLabel.font = [UIFont systemFontOfSize:14.0];
        
        titleLabel.textAlignment = NSTextAlignmentCenter;
        
        titleLabel.backgroundColor = [UIColor clearColor];
        
        titleLabel.numberOfLines = 0;
        
        titleLabel.text = title;
        
        [self addSubview:titleLabel];
        
        self.titleLabel = titleLabel;
        
        self.Logo.sd_layout.widthIs(KlogImageHW).heightEqualToWidth().centerXEqualToView(self).centerYIs((KScreenHeight-KlogImageHW)/2 - Loginheight);
        
        self.titleLabel.sd_layout.topSpaceToView(self.Logo,10).heightIs(25).centerXEqualToView(self).widthRatioToView(self,1);
        
    }
    return self;
}

- (instancetype)init
{
    return [self initWithTitle:@"" imageName:@"" height:0 TopMargin:0];
}


- (void)setTitle:(NSString *)title
{
    _titleLabel.text = title;
}

@end
