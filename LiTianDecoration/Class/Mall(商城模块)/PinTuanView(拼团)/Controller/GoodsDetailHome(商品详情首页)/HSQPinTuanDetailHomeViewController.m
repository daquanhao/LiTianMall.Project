//
//  HSQPinTuanDetailHomeViewController.m
//  LiTianDecoration
//
//  Created by administrator on 2018/5/9.
//  Copyright © 2018年 administrator. All rights reserved.
//

#define KTitlesViewHeight 44
#define KTitlesViewWitdh 150

#import "HSQPinTuanDetailHomeViewController.h"
#import "HSQPinTuanDetailGoodsListModel.h"
#import "HSQLoginViewController.h"
#import "HSQAccountTool.h"
#import "HSQPinTuanDataDealTool.h"
#import "HSQTopNavtionView.h"
#import "HSQGoodsDetailViewController.h"  // 商品详情
#import "HSQGoodsImageDetailViewController.h"  // 商品图文详情
#import "HSQGoodsDetailCommentsViewController.h" // 商品评论
#import "HSQContactTheMerchantController.h"
#import "HSQMallShopCarViewController.h"  // 购物车

@interface HSQPinTuanDetailHomeViewController ()<HSQTopNavtionViewDelegate,UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ViewBottomMargin;

@property (weak, nonatomic) IBOutlet UILabel *Buy_Label;

@property (weak, nonatomic) IBOutlet UILabel *KaiTuanCount_Label;

@property (nonatomic, strong) NSDictionary *DataDiction;  // 数据字典

@property (nonatomic, strong) NSMutableArray *GoodsArray;

@property (weak, nonatomic) IBOutlet UIImageView *CollectionImageView;

@property (nonatomic, copy) NSString *IsCollection;   // 是否收藏 0 代表没有收藏  1代表收藏

@property (nonatomic, strong) UIScrollView *contentView;

@property (nonatomic, strong) HSQTopNavtionView *NavtionView;

@end

@implementation HSQPinTuanDetailHomeViewController

- (NSMutableArray *)GoodsArray{
    
    if (_GoodsArray == nil) {
        
        self.GoodsArray = [NSMutableArray array];
    }
    
    return _GoodsArray;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.view.backgroundColor = KViewBackGroupColor;
    
    self.DataDiction = [NSDictionary dictionary];
    
    // 1.监听用户的登录
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(UserLoginSuccessNotif:) name:@"UserDidLoginSuccessNotif" object:nil];
    
    // 2.请求拼团详情的界面的数据
    [self TheInterfaceToRequestTheSyndicationDetails];
    
    // 3.检测商品是否收藏
    [self RequestDataToDetermineIfTheItemIsCollected];
}

/**
 * @brief 监听用户的登录
 */
- (void)UserLoginSuccessNotif:(NSNotification *)notif{
    
    [self RequestDataToDetermineIfTheItemIsCollected];
}

/**
 * @brief 请求数据判断商品是否被收藏
 */
- (void)RequestDataToDetermineIfTheItemIsCollected{
    
    NSString *token = [HSQAccountTool account].token;
    
    if (token.length == 0) return;
    
    NSDictionary *params = @{@"token":token,@"commonId":self.commonId};
    
    AFNetworkRequestTool *requestTool = [AFNetworkRequestTool shareRequestTool];
    
    [requestTool.manger POST:UrlAdress(KCheckIsCollectionGoodsUrl) parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        HSQLog(@"==是否收藏==%@",responseObject);
        if ([responseObject[@"code"] integerValue] == 200)
        {
            self.IsCollection = [NSString stringWithFormat:@"%@",responseObject[@"datas"][@"isExist"]];
            
             self.CollectionImageView.image = [UIImage imageNamed:[[HSQPinTuanDataDealTool shareDataDealTool] imageNameWithIsCollection:self.IsCollection]];
        }
        else
        {
            NSString *errorString = [NSString stringWithFormat:@"%@",responseObject[@"datas"][@"error"]];
            
            [[HSQProgressHUDManger Manger] ShowDisplayFailedToLoadData:errorString SuperView:self.view];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [[HSQProgressHUDManger Manger] ShowDisplayFailedToLoadData:@"检测是否收藏数据加载失败" SuperView:self.view];
    }];
}

/**
 * @brief 请求拼团详情的界面的数据
 */
