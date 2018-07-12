//
//  HSQMineViewController.m
//  LiTianDecoration
//
//  Created by administrator on 2018/4/10.
//  Copyright © 2018年 administrator. All rights reserved.
//

#define KRadio 0.7
#define KHeadHeight 400

//#define KcollectionView_Y ([UIScreen mainScreen].bounds.size.height == 812.0 ? 0 : 0)
#define KcollectionView_Y 0

#import "HSQMineViewController.h"
#import "HSQAccountTool.h"
#import "HSQHeaderCollectionReusableView.h"
#import "HSQCustomNavBar.h"
#import "HSQGoodsCollectionListCell.h"
#import "HSQPersonCenterViewController.h"
#import "HSQSetingViewController.h"
#import "HSQAdressListViewController.h"
#import "HSQLoginBandViewController.h"
#import "HSQMessageSetViewController.h"
#import "HSQMessageListViewController.h"
#import "HSQMyCollectionHomeViewController.h"
#import "BrowseFootprintViewController.h"
#import "HSQMyPropertyHomeController.h"
#import "HSQMyAccountBalanceViewController.h"
#import "HSQCouponsHomeViewController.h"
#import "HSQIntegralListViewController.h"
#import "HSQMyOrderHomeViewController.h"
#import "HSQReturnGoodsViewController.h"
#import "HSQMIneCollectionViewListCell.h"
#import "HSQLikeFooterCollectionReusableView.h"
#import "HSQLoginHomeViewController.h"
#import "HSQPointExchangeGoodsOrderViewController.h"
#import "HSQToPromoteViewController.h"

@interface HSQMineViewController ()<UINavigationControllerDelegate,UICollectionViewDelegate,UICollectionViewDataSource,HSQHeaderCollectionReusableViewDelegate,HSQCustomNavBarDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) HSQCustomNavBar *CustomNavBar;

@property (nonatomic, strong) NSMutableDictionary *UserInfoDiction;

@property (nonatomic, strong) NSMutableArray *title_array;  // 标题数组

@property (nonatomic, strong) NSMutableArray *Icon_array;  // 图标数组

@property (nonatomic, strong) NSMutableArray *LikeGoods_array;  // 猜你喜欢的数组

@end

@implementation HSQMineViewController

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    // 修改电池条的颜色
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

- (NSMutableDictionary *)UserInfoDiction{
    
    if (_UserInfoDiction == nil) {
        
        self.UserInfoDiction = [NSMutableDictionary dictionary];
    }
    
    return _UserInfoDiction;
}

-(NSMutableArray *)title_array{
    
    if (_title_array == nil) {
        
        self.title_array = [NSMutableArray arrayWithObjects:@"待付款",@"待收/取货",@"待评价",@"退换/售后",@"我的订单",@"预存款",@"优惠券",@"红包",@"积分",@"我的财产",@"我的收藏",@"预约到店",@"浏览足迹",@"商品咨询",@"积分兑换",@"试用",@"晒宝",@"推广分佣",@"收货地址",@"个人信息",@"登录绑定",@"消息接收",@"设置", nil];
    }
    
    return _title_array;
}

-(NSMutableArray *)Icon_array{
    
    if (_Icon_array == nil) {
        
        self.Icon_array = [NSMutableArray arrayWithObjects:@"WaitPay",@"ToCollected",@"ToEvaluate",@"AfterSales",@"MineOrder",@"预存款",@"优惠券",@"红包",@"积分",@"MyProperty",@"xin",@"YuYueDaoDian",@"BrowseFootprint",@"CommodityConsult",@"PointExchange",@"TheTrial",@"shaibao",@"TuiGuang",@"ShippingAddress",@"Person",@"LoginBand",@"MessageInfo",@"Seting", nil];
    }
    
    return _Icon_array;
}

