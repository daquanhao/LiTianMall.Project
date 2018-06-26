//
//  HSQIntegralCenterViewController.m
//  LiTianDecoration
//
//  Created by administrator on 2018/4/13.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import "HSQIntegralCenterViewController.h"
#import "HSQAccountTool.h"
#import "HSQPointsExchangeHeadReusableView.h"
#import "HSQPointsExchangeFooterReusableView.h"
#import "HSQPointsRedEnvelopeListCell.h"
#import "HSQRedEnvelopeListDataModel.h"
#import "HSQMembershipListModel.h"
#import "HSQPointsExchangeGoodsListModel.h"
#import "HSQPointsGoodsListViewCell.h"
#import "HSQPointsExchangeGoodsDetailViewController.h"
#import "HSQLoginHomeViewController.h"

@interface HSQIntegralCenterViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,HSQPointsExchangeFooterReusableViewDelegate,HSQPointsExchangeHeadReusableViewDelegate>

{
    dispatch_group_t HSQ_Group;
}

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSMutableArray *pointsGoodsList; // 积分商品列表

@property (nonatomic, strong) NSMutableArray *RedEnvelope_Source;  // 红包列表数组

@property (nonatomic, strong) NSMutableArray *memberGradeList;  // 会员等级列表数组

@property (nonatomic, assign) NSInteger currentPage;

@property (nonatomic, copy) NSString *totalPage; // 总页数

@property (nonatomic, strong) HSQNoDataView *noDataView;

@property (nonatomic, copy) NSString *memberGrade; // 会员等级（非必选项）

@property (nonatomic, copy) NSString *sort; // 排序方式

@property (nonatomic, copy) NSString *points; // 积分区间区间 0-0，必须以-为连接符

@property (nonatomic, strong) NSDictionary *UserInfoDiction;  // 用户信息

@property (nonatomic, strong) UIView *BgView;

@end

@implementation HSQIntegralCenterViewController

-(NSMutableArray *)pointsGoodsList{
    
    if (_pointsGoodsList == nil) {
        
        self.pointsGoodsList = [NSMutableArray array];
    }
    
    return _pointsGoodsList;
}

-(NSMutableArray *)RedEnvelope_Source{
    
    if (_RedEnvelope_Source == nil) {
        
        self.RedEnvelope_Source = [NSMutableArray array];
    }
    
    return _RedEnvelope_Source;
}

-(NSMutableArray *)memberGradeList{
    
    if (_memberGradeList == nil) {
        
        self.memberGradeList = [NSMutableArray array];
    }
    
    return _memberGradeList;
}

- (HSQNoDataView *)noDataView{
    
    if (!_noDataView) {
        
        _noDataView = [[HSQNoDataView alloc] initWithTitle:@"亲，还没有相关的数据额" imageName:@"WaitingForView" height:50 TopMargin:0];
    }
    return _noDataView;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.view.backgroundColor = KViewBackGroupColor; // KListPointsExchangedGoodsUrl
    
    self.navigationItem.title = self.NavtionTitle;
    
    self.UserInfoDiction = [NSDictionary dictionary];
    
    self.memberGrade = @""; // 会员等级
    
    self.sort = @""; // 排序
    
    self.points = @""; // 积分区间区间 0-0，必须以-为连接符

    // 4.监听用户的登录
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(UserLoginSuccessNotif:) name:@"UserDidLoginSuccessNotif" object:nil];
    
    // 创建集合视图
    [self CreatCollectionView];
    
    [[HSQProgressHUDManger Manger] ShowLoadingDataFromeServer:nil ToView:self.view IsClearColor:NO];
    
    // 1.创建队列组
    dispatch_group_t group = dispatch_group_create();
    
    HSQ_Group = group;
  
    [self ThreadsAreOpenedToRequestData];
}

/**
 * @brief 开辟线程请求数据
 */
