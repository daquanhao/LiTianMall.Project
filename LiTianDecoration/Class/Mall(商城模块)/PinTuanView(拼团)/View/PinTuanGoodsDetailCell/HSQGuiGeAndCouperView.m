//
//  HSQGuiGeAndCouperView.m
//  LiTianDecoration
//
//  Created by administrator on 2018/5/10.
//  Copyright © 2018年 administrator. All rights reserved.
//

#define KPlacherLabelHeight 50

#define KViewHeight KScreenHeight - KSafeBottomHeight

#import "HSQGuiGeAndCouperView.h"
#import "HSQCoupterListCell.h"

@interface HSQGuiGeAndCouperView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UIView *BgView;

@property (nonatomic, strong) UIView *TopView;

@property (nonatomic, strong) UILabel *placher_Label;

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation HSQGuiGeAndCouperView

/**
 * @brief 初始化视图
 */
+ (instancetype)initGuiGeAndCouperView{
    
    HSQGuiGeAndCouperView *publicView = [[HSQGuiGeAndCouperView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KViewHeight)];
    
    publicView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
    
    [[[UIApplication sharedApplication] keyWindow]addSubview:publicView];
    
    return publicView;
}

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        // 1.创建控件
        [self SetUpViews];
        
    }
    
    return self;
}


// 1.创建控件
- (void)SetUpViews{
    
    // 最底部的点击按钮
    UIButton *Bottombtn = [UIButton buttonWithType:(UIButtonTypeSystem)];
    Bottombtn.frame = self.bounds;
    Bottombtn.backgroundColor = [UIColor clearColor];
    [Bottombtn addTarget:self action:@selector(btnClickAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:Bottombtn];
    
    // 1.屏幕一半的背景图
    UIView *BgView = [[UIView alloc] initWithFrame:CGRectMake(0, KScreenHeight, KScreenWidth,(KViewHeight)/2)];
    BgView.backgroundColor = [UIColor whiteColor];
    [self addSubview:BgView];
    self.BgView = BgView;
    
    // 2.头部的提示标题
    UILabel *placher_Label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KPlacherLabelHeight)];
    placher_Label.textColor = [UIColor grayColor];
    placher_Label.backgroundColor = [UIColor clearColor];
    placher_Label.font = [UIFont systemFontOfSize:15.0];
    placher_Label.textAlignment = NSTextAlignmentCenter;
    [BgView addSubview:placher_Label];
    self.placher_Label = placher_Label;
    
    // 3.右边的退出按钮
    UIButton *right_button = [UIButton buttonWithType:(UIButtonTypeCustom)];
    right_button.frame = CGRectMake(KScreenWidth - KPlacherLabelHeight, 0, KPlacherLabelHeight, KPlacherLabelHeight);
    right_button.backgroundColor = [UIColor orangeColor];
    [right_button addTarget:self action:@selector(dismissAdressView) forControlEvents:(UIControlEventTouchUpInside)];
    [BgView addSubview:right_button];
    
    // 6.添加tableView
    UITableView * tabbleView = [[UITableView alloc]initWithFrame:CGRectMake(0, KPlacherLabelHeight, KScreenWidth, BgView.mj_h - KPlacherLabelHeight)];
    tabbleView.backgroundColor = KViewBackGroupColor;
    tabbleView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tabbleView.delegate = self;
    tabbleView.dataSource = self;
    tabbleView.contentInset = UIEdgeInsetsMake(0, 0, 10, 0);
    [tabbleView registerNib:[UINib nibWithNibName:@"HSQCoupterListCell" bundle:nil] forCellReuseIdentifier:@"HSQCoupterListCell"];
    [BgView addSubview:tabbleView];
    self.tableView = tabbleView;
    
}

- (void)setTypeString:(NSString *)TypeString{
    
    _TypeString = TypeString;
    
    [self.tableView reloadData];
}


#pragma mark - TableViewDatasouce

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    HSQCoupterListCell * cell = [tableView dequeueReusableCellWithIdentifier:@"HSQCoupterListCell" forIndexPath:indexPath];
    
    if (self.TypeString.integerValue == 100)
    {
        [cell.BgView setHidden:YES];
    }
    else
    {
         [cell.BgView setHidden:NO];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
        
    if (self.delegate && [self.delegate respondsToSelector:@selector(ChooseGuiGeAndCoupter:)]) {
        
        [self.delegate ChooseGuiGeAndCoupter:indexPath];
    }
}

















- (void)setPlacherString:(NSString *)placherString{
    
    _placherString = placherString;
    
    self.placher_Label.text = placherString;
}

/** 点击背景按钮的点击事件*/
- (void)btnClickAction:(UIButton *)sender{
    
    [self dismissAdressView];
}


/**
 * @brief 显示视图
 */
- (void)ShowGuiGeAndCouperView{
    
    [UIView animateWithDuration:0.25 animations:^{
        
        self.BgView.frame = ({
            
            CGRect frame = self.BgView.frame;
            
            frame.origin.y = (KScreenHeight) / 2;
            
            frame;
        });
    }];
}

/**
 * @brief 隐藏视图
 */
- (void)dismissAdressView{
    
    [UIView animateWithDuration:0.25 animations:^{
        
        self.BgView.frame = ({
            
            CGRect frame = self.BgView.frame;
            
            frame.origin.y = KScreenHeight;
            
            frame;
        });
    }completion:^(BOOL finished) {
        
        [self.BgView removeFromSuperview];
        
        [self removeFromSuperview];
    }];
}


@end