- (void)TheInterfaceToRequestTheSyndicationDetails{
    
    NSString *url = [NSString stringWithFormat:@"%@/group/%@",@"http://10.1.8.238/api",self.commonId];
    
    [[HSQProgressHUDManger Manger] ShowLoadingDataFromeServer:@"" ToView:self.view IsClearColor:YES];
    
    AFNetworkRequestTool *RequestTool = [AFNetworkRequestTool shareRequestTool];
    
    [RequestTool.manger GET:url parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [[HSQProgressHUDManger Manger] DismissProgressHUD];
        
//        HSQLog(@"=拼团数据=%@",responseObject);
        if ([responseObject[@"code"] integerValue] == 200)
        {
            self.DataDiction = responseObject[@"datas"];
            
            // 控件赋值
            [self AssignValuesToViewControls:responseObject[@"datas"]];
            
            // 4.初始化子控制器
            [self setupChildVcesWithDiction:responseObject[@"datas"]];
            
            // 5.设置顶部标题栏
            [self setupTopTitlesView];
            
            // 6.设置底布滚动控制器
            [self setupContentView];
        }
        else
        {
            NSString *errorString = [NSString stringWithFormat:@"%@",responseObject[@"datas"][@"error"]];
            
            [[HSQProgressHUDManger Manger] ShowDisplayFailedToLoadData:errorString SuperView:self.view];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [[HSQProgressHUDManger Manger] ShowDisplayFailedToLoadData:@"数据加载失败" SuperView:self.view];
        
    }];
}

/**
 * @brief 给视图控件赋值
 */