- (void)ThreadsAreOpenedToRequestData{
    
    // 1.1.全局并发队列
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    // 进入组（进入组和离开组必须成对出现, 否则会造成死锁）
    dispatch_group_enter(HSQ_Group);
    
    // 1.2.执行任务1（请求用户的信息）
    dispatch_group_async(HSQ_Group, queue, ^{
        
        // 请求用户中心的数据
        [self requestUserCenterDataFromeserver];
        
    });
    
    // 进入组
    dispatch_group_enter(HSQ_Group);
    
    // 1.3.执行任务2（请求红包的数据）
    dispatch_group_async(HSQ_Group, queue, ^{
        
        // 请求红包的数据
        [self LoadARedEnvelopeListDataFromeServer];
    });
    
    // 进入组
    dispatch_group_enter(HSQ_Group);
    
    // 1.3.执行任务3（会员等级列表）
    dispatch_group_async(HSQ_Group, queue, ^{
        
        // 会员等级列表
        [self LoadMembershipListDataFromeServer];
    });
    
    // 任务全部执行完以后，同意处理（刷新UI）
    dispatch_group_notify(HSQ_Group, queue, ^{
        
        HSQLog(@"======所有的数据处理完毕");
        
        //通知主线程刷新
        dispatch_async(dispatch_get_main_queue(), ^{
            
            //回调或者说是通知主线程刷新，
            [[HSQProgressHUDManger Manger] DismissProgressHUD];
            
            [self.collectionView reloadData];
        });
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            // 添加刷新控件
            [self AddTheListOfPointsExchangedForGoodsListRefreshControls];
        });
    });
}

/**
 * @brief  创建集合视图
 */
- (void)CreatCollectionView{
    
    UICollectionViewFlowLayout *Layout = [[UICollectionViewFlowLayout alloc] init];
    
    CGFloat collectionHeight = KScreenHeight - KSafeBottomHeight - KSafeTopeHeight;
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, collectionHeight) collectionViewLayout:Layout];
    
    collectionView.backgroundColor = [UIColor clearColor];
    
    collectionView.dataSource = self;

    collectionView.delegate = self;

    UINib *HeadNib = [UINib nibWithNibName:@"HSQPointsExchangeHeadReusableView" bundle:nil];
    [collectionView registerNib:HeadNib forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HSQPointsExchangeHeadReusableView"];

    UINib *FooterNib = [UINib nibWithNibName:@"HSQPointsExchangeFooterReusableView" bundle:nil];
    [collectionView registerNib:FooterNib forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"HSQPointsExchangeFooterReusableView"];
    
    [collectionView registerNib:[UINib nibWithNibName:@"HSQPointsGoodsListViewCell" bundle:nil] forCellWithReuseIdentifier:@"HSQPointsGoodsListViewCell"];

    [collectionView registerNib:[UINib nibWithNibName:@"HSQPointsRedEnvelopeListCell" bundle:nil] forCellWithReuseIdentifier:@"HSQPointsRedEnvelopeListCell"];
    
    [self.view addSubview:collectionView];
    
    [self.view sendSubviewToBack:collectionView];
    
    self.collectionView = collectionView;
    
    // 背景图
    UIView *BgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - KSafeTopeHeight - KSafeBottomHeight)];
    
    BgView.backgroundColor = KViewBackGroupColor;
    
    [self.view addSubview:BgView];
    
    self.BgView = BgView;
}

/**
 * @brief 请求用户中心的数据
 */
