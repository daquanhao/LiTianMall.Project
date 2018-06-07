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
#import "HSQLoginViewController.h"
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

@interface HSQMineViewController ()<UINavigationControllerDelegate,UICollectionViewDelegate,UICollectionViewDataSource,HSQHeaderCollectionReusableViewDelegate,HSQCustomNavBarDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) HSQCustomNavBar *CustomNavBar;

@property (nonatomic, strong) NSMutableDictionary *UserInfoDiction;

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
    
    // 5.判断用户是否登录
    [self requestUserCenterDataFromeserver];
   
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
        HSQLoginViewController *LoginVC = [[HSQLoginViewController alloc] init];
        
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
    
    Layout.itemSize = CGSizeMake((KScreenWidth-5)/2, (KScreenWidth-5)/2);
    
    Layout.minimumLineSpacing = 5;  // 最小的行间距
    
    Layout.minimumInteritemSpacing = 5; // 最小的列间距
    
    CGFloat collectionHeight = KScreenHeight - KSafeBottomHeight - KcollectionView_Y - 49;
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, KcollectionView_Y, KScreenWidth, collectionHeight) collectionViewLayout:Layout];
    
    collectionView.backgroundColor = [UIColor clearColor];
    
    collectionView.dataSource = self;

    collectionView.delegate = self;
        
    UINib *nib = [UINib nibWithNibName:@"HSQHeaderCollectionReusableView" bundle:nil];
    
    [collectionView registerNib:nib forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HSQHeaderCollectionReusableView"];
    
    [collectionView registerClass:[HSQGoodsCollectionListCell class] forCellWithReuseIdentifier:@"HSQGoodsCollectionListCell"];
    
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
 * @brief 请求用户中心的数据
 */
- (void)requestUserCenterDataFromeserver{
    
    HSQAccount *account = [HSQAccountTool account];
    
    if (account.token.length == 0) return;
    
    [[HSQProgressHUDManger Manger] ShowLoadingDataFromeServer:nil ToView:self.view IsClearColor:NO];
    
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
        
        [self.collectionView reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        HSQLog(@"==%@",error.description);
        
        [[HSQProgressHUDManger Manger] ShowDisplayFailedToLoadData:@"用户中心数据加载失败" SuperView:self.view];
    }];
}

/**
 * @brief 请求猜你喜欢的数据
 */
