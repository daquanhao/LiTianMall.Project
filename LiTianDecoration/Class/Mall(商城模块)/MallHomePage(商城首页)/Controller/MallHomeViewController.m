//
//  MallHomeViewController.m
//  LiTianDecoration
//
//  Created by administrator on 2018/5/7.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import "MallHomeViewController.h"
#import "HSQMallHomeHeadView.h"
#import "HSQMallHomeDataModel.h"
#import "HSQGoodsCollectionListCell.h"
#import "HSQModelViewReusableView.h"
#import "HSQSecondsKillReusableView.h"
#import "HSQHeadImageReusableView.h"

@interface MallHomeViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,HSQMallHomeHeadViewDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, strong) NSMutableArray *Secons;

@end

@implementation MallHomeViewController

- (NSMutableArray *)dataSource{
    
    if (_dataSource == nil) {
        
        self.dataSource = [NSMutableArray array];
    }
    
    return _dataSource;
}

- (NSMutableArray *)Secons{
    
    if (_Secons == nil) {
        
        self.Secons = [NSMutableArray arrayWithObjects:@"0",@"0",@"0",@"0",@"0",@"2",@"8",@"1",@"4",@"4",@"4",@"4",@"1",@"4",@"4",@"8",@"13", nil];
    }
    
    return _Secons;
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
    
    NSDictionary *diction = @{@"clientType":@"ios"};
    
    AFNetworkRequestTool *RequestTool = [AFNetworkRequestTool shareRequestTool];
    
    [RequestTool.manger GET:UrlAdress(@"/") parameters:diction progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
    
        HSQLog(@"==商城首页=%@",responseObject);
        
        [[HSQProgressHUDManger Manger] DismissProgressHUD];
        
        // 1.轮播图数据
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
    
    return self.Secons.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    if (section == self.Secons.count - 1)
    {
        HSQMallHomeDataModel *model = [self.dataSource lastObject];
        
        return model.itemDataSource.count;
    }
    else
    {
        NSString *count = self.Secons[section];
        
        return count.integerValue;
    }
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    
    if (section == 0)  // 轮播图
    {
        return CGSizeMake(KScreenWidth, KScreenWidth/2);
    }
    else if(section == 1) // 每列5个按钮的模块
    {
       return CGSizeMake(KScreenWidth, KScreenWidth * 0.35 + 20);
    }
    else if(section == 2) // 秒杀
    {
        return CGSizeMake(KScreenWidth, KSecondViewHeight);
    }
    else if(section == 3) // 发现好货
    {
        return CGSizeMake(KScreenWidth, 200);
    }
    else if(section == 4) // 领券中心
    {
        return CGSizeMake(KScreenWidth, 200);
    }
    else if(section == 5) // 海外购
    {
        return CGSizeMake(KScreenWidth, 150);
    }
    else if(section == 6) // 海外购下面的8个小模块
    {
        return CGSizeMake(0, 0);
    }
    else if(section == 7) // 爱生活
    {
        return CGSizeMake(KScreenWidth, 80);
    }
    else if(section == 8) // 享品质
    {
        return CGSizeMake(KScreenWidth, 80);
    }
    else if(section == 10) // 517吃货节
    {
        return CGSizeMake(KScreenWidth, 150);
    }
    else if(section == 13) // 逛商场
    {
        return CGSizeMake(KScreenWidth, 80);
    }
    else if(section == self.Secons.count - 1) // 为你推荐
    {
        return CGSizeMake(KScreenWidth, 60);
    }
    else
    {
        return CGSizeMake(0, 0);
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0)  // 轮播图
    {
        return CGSizeMake(0, 0);
    }
    else if(indexPath.section == 1) // 每列5个按钮的模块
    {
        return CGSizeMake(0, 0);
    }
    else if(indexPath.section == 2) // 秒杀
    {
        return CGSizeMake(0, 0);
    }
    else if(indexPath.section == 3) // 发现好货
    {
        return CGSizeMake(0, 0);
    }
    else if(indexPath.section == 4) // 领券中心
    {
        return CGSizeMake(0, 0);
    }
    else if(indexPath.section == 5) // 海外购
    {
        return CGSizeMake((KScreenWidth - 2)/2, 100);
    }
    else if(indexPath.section == 6)// 海外购下面的8个模块
    {
        return CGSizeMake((KScreenWidth-5)/4, (KScreenWidth-5)/4 * 1.5);
    }
    else if(indexPath.section == 7)// 爱生活
    {
        return CGSizeMake(KScreenWidth,150);
    }
    else if(indexPath.section == 8) // 享品质
    {
       return CGSizeMake((KScreenWidth - 2)/2, 100);
    }
    else if(indexPath.section == 9) // 享品质下面的4个模块
    {
        return CGSizeMake((KScreenWidth-5)/4, (KScreenWidth-5)/4 * 1.5);
    }
    else if(indexPath.section == 10) // 517吃货节
    {
        return CGSizeMake((KScreenWidth - 2)/2, 100);
    }
    else if(indexPath.section == 11) // 517吃货节下面的四个按钮
    {
        return CGSizeMake((KScreenWidth-5)/4, (KScreenWidth-5)/4 * 1.5);
    }
    else if(indexPath.section == 12) // 母亲节
    {
         return CGSizeMake(KScreenWidth, 150);
    }
    else if(indexPath.section == 13) // 逛商场
    {
        return CGSizeMake((KScreenWidth - 2)/2, 100);
    }
    else if(indexPath.section == 14) // 逛商场
    {
        return CGSizeMake((KScreenWidth-5)/4, (KScreenWidth-5)/4 * 1.5);
    }
    else if(indexPath.section == self.Secons.count - 1) // 为你推荐
    {
        return CGSizeMake((KScreenWidth-2)/2, (KScreenWidth-5)/2);
    }
    else
    {
        return CGSizeMake(0, 0);
    }
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) // 轮播图
    {
        HSQMallHomeHeadView *headView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HSQMallHomeHeadView" forIndexPath:indexPath];
        headView.delegate = self;
        
        if (self.dataSource.count != 0)
        {
            headView.model = self.dataSource[indexPath.section];
        }
        
        return headView;
    }
    else if (indexPath.section == 1)  // 每列5个按钮的模块
    {
        HSQModelViewReusableView *ModelView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HSQModelViewReusableView" forIndexPath:indexPath];
    
        if (self.dataSource.count != 0)
        {
            ModelView.model = self.dataSource[indexPath.section];
        }
        return ModelView;
    }
    else if (indexPath.section == 2) // 秒杀
    {
        HSQSecondsKillReusableView *ModelView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HSQSecondsKillReusableView" forIndexPath:indexPath];
        
        if (self.dataSource.count != 0)
        {
            ModelView.model = self.dataSource[indexPath.section];
        }
        
        return ModelView;
    }
    else
    {
        HSQHeadImageReusableView *HeadImageView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HSQHeadImageReusableView" forIndexPath:indexPath];
        
//        if (indexPath.section == 3) // 发现好货
//        {
//            HeadImageView.nameLabel.text = @"发现好货";
//            HeadImageView.backgroundColor = [UIColor purpleColor];
//        }
//        else if (indexPath.section == 4) //领券中心
//        {
//            HeadImageView.nameLabel.text = @"领券中心";
//            HeadImageView.backgroundColor = [UIColor redColor];
//        }
//        else if (indexPath.section == 5) //海外购
//        {
//            HeadImageView.nameLabel.text = @"海外购";
//            HeadImageView.backgroundColor = [UIColor lightGrayColor];
//        }
//        else if (indexPath.section == 7) //爱生活
//        {
//            HeadImageView.nameLabel.text = @"爱生活";
//            HeadImageView.backgroundColor = [UIColor whiteColor];
//        }
//        else if (indexPath.section == 8) //享品质
//        {
//            HeadImageView.nameLabel.text = @"享品质";
//            HeadImageView.backgroundColor = [UIColor blueColor];
//        }
//        else if (indexPath.section == 10) //517吃货节
//        {
//            HeadImageView.nameLabel.text = @"517吃货节";
//            HeadImageView.backgroundColor = [UIColor redColor];
//        }
//        else if (indexPath.section == 13) //逛商场
//        {
//            HeadImageView.nameLabel.text = @"逛商场";
//            HeadImageView.backgroundColor = [UIColor lightGrayColor];
//        }
//        else if (indexPath.section == self.Secons.count - 1) //为你推荐
//        {
//            HeadImageView.nameLabel.text = @"为  你  推  荐";
//            HeadImageView.backgroundColor = [UIColor lightGrayColor];
//        }
        
        return HeadImageView;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    HSQGoodsCollectionListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HSQGoodsCollectionListCell" forIndexPath:indexPath];
    
    [cell.OrginPrice_label setHidden:YES];
    
    if (self.dataSource != 0)
    {
        HSQMallHomeDataModel *model = [self.dataSource lastObject];
        
        //            cell.Diction = model.itemDataSource[indexPath.row];
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
}


#pragma mark - HSQMallHomeHeadViewDelegate

- (void)didClickCycleScrollView:(SDCycleScrollView *)CycleScrollView didSelectItemAtIndex:(NSInteger)index{
    
    HSQLog(@"=第几个轮播图==%ld",index);
}




@end
