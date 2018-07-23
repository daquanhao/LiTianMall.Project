//
//  HSQClassViewController.m
//  LiTianDecoration
//
//  Created by administrator on 2018/4/12.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import "HSQClassViewController.h"
#import "HSQClassHomeListCell.h"
#import "HSQClassGoodsListCell.h"
#import "RightGoodsClassModel.h"
#import "HSQLeftCategoryModel.h"
#import "HSQClassHeadCollectionReusableView.h"
#import "HSQClassGoodsListViewController.h"
#import "HSQMessageListViewController.h"
#import "HSQSearchBarViewController.h"

@interface HSQClassViewController ()<UITableViewDataSource,UITableViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSMutableArray *Left_DataSource;

@property (nonatomic, strong) NSMutableArray *Right_DataSource;

@property (nonatomic, strong) UIButton *SearchBar_Btn;

@end

@implementation HSQClassViewController

- (NSMutableArray *)Left_DataSource{
    
    if (_Left_DataSource == nil) {
        
        self.Left_DataSource = [NSMutableArray array];
    }
    
    return _Left_DataSource;
}

- (NSMutableArray *)Right_DataSource{
    
    if (_Right_DataSource == nil) {
        
        self.Right_DataSource = [NSMutableArray array];
    }
    
    return _Right_DataSource;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.view.backgroundColor = KViewBackGroupColor;
    
    // 1.创建左边的tableView
    [self CreatLeftTableView];
    
    // 2.创建集合视图
    [self CreatRightCollectionView];
    
    // 3.添加头部的搜索框视图
    [self AddASearchBoxViewOfTheHeader];
    
    // 4.请求左边的数据
    [self RequestLeftClassDataFromeServer];
    
    // 5.开线程异步加载数据
    [self TheOpenThreadLoadsTheDataAsynchronously];
    
}

/**
 * @brief 创建左边的tableView
 */
- (void)CreatLeftTableView{
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth/4, KScreenHeight - KSafeTopeHeight - KSafeBottomHeight) style:(UITableViewStylePlain)];
    
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    tableView.backgroundColor = [UIColor clearColor];
    
    tableView.dataSource = self;
    
    tableView.delegate = self;
    
    tableView.showsVerticalScrollIndicator = NO;
    
    tableView.showsHorizontalScrollIndicator = NO;
    
    [tableView registerClass:[HSQClassHomeListCell class] forCellReuseIdentifier:@"HSQClassHomeListCell"];
    
    [self.view addSubview:tableView];
    
    self.tableView = tableView;
    
    
}

/**
 * @brief 创建集合视图
 */
