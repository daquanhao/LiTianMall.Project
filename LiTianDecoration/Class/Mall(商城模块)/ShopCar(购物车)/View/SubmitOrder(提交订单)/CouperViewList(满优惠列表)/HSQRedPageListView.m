//
//  HSQRedPageListView.m
//  LiTianDecoration
//
//  Created by administrator on 2018/7/10.
//  Copyright © 2018年 administrator. All rights reserved.
//

#define KPlacherLabelHeight 50

#define KViewHeight KScreenHeight - KSafeBottomHeight

#import "HSQRedPageListView.h"
#import "HSQSubmitOrderCouperListCell.h"
#import "HSQRedEnvelopeListModel.h"

@interface HSQRedPageListView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UIView *BgView;

@property (nonatomic, strong) UIView *TopView;

@property (nonatomic, strong) UILabel *placher_Label;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, copy) NSString *IndexString;

@end

@implementation HSQRedPageListView


-(NSMutableArray *)dataSource{
    
    if (_dataSource == nil) {
        
        self.dataSource = [NSMutableArray array];
    }
    
    return _dataSource;
}

/**
 * @brief 初始化视图
 */
+ (instancetype)initSubmitRedPageListView{
    
    HSQRedPageListView *publicView = [[HSQRedPageListView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KViewHeight)];
    
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
    placher_Label.font = [UIFont systemFontOfSize:14.0];
    placher_Label.text = @"选择平台红包";
    placher_Label.textAlignment = NSTextAlignmentCenter;
    [BgView addSubview:placher_Label];
    self.placher_Label = placher_Label;
    
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

/**
 * @Brief 店铺券的数据
 */
-(void)SetValueDataWithArray:(NSArray *)data_Array Select_Index:(NSString *)index{
    
    [self.dataSource addObjectsFromArray:data_Array];
    
    for (NSInteger i = 0; i < data_Array.count; i++) {
        
        HSQRedEnvelopeListModel *model = data_Array[i];
        
        NSString *Voucherid = [NSString stringWithFormat:@"%@",model.redPackageId];
        
        if (index.integerValue == Voucherid.integerValue) {
            
            self.IndexString = [NSString stringWithFormat:@"%ld",i+1];
        }
    }
    
    [self.tableView reloadData];
    
}

#pragma mark - TableViewDatasouce

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataSource.count + 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 45;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    HSQSubmitOrderCouperListCell * cell = [tableView dequeueReusableCellWithIdentifier:@"HSQSubmitOrderCouperListCell" forIndexPath:indexPath];
    
    if (indexPath.row == 0)
    {
        cell.ShengMonery_Label.text = [NSString stringWithFormat:@"%@",@"不使用优惠"];
        
    }
    else
    {
        if (self.dataSource.count != 0)
        {
            HSQRedEnvelopeListModel *model = self.dataSource[indexPath.row-1];
            
            cell.ShengMonery_Label.text = [NSString stringWithFormat:@"面额：¥%.2f",[model.redPackagePrice floatValue]];
            
            cell.ActivityName_Label.text = [NSString stringWithFormat:@"满%.2f元可用",[model.limitAmount floatValue]];
            
            cell.Reason_Label.hidden = YES;
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
    
    [self dismissAdressView];
    
    if (self.SelectRedPageDataBlock)
    {
        self.SelectRedPageDataBlock(indexPath);
    }
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
- (void)ShowSubmitRedPageListView{
    
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