- (NSMutableArray *)LikeGoods_array{
    
    if (_LikeGoods_array == nil) {
        
        self.LikeGoods_array = [NSMutableArray array];
    }
    
    return _LikeGoods_array;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.view.backgroundColor = KViewBackGroupColor;
    
    self.navigationController.delegate = self;
    
    // 1.创建头部导航栏
    [self SetUpHeadNavtionBarView];
    
    // 3.创建集合视图
    [self CreatCollectionView];
    
    // 4.监听用户的登录
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(UserLoginSuccessNotif:) name:@"UserDidLoginSuccessNotif" object:nil];
    
    // 5.监听用户的退出登录
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(UserLoginOutSuccessful:) name:@"UserLoginOutSuccessful" object:nil];
    
    // 6.监听用户解绑
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(UnbindSuccessful) name:@"UnbindSuccessful" object:nil];
    
    // 5.添加刷新控件
    [self AddRefreshControl];
   
    // 请求猜你喜欢的数据
    [self AskForYourFavoriteData];
}

#pragma mark - UINavigationControllerDelegate

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    // 判断要显示的控制器是否是自己
    BOOL isShowHomePage = [viewController isKindOfClass:[self class]];
    
    [self.navigationController setNavigationBarHidden:isShowHomePage animated:YES];
}

/**
 * @brief  创建头部导航栏
 */
- (void)SetUpHeadNavtionBarView{
    
    HSQCustomNavBar *NavBar = [[HSQCustomNavBar alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KSafeTopeHeight)];
    
    NavBar.title = @"个人中心";
    
    NavBar.titleColor = [[UIColor blackColor] colorWithAlphaComponent:0.0];
    
    NavBar.Right_imageName = @"MessageSelect";
    
    NavBar.delegate = self;
    
    [self.view addSubview:NavBar];
    
    self.CustomNavBar = NavBar;
}

/**
 * @brief 查看消息列表
 */
- (void)LookUpTheDataInTheMessageList:(UIButton *)sender{
    
    HSQAccount *account = [HSQAccountTool account];
    
    if (account.token.length == 0)  // 没有登录
    {
        HSQLoginHomeViewController *LoginVC = [[HSQLoginHomeViewController alloc] init];
        
         [self.navigationController pushViewController:LoginVC animated:YES];
    }
    else
    {
        HSQMessageListViewController *MessageListVC = [[HSQMessageListViewController alloc] init];
        
        [self.navigationController pushViewController:MessageListVC animated:YES];
    }
}

/**
 * @brief  创建集合视图
 */
- (void)CreatCollectionView{

    UICollectionViewFlowLayout *Layout = [[UICollectionViewFlowLayout alloc] init];
    
    CGFloat collectionHeight = KScreenHeight - KSafeBottomHeight - KcollectionView_Y - 49;
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, KcollectionView_Y, KScreenWidth, collectionHeight) collectionViewLayout:Layout];
    
    collectionView.backgroundColor = [UIColor clearColor];
    
    collectionView.dataSource = self;

    collectionView.delegate = self;
        
    UINib *HeadNib = [UINib nibWithNibName:@"HSQHeaderCollectionReusableView" bundle:nil];
    [collectionView registerNib:HeadNib forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HSQHeaderCollectionReusableView"];
    
    UINib *FooterNib = [UINib nibWithNibName:@"HSQLikeFooterCollectionReusableView" bundle:nil];
    [collectionView registerNib:FooterNib forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"HSQLikeFooterCollectionReusableView"];
    
    [collectionView registerClass:[HSQGoodsCollectionListCell class] forCellWithReuseIdentifier:@"HSQGoodsCollectionListCell"];
    
    [collectionView registerNib:[UINib nibWithNibName:@"HSQMIneCollectionViewListCell" bundle:nil] forCellWithReuseIdentifier:@"HSQMIneCollectionViewListCell"];
    
    [self.view addSubview:collectionView];
    
    [self.view sendSubviewToBack:collectionView];
    
    self.collectionView = collectionView;
    
    // 当ios是11.0版本以上的时候，系统会自动为视图设置安全区域，如果不想要的话，可以添加一下代码取消
    KCancelSafeSet(collectionView);
    
    self.automaticallyAdjustsScrollViewInsets = NO;
}

/**
 * @brief 监听用户的登录
 */
- (void)UserLoginSuccessNotif:(NSNotification *)notif{
    
    [self requestUserCenterDataFromeserver];
}

/**
 * @brief 监听用户的退出登录
 */