- (void)requestUserCenterDataFromeserver{
    
    HSQAccount *account = [HSQAccountTool account];
    
    if (account.token.length == 0)
    {
        // 离开组
        dispatch_group_leave(HSQ_Group);
    }
    else
    {
        NSDictionary *diction = @{@"token":account.token};
        
        AFNetworkRequestTool *RequestTool = [AFNetworkRequestTool shareRequestTool];
        
        [RequestTool.manger POST:UrlAdress(KUserCenterDataUrl) parameters:diction progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *responseObject) {
            
            HSQLog(@"=用户中心的数据==%@",responseObject);
            
            if ([responseObject[@"code"] integerValue] == 200)
            {
                self.UserInfoDiction = responseObject[@"datas"];
            }
            
            // 离开组
            dispatch_group_leave(HSQ_Group);
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            // 离开组
            dispatch_group_leave(HSQ_Group);
            
            [[HSQProgressHUDManger Manger] ShowDisplayFailedToLoadData:KErrorPlacherString SuperView:self.view];
        }];
    }
}


/**
 * @brief 加载红包数据
 */
- (void)LoadARedEnvelopeListDataFromeServer{
    
    // 0.清空数组
    [self.RedEnvelope_Source removeAllObjects];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    params[@"token"] = ([HSQAccountTool account].token.length == 0 ? @"" : [HSQAccountTool account].token);
    
    AFNetworkRequestTool *requestTool = [AFNetworkRequestTool shareRequestTool];
    
    [requestTool.manger POST:UrlAdress(KListPointsRedPageUrl) parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [[HSQProgressHUDManger Manger] DismissProgressHUD];
        
        if ([responseObject[@"code"] integerValue] == 200)
        {
            self.RedEnvelope_Source = [HSQRedEnvelopeListDataModel mj_objectArrayWithKeyValuesArray:responseObject[@"datas"][@"redPackageTemplateList"]];
        }
        else
        {
            NSString *errorString = [NSString stringWithFormat:@"%@",responseObject[@"datas"][@"error"]];
            
            [[HSQProgressHUDManger Manger] ShowDisplayFailedToLoadData:errorString SuperView:self.view];
        }
        
        // 离开组
        dispatch_group_leave(HSQ_Group);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        // 离开组
        dispatch_group_leave(HSQ_Group);
        
        // 提示数据请求失败
        [[HSQProgressHUDManger Manger] ShowProgressHUDPromptText:KErrorPlacherString SupView:self.view];
    }];
}

/**
 * @brief 会员等级列表数据
 */
- (void)LoadMembershipListDataFromeServer{
    
    AFNetworkRequestTool *requestTool = [AFNetworkRequestTool shareRequestTool];
    
    [requestTool.manger GET:UrlAdress(KMembershipListDataUrl) parameters:nil progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if ([responseObject[@"code"] integerValue] == 200)
        {
            self.memberGradeList = [HSQMembershipListModel mj_objectArrayWithKeyValuesArray:responseObject[@"datas"][@"memberGradeList"]];
        }
        else
        {
            NSString *errorString = [NSString stringWithFormat:@"%@",responseObject[@"datas"][@"error"]];
            
            [[HSQProgressHUDManger Manger] ShowDisplayFailedToLoadData:errorString SuperView:self.view];
        }
        
        // 离开组
        dispatch_group_leave(HSQ_Group);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        // 离开组
        dispatch_group_leave(HSQ_Group);
        
        // 提示数据请求失败
        [[HSQProgressHUDManger Manger] ShowProgressHUDPromptText:KErrorPlacherString SupView:self.view];
    }];
}


/**
 * @brief 添加刷新控件
 */
- (void)AddTheListOfPointsExchangedForGoodsListRefreshControls{
    
    // 1.下拉加载更多的数据
    self.collectionView.mj_header  = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(LoadNewPointsExchangedForGoodsListData)];
    
    [self.collectionView.mj_header beginRefreshing];
    
    // 3.上啦加载更多的代码
    self.collectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(LoadMorePointsExchangedForGoodsListData)];
}

/**
 * @brief 加载最新的积分兑换商品数据
 */
