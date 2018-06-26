//
//  HSQStoreCollectionViewController.m
//  LiTianDecoration
//
//  Created by administrator on 2018/4/29.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import "HSQStoreCollectionViewController.h"
#import "HSQGoodsCollectionListCell.h"
#import "HSQStoreCollectionHeadReusableView.h"
#import "HSQAccountTool.h"
#import "HSQStoreCollectionDataListModel.h" // 收藏店铺的模型

@interface HSQStoreCollectionViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,HSQStoreCollectionHeadReusableViewDelegate>

@property (nonatomic, weak) UIView *titlesView; // 顶部的所有标签

@property (nonatomic, weak) UIButton *selectedButton; // 当前选中的按钮

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSMutableArray *dataSource; // 商品的数组

@property (nonatomic, strong) NSMutableArray *categoryList; // 分类的数组

@property (nonatomic, assign) NSInteger currentPage; // 当前的页数

@property (nonatomic, strong) HSQNoDataView *noDataView;

@property (nonatomic, copy) NSString *totalPage;  // 总的页数

@property (nonatomic, copy) NSString *commonId;  // 商品的sku

@property (nonatomic, assign) NSInteger IsEditState;  // 是否处于编辑状态

@property (nonatomic, strong) UIView *Dete_View; // 底部的删除视图

@property (nonatomic, strong) UILabel *Select_Label; // 底部的选中个数

@property (nonatomic, strong) UIButton *Dete_Button; // 底部的删除按钮

@property (nonatomic, strong) NSMutableArray *Select_Array; // 选中删除的商品数组

@end

@implementation HSQStoreCollectionViewController

-(NSMutableArray *)Select_Array{
    
    if (_Select_Array == nil) {
        
        self.Select_Array = [NSMutableArray array];
    }
    
    return _Select_Array;
}

-(NSMutableArray *)dataSource{
    
    if (_dataSource == nil) {
        
        self.dataSource = [NSMutableArray array];
    }
    
    return _dataSource;
}

-(NSMutableArray *)categoryList{
    
    if (_categoryList == nil) {
        
        self.categoryList = [NSMutableArray array];
    }
    
    return _categoryList;
}

- (HSQNoDataView *)noDataView{
    
    if (!_noDataView) {
        
        _noDataView = [[HSQNoDataView alloc] initWithTitle:@"亲，还没有收藏的店铺额" imageName:@"WaitingForView" height:50 TopMargin:0];
    }
    return _noDataView;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.navigationItem.title = @"我的收藏";
    
    self.view.backgroundColor = KViewBackGroupColor;
    
    // 0.创建CollectionView
    [self SetUpCollectionView];
    
    // 请求商品收藏的数据
    [self RequestDataFromTheMerchandiseCollection];
    
    // 底部删除视图
    [self addBottomDeleteView];
    
    // 监听是否编辑的消息
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(EditNotif:) name:@"SendIsEditStateNotif" object:nil];
    
}


/**
 * @brief 创建CollectionView
 */
- (void)SetUpCollectionView{
    
    UICollectionViewFlowLayout *Layout = [[UICollectionViewFlowLayout alloc] init];
    
    Layout.minimumLineSpacing = 5;  // 最小的行间距
    
    Layout.minimumInteritemSpacing = 5; // 最小的列间距
    
    CGFloat collectionHeight = KScreenHeight - KSafeBottomHeight  - KSafeTopeHeight ;
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, collectionHeight) collectionViewLayout:Layout];
    
    collectionView.backgroundColor = [UIColor clearColor];
    
    collectionView.dataSource = self;
    
    collectionView.delegate = self;
    
    [collectionView registerClass:[HSQGoodsCollectionListCell class] forCellWithReuseIdentifier:@"HSQGoodsCollectionListCell"];
    
    [collectionView registerClass:[HSQStoreCollectionHeadReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HSQStoreCollectionHeadReusableView"];
    
    [self.view addSubview:collectionView];
    
    [self.view sendSubviewToBack:collectionView];
    
    self.collectionView = collectionView;
    
}

/**
 * @brief 请求商品收藏的数据
 */
- (void)RequestDataFromTheMerchandiseCollection{
    
    // 1.下拉加载更多的数据
    self.collectionView.mj_header  = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(LoadNewGoodsCollectionListData)];
    
    [self.collectionView.mj_header beginRefreshing];
    
    // 3.上啦加载更多的代码
    self.collectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(LoadMoreGoodsCollectionListData)];
}