- (void)UserLoginOutSuccessful:(NSNotification *)notif{
    
    [self.UserInfoDiction removeAllObjects];
    
    [self.collectionView reloadData];
}

/**
 * @brief 监听用户解绑微信或者QQ
 */
- (void)UnbindSuccessful{
    
    [self.collectionView.mj_header beginRefreshing];
}

/**
 * @brief 添加刷新控件
 */
- (void)AddRefreshControl{
    
    // 1.下拉加载更多的数据
    self.collectionView.mj_header  = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(requestUserCenterDataFromeserver)];
    
    [self.collectionView.mj_header beginRefreshing];
}

/**
 * @brief 请求用户中心的数据
 */
- (void)requestUserCenterDataFromeserver{
    
    HSQAccount *account = [HSQAccountTool account];
    
    if (account.token.length == 0)
    {
        [self.collectionView.mj_header endRefreshing];
    }
    else
    {
        [[HSQProgressHUDManger Manger] ShowLoadingDataFromeServer:nil ToView:self.view IsClearColor:YES];
        
        NSDictionary *diction = @{@"token":account.token};
        
        AFNetworkRequestTool *RequestTool = [AFNetworkRequestTool shareRequestTool];
        
        [RequestTool.manger POST:UrlAdress(KUserCenterDataUrl) parameters:diction progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *responseObject) {
            
            HSQLog(@"=用户中心的数据==%@",responseObject);
            
            [[HSQProgressHUDManger Manger] DismissProgressHUD];
            
            if ([responseObject[@"code"] integerValue] == 200)
            {
                [self.UserInfoDiction setDictionary:responseObject[@"datas"]];
            }
            
            [self.collectionView.mj_header endRefreshing];
            
            [self.collectionView reloadData];
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            [self.collectionView.mj_header endRefreshing];
            
            [[HSQProgressHUDManger Manger] ShowDisplayFailedToLoadData:KErrorPlacherString SuperView:self.view];
        }];
    }
}

/**
 * @brief 请求猜你喜欢的数据
 */
- (void)AskForYourFavoriteData{
    
    AFNetworkRequestTool *requestTool = [AFNetworkRequestTool shareRequestTool];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"token"] = ([HSQAccountTool account].token.length == 0 ? @"":[HSQAccountTool account].token);
    
    [requestTool.manger POST:UrlAdress(KYouLikeUrl) parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [[HSQProgressHUDManger Manger] DismissProgressHUD];
        
        HSQLog(@"===猜你喜欢数据===%@",responseObject);
        
        if ([responseObject[@"code"] integerValue] == 200)
        {
            [self.LikeGoods_array addObjectsFromArray:responseObject[@"datas"][@"goodsCommonList"]];
        }
        else
        {
            NSString *errorString = [NSString stringWithFormat:@"%@",responseObject[@"datas"][@"error"]];
            
            [[HSQProgressHUDManger Manger] ShowDisplayFailedToLoadData:errorString SuperView:self.view];
        }
        
        [self.collectionView reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [[HSQProgressHUDManger Manger] ShowProgressHUDPromptText:@"网络出现问题" SupView:self.view];
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
        return self.title_array.count;
    }
    else
    {
        return self.LikeGoods_array.count;
    }
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{

//    return CGSizeMake(KScreenWidth, KPersonHeight + 3 * 5 + 3 + 5 * KBtnViewH);
    
    if (section == 0)
    {
       return CGSizeMake(KScreenWidth, KPersonHeight);
    }
    else
    {
        return CGSizeMake(0, 0);
    }
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    
    if (section == 0)
    {
         return CGSizeMake(KScreenWidth, 50);
    }
    else
    {
         return CGSizeMake(0, 0);
    }
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{

    UICollectionReusableView *reusableView = nil;
    
    if (kind == UICollectionElementKindSectionHeader)
    {
        HSQHeaderCollectionReusableView *headView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HSQHeaderCollectionReusableView" forIndexPath:indexPath];
        
        headView.delegate = self;
        
        headView.UserInfoDiction = self.UserInfoDiction;
        
        reusableView = headView;
    }
    
    if (kind == UICollectionElementKindSectionFooter)
    {
        HSQLikeFooterCollectionReusableView *FooterView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"HSQLikeFooterCollectionReusableView" forIndexPath:indexPath];

         reusableView = FooterView;
    }
    
    return reusableView;
}

// 两个cell之间的最小间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    
    if (section == 0)
    {
        return 0;
    }
    else
    {
        return 5;
    }
}

