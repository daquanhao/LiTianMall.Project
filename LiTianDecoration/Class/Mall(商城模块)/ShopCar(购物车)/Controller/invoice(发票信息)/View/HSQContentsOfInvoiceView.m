//
//  HSQContentsOfInvoiceView.m
//  LiTianDecoration
//
//  Created by administrator on 2018/5/25.
//  Copyright © 2018年 administrator. All rights reserved.
//

#define KPlacherLabelHeight 50

#define KViewHeight KScreenHeight - KSafeBottomHeight

#import "HSQContentsOfInvoiceView.h"
#import "HSQSubmitOrderCouperListCell.h"

@interface HSQContentsOfInvoiceView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UIView *BgView;

@property (nonatomic, strong) UIView *TopView;

@property (nonatomic, strong) UILabel *placher_Label;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, copy) NSString *IndexString;

@end

@implementation HSQContentsOfInvoiceView

-(NSMutableArray *)dataSource{
    
    if (_dataSource == nil) {
        
        self.dataSource = [NSMutableArray arrayWithObjects:@"明细",@"酒",@"食品",@"饮料",@"玩具",@"日用品", @"装修材料",@"化妆品",@"办公用品",@"学生用品",@"家具用品",@"饰品",@"服装", @"箱包",@"精品",@"家电",@"家防用品",@"耗材",@"电脑配件",nil];
    }
    
    return _dataSource;
}

/**
 * @brief 初始化视图
 */
+ (instancetype)initContentsOfInvoiceView{
    
    HSQContentsOfInvoiceView *publicView = [[HSQContentsOfInvoiceView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KViewHeight)];
    
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
    placher_Label.text = @"选择发票内容";
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

- (void)setFaPiaoContent_String:(NSString *)FaPiaoContent_String{
    
    _FaPiaoContent_String = FaPiaoContent_String;
    
    for (NSInteger i = 0; i < self.dataSource.count; i++) {
        
        NSString *string = [NSString stringWithFormat:@"%@",self.dataSource[i]];
        
        if ([string isEqualToString:FaPiaoContent_String])
        {
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
    
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    HSQSubmitOrderCouperListCell * cell = [tableView dequeueReusableCellWithIdentifier:@"HSQSubmitOrderCouperListCell" forIndexPath:indexPath];
    
    cell.ShengMonery_Label.text = [NSString stringWithFormat:@"%@",self.dataSource[indexPath.row]];
    
    cell.ActivityName_Label.hidden = YES;
    
    cell.Reason_Label.hidden = YES;
    
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
    
    NSString *string = self.dataSource[indexPath.row];
    
    if (self.SelectFaPiaoContentDataBlock) {
        
        self.SelectFaPiaoContentDataBlock(string);
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
- (void)ShowContentsOfInvoiceView{
    
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