/**
 * @brief 加载最新的收藏的商品数据
 */
- (void)LoadNewGoodsCollectionListData{
    
    [[HSQProgressHUDManger Manger] ShowLoadingDataFromeServer:@"" ToView:self.view IsClearColor:YES];
    
    // 0.清空数组
    [self.dataSource removeAllObjects];
    
    // 结束上啦
    [self.collectionView.mj_footer endRefreshing];
    
    self.currentPage = 1;
    
    NSDictionary *params = @{@"token":[HSQAccountTool account].token,@"page": @(self.currentPage)};
    
    AFNetworkRequestTool *requestTool = [AFNetworkRequestTool shareRequestTool];
    
    [requestTool.manger POST:UrlAdress(KMyCollectionStoreListUrl) parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [[HSQProgressHUDManger Manger] DismissProgressHUD];
        
        HSQLog(@"===店铺收藏数据===%@",responseObject);
        
        self.totalPage = [NSString stringWithFormat:@"%@",responseObject[@"datas"][@"pageEntity"][@"totalPage"]];
        
        if ([responseObject[@"code"] integerValue] == 200)
        {            
            NSArray *array = responseObject[@"datas"][@"storeFavList"];
            
            if (array.count == 0)
            {
                [self.collectionView addSubview:self.noDataView];
            }
            
            for (NSDictionary *diction in array) {
                
                HSQStoreCollectionDataListModel *model = [[HSQStoreCollectionDataListModel alloc] init];
                
                model.IsOpen = @"0";
                
                model.IsEditState = @"1";
                
                model.IsSelectState = @"1";
                
                [model setValuesForKeysWithDictionary:diction];
                
                [self.dataSource addObject:model];
            }
        }
        else
        {
            NSString *errorString = [NSString stringWithFormat:@"%@",responseObject[@"datas"][@"error"]];
            
            [[HSQProgressHUDManger Manger] ShowDisplayFailedToLoadData:errorString SuperView:self.view];
        }
        
        [self.collectionView.mj_header endRefreshing];
        
        [self.collectionView reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        // 结束刷新
        [self.collectionView.mj_header endRefreshing];
        
        [self.collectionView addSubview:self.noDataView];
        
        // 提示数据请求失败
        [[HSQProgressHUDManger Manger] ShowProgressHUDPromptText:@"网络出现问题" SupView:self.view];
    }];
}

/**
 * @brief 加载更多的收藏的商品数据
 */
- (void)LoadMoreGoodsCollectionListData{
    
    [self.collectionView.mj_header endRefreshing];
    
    NSDictionary *params = @{@"token":[HSQAccountTool account].token,@"page": @(++self.currentPage)};
    
    AFNetworkRequestTool *requestTool = [AFNetworkRequestTool shareRequestTool];
    
    [requestTool.manger POST:UrlAdress(KMyCollectionStoreListUrl) parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [[HSQProgressHUDManger Manger] DismissProgressHUD];
        
        HSQLog(@"===加载更多收藏数据===%@",responseObject);
        
        if ([responseObject[@"code"] integerValue] == 200)
        {
            NSArray *array = responseObject[@"datas"][@"storeFavList"];
            
            for (NSDictionary *diction in array) {
                
                HSQStoreCollectionDataListModel *model = [[HSQStoreCollectionDataListModel alloc] init];
                
                model.IsOpen = @"0";
                
                model.IsEditState = @"1";
                
                model.IsSelectState = @"1";
                
                [model setValuesForKeysWithDictionary:diction];
                
                [self.dataSource addObject:model];
            }
        }
        else
        {
            NSString *errorString = [NSString stringWithFormat:@"%@",responseObject[@"datas"][@"error"]];
            
            [[HSQProgressHUDManger Manger] ShowDisplayFailedToLoadData:errorString SuperView:self.view];
        }
        
        [self.collectionView.mj_footer endRefreshing];
        
        [self.collectionView reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        // 结束刷新
        [self.collectionView.mj_footer endRefreshing];
        
        // 提示数据请求失败
        [[HSQProgressHUDManger Manger] ShowProgressHUDPromptText:@"网络出现问题" SupView:self.view];
    }];
    
    
}