// 行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    
    return 5;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0)
    {
        if (indexPath.row == 10 || indexPath.row == 11 ||indexPath.row == 12 || indexPath.row == 13  || indexPath.row == 14 || indexPath.row == 15 ||indexPath.row == 16 ||indexPath.row == 17)
        {
            return CGSizeMake(KScreenWidth/4, 60);
        }
        else
        {
            return CGSizeMake((KScreenWidth - 1)/5, 60);
        }
    }
    else
    {
        return CGSizeMake((KScreenWidth-5)/2, (KScreenWidth-5)/2 + 50);
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0)
    {
        HSQMIneCollectionViewListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HSQMIneCollectionViewListCell" forIndexPath:indexPath];
        
        cell.Title_Label.text = [NSString stringWithFormat:@"%@",self.title_array[indexPath.row]];
        
        cell.Icon_ImageView.image = [UIImage imageNamed:self.Icon_array[indexPath.row]];
        
        if (indexPath.row == 5 || indexPath.row == 6 ||indexPath.row == 7 ||indexPath.row == 8)
        {
            cell.Icon_ImageView.hidden = YES;
            
            cell.Count_Label.hidden = NO;
        }
        else
        {
            cell.Icon_ImageView.hidden = NO;
            
            cell.Count_Label.hidden = YES;
        }
        
        if (self.UserInfoDiction.allKeys.count != 0)
        {
            if (indexPath.row == 5) // 预存款
            {
                NSString *predepositAvailable = [NSString stringWithFormat:@"%@",self.UserInfoDiction[@"memberInfo"][@"predepositAvailable"]];
                
                cell.Count_Label.text = [NSString stringWithFormat:@"%.2f",predepositAvailable.floatValue];
            }
            else if (indexPath.row == 6) // 优惠券
            {
                cell.Count_Label.text = [NSString stringWithFormat:@"%@",self.UserInfoDiction[@"memberInfo"][@"voucherNum"]];
            }
            else if (indexPath.row == 7) // 红包
            {
                cell.Count_Label.text = [NSString stringWithFormat:@"%@",self.UserInfoDiction[@"memberInfo"][@"redpackageNum"]];
            }
            else if (indexPath.row == 8) // 积分
            {
                cell.Count_Label.text = [NSString stringWithFormat:@"%@",self.UserInfoDiction[@"memberInfo"][@"memberPoints"]];
            }
        }
        
        return cell;
    }
    else
    {
        HSQGoodsCollectionListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HSQGoodsCollectionListCell" forIndexPath:indexPath];
        
        [cell.OrginPrice_label setHidden:YES];
        
        cell.StoreGoodsDiction = self.LikeGoods_array[indexPath.row];
        
        return cell;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
   HSQAccount *account = [HSQAccountTool account];
    
    if (account.token.length == 0)  // 没有登录
    {
        HSQLoginHomeViewController *LoginVC = [[HSQLoginHomeViewController alloc] init];
        
        [self.navigationController pushViewController:LoginVC animated:YES];
    }
    else
    {
        if (indexPath.section == 0)
        {
            [self FirstSectionClickWithIndexPath:indexPath];
        }
        else // 猜你喜欢的点击
        {
            
        }
    }
    
}

/**
 * @brief 第一个分区cell的点击
 */
