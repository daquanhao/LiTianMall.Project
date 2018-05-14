//
//  HSQMallHomePageController.m
//  LiTianDecoration
//
//  Created by administrator on 2018/5/8.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import "HSQMallHomePageController.h"
#import "HSQMallHomeHeadView.h"
#import "HSQMallHomeDataModel.h"
#import "HSQGoodsCollectionListCell.h"
#import "HSQModelViewReusableView.h"
#import "HSQSecondsKillReusableView.h"
#import "HSQHeadImageReusableView.h"
#import "HSQMallHeiperTool.h"
#import "HSQImageListCollectionViewCell.h"
#import "HSQClassViewController.h"
#import "HSQMallShopCarViewController.h"
#import "HSQLoginViewController.h"
#import "HSQAccountTool.h"
#import "HSQPinTuanViewController.h"
#import "HSQCouponsCenterViewController.h"
#import "HSQToPromoteViewController.h"

@interface HSQMallHomePageController ()<UICollectionViewDelegate,UICollectionViewDataSource,HSQMallHomeHeadViewDelegate,HSQModelViewReusableViewDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation HSQMallHomePageController


- (NSMutableArray *)dataSource{
    
    if (_dataSource == nil) {
        
        self.dataSource = [NSMutableArray array];
    }
    
    return _dataSource;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.view.backgroundColor = KViewBackGroupColor;
    
    // 创建集合视图
    [self CreatCollectionView];
    
    // 请求首页的数据
    [self AddRefreshControlOnTheHomePage];
    
    
}

/**
 * @brief  创建集合视图
 */