/**
 * @brief 底部的删除视图
 */
- (void)addBottomDeleteView{
    
    // 删除视图
    UIView *dete_View = [[UIView alloc] initWithFrame:CGRectMake(0, KScreenHeight, KScreenWidth, 50)];
    dete_View.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:dete_View];
    self.Dete_View = dete_View;
    
    // 删除的按钮
    UIButton *Dete_Button = [UIButton buttonWithType:(UIButtonTypeSystem)];
    Dete_Button.frame = CGRectMake(KScreenWidth - 100, 0, 100, dete_View.mj_h);
    Dete_Button.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [Dete_Button setTitle:@"删除" forState:(UIControlStateNormal)];
    [Dete_Button setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    [Dete_Button setBackgroundImage:[UIImage ImageWithColor:[UIColor redColor]] forState:(UIControlStateNormal)];
    [Dete_Button addTarget:self action:@selector(Dete_ButtonClickAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [dete_View addSubview:Dete_Button];
    self.Dete_Button = Dete_Button;
    
    // 选中的个数
    UILabel *Select_Label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, KScreenWidth - 110, dete_View.mj_h)];
    Select_Label.textColor = RGB(160, 150, 150);
    Select_Label.font = [UIFont systemFontOfSize:14.0];
    NSString *count = [NSString stringWithFormat:@"已选择%@家店铺",@"0"];
    NSMutableAttributedString *attribe = [[NSMutableAttributedString alloc] initWithString:count];
    [attribe addAttribute:NSForegroundColorAttributeName value:RGB(238, 58, 68) range:NSMakeRange(3, 1)];
    Select_Label.attributedText = attribe;
    [dete_View addSubview:Select_Label];
    self.Select_Label = Select_Label;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionViewDelegate,UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    if (self.currentPage == self.totalPage.integerValue || self.totalPage.integerValue == 0)
    {
        self.collectionView.mj_footer.hidden = YES;
    }
    else
    {
        self.collectionView.mj_footer.hidden = NO;
    }
    
    self.noDataView.hidden = (self.dataSource.count != 0);
    
    return self.dataSource.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return 0;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    
    return CGSizeMake(KScreenWidth, 60);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    HSQStoreCollectionHeadReusableView *headView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HSQStoreCollectionHeadReusableView" forIndexPath:indexPath];
    
    headView.delegate = self;
    
    headView.StoreModel = self.dataSource[indexPath.section];
    
    headView.section = indexPath.section;
    
    return headView;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake(KScreenWidth, 100);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    HSQGoodsCollectionListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HSQGoodsCollectionListCell" forIndexPath:indexPath];
    
    [cell.OrginPrice_label setHidden:YES];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    
}

/**
 * @brief 立即分享的按钮点击事件
 */
- (void)ShareTheButtonImmediatelyByClickingTheEvent:(UIButton *)sender{
    
    
}

/**
 * @brief 编辑按钮的点击
 */
- (void)EditNotif:(NSNotification *)notif{
    
    NSString *IsEditState = notif.userInfo[@"IsEditState"];
    
    self.IsEditState = IsEditState.integerValue;
    
    [UIView animateWithDuration:0.25 animations:^{
        
        self.Dete_View.frame = ({
            
            CGRect Dete_View_Frame = self.Dete_View.frame;
            
            Dete_View_Frame.origin.y = (IsEditState.integerValue == 2 ? KScreenHeight - KSafeTopeHeight - KSafeBottomHeight - 50 : KScreenHeight);
            
            Dete_View_Frame;
            
        });
    }];
    
    self.collectionView.mj_header.hidden = self.collectionView.mj_footer.hidden = (IsEditState.integerValue == 2 ? YES : NO);
    
    self.collectionView.contentInset = UIEdgeInsetsMake(0, 0,  (IsEditState.integerValue == 2 ? 50 : 0), 0);
    
    for (HSQStoreCollectionDataListModel *model in self.dataSource) {
        
        model.IsEditState = (IsEditState.integerValue == 2 ? @"2" : @"1");
        
        model.IsOpen =@"0";
    }
    
    [self.collectionView reloadData];
}

