//
//  HSQLoginChooseAdressView.m
//  LiTianDecoration
//
//  Created by administrator on 2018/5/10.
//  Copyright © 2018年 administrator. All rights reserved.
//

#define KPlacherLabelHeight 50

#define KViewHeight KScreenHeight - KSafeBottomHeight

#import "HSQLoginChooseAdressView.h"
#import "HSQChooseMemberAdressListCell.h"
#import "HSQAccountTool.h"
#import "HSQAcceptAddressListModel.h"
#import "HSQOtherAdressView.h"

@interface HSQLoginChooseAdressView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UIView *BgView;

@property (nonatomic, strong) UIView *TopView;

@property (nonatomic, strong) UILabel *placher_Label;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UIButton *ChooseOther_Btn;

@property (nonatomic, strong) HSQOtherAdressView *OtherAdressView;

@property (nonatomic, strong) UIButton *Back_Btn;

@property (nonatomic, weak) UIScrollView *contentView; // 底部的所有内容

@end

@implementation HSQLoginChooseAdressView

/**
 * @brief 初始化视图
 */
+ (instancetype)initGuiGeAndCouperView{
    
    HSQLoginChooseAdressView *publicView = [[HSQLoginChooseAdressView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KViewHeight)];
    
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

/**
 * @brief 创建控件
 */
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
    placher_Label.font = [UIFont systemFontOfSize:KLabelFont(15.0, 14.0)];
    placher_Label.textAlignment = NSTextAlignmentCenter;
    [BgView addSubview:placher_Label];
    self.placher_Label = placher_Label;
    
    // 3.左边的退出按钮
    UIButton *Back_Btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    Back_Btn.frame = CGRectMake(0, 0, KPlacherLabelHeight, KPlacherLabelHeight);
    [Back_Btn setImage:KImageName(@"LeftBackIcon") forState:(UIControlStateNormal)];
    [Back_Btn addTarget:self action:@selector(Back_BtnClickAction:) forControlEvents:(UIControlEventTouchUpInside)];
    Back_Btn.hidden = YES;
    [BgView addSubview:Back_Btn];
    self.Back_Btn = Back_Btn;
    
    // 3.右边的退出按钮
    UIButton *right_button = [UIButton buttonWithType:(UIButtonTypeCustom)];
    right_button.frame = CGRectMake(KScreenWidth - KPlacherLabelHeight, 0, KPlacherLabelHeight, KPlacherLabelHeight);
    [right_button setImage:KImageName(@"TuiChuButton") forState:(UIControlStateNormal)];
    [right_button addTarget:self action:@selector(dismissAdressView) forControlEvents:(UIControlEventTouchUpInside)];
    [BgView addSubview:right_button];
    
    // 滚动式图
    UIScrollView *contentView = [[UIScrollView alloc] init];
    contentView.showsVerticalScrollIndicator = NO;
    contentView.showsHorizontalScrollIndicator = NO;
    contentView.frame = CGRectMake(0, KPlacherLabelHeight, KScreenWidth, BgView.mj_h - KPlacherLabelHeight);
    contentView.pagingEnabled = NO;
    contentView.backgroundColor = KViewBackGroupColor;
    [BgView addSubview:contentView];
    contentView.contentSize = CGSizeMake(contentView.mj_w * 2, 0);
    self.contentView = contentView;
    
    // 6.添加tableView
    UITableView * tabbleView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, BgView.mj_h - KPlacherLabelHeight - 45)];
    tabbleView.backgroundColor = [UIColor whiteColor];
    tabbleView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tabbleView.delegate = self;
    tabbleView.dataSource = self;
    [tabbleView registerClass:[HSQChooseMemberAdressListCell class] forCellReuseIdentifier:@"HSQChooseMemberAdressListCell"];
    [contentView addSubview:tabbleView];
    self.tableView = tabbleView;
    
    // 选择其他地址
    UIButton *ChooseOther_Btn = [UIButton buttonWithType:(UIButtonTypeSystem)];
    [ChooseOther_Btn setTitle:@"选择其他地址" forState:(UIControlStateNormal)];
    [ChooseOther_Btn setBackgroundImage:[UIImage ImageWithColor:RGB(238, 58, 68)] forState:(UIControlStateNormal)];
    ChooseOther_Btn.titleLabel.font = [UIFont systemFontOfSize:KLabelFont(14.0, 12.0)];
    [ChooseOther_Btn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    ChooseOther_Btn.frame = CGRectMake(0, CGRectGetMaxY(tabbleView.frame), KScreenWidth, 45);
    [ChooseOther_Btn addTarget:self action:@selector(ChooseOther_BtnClickAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [contentView addSubview:ChooseOther_Btn];
    self.ChooseOther_Btn = ChooseOther_Btn;
    
    // 选择其他的地址的视图
    HSQOtherAdressView *OtherAdressView = [[HSQOtherAdressView alloc] initWithFrame:CGRectMake(KScreenWidth, 0, KScreenWidth, contentView.mj_h)];
    
    OtherAdressView.chooseFinish = ^(NSString *string, NSString * proId, NSString * cityId, NSString * areaId) {
    
        [self dismissAdressView];
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(ChooseMemberAdressWithModel:Adreid:)]) {
            
            [self.delegate ChooseMemberAdressWithModel:string Adreid:cityId];
        }
        
    };
    
    [contentView addSubview:OtherAdressView];
    
    self.OtherAdressView = OtherAdressView;
}

