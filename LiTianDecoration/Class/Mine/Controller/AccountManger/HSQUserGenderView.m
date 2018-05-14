//
//  HSQUserGenderView.m
//  LiTianDecoration
//
//  Created by administrator on 2018/4/18.
//  Copyright © 2018年 administrator. All rights reserved.
//

#define ViewHeight 50

#import "HSQUserGenderView.h"

@interface HSQUserGenderView ()

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UIView *WhiteView;

@end

@implementation HSQUserGenderView

+ (instancetype)ShowUserGnederView{
    
    HSQUserGenderView *UserGenderView = [[HSQUserGenderView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - KSafeBottomHeight)];
    
     [[UIApplication sharedApplication] .keyWindow addSubview:UserGenderView];
    
    return UserGenderView;
}

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
        
        self.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(DismissFromeSuperView)];
        
        [self addGestureRecognizer:tapGR];
   
    }
    
    return self;
}

- (void)setDataSource:(NSArray *)dataSource{
    
    _dataSource = dataSource;
    
    [self initGenderViewWithItems:dataSource];
}

- (void)setSelectGender:(NSString *)SelectGender{
    
    _SelectGender = SelectGender;
    
    NSInteger index = [self.dataSource indexOfObject:SelectGender];
    
    UIView *whiteView = self.bgView.subviews[index];
    
    for (UIView *SelectView in whiteView.subviews) {
        
        if ([SelectView isKindOfClass:[UILabel class]]) {
        
            UILabel *namelabel = (UILabel *)SelectView;

            namelabel.textColor = [UIColor redColor];
        }
        
        if ([SelectView isKindOfClass:[UIImageView class]]) {
            
            UIImageView *selecImage = (UIImageView *)SelectView;
            
            [selecImage setHidden:NO];
        }
    }
}

- (void)initGenderViewWithItems:(NSArray *)items{

    CGFloat ViewY = KScreenHeight - KSafeBottomHeight;
    
    // 背景视图
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, ViewY , KScreenWidth, items.count * ViewHeight)];
    
    bgView.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:bgView];
    
    self.bgView = bgView;
    
    // 右边的按钮
    for (NSInteger i = 0; i < items.count; i++) {
        
        CGFloat ViewY = ViewHeight * i;
        
        [self CreatGenderView:items[i] ViewY:ViewY index:i];
    }
}

- (void)CreatGenderView:(NSString *)title ViewY:(CGFloat)TopY index:(NSInteger)number{
    
    UIView *WhiteView = [[UIView alloc] initWithFrame:CGRectMake(0, TopY, KScreenWidth, ViewHeight)];
    WhiteView.backgroundColor = [UIColor whiteColor];
    [self.bgView addSubview:WhiteView];
    
    // 分割线
    UIView *LineView = [[UIView alloc] initWithFrame:CGRectMake(15, WhiteView.mj_h - 1, WhiteView.mj_w, 1)];
    LineView.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.3];
    LineView.hidden = (number == 0) ? YES : NO;
    [WhiteView addSubview:LineView];
    
    // 标题
    UILabel *title_Label = [[UILabel alloc] initWithFrame:CGRectMake(LineView.mj_x, 0, WhiteView.mj_w - 30, WhiteView.mj_h - 1)];
    title_Label.text = title;
    title_Label.font = [UIFont systemFontOfSize:15];
    title_Label.textColor = [UIColor blackColor];
    title_Label.textAlignment = (number == 0) ? NSTextAlignmentCenter : NSTextAlignmentLeft;
    [WhiteView addSubview:title_Label];
    
    //右边的图片
    UIImageView *right_imageView = [[UIImageView alloc] initWithImage: KImageName(@"123")];
    right_imageView.frame = CGRectMake(WhiteView.mj_w - 40, (WhiteView.mj_h - 20)/2, 20, 20);
//    right_imageView.hidden = (number == 0) ? NO : YES;
    right_imageView.hidden = YES;
    [WhiteView addSubview:right_imageView];
    
    // 点击的按钮
    UIButton *clickBtn = [UIButton buttonWithType:(UIButtonTypeSystem)];
    clickBtn.frame = WhiteView.bounds;
    clickBtn.tag = number;
    [clickBtn addTarget:self action:@selector(clickButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [WhiteView addSubview:clickBtn];
}

- (void)clickButtonAction:(UIButton *)sender{
    
    HSQLog(@"===%ld",sender.tag);
    
    if (sender.tag != 0)
    {
        NSString *gender_string = self.dataSource[sender.tag];
        
         NSString *sexnumber = nil;
        
        if ([gender_string isEqualToString:@"保密"])
        {
            sexnumber = @"0";
        }
        else if([gender_string isEqualToString:@"男"])
        {
            sexnumber = @"1";
        }
        else if([gender_string isEqualToString:@"女"])
        {
            sexnumber = @"2";
        }
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(SelectUserGenderfromeButton:selectGender:Sex:)]) {
            
            [self.delegate SelectUserGenderfromeButton:sender selectGender:gender_string Sex:sexnumber];
        }
        
        // 隐藏式图
        [self DismissFromeSuperView];
    }
}

/**
 * @brief 显示视图
 */
- (void)Show{
    
    [UIView animateWithDuration:0.25 animations:^{
        
        self.bgView.frame = ({
            
            CGRect frame = self.bgView.frame;
            
            frame.origin.y = KScreenHeight - KSafeBottomHeight - self.dataSource.count * ViewHeight;
            
            frame;
        });
    }];
}

/**
 * @brief 隐藏视图
 */
- (void)DismissFromeSuperView{
    
    [UIView animateWithDuration:0.25 animations:^{
        
        self.bgView.frame = ({
            
            CGRect frame = self.bgView.frame;
            
            frame.origin.y = KScreenHeight;
            
            frame;
            
        });
        
    }completion:^(BOOL finished) {
        
        [self.bgView removeFromSuperview];
        
        [self removeFromSuperview];
    }];
}



@end