- (void)CreatCollectionView{
    
    UICollectionViewFlowLayout *Layout = [[UICollectionViewFlowLayout alloc] init];
    
    Layout.minimumLineSpacing = 1;  // 最小的行间距
    
    Layout.minimumInteritemSpacing = 1; // 最小的列间距
    
    CGFloat collectionHeight = KScreenHeight - KSafeBottomHeight - KSafeTopeHeight;
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, collectionHeight) collectionViewLayout:Layout];
    
    collectionView.backgroundColor = [UIColor clearColor];
    
    collectionView.dataSource = self;
    
    collectionView.delegate = self;
    
    [collectionView registerClass:[HSQMallHomeHeadView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HSQMallHomeHeadView"];
    
    [collectionView registerClass:[HSQModelViewReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HSQModelViewReusableView"];
    
    [collectionView registerClass:[HSQSecondsKillReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HSQSecondsKillReusableView"];
    
    [collectionView registerClass:[HSQHeadImageReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HSQHeadImageReusableView"];
    
    [collectionView registerClass:[HSQGoodsCollectionListCell class] forCellWithReuseIdentifier:@"HSQGoodsCollectionListCell"];
        
    [collectionView registerNib:[UINib nibWithNibName:@"HSQImageListCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"HSQImageListCollectionViewCell"];
    
    [self.view addSubview:collectionView];
    
    [self.view sendSubviewToBack:collectionView];
    
    self.collectionView = collectionView;
}

/**
 * @brief 添加刷新控件
 */
- (void)AddRefreshControlOnTheHomePage{
    
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(LoadMallHomeNewDataFromeServer)];
    
    [self.collectionView.mj_header beginRefreshing];
}

/**
 * @brief 加载商城首页最新的数据
 */
- (void)LoadMallHomeNewDataFromeServer{
    
    [self.dataSource removeAllObjects];
    
    [self.collectionView.mj_footer endRefreshing];
    
    [[HSQProgressHUDManger Manger] ShowLoadingDataFromeServer:@"" ToView:self.view IsClearColor:YES];
    
    NSDictionary *paramer = @{@"clientType":@"ios"};
    
    AFNetworkRequestTool *RequestTool = [AFNetworkRequestTool shareRequestTool];
    
    [RequestTool.manger GET:UrlAdress(@"/") parameters:paramer progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
//        HSQLog(@"==商城首页=%@",responseObject);
        
        [[HSQProgressHUDManger Manger] DismissProgressHUD];
        
        // 1.数据
        self.dataSource = [HSQMallHomeDataModel mj_objectArrayWithKeyValuesArray:responseObject[@"datas"][@"itemList"]];

        [self.collectionView.mj_header endRefreshing];
        
        [self.collectionView reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [self.collectionView.mj_header endRefreshing];
        
        [[HSQProgressHUDManger Manger] ShowDisplayFailedToLoadData:@"数据刷新失败" SuperView:self.view];
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionViewDelegate,UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return self.dataSource.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    HSQMallHomeDataModel *model = self.dataSource[section];
        
    return [HSQMallHeiperTool returnNumberWithModel:model];
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    
     HSQMallHomeDataModel *model = self.dataSource[section];
    
    return [HSQMallHeiperTool referenceSizeForHeaderInSection:model];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    HSQMallHomeDataModel *model = self.dataSource[indexPath.section];
    
    return [HSQMallHeiperTool sizeForItemInModel:model index:indexPath];
    
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    HSQMallHomeDataModel *model = self.dataSource[indexPath.section];
    
    if ([model.itemType isEqualToString:@"ad"]) // 轮播图
    {
        HSQMallHomeHeadView *headView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HSQMallHomeHeadView" forIndexPath:indexPath];
        
        headView.delegate = self;
        
        headView.model = self.dataSource[indexPath.section];
        
        return headView;
    }
    else if ([model.itemType isEqualToString:@"home8"]) // 模块式图
    {
        HSQModelViewReusableView *headView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HSQModelViewReusableView" forIndexPath:indexPath];
        
        headView.model = self.dataSource[indexPath.section];
        
        headView.delegate = self;
        
        return headView;
    }
    else
    {
        HSQHeadImageReusableView *HeadImageView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HSQHeadImageReusableView" forIndexPath:indexPath];
                
        HeadImageView.model = self.dataSource[indexPath.section];

        return HeadImageView;
    }

}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    HSQMallHomeDataModel *model = self.dataSource[indexPath.section];
    
    if ([model.itemType isEqualToString:@"goods"])  // 为你推荐的商品列表
    {
        HSQGoodsCollectionListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HSQGoodsCollectionListCell" forIndexPath:indexPath];
        
        [cell.OrginPrice_label setHidden:YES];
        
        cell.Diction = model.itemDataSource[indexPath.row];
        
        return cell;
    }
    else
    {
        HSQImageListCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HSQImageListCollectionViewCell" forIndexPath:indexPath];
        
        if ([model.itemType isEqualToString:@"home4"] || [model.itemType isEqualToString:@"home2"]) 
        {
            cell.model = model;
        }
        else
        {
            NSDictionary *diction = model.itemDataSource[indexPath.row];
            cell.ImageUrl = diction[@"imageUrl"];
        }
    
        return cell;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
}


#pragma mark - HSQMallHomeHeadViewDelegate

- (void)didClickCycleScrollView:(SDCycleScrollView *)CycleScrollView didSelectItemAtIndex:(NSInteger)index{
    
    HSQLog(@"=第几个轮播图==%ld",index);
}

/**
 * @brief 顶部模块按钮的点击事件
 */
- (void)HeadModelViewClickAction:(UIButton *)sender type:(NSString *)typeString{
    
    HSQLog(@"===dingbu===%@",typeString);
//    my 跳转到我的商城，data中无数据
//    setting 跳转到设置页面，data中无数据
//    distPage 跳转到推广页面，data中无数据
//    trys 跳转到试用页面，data中无数据
//    showOrders 跳转到晒宝页面，data中无数据
//    signin 跳转到签到页面，data中无数据
//    pointsCenter 跳转到积分中心，data中无数据
//    voucherCenter 跳转到领券中心，data中无数据
//    activityGoldEgg 跳转到砸蛋活动，data中无数据
    if ([typeString isEqualToString:@"category"])  // 跳转到分类
    {
        HSQClassViewController *classVC = [[HSQClassViewController alloc] init];
        [self.navigationController pushViewController:classVC animated:YES];
    }
    else if ([typeString isEqualToString:@"cart"]) //跳转到购物车
    {
        HSQAccount *account = [HSQAccountTool account];
        
        if (account.token.length == 0)  // 没有登录
        {
            HSQLoginViewController *LoginVC = [[HSQLoginViewController alloc] init];
            [self.navigationController pushViewController:LoginVC animated:YES];
        }
        else
        {
            HSQMallShopCarViewController *ShopCarVC = [[HSQMallShopCarViewController alloc] init];
            [self.navigationController pushViewController:ShopCarVC animated:YES];
        }
    }
    else if ([typeString isEqualToString:@"group"]) //跳转到拼团页面
    {
        HSQPinTuanViewController *PinTuanVC = [[HSQPinTuanViewController alloc] init];
        PinTuanVC.NavtionTitle = @"拼团";
        [self.navigationController pushViewController:PinTuanVC animated:YES];
    }
    else if ([typeString isEqualToString:@"voucherCenter"]) //跳转到领券中心
    {
        HSQCouponsCenterViewController *CouponsCenterVC = [[HSQCouponsCenterViewController alloc] init];
        [self.navigationController pushViewController:CouponsCenterVC animated:YES];
    }
    else if ([typeString isEqualToString:@"distPage"]) //跳转到推广页面
    {
        HSQToPromoteViewController *ToPromoteVC = [[HSQToPromoteViewController alloc] init];
        ToPromoteVC.NavtionTitle = @"推广分佣";
        [self.navigationController pushViewController:ToPromoteVC animated:YES];
    }
        
}








@end