- (void)CreatRightCollectionView{
    
    UICollectionViewFlowLayout *Layout = [[UICollectionViewFlowLayout alloc] init];
    
    Layout.itemSize = CGSizeMake((KScreenWidth * 0.75 - 20)/3, (KScreenWidth * 0.75 - 20)/3);
    
    Layout.minimumLineSpacing = 0;  // 最小的行间距
    
    Layout.minimumInteritemSpacing = 0; // 最小的列间距
    
    CGFloat collectionHeight = KScreenHeight - KSafeBottomHeight - KSafeTopeHeight;
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.tableView.frame)+10, 0, KScreenWidth * 0.75 - 20, collectionHeight) collectionViewLayout:Layout];
    
    collectionView.backgroundColor = [UIColor clearColor];
    
    collectionView.dataSource = self;
    
    collectionView.delegate = self;
    
    collectionView.showsHorizontalScrollIndicator = NO;
    
    collectionView.showsVerticalScrollIndicator = NO;
    
    [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    
    [collectionView registerClass:[HSQClassHeadCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HSQClassHeadCollectionReusableView"];

    [collectionView registerClass:[HSQClassGoodsListCell class] forCellWithReuseIdentifier:@"HSQClassGoodsListCell"];
    
    [self.view addSubview:collectionView];
    
    self.collectionView = collectionView;
}

/**
 * @brief 添加头部的搜索框视图
 */
- (void)AddASearchBoxViewOfTheHeader{
    
    UIButton *SearchBar_Btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [SearchBar_Btn setTitleColor:RGB(180, 180, 180) forState:(UIControlStateNormal)];
    SearchBar_Btn.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [SearchBar_Btn setTitle:@"六一儿童童装" forState:(UIControlStateNormal)];
    [SearchBar_Btn setImage:KImageName(@"6DE36884-837C-44C3-B808-CE7F7D8C4FFA") forState:(UIControlStateNormal)];
    [SearchBar_Btn setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
    [SearchBar_Btn setBackgroundImage:KImageName(@"SearchBackGroupImageView") forState:(UIControlStateNormal)];
    [SearchBar_Btn setBackgroundImage:KImageName(@"SearchBackGroupImageView") forState:(UIControlStateHighlighted)];
    SearchBar_Btn.frame = CGRectMake(0, 0, KScreenWidth * 0.7, 30);
    [SearchBar_Btn addTarget:self action:@selector(SearchBar_BtnClickAction:) forControlEvents:(UIControlEventTouchUpInside)];
    self.navigationItem.titleView = SearchBar_Btn;
    self.SearchBar_Btn = SearchBar_Btn;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:KImageName(@"123") style:(UIBarButtonItemStylePlain) target:self action:@selector(ItemClickAction:)];
}

- (void)SearchBar_BtnClickAction:(UIButton *)sender{
    
    HSQSearchBarViewController *SearchBarVC = [[HSQSearchBarViewController alloc] init];
    
    [self.navigationController pushViewController:SearchBarVC animated:YES];
}

- (void)ItemClickAction:(UIBarButtonItem *)sender{
    
    HSQMessageListViewController *MessageListVC = [[HSQMessageListViewController alloc] init];
    
    [self.navigationController pushViewController:MessageListVC animated:YES];
}

/**
 * @brief 开线程异步加载数据
 */
- (void)TheOpenThreadLoadsTheDataAsynchronously{
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(1);
    
    for (NSInteger i = 0; i < 2; i++) {
        
        dispatch_sync(queue, ^{
            
            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
            
            if (i==0)
            {
                [self RequestLeftClassDataFromeServer];  // 1.请求左边的数据
            }
            else if (i==1)
            {
                [self LoadSearchPlacherDataFromeServer];  // 2.加载搜索关键字的数据
            }
            
            dispatch_semaphore_signal(semaphore);
        });
    }
}

/**
 * @brief 请求左边的数据
 */
- (void)RequestLeftClassDataFromeServer{
    
    [[HSQProgressHUDManger Manger] ShowLoadingDataFromeServer:@"" ToView:self.view IsClearColor:YES];
    
    AFNetworkRequestTool *RequestTool = [AFNetworkRequestTool shareRequestTool];
    
    [RequestTool.manger GET:UrlAdress(KClassDataUrl) parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *responseObject) {
        
        HSQLog(@"===%@",responseObject);
        [[HSQProgressHUDManger Manger] DismissProgressHUD];
        
        if ([[responseObject allKeys] containsObject:@"datas"])
        {
            self.Left_DataSource = [HSQLeftCategoryModel mj_objectArrayWithKeyValuesArray:responseObject[@"datas"][@"categoryList"]];
            
            [self tableView:self.tableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];  
        }
        else
        {
            NSString *errorString = [NSString stringWithFormat:@"%@",responseObject[@"datas"][@"error"]];
            
            [[HSQProgressHUDManger Manger] ShowDisplayFailedToLoadData:errorString SuperView:self.view];
        }
        
        [self.tableView reloadData];
        
        [self.collectionView reloadData];
        
        // 设置视图加载是默认选择左边的第几个分类、这里设置默认选中第一个
        [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [[HSQProgressHUDManger Manger] ShowDisplayFailedToLoadData:@"分类数据加载失败" SuperView:self.view];
        
    }];
    
}

/**
 * @brief 加载搜索关键字的数据
 */
- (void)LoadSearchPlacherDataFromeServer{
    
    AFNetworkRequestTool *RequestTool = [AFNetworkRequestTool shareRequestTool];
    
    [RequestTool.manger GET:UrlAdress(KSearchPlacherUrl) parameters:nil progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        HSQLog(@"=搜索==%@",responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
        [self.SearchBar_Btn setTitle:@"搜索" forState:(UIControlStateNormal)];
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource,UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.Left_DataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    HSQClassHomeListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HSQClassHomeListCell" forIndexPath:indexPath];
    
    if (self.Left_DataSource.count != 0)
    {
        cell.model = self.Left_DataSource[indexPath.row];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    HSQLeftCategoryModel *model = self.Left_DataSource[indexPath.row];
    
    self.Right_DataSource = [RightGoodsClassModel mj_objectArrayWithKeyValuesArray:model.categoryList];

    [self.collectionView reloadData];

//    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:(UICollectionViewScrollPositionTop) animated:YES];
}

#pragma mark - UICollectionViewDelegate,UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return self.Right_DataSource.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    RightGoodsClassModel *model = self.Right_DataSource[section];
    
    return model.categoryList.count;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{

    if (section == 0)
    {
        return CGSizeMake(KScreenWidth * 0.75 - 20, 150);
    }
    else
    {
        return CGSizeMake(KScreenWidth * 0.75 - 20, 40);
    }
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{

    HSQClassHeadCollectionReusableView *headView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HSQClassHeadCollectionReusableView" forIndexPath:indexPath];
    
    [headView.head_imageView setHidden:(indexPath.section == 0 ? NO : YES)];
    
    RightGoodsClassModel *model = self.Right_DataSource[indexPath.section];
    
    headView.title_label.text = model.categoryName;
    
    [headView.BottomView setHidden:YES];

    return headView;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    HSQClassGoodsListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HSQClassGoodsListCell" forIndexPath:indexPath];

    if (self.Right_DataSource.count != 0)
    {
        RightGoodsClassModel *model = self.Right_DataSource[indexPath.section];

        NSDictionary *diction = model.categoryList[indexPath.row];

        cell.good_titleLabel.text = [NSString stringWithFormat:@"%@",diction[@"categoryName"]];
        
        [cell.good_image sd_setImageWithURL:[NSURL URLWithString:diction[@"appImageUrl"]] placeholderImage:KGoodsPlacherImage];

    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    HSQClassGoodsListViewController *ClassGoodsListVC = [[HSQClassGoodsListViewController alloc] init];
    
    [self.navigationController pushViewController:ClassGoodsListVC animated:YES];
}


                                                            
                                                                                                        



@end