- (void)FirstSectionClickWithIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) // 待支付
    {
        HSQMyOrderHomeViewController *MyOrderHomeVC = [[HSQMyOrderHomeViewController alloc] init];
        
        MyOrderHomeVC.indexNumber = @"1";
        
        [self.navigationController pushViewController:MyOrderHomeVC animated:YES];
    }
    else if (indexPath.row == 1) // 待收/取货
    {
        HSQMyOrderHomeViewController *MyOrderHomeVC = [[HSQMyOrderHomeViewController alloc] init];
        
        MyOrderHomeVC.indexNumber = @"3";
        
        [self.navigationController pushViewController:MyOrderHomeVC animated:YES];
    }
    else if (indexPath.row == 2) // 待评价
    {
        HSQMyOrderHomeViewController *MyOrderHomeVC = [[HSQMyOrderHomeViewController alloc] init];
        
        MyOrderHomeVC.indexNumber = @"4";
        
        [self.navigationController pushViewController:MyOrderHomeVC animated:YES];
    }
    else if (indexPath.row == 3) // 退换/售后
    {
        HSQReturnGoodsViewController *ReturnGoodsVC = [[HSQReturnGoodsViewController alloc] init];
        
        [self.navigationController pushViewController:ReturnGoodsVC animated:YES];
    }
    else if (indexPath.row == 4) // 我的订单
    {
        HSQMyOrderHomeViewController *MyOrderHomeVC = [[HSQMyOrderHomeViewController alloc] init];
        
        MyOrderHomeVC.indexNumber = @"0";
        
        MyOrderHomeVC.JumpType_string = @"200";
        
        [self.navigationController pushViewController:MyOrderHomeVC animated:YES];
    }
    else if (indexPath.row == 5) // 预存款
    {
        HSQMyAccountBalanceViewController *MyAccountBalanceVC = [[HSQMyAccountBalanceViewController alloc] init];
                
        [self.navigationController pushViewController:MyAccountBalanceVC animated:YES];
    }
    else if (indexPath.row == 6) // 优惠券
    {
        HSQCouponsHomeViewController *CouponsHomeVC = [[HSQCouponsHomeViewController alloc] init];
        
        CouponsHomeVC.Navtion_Title = @"优惠券";
        
        CouponsHomeVC.LeftTop_Title = @"我的优惠券";
        
        CouponsHomeVC.RightTop_Title = @"领取优惠券";
        
        CouponsHomeVC.ID_Number = @"100";
        
        [self.navigationController pushViewController:CouponsHomeVC animated:YES];
    }
    else if (indexPath.row == 7) // 红包
    {
        HSQCouponsHomeViewController *CouponsHomeVC = [[HSQCouponsHomeViewController alloc] init];
        
        CouponsHomeVC.Navtion_Title = @"红包";
        
        CouponsHomeVC.LeftTop_Title = @"我的红包";
        
        CouponsHomeVC.RightTop_Title = @"领取红包";
        
        CouponsHomeVC.ID_Number = @"200";
        
        [self.navigationController pushViewController:CouponsHomeVC animated:YES];
    }
    else if (indexPath.row == 8) //积分
    {
        HSQIntegralListViewController *IntegralListVC = [[HSQIntegralListViewController alloc] init];
        
        IntegralListVC.IntegralCount = [NSString stringWithFormat:@"%@",self.UserInfoDiction[@"memberInfo"][@"memberPoints"]];
        
        IntegralListVC.Navtion_Title = @"积分明细";
        
        IntegralListVC.Top_Title = @"我的积分";
        
        IntegralListVC.DataUrl = UrlAdress(KIntegralListCell);
        
        [self.navigationController pushViewController:IntegralListVC animated:YES];
    }
    else if (indexPath.row == 9) //我的财产
    {
        HSQMyPropertyHomeController *MyPropertyVC = [[HSQMyPropertyHomeController alloc] init];
        
        [self.navigationController pushViewController:MyPropertyVC animated:YES];
    }
    else if (indexPath.row == 10) // 我的收藏
    {
        HSQMyCollectionHomeViewController *MyCollectionVC = [[HSQMyCollectionHomeViewController alloc] init];
        
        [self.navigationController pushViewController:MyCollectionVC animated:YES];
    }
    else if (indexPath.row == 11) // 预约到店
    {
        
    }
    else if (indexPath.row == 12) // 浏览足迹
    {
        BrowseFootprintViewController *BrowseFootprintVC = [[BrowseFootprintViewController alloc] init];
        
        [self.navigationController pushViewController:BrowseFootprintVC animated:YES];
    }
    else if (indexPath.row == 13) // 商品咨询
    {
        
    }
    else if (indexPath.row == 14) // 积分兑换
    {
        HSQPointExchangeGoodsOrderViewController *PointExchangeGoodsOrderVC = [[HSQPointExchangeGoodsOrderViewController alloc] init];
        
        [self.navigationController pushViewController:PointExchangeGoodsOrderVC animated:YES];
    }
    else if (indexPath.row == 15) // 试用
    {

    }
    else if (indexPath.row == 16) // 晒宝
    {

    }
    else if (indexPath.row == 17) // 推广分佣
    {
        HSQToPromoteViewController *ToPromoteVC = [[HSQToPromoteViewController alloc] init];
        
        ToPromoteVC.NavtionTitle = @"推广分佣";
        
        [self.navigationController pushViewController:ToPromoteVC animated:YES];
    }
    else if (indexPath.row == 18) // 收货地址
    {
        HSQAdressListViewController *AdressListVC = [[HSQAdressListViewController alloc] init];
        
        [self.navigationController pushViewController:AdressListVC animated:YES];
    }
    else if (indexPath.row == 19) // 个人信息
    {
        HSQPersonCenterViewController *personVC = [[HSQPersonCenterViewController alloc] init];
        
        personVC.Success = ^(NSString *Url) {
            
            [self requestUserCenterDataFromeserver];
        };
        
        [self.navigationController pushViewController:personVC animated:YES];
    }
    else if (indexPath.row == 20) // 登录绑定
    {
        HSQLoginBandViewController *LoginBandVC = [[HSQLoginBandViewController alloc] init];
        
        LoginBandVC.UserInfo_Diction = self.UserInfoDiction;
        
        [self.navigationController pushViewController:LoginBandVC animated:YES];
    }
    else if (indexPath.row == 21) // 消息接收
    {
        HSQMessageSetViewController *MessageSetVC = [[HSQMessageSetViewController alloc] init];
        
        [self.navigationController pushViewController:MessageSetVC animated:YES];
    }
    else if (indexPath.row == 22) // 设置
    {
        HSQSetingViewController *setingVC = [[HSQSetingViewController alloc] init];
        
        [self.navigationController pushViewController:setingVC animated:YES];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    CGFloat Y_offset = scrollView.contentOffset.y;
    
    // 当滑动到这个距离的时候，导航栏应该全部显示出来
    CGFloat Margin = KPersonHeight - KSafeTopeHeight;
    
    // 颜色的透明度
    CGFloat offset = (Y_offset - KcollectionView_Y) / Margin;
    
    if (Y_offset < KcollectionView_Y) // 向下滑动
    {
        self.CustomNavBar.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent: 0.0];
        self.CustomNavBar.titleColor =  [[UIColor blackColor] colorWithAlphaComponent: 0.0];
    }
    else
    {
        self.CustomNavBar.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent: offset];
        self.CustomNavBar.titleColor =  [[UIColor blackColor] colorWithAlphaComponent: offset];
    }
    
    // 修改电池条的颜色
    if (offset >= 1)
    {
         [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;//黑色
    }
    else
    {
         [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;//白色
    }
}

#pragma mark - HSQHeaderCollectionReusableViewDelegate

- (void)LoginActionClickWithMineHomeHead:(UIButton *)sender{
    
    HSQAccount *account = [HSQAccountTool account];
    
    if (account.token.length == 0)  // 没有登录
    {
        HSQLoginHomeViewController *LoginVC = [[HSQLoginHomeViewController alloc] init];
        
         [self.navigationController pushViewController:LoginVC animated:YES];
    }
    else
    {
        HSQPersonCenterViewController *personVC = [[HSQPersonCenterViewController alloc] init];
        
        personVC.Success = ^(NSString *Url) {
            
            [self requestUserCenterDataFromeserver];
        };
        
        [self.navigationController pushViewController:personVC animated:YES];
    }
}

- (void)ToPrepareLoginAction:(UIButton *)sender{
    
    HSQLoginHomeViewController *LoginVC = [[HSQLoginHomeViewController alloc] init];
    
     [self.navigationController pushViewController:LoginVC animated:YES];
}


@end