- (void)LoadNewPointsExchangedForGoodsListData{
    
    // 0.清空数组
    [self.pointsGoodsList removeAllObjects];
    
    // 结束上啦
    [self.collectionView.mj_footer endRefreshing];
    
    self.currentPage = 1;
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    params[@"token"] = ( [HSQAccountTool account].token.length == 0? @"" : [HSQAccountTool account].token);
    
    params[@"page"] = @(self.currentPage);
    
    params[@"memberGrade"] = self.memberGrade;
    
    params[@"sort"] = self.sort;
    
    params[@"points"] = self.points;
    
    AFNetworkRequestTool *requestTool = [AFNetworkRequestTool shareRequestTool];
    
    [requestTool.manger GET:UrlAdress(KListPointsExchangedGoodsUrl) parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        HSQLog(@"===积分兑换商品数据===%@",responseObject);
        
        self.totalPage = [NSString stringWithFormat:@"%@",responseObject[@"datas"][@"pageEntity"][@"totalPage"]];
        
        if ([responseObject[@"code"] integerValue] == 200)
        {
            self.pointsGoodsList = [HSQPointsExchangeGoodsListModel mj_objectArrayWithKeyValuesArray:responseObject[@"datas"][@"pointsGoodsList"]];
            
            self.BgView.hidden = YES;
        }
        else
        {
            NSString *errorString = [NSString stringWithFormat:@"%@",responseObject[@"datas"][@"error"]];
            
            [[HSQProgressHUDManger Manger] ShowDisplayFailedToLoadData:errorString SuperView:self.view];
        }
        
        [self.collectionView.mj_header endRefreshing];
        
        [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:1]];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        // 结束刷新
        [self.collectionView.mj_header endRefreshing];
        
        // 提示数据请求失败
        [[HSQProgressHUDManger Manger] ShowProgressHUDPromptText:KErrorPlacherString SupView:self.view];

    }];
}

/**
 * @brief 加载更多的积分兑换商品数据
 */
- (void)LoadMorePointsExchangedForGoodsListData{
    
    [self.collectionView.mj_header endRefreshing];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    params[@"token"] = ( [HSQAccountTool account].token.length == 0? @"" : [HSQAccountTool account].token);
    
    params[@"page"] = @(++self.currentPage);
    
    params[@"memberGrade"] = self.memberGrade;
    
    params[@"sort"] = self.sort;
    
    params[@"points"] = self.points;
    
    AFNetworkRequestTool *requestTool = [AFNetworkRequestTool shareRequestTool];
    
    [requestTool.manger GET:UrlAdress(KListPointsExchangedGoodsUrl) parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        HSQLog(@"===积分兑换商品数据===%@",responseObject);
        
        if ([responseObject[@"code"] integerValue] == 200)
        {
            NSArray *cashList = [HSQPointsExchangeGoodsListModel mj_objectArrayWithKeyValuesArray:responseObject[@"datas"][@"pointsGoodsList"]];
            
            if (cashList.count == 0)
            {
                [self.collectionView.mj_footer endRefreshingWithNoMoreData];
            }
            else
            {
                [self.pointsGoodsList addObjectsFromArray:cashList];
            }
        }
        else
        {
            NSString *errorString = [NSString stringWithFormat:@"%@",responseObject[@"datas"][@"error"]];
            
            [[HSQProgressHUDManger Manger] ShowDisplayFailedToLoadData:errorString SuperView:self.view];
        }
        
        [self.collectionView.mj_footer endRefreshing];
        
         [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:1]];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        // 结束刷新
        [self.collectionView.mj_footer endRefreshing];
        
        // 提示数据请求失败
        [[HSQProgressHUDManger Manger] ShowProgressHUDPromptText:KErrorPlacherString SupView:self.view];
    }];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionViewDelegate,UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    if (section == 0)
    {
         return self.RedEnvelope_Source.count;
    }
    else
    {
        if (self.currentPage == self.totalPage.integerValue || self.totalPage.integerValue == 0)
        {
            self.collectionView.mj_footer.hidden = YES;
        }
        else
        {
            self.collectionView.mj_footer.hidden = NO;
        }
         return self.pointsGoodsList.count;
    }
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    
    if (section == 0)
    {
         return CGSizeMake(KScreenWidth, 130);
    }
    else
    {
         return CGSizeMake(KScreenWidth, 0);
    }
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    
    if (section == 0)
    {
        return CGSizeMake(KScreenWidth, 80);
    }
    else
    {
        return CGSizeMake(KScreenWidth, 0);
    }
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionReusableView *reusableView = nil;
    
    if (kind == UICollectionElementKindSectionHeader)
    {
        HSQPointsExchangeHeadReusableView *headView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HSQPointsExchangeHeadReusableView" forIndexPath:indexPath];
        
        if (self.UserInfoDiction.allKeys.count == 0)
        {
            headView.NickName_BgView.hidden = YES;
        }
        else
        {
            headView.NickName_BgView.hidden = NO;
            
            headView.UserInfoDiction = self.UserInfoDiction;
        }
        
        headView.delegate = self;
        
        reusableView = headView;
    }
    
    if (kind == UICollectionElementKindSectionFooter)
    {
        HSQPointsExchangeFooterReusableView *FooterView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"HSQPointsExchangeFooterReusableView" forIndexPath:indexPath];
        
        FooterView.memberGradeList = self.memberGradeList;
        
        FooterView.delegate = self;
        
        reusableView = FooterView;
    }
    
    return reusableView;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
   
    if (indexPath.section == 0)
    {
        return CGSizeMake(KScreenWidth, 70);
    }
    else
    {
        return CGSizeMake((KScreenWidth - 5) / 2, (KScreenWidth - 5) / 2 + 80);
    }
    
}