- (void)AssignValuesToViewControls:(NSDictionary *)diction{
    
    // 1.拼团的价格和所需的人数
    self.GoodsArray = [HSQPinTuanDetailGoodsListModel mj_objectArrayWithKeyValuesArray:diction[@"groupGoodsDetailVo"][@"goodsList"]];
    HSQPinTuanDetailGoodsListModel *model = [self.GoodsArray firstObject];
    NSString *count = [NSString stringWithFormat:@"%@",diction[@"groupGoodsDetailVo"][@"groups"][@"groupRequireNum"]];
    self.KaiTuanCount_Label.text = [NSString stringWithFormat:@"¥%@\n%@人团",model.groupPrice,count];
    
    // 2.单独购买
    self.Buy_Label.text = [NSString stringWithFormat:@"¥%@\n单独购买",model.appPrice0];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 * @brief 联系客服的点击
 */
- (IBAction)ContactCustomerServiceForAClick:(UIButton *)sender {
    
    HSQContactTheMerchantController *ContactTheMerchantVC = [[HSQContactTheMerchantController alloc] init];
    
    [self.navigationController pushViewController:ContactTheMerchantVC animated:YES];
    
}

/**
 * @brief 收藏按钮的点击
 */
- (IBAction)CollectionButtonClickEvent:(UIButton *)sender {
    
    HSQAccount *account = [HSQAccountTool account];
    
    if (account.token.length == 0)  // 没有登录
    {
        HSQLoginViewController *LoginVC = [[HSQLoginViewController alloc] init];
        
        [self.navigationController pushViewController:LoginVC animated:YES];
    }
    else
    {
        if (self.IsCollection.integerValue == 0) // 没有收藏，点击收藏
        {
            [self AddCollectionGoodsToServer:account.token State:@"0" Url:UrlAdress(KAddCollectionGoodsUrl)];
        }
        else // 已经收藏，点击取消收藏
        {
             [self AddCollectionGoodsToServer:account.token State:@"1" Url:UrlAdress(KCancelCollectionGoodsUrl)];
        }
    }
}

/**
 * @brief 收藏或者取消某商品
 */
- (void)AddCollectionGoodsToServer:(NSString *)token State:(NSString *)CollectionState Url:(NSString *)GoodsUrl{
    
    [[HSQProgressHUDManger Manger] ShowLoadingDataFromeServer:@"" ToView:self.view IsClearColor:YES];
    
    NSDictionary *params = @{@"token":token,@"commonId":self.commonId};
    
    AFNetworkRequestTool *requestTool = [AFNetworkRequestTool shareRequestTool];
    
    [requestTool.manger POST:GoodsUrl parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        HSQLog(@"==收藏商品==%@==%@",responseObject,CollectionState);
        
        [[HSQProgressHUDManger Manger] DismissProgressHUD];
        
        if ([responseObject[@"code"] integerValue] == 200)
        {
            if (CollectionState.integerValue == 0)
            {
                self.IsCollection = @"1";
                self.CollectionImageView.image = [UIImage imageNamed:@"xin"];
            }
            else
            {
                self.IsCollection = @"0";
                self.CollectionImageView.image = [UIImage imageNamed:@"Shape"];
            }
        }
        else
        {
            self.IsCollection = CollectionState;
            
            NSString *errorString = [NSString stringWithFormat:@"%@",responseObject[@"datas"][@"error"]];
            
            [[HSQProgressHUDManger Manger] ShowDisplayFailedToLoadData:errorString SuperView:self.view];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        self.IsCollection = CollectionState;
        
        [[HSQProgressHUDManger Manger] ShowDisplayFailedToLoadData:@"数据加载失败" SuperView:self.view];
    }];
    
}

/**
 * @brief 购物车按钮的点击
 */
- (IBAction)ShopCarBtnClickAction:(UIButton *)sender {
    
    HSQMallShopCarViewController *ShopCarVC = [[HSQMallShopCarViewController alloc] init];
    
    [self.navigationController pushViewController:ShopCarVC animated:YES];
}

/**
 * @brief 单独购买
 */
- (IBAction)ClickEventsForIndividualPurchaseButtons:(UIButton *)sender {
}

/**
 * @brief 开团按钮的点击事件
 */
- (IBAction)ClickEventForTheGroupButton:(UIButton *)sender {
}


#pragma mark *******************************************************************

/**
 * @brief 初始化子控制器
 */
-(void)setupChildVcesWithDiction:(NSDictionary *)diction{
    
    HSQGoodsDetailViewController *GoodsCollectionVC = [[HSQGoodsDetailViewController alloc] init];
    GoodsCollectionVC.title = @"商品";
    GoodsCollectionVC.GoodsDetailDict = diction;
     GoodsCollectionVC.commonId = self.commonId;
    [self addChildViewController:GoodsCollectionVC];
    
    HSQGoodsImageDetailViewController *ImageDetailVC = [[HSQGoodsImageDetailViewController alloc] init];
    ImageDetailVC.title = @"详情";
    ImageDetailVC.commonId = self.commonId;
    ImageDetailVC.goodsImageList = diction[@"groupGoodsDetailVo"][@"goodsImageList"];
    [self addChildViewController:ImageDetailVC];
    
     HSQGoodsDetailCommentsViewController *GoodsDetailCommentsVC = [[HSQGoodsDetailCommentsViewController alloc] init];
    GoodsDetailCommentsVC.title = @"评论";
    GoodsDetailCommentsVC.commonId = self.commonId;
    GoodsDetailCommentsVC.dataDiction = diction;
    [self addChildViewController:GoodsDetailCommentsVC];
}

/**
 * @brief 设置顶部标题栏
 */
- (void)setupTopTitlesView{
    
    HSQTopNavtionView *NavtionView = [[HSQTopNavtionView alloc] initWithFrame:CGRectMake(0, 0, KTitlesViewWitdh, KTitlesViewHeight)];
    
    NavtionView.TitlesArray = @[@"商品",@"详情",@"评论"];
    
    NavtionView.delegate = self;
    
    self.navigationItem.titleView = NavtionView;
    
    self.NavtionView = NavtionView;
}

/**
 * @brief 顶部按钮的点击事件
 */
- (void)TopNavtionViewButtonClickAction:(UIButton *)sender{
    
    // 修改按钮状态
    self.NavtionView.selectedButton.enabled = YES;
    sender.enabled = NO;
    self.NavtionView.selectedButton = sender;
    
    // 动画
    [UIView animateWithDuration:0.25 animations:^{
        self.NavtionView.indicatorView.width = sender.titleLabel.mj_w;
        self.NavtionView.indicatorView.centerX = sender.centerX;
    }];
    
    // 滚动
    CGPoint offset = self.contentView.contentOffset;
    offset.x = sender.tag * self.contentView.width;
    [self.contentView setContentOffset:offset animated:YES];
}

/**
 * @brief 设置底布滚动控制器
 */
- (void)setupContentView{
    
    // 不要自动调整inset
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UIScrollView *contentView = [[UIScrollView alloc] init];
    
    CGFloat ScrollerHeight = 0;
    
    contentView.showsVerticalScrollIndicator = NO;
    
    contentView.showsHorizontalScrollIndicator = NO;
    
    contentView.frame = CGRectMake(0, ScrollerHeight, KScreenWidth, KScreenHeight - ScrollerHeight - KSafeTopeHeight - KSafeBottomHeight - 50);
    
    contentView.delegate = self;
    
    contentView.pagingEnabled = YES;
    
    contentView.backgroundColor = KViewBackGroupColor;
    
    [self.view insertSubview:contentView atIndex:0];
    
    contentView.contentSize = CGSizeMake(contentView.mj_w * self.childViewControllers.count, 0);
    
    self.contentView = contentView;
    
    // 添加第一个控制器的view
    [self scrollViewDidEndScrollingAnimation:contentView];
}

#pragma mark - <UIScrollViewDelegate>
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    
    // 当前的索引
    NSInteger index = scrollView.contentOffset.x / scrollView.mj_w;
    
    // 取出子控制器
    UIViewController *vc = self.childViewControllers[index];
    
    vc.view.mj_x = scrollView.contentOffset.x;
    
    vc.view.mj_y = 0; // 设置控制器view的y值为0(默认是20)
    
    vc.view.mj_h = scrollView.mj_h; // 设置控制器view的height值为整个屏幕的高度(默认是比屏幕高度少个20)
    
    vc.view.mj_w = KScreenWidth;
    
    [scrollView addSubview:vc.view];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    [self scrollViewDidEndScrollingAnimation:scrollView];
    
    // 点击按钮
    NSInteger index = scrollView.contentOffset.x / scrollView.mj_w;
    
    [self TopNavtionViewButtonClickAction:self.navigationItem.titleView.subviews[index]];
}









@end
