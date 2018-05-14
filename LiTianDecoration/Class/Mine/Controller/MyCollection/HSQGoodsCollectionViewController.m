//
//  HSQGoodsCollectionViewController.m
//  LiTianDecoration
//
//  Created by administrator on 2018/4/29.
//  Copyright © 2018年 administrator. All rights reserved.
//

#define KTitlesViewHeight 50

#import "HSQGoodsCollectionViewController.h"
#import "HSQGoodsCollectionListCell.h"
#import "HSQMyCollectionHeaderView.h"

@interface HSQGoodsCollectionViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,HSQMyCollectionHeaderViewDelegate>

@property (nonatomic, weak) UIView *titlesView; // 顶部的所有标签

@property (nonatomic, weak) UIButton *selectedButton; // 当前选中的按钮

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) UICollectionView *CollectionView;

@end

@implementation HSQGoodsCollectionViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.navigationItem.title = @"我的收藏";
    
    self.view.backgroundColor = KViewBackGroupColor;
    
    // 0.创建CollectionView
    [self SetUpCollectionView];
    
    // 1.设置顶部标题栏
    [self setupTopTitlesView];
    
}

/**
 * @brief 设置顶部标题栏
 */
- (void)setupTopTitlesView{
    
    NSArray *titlesArray = @[@"默认",@"降价",@"促销",@"分类"];
    
    // 标签栏整体
    UIView *titlesView = [[UIView alloc] init];
    titlesView.backgroundColor = [[UIColor whiteColor]colorWithAlphaComponent:0.8];
    titlesView.mj_w = [UIScreen mainScreen].bounds.size.width;
    titlesView.mj_h = KTitlesViewHeight;
    titlesView.mj_y = 0;
    [self.view addSubview:titlesView];
    self.titlesView = titlesView;
    
    // 内部的子标签
    CGFloat width = titlesView.mj_w / titlesArray.count;
    CGFloat height = titlesView.mj_h;
    for (NSInteger i = 0; i < titlesArray.count; i++) {
        
        UIButton *button = [UIButton buttonWithType:(UIButtonTypeCustom)];
        button.tag = i;
        button.mj_h = height;
        button.mj_w = width;
        button.mj_x = i * width;
        
        [button setTitle:titlesArray[i] forState:UIControlStateNormal];
        
        [button setTitleColor:RGB(131, 131, 131) forState:UIControlStateNormal];
        
        [button setTitleColor:RGB(255, 83, 63) forState:UIControlStateDisabled];
        
        button.titleLabel.font = [UIFont systemFontOfSize:KTextFont_(14)];
        
        [button addTarget:self action:@selector(titleClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [titlesView addSubview:button];
        
        // 默认点击了第一个按钮
        if (i == 0)
        {
            button.enabled = NO;
            
            self.selectedButton = button;
            
            // 让按钮内部的label根据文字内容来计算尺寸
            [button.titleLabel sizeToFit];
        }
    }
}

/**
 * @brief 顶部按钮的点击事件
 */
- (void)titleClick:(UIButton *)button{
    
    // 修改按钮状态
    self.selectedButton.enabled = YES;
    
    button.enabled = NO;
    
    self.selectedButton = button;
    
}

/**
 * @brief 创建CollectionView
 */
- (void)SetUpCollectionView{
    
    UICollectionViewFlowLayout *Layout = [[UICollectionViewFlowLayout alloc] init];
    
    Layout.itemSize = CGSizeMake((KScreenWidth-5)/2, (KScreenWidth-5)/2);
    
    Layout.minimumLineSpacing = 5;  // 最小的行间距
    
    Layout.minimumInteritemSpacing = 5; // 最小的列间距
    
    CGFloat collectionHeight = KScreenHeight - KSafeBottomHeight  - KSafeTopeHeight  - KTitlesViewHeight;
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, KTitlesViewHeight, KScreenWidth, collectionHeight) collectionViewLayout:Layout];
    
    collectionView.backgroundColor = [UIColor clearColor];
    
    collectionView.dataSource = self;
    
    collectionView.delegate = self;
    
    [collectionView registerClass:[HSQGoodsCollectionListCell class] forCellWithReuseIdentifier:@"HSQGoodsCollectionListCell"];
    
    [collectionView registerClass:[HSQMyCollectionHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HSQMyCollectionHeaderView"];
    
    [self.view addSubview:collectionView];
    
    [self.view sendSubviewToBack:collectionView];
    
    self.collectionView = collectionView;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionViewDelegate,UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 10;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return (section == 9 ? 11 : 0);
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    
    return (section == 9 ? CGSizeMake(KScreenWidth, 150) : CGSizeMake(KScreenWidth, 100));
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    HSQMyCollectionHeaderView *headView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HSQMyCollectionHeaderView" forIndexPath:indexPath];
    
    [headView.Like_Btn setHidden:(indexPath.section == 9 ? NO : YES)];
    
    headView.delegate = self;
    
    return headView;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    HSQGoodsCollectionListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HSQGoodsCollectionListCell" forIndexPath:indexPath];
    
    [cell.OrginPrice_label setHidden:YES];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    
}

- (void)ClickOnTheButtonInTheLowerRightCorner:(UIButton *)sender{
    
//    HSQMyCollectionHeaderView *HeaderView = (HSQMyCollectionHeaderView *)sender.superview;
}











@end