// 两个cell之间的最小间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    
    return 5;
}

// 行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    
    return 5;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0)
    {
        HSQPointsRedEnvelopeListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HSQPointsRedEnvelopeListCell" forIndexPath:indexPath];
        
        cell.model = self.RedEnvelope_Source[indexPath.row];
        
        return cell;
    }
    else
    {
        HSQPointsGoodsListViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HSQPointsGoodsListViewCell" forIndexPath:indexPath];
        
        cell.model = self.pointsGoodsList[indexPath.row];
                
        return cell;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) // 红包
    {
        // 1.判断用户是否登录
        [self ClickEventForReceivingRedEnvelopes:indexPath];
    }
    else
    {
        HSQPointsExchangeGoodsListModel *model = self.pointsGoodsList[indexPath.row];
        
        HSQPointsExchangeGoodsDetailViewController *PointsExchangeGoodsDetailVC  = [[HSQPointsExchangeGoodsDetailViewController alloc] init];
        
        PointsExchangeGoodsDetailVC.commonId = model.commonId;
        
        [self.navigationController pushViewController:PointsExchangeGoodsDetailVC animated:YES];
    }
    
}

/**
 * @brief 会员等级按钮的点击
 */
- (void)ClickEventOfTheMembershipRankButton:(UIButton *)sender model:(HSQMembershipListModel *)ListModel{
    
    self.memberGrade = ListModel.gradeLevel;
    
    [self.collectionView.mj_header beginRefreshing];
}

/**
 * @brief 头部登录按钮的点击
 */
- (void)HeaderLoginButtonClickEvent:(UIButton *)sender{
    
    HSQLoginHomeViewController *LoginVC = [[HSQLoginHomeViewController alloc] init];
    
    [self.navigationController pushViewController:LoginVC animated:YES];
}

/**
 * @brief 监听用户的登录
 */
