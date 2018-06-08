//
//  HSQChooseTuiKuanReasonView.m
//  LiTianDecoration
//
//  Created by administrator on 2018/5/25.
//  Copyright © 2018年 administrator. All rights reserved.
//

#define KPlacherLabelHeight 50

#define KViewHeight KScreenHeight - KSafeBottomHeight

#import "HSQChooseTuiKuanReasonView.h"
#import "HSQSubmitOrderCouperListCell.h"

@interface HSQChooseTuiKuanReasonView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UIView *BgView;

@property (nonatomic, strong) UIView *TopView;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, copy) NSString *IndexString;

@end

@implementation HSQChooseTuiKuanReasonView

-(NSMutableArray *)dataSource{
    
    if (_dataSource == nil) {
        
        self.dataSource = [NSMutableArray array];
    }
    
    return _dataSource;
}

/**
 * @brief 初始化视图
 */
+ (instancetype)initChooseTuiKuanReasonView{
    
    HSQChooseTuiKuanReasonView *publicView = [[HSQChooseTuiKuanReasonView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KViewHeight)];
    
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
    
    // 3.右边的退出按钮
    UIButton *right_button = [UIButton buttonWithType:(UIButtonTypeCustom)];
    right_button.frame = CGRectMake(KScreenWidth - KPlacherLabelHeight, 0, KPlacherLabelHeight, KPlacherLabelHeight);
    [right_button setImage:KImageName(@"TuiChuButton") forState:(UIControlStateNormal)];
    [right_button addTarget:self action:@selector(dismissAdressView) forControlEvents:(UIControlEventTouchUpInside)];
    [BgView addSubview:right_button];
    
    // 6.添加tableView
    UITableView * tabbleView = [[UITableView alloc]initWithFrame:CGRectMake(0, KPlacherLabelHeight, KScreenWidth, BgView.mj_h - KPlacherLabelHeight)];
    tabbleView.backgroundColor = KViewBackGroupColor;
    tabbleView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tabbleView.delegate = self;
    tabbleView.dataSource = self;
    tabbleView.contentInset = UIEdgeInsetsMake(0, 0, 10, 0);
    [tabbleView registerNib:[UINib nibWithNibName:@"HSQSubmitOrderCouperListCell" bundle:nil] forCellReuseIdentifier:@"HSQSubmitOrderCouperListCell"];
    [BgView addSubview:tabbleView];
    self.tableView = tabbleView;
    
}


-(void)SetValueDataWithArray:(NSArray *)data_Array Select_Index:(NSString *)index{
    
    [self.dataSource addObjectsFromArray:data_Array];
    
    for (NSInteger i = 0; i < data_Array.count; i++) {
        
        NSDictionary *diction = data_Array[i];
        
        NSString *couperid = nil;
        
        if ([diction.allKeys containsObject:@"reasonId"])
        {
            couperid = [NSString stringWithFormat:@"%@",diction[@"reasonId"]];
        }
        else
        {
            couperid = [NSString stringWithFormat:@"%@",diction[@"subjectId"]];
        }
        
        if (index.integerValue == couperid.integerValue) {
            
            self.IndexString = [NSString stringWithFormat:@"%ld",i];
        }
    }
    
    [self.tableView reloadData];
    
}

#pragma mark - TableViewDatasouce

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 45;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    HSQSubmitOrderCouperListCell * cell = [tableView dequeueReusableCellWithIdentifier:@"HSQSubmitOrderCouperListCell" forIndexPath:indexPath];
    
    if (self.dataSource.count != 0)
    {
        NSDictionary *diction = self.dataSource[indexPath.row];
        
        cell.ShengMonery_Label.hidden = YES;
        
        cell.ActivityName_Label.hidden = YES;
        
        if ([diction.allKeys containsObject:@"reasonId"])
        {
            cell.Reason_Label.text = [NSString stringWithFormat:@"%@",diction[@"reasonInfo"]];
        }
        else
        {
            cell.Reason_Label.text = [NSString stringWithFormat:@"%@",diction[@"title"]];
        }
    }
    
    if (indexPath.row == self.IndexString.integerValue)
    {
        cell.Left_ImageView.image = KImageName(@"320A9B4D-0268-49C1-845B-7E3AABAB72BC");
    }
    else
    {
        cell.Left_ImageView.image = KImageName(@"878CADA4-7366-480C-856E-9DBA873C758C");
    }
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.SelectReasonDataBlock)
    {
        self.SelectReasonDataBlock(indexPath);
    }
    
    [self dismissAdressView];
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
- (void)ShowChooseTuiKuanReasonView{
    
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