#pragma mark - TableViewDatasouce

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    HSQAcceptAddressListModel *model = self.dataSource[indexPath.row];
    
    return [self.tableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:[HSQChooseMemberAdressListCell class] contentViewWidth:KScreenWidth];

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    HSQChooseMemberAdressListCell * cell = [tableView dequeueReusableCellWithIdentifier:@"HSQChooseMemberAdressListCell" forIndexPath:indexPath];
    
    cell.model = self.dataSource[indexPath.row];
    
    ////// 此步设置用于实现cell的frame缓存，可以让tableview滑动更加流畅 //////
    [cell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self dismissAdressView];
    
    HSQAcceptAddressListModel *model = self.dataSource[indexPath.row];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(ChooseMemberAdressWithModel:Adreid:)]) {
        
        [self.delegate ChooseMemberAdressWithModel:model.adressName Adreid:model.areaId2];
    }
}

- (void)setPlacherString:(NSString *)placherString{
    
    _placherString = placherString;
    
    self.placher_Label.text = placherString;
}

/**
 * @brief 数据源
 */
- (void)setDataSource:(NSMutableArray *)dataSource{
    
    _dataSource = dataSource;
    
    [self.tableView reloadData];
}

/**
 * @brief 选中的城市id
 */
- (void)setCity_name:(NSString *)city_name{
    
    _city_name = city_name;
    
    HSQLog(@"=我来啦===%@",city_name);
    
    for (NSInteger i = 0; i < self.dataSource.count; i ++) {
        
        HSQAcceptAddressListModel *model = self.dataSource[i];
        
        HSQLog(@"===%@",model.adressName);
        
        if ([model.adressName isEqualToString:city_name])
        {
            model.Select_string = @"1";
        }
        else
        {
            model.Select_string = @"0";
        }
    }
    
    [self.tableView reloadData];
}

/**
 * @brief 点击背景按钮的点击事件
 */
- (void)btnClickAction:(UIButton *)sender{
    
    [self dismissAdressView];
}


/**
 * @brief 显示视图
 */
- (void)ShowLoginChooseAdressView{
    
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

/**
 * @brief 选择其他地址的点击事件
 */
- (void)ChooseOther_BtnClickAction:(UIButton *)sender{
    
    self.Back_Btn.hidden = NO;
    
    [self.contentView setContentOffset:CGPointMake(KScreenWidth, 0) animated:YES];
    
    
}

/**
 * @brief 返回按钮的点击
 */
- (void)Back_BtnClickAction:(UIButton *)sender{
    
    self.Back_Btn.hidden = YES;
    
    [self.contentView setContentOffset:CGPointMake(0, 0) animated:YES];
}








@end