- (void)UserLoginSuccessNotif:(NSNotification *)notif{
    
    // 1.1.全局并发队列
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    // 进入组（进入组和离开组必须成对出现, 否则会造成死锁）
    dispatch_group_enter(HSQ_Group);
    
    // 1.2.执行任务1（请求用户的信息）
    dispatch_group_async(HSQ_Group, queue, ^{
        
        // 请求用户中心的数据
        [self requestUserCenterDataFromeserver];
        
    });
    
    // 进入组
    dispatch_group_enter(HSQ_Group);
    
    // 1.3.执行任务2（请求红包的数据）
    dispatch_group_async(HSQ_Group, queue, ^{
        
        // 请求红包的数据
        [self LoadARedEnvelopeListDataFromeServer];
    });
    
    // 任务全部执行完以后，同意处理（刷新UI）
    dispatch_group_notify(HSQ_Group, queue, ^{
        
        HSQLog(@"======所有的数据处理完毕");
        
        //通知主线程刷新
        dispatch_async(dispatch_get_main_queue(), ^{
            
            //回调或者说是通知主线程刷新，
            [[HSQProgressHUDManger Manger] DismissProgressHUD];
            
            [self.collectionView reloadData];
        });
    });
}


/**
 * @brief 领取红包
 */
- (void)ClickEventForReceivingRedEnvelopes:(NSIndexPath *)indexPath{
    
    NSString *token = [HSQAccountTool account].token;
    
    if (token.length == 0)
    {
        HSQLoginHomeViewController *LoginVC = [[HSQLoginHomeViewController alloc] init];
        
        [self.navigationController pushViewController:LoginVC animated:YES];
    }
    else
    {
        HSQRedEnvelopeListDataModel *model = self.RedEnvelope_Source[indexPath.row];
        
        HSQLog(@"====%@",model.hasReceived);
        
        if (model.hasReceived.integerValue == 0)
        {
            [self InformTheServerThatNeedToGetThePlatformCoupon:model indexPath:indexPath];
        }
    }
}

/**
 * @brief 通知服务器我要领取积分平台券
 */
- (void)InformTheServerThatNeedToGetThePlatformCoupon:(HSQRedEnvelopeListDataModel *)model indexPath:(NSIndexPath *)indexPath{
    
    NSString *message = [NSString stringWithFormat:@"确定要花费%@积分兑换红包吗？",model.expendPoints];
    
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:(UIAlertControllerStyleAlert)];
    
    UIAlertAction *Cancel_action = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:nil];
    
    UIAlertAction *delete_action = [UIAlertAction actionWithTitle:@"确认" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        
        [[HSQProgressHUDManger Manger] ShowLoadingDataFromeServer:@"" ToView:self.view IsClearColor:YES];
        
        NSDictionary *params = @{@"token":[HSQAccountTool account].token,@"templateId":model.templateId};
        
        AFNetworkRequestTool *requestTool = [AFNetworkRequestTool shareRequestTool];
        
        [requestTool.manger POST:UrlAdress(KFreeReceiveRedPageUrl) parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            HSQLog(@"==领取积分平台券==%@===",responseObject);
            
            [[HSQProgressHUDManger Manger] DismissProgressHUD];
            
            if ([responseObject[@"code"] integerValue] == 200)
            {
                model.hasReceived = @"1";
                
                [[HSQProgressHUDManger Manger] ShowProgressHUDPromptText:@"领取成功" SupView:self.view];
                
                [self.RedEnvelope_Source replaceObjectAtIndex:indexPath.row withObject:model];
                
                [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
            }
            else
            {
                NSString *errorString = [NSString stringWithFormat:@"%@",responseObject[@"datas"][@"error"]];
                
                [[HSQProgressHUDManger Manger] ShowDisplayFailedToLoadData:errorString SuperView:self.view];
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            [[HSQProgressHUDManger Manger] ShowProgressHUDPromptText:KErrorPlacherString SupView:self.view];
            
        }];
    }];
    
    [alertVC addAction:delete_action];
    
    [alertVC addAction:Cancel_action];
    
    [self presentViewController:alertVC animated:YES completion:nil];
}

/**
 * @brief 视图销毁的时候，移除消息
 */
- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}









@end
