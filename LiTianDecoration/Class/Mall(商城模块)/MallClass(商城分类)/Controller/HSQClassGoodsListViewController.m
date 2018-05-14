//
//  HSQClassGoodsListViewController.m
//  LiTianDecoration
//
//  Created by administrator on 2018/4/30.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import "HSQClassGoodsListViewController.h"
#import "HSQScreeningViewController.h"
#import "HSQClassSecondGoodsListCell.h"
#import "HSQDropdownMenuView.h"

@interface HSQClassGoodsListViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,HSQDropdownMenuViewDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic,strong) NSMutableArray *dataSource;

@property (nonatomic, assign) BOOL isGrid;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ViewHeight;

@property (weak, nonatomic) IBOutlet UIButton *ComprehensiveBtn;  // 综合按钮

@property (weak, nonatomic) IBOutlet UIButton *XiaoLiang_Btn;  // 销量

@property (weak, nonatomic) IBOutlet UIButton *Price_Btn;

@property (nonatomic, strong) HSQDropdownMenuView *bgView;

@property (nonatomic, copy) NSString *IsSelectString;

@property (nonatomic, copy) NSString *SelectIndex;

@end

@implementation HSQClassGoodsListViewController

-(NSMutableArray *)dataSource{
    
    if (_dataSource == nil) {
        
        self.dataSource = [NSMutableArray array];
    }
    
    return _dataSource;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.view.backgroundColor = KViewBackGroupColor;
    
    // 默认列表视图
    self.isGrid = YES;
    
    // 创建集合视图
    [self SetUpCollectionView];
    
    // 默认第一个被点击
    self.IsSelectString = self.SelectIndex =@"0";
    self.ComprehensiveBtn.selected = YES;
    
    // 添加菜单按钮
    [self addMenuView];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"布局" style:(UIBarButtonItemStylePlain) target:self action:@selector(RightItemClick:)];

}

/**
 * @brief 综合按钮的点击
 */
- (IBAction)ClickEventForTheHeadFilterButton:(UIButton *)sender {
    
    self.ComprehensiveBtn.selected = YES;
    [self.XiaoLiang_Btn setEnabled:YES];
    [self.Price_Btn setEnabled:YES];
    
    // 显示筛选界面
    if (self.IsSelectString.integerValue == 0 || self.IsSelectString.integerValue == 1)
    {
        [self.bgView ShowMenuView];
        
        self.IsSelectString = @"2";
    }
    else
    {
        [self.bgView HiddenMenuView];
        
        self.IsSelectString = @"1";
    }
    
    self.bgView.SelectNumber = self.SelectIndex;
    
}

/**
 * @brief 销量的点击
 */
- (IBAction)ClickOnTheSalesButton:(UIButton *)sender {
    
    // 1.首先隐藏综合排序的界面
    [self.bgView HiddenMenuView];
    self.bgView.SelectNumber = @"0";
    self.IsSelectString = @"1";
    self.SelectIndex = @"0";
    self.ComprehensiveBtn.selected = NO;
    [self.Price_Btn setEnabled:YES];
     [self.ComprehensiveBtn setTitle:@"综合" forState:(UIControlStateNormal)];
    
    // 2.修改按钮状态
    self.XiaoLiang_Btn.enabled = NO;
}

/**
 * @brief 价格的点击
 */
- (IBAction)ClickOnPriceSort:(UIButton *)sender {
    
    
    
}

/**
 * @brief 筛选的点击
 */
- (IBAction)FilteredClickAction:(UIButton *)sender {
    
    HSQScreeningViewController *ScreeningVC = [[HSQScreeningViewController alloc] init];
    
    [self.navigationController pushViewController:ScreeningVC animated:YES];
}


- (void)RightItemClick:(UIBarButtonItem *)sender{
    
    _isGrid = !_isGrid;
    
    [self.collectionView reloadData];
    
    if (_isGrid)
    {
        //        [self.swithBtn setImage:[UIImage imageNamed:@"product_list_grid_btn"] forState:0];
    }
    else
    {
        //        [self.swithBtn setImage:[UIImage imageNamed:@"product_list_list_btn"] forState:0];
    }
}

/**
 * @brief 创建集合视图
 */
- (void)SetUpCollectionView{
    
    UICollectionViewFlowLayout *flowlayout = [[UICollectionViewFlowLayout alloc] init];
    [flowlayout setScrollDirection:UICollectionViewScrollDirectionVertical]; //设置滚动方向
    flowlayout.minimumInteritemSpacing = 2; //左右间距
    flowlayout.minimumLineSpacing = 2; //上下间距
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0 , self.ViewHeight.constant , KScreenWidth, KScreenHeight - KSafeTopeHeight - KSafeBottomHeight - 50) collectionViewLayout:flowlayout];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.showsVerticalScrollIndicator = NO;
    collectionView.showsHorizontalScrollIndicator = NO;
    [collectionView setBackgroundColor:[UIColor clearColor]];
    
    [collectionView registerClass:[HSQClassSecondGoodsListCell class] forCellWithReuseIdentifier:@"HSQClassSecondGoodsListCell"];
    
    [self.view addSubview:collectionView];
    
    self.collectionView = collectionView;

}

/**
 * @brief 添加菜单视图
 */
- (void)addMenuView{
    
    HSQDropdownMenuView *menuView = [[HSQDropdownMenuView alloc] initWithFrame:CGRectMake(0, self.ViewHeight.constant, KScreenWidth, KScreenHeight - KSafeTopeHeight - KSafeBottomHeight - self.ViewHeight.constant)];
   
    menuView.delegate = self;
    
    [self.view addSubview:menuView];
    
    self.bgView = menuView;
}

/**
 * @brief 菜单视图的点击事件
 */
- (void)MenuButtonSelectionClickIndexPath:(NSIndexPath *)indexPath content:(NSString *)SelectString{
    
    HSQLog(@"===%@",SelectString);
    
    self.ComprehensiveBtn.selected = YES;
    [self.XiaoLiang_Btn setEnabled:YES];
    [self.Price_Btn setEnabled:YES];
    self.IsSelectString = @"1";
    [self.bgView HiddenMenuView];
    
    if ([SelectString containsString:@"综合"])
    {
        [self.ComprehensiveBtn setTitle:@"综合" forState:(UIControlStateSelected)];
        self.SelectIndex = @"0";
    }
    else
    {
        [self.ComprehensiveBtn setTitle:@"评论" forState:(UIControlStateSelected)];
        self.SelectIndex = @"1";
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return 20;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    HSQClassSecondGoodsListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HSQClassSecondGoodsListCell" forIndexPath:indexPath];
    
    cell.isGrid = _isGrid;
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.isGrid)
    {
        return CGSizeMake((KScreenWidth - 6) / 2, (KScreenWidth - 6) / 2 + 80);
    }
    else
    {
        return CGSizeMake(KScreenWidth, 120);
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
}



















@end