/**
 * @brief 编辑时选中按钮的点击
 */
- (void)SelectTheClickEventOfTheButtonWhenEditing:(UIButton *)sender{
    
    HSQStoreCollectionHeadReusableView *headView = (HSQStoreCollectionHeadReusableView *)sender.superview.superview;
    
    HSQStoreCollectionDataListModel *model = self.dataSource[headView.section];
    
    if (model.IsSelectState.integerValue == 1) // 没有编辑
    {
        model.IsSelectState = @"2";
        
        [self.Select_Array addObject:model.storeId];
    }
    else
    {
        model.IsSelectState = @"1";
        
        [self.Select_Array removeObject:model.storeId];
    }
    
    [self.collectionView reloadData];
    
    NSString *count = [NSString stringWithFormat:@"%ld",self.Select_Array.count];
    
    NSMutableAttributedString *attribe = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"已选择%@家店铺",count]];
    
    [attribe addAttribute:NSForegroundColorAttributeName value:RGB(238, 58, 68) range:NSMakeRange(3, count.length)];
    
    self.Select_Label.attributedText = attribe;
    
}

/**
 * @brief 删除按钮的点击
 */
- (void)Dete_ButtonClickAction:(UIButton *)sender{
    
    if (self.Select_Array.count ==0)
    {
        [[HSQProgressHUDManger Manger] ShowProgressHUDPromptText:@"请选择你要删除的店铺" SupView:self.view];
    }
    else
    {
        NSString *Count = [NSString stringWithFormat:@"确认要删除这%ld家店铺吗？",self.Select_Array.count];
        
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:Count preferredStyle:(UIAlertControllerStyleAlert)];
        
        UIAlertAction *Cancel_action = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:nil];
        
        UIAlertAction *delete_action = [UIAlertAction actionWithTitle:@"删除" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            
            [self DeteSelectGoodsFromeServer];
        }];
        
        [alertVC addAction:delete_action];
        
        [alertVC addAction:Cancel_action];
        
        [self presentViewController:alertVC animated:YES completion:nil];
    }
}

/**
 * @brief 删除选中的商品
 */
- (void)DeteSelectGoodsFromeServer{
    
    [[HSQProgressHUDManger Manger] ShowLoadingDataFromeServer:@"" ToView:self.view IsClearColor:YES];
    
    NSString *commonIds = [self.Select_Array componentsJoinedByString:@","];
    
    NSDictionary *params = @{@"token":[HSQAccountTool account].token,@"storeIds":commonIds};
    
    AFNetworkRequestTool *requestTool = [AFNetworkRequestTool shareRequestTool];
    
    [requestTool.manger POST:UrlAdress(KBatchDeteStoreCollectionUrl) parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [[HSQProgressHUDManger Manger] DismissProgressHUD];
        
        HSQLog(@"==删除===%@",responseObject);
        
        if ([responseObject[@"code"] integerValue] == 200)
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"DeteleGoodsSuccessFul" object:self];
            
            for (NSInteger i = 0; i < self.Select_Array.count; i++) {
                
                NSString *commid = self.Select_Array[i];
                
                for (NSInteger j = 0; j < self.dataSource.count; j++) {
                    
                    HSQStoreCollectionDataListModel *model = self.dataSource[j];
                    
                    if ([commid isEqual:model.storeId]) {
                        
                        [self.dataSource removeObject:model];
                    }
                }
            }
            
            [self.collectionView reloadData];
        }
        else
        {
            NSString *errorString = [NSString stringWithFormat:@"%@",responseObject[@"datas"][@"error"]];
            
            [[HSQProgressHUDManger Manger] ShowDisplayFailedToLoadData:errorString SuperView:self.view];
        }
        
        [self.collectionView reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [[HSQProgressHUDManger Manger] ShowProgressHUDPromptText:@"网络出问题啦！" SupView:self.view];
    }];
}




-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