- (void)AskForYourFavoriteData{
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionViewDelegate,UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return 13;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{

    return CGSizeMake(KScreenWidth, KPersonHeight + 3 * 5 + 3 + 5 * KBtnViewH);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{

    HSQHeaderCollectionReusableView *headView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HSQHeaderCollectionReusableView" forIndexPath:indexPath];

    headView.delegate = self;
    
    headView.UserInfoDiction = self.UserInfoDiction;

    return headView;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    HSQGoodsCollectionListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HSQGoodsCollectionListCell" forIndexPath:indexPath];

    [cell.OrginPrice_label setHidden:YES];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
  
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
        HSQLoginViewController *LoginVC = [[HSQLoginViewController alloc] init];
        
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
    
    HSQLoginViewController *LoginVC = [[HSQLoginViewController alloc] init];
    
     [self.navigationController pushViewController:LoginVC animated:YES];
}

- (void)UnderLogineCustomeButtonClickAction:(UIButton *)sender{
    
    HSQAccount *account = [HSQAccountTool account];
    
    if (account.token.length == 0)  // 没有登录
    {
        HSQLoginViewController *LoginVC = [[HSQLoginViewController alloc] init];
        
        [self.navigationController pushViewController:LoginVC animated:YES];
    }
    else
    {
        if ([sender.titleLabel.text isEqualToString:@"设置"])
        {
            HSQSetingViewController *setingVC = [[HSQSetingViewController alloc] init];
            
            [self.navigationController pushViewController:setingVC animated:YES];
        }
        else if ([sender.titleLabel.text isEqualToString:@"收货地址"])
        {
            HSQAdressListViewController *AdressListVC = [[HSQAdressListViewController alloc] init];
            
            [self.navigationController pushViewController:AdressListVC animated:YES];
        }
        else if ([sender.titleLabel.text isEqualToString:@"个人信息"])
        {
            HSQPersonCenterViewController *personVC = [[HSQPersonCenterViewController alloc] init];
            
            personVC.Success = ^(NSString *Url) {
                
                [self requestUserCenterDataFromeserver];
            };
            
            [self.navigationController pushViewController:personVC animated:YES];
        }
        else if ([sender.titleLabel.text isEqualToString:@"登录绑定"])
        {
            HSQLoginBandViewController *LoginBandVC = [[HSQLoginBandViewController alloc] init];
            
            [self.navigationController pushViewController:LoginBandVC animated:YES];
        }
        else if ([sender.titleLabel.text isEqualToString:@"消息接收"])
        {
            HSQMessageSetViewController *MessageSetVC = [[HSQMessageSetViewController alloc] init];
            
            [self.navigationController pushViewController:MessageSetVC animated:YES];
        }
        else if ([sender.titleLabel.text isEqualToString:@"我的收藏"])
        {
            HSQMyCollectionHomeViewController *MyCollectionVC = [[HSQMyCollectionHomeViewController alloc] init];
            
            [self.navigationController pushViewController:MyCollectionVC animated:YES];
        }
        else if ([sender.titleLabel.text isEqualToString:@"浏览足迹"])
        {
            BrowseFootprintViewController *BrowseFootprintVC = [[BrowseFootprintViewController alloc] init];
            
            [self.navigationController pushViewController:BrowseFootprintVC animated:YES];
        }
        else if ([sender.titleLabel.text isEqualToString:@"我的财产"])
        {
            HSQMyPropertyHomeController *MyPropertyVC = [[HSQMyPropertyHomeController alloc] init];
            
            [self.navigationController pushViewController:MyPropertyVC animated:YES];
        }
        else if ([sender.titleLabel.text isEqualToString:@"预存款"])
        {
            HSQMyAccountBalanceViewController *MyAccountBalanceVC = [[HSQMyAccountBalanceViewController alloc] init];
        
            [self.navigationController pushViewController:MyAccountBalanceVC animated:YES];
        }
        else if ([sender.titleLabel.text isEqualToString:@"优惠券"])
        {
            HSQCouponsHomeViewController *CouponsHomeVC = [[HSQCouponsHomeViewController alloc] init];
        
            CouponsHomeVC.Navtion_Title = @"优惠券";
        
            CouponsHomeVC.LeftTop_Title = @"我的优惠券";
        
            CouponsHomeVC.RightTop_Title = @"领取优惠券";
        
            CouponsHomeVC.ID_Number = @"100";
        
            [self.navigationController pushViewController:CouponsHomeVC animated:YES];
        }
        else if ([sender.titleLabel.text isEqualToString:@"红包"])
        {
            HSQCouponsHomeViewController *CouponsHomeVC = [[HSQCouponsHomeViewController alloc] init];
        
            CouponsHomeVC.Navtion_Title = @"红包";
        
            CouponsHomeVC.LeftTop_Title = @"我的红包";
        
            CouponsHomeVC.RightTop_Title = @"领取红包";
        
            CouponsHomeVC.ID_Number = @"200";
        
            [self.navigationController pushViewController:CouponsHomeVC animated:YES];
        }
        else if ([sender.titleLabel.text isEqualToString:@"积分"])
        {
            HSQIntegralListViewController *IntegralListVC = [[HSQIntegralListViewController alloc] init];
        
            IntegralListVC.IntegralCount = [NSString stringWithFormat:@"%@",self.UserInfoDiction[@"memberInfo"][@"memberPoints"]];
        
            IntegralListVC.Navtion_Title = @"积分明细";
        
            IntegralListVC.Top_Title = @"我的积分";
        
            IntegralListVC.DataUrl = UrlAdress(KIntegralListCell);
        
            [self.navigationController pushViewController:IntegralListVC animated:YES];
        }
        else if ([sender.titleLabel.text isEqualToString:@"我的订单"])
        {
            HSQMyOrderHomeViewController *MyOrderHomeVC = [[HSQMyOrderHomeViewController alloc] init];
            MyOrderHomeVC.indexNumber = @"0";
            MyOrderHomeVC.JumpType_string = @"200";
            [self.navigationController pushViewController:MyOrderHomeVC animated:YES];
        }
        else if ([sender.titleLabel.text isEqualToString:@"待付款"])
        {
            HSQMyOrderHomeViewController *MyOrderHomeVC = [[HSQMyOrderHomeViewController alloc] init];
            MyOrderHomeVC.indexNumber = @"1";
            [self.navigationController pushViewController:MyOrderHomeVC animated:YES];
        }
        else if ([sender.titleLabel.text isEqualToString:@"待收/取货"])
        {
            HSQMyOrderHomeViewController *MyOrderHomeVC = [[HSQMyOrderHomeViewController alloc] init];
            MyOrderHomeVC.indexNumber = @"3";
            [self.navigationController pushViewController:MyOrderHomeVC animated:YES];
        }
        else if ([sender.titleLabel.text isEqualToString:@"待评价"])
        {
            HSQMyOrderHomeViewController *MyOrderHomeVC = [[HSQMyOrderHomeViewController alloc] init];
            MyOrderHomeVC.indexNumber = @"4";
            [self.navigationController pushViewController:MyOrderHomeVC animated:YES];
        }
        else if ([sender.titleLabel.text isEqualToString:@"退换/售后"])
        {
            HSQReturnGoodsViewController *ReturnGoodsVC = [[HSQReturnGoodsViewController alloc] init];
            [self.navigationController pushViewController:ReturnGoodsVC animated:YES];
        }
    }
}







@end
