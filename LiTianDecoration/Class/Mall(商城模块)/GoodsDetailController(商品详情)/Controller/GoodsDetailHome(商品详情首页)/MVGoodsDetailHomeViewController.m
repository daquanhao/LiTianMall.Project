//
//  MVGoodsDetailHomeViewController.m
//  LiTianDecoration
//
//  Created by administrator on 2018/7/2.
//  Copyright © 2018年 administrator. All rights reserved.
//

#define KTitlesViewHeight 44

#define KTitlesViewWitdh 150

#import "MVGoodsDetailHomeViewController.h"
#import "HSQTopNavtionView.h"
#import "HSQGoodsImageDetailViewController.h"  // 详情
#import "MVGoodsDetailViewController.h" // 商品
#import "HSQGoodsDetailCommentsViewController.h" // 评论
#import "HSQContactTheMerchantController.h"
#import "HSQLoginHomeViewController.h"
#import "HSQAccountTool.h"
#import "HSQShopCarManger.h"
#import "HSQMallShopCarViewController.h"
#import "HSQShopCarGoodsListModel.h"
#import "HSQGoodsModelView.h"
#import "HSQSubmitOrdersViewController.h"

@interface MVGoodsDetailHomeViewController ()<HSQTopNavtionViewDelegate,UIScrollViewDelegate,HSQGoodsModelViewDelegate,MVGoodsDetailViewControllerDelegate>

@property (nonatomic, strong) UIScrollView *contentView;

@property (nonatomic, strong) MVGoodsDetailViewController *GoodsDetailVC;  // 商品

@property (nonatomic, strong) HSQGoodsDetailCommentsViewController *GoodsDetailCommentsVC;  // 评论

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ViewBottomMargin; // 距离底部的距离

@property (weak, nonatomic) IBOutlet UIImageView *Collection_ImageView; // 收藏的图片

@property (weak, nonatomic) IBOutlet UILabel *ShopCarCount_Label; // 购物车数量

@property (weak, nonatomic) IBOutlet UIButton *First_Button;

@property (weak, nonatomic) IBOutlet UIButton *Second_Button;

@property (nonatomic, copy) NSString *IsCollection;   // 是否收藏 0 代表没有收藏  1代表收藏

@property (nonatomic, copy) NSString *cartCount; // 购物车数量

@property (nonatomic, strong) NSDictionary *DataDiction;

@property (weak, nonatomic) IBOutlet UIView *goodsState_View; // 商品的状态

@property (weak, nonatomic) IBOutlet UILabel *Placher_Label;

@property (nonatomic, strong) HSQTopNavtionView *NavtionView;

@end

@implementation MVGoodsDetailHomeViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.view.backgroundColor = KViewBackGroupColor;
    
    self.goodsState_View.hidden = YES;
    
    // 初始化子控制器
    [self setupChildVces];
    
    // 设置顶部标题栏
    [self setupTopTitlesView];
    
    // 设置底布滚动控制器
    [self setupContentView];
    
    // 请求商品详情的数据
    [self RequestGoodsDetailInfoFromeServer];
    
    // 商品是否被收藏
    [self RequestDataToDetermineIfTheItemIsCollected];
    
    //查看本地购物车中商品的个数
    [self LookUpShopCarCount];
    
    // 1.监听用户的登录
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(UserLoginSuccessNotif:) name:@"UserDidLoginSuccessNotif" object:nil];
    
}

/**
 * @brief 初始化子控制器
 */
-(void)setupChildVces{
    
    MVGoodsDetailViewController *GoodsDetailVC = [[MVGoodsDetailViewController alloc] init];
    GoodsDetailVC.title = @"商品";
    GoodsDetailVC.delegate = self;
    [self addChildViewController:GoodsDetailVC];
    self.GoodsDetailVC = GoodsDetailVC;
    
    HSQGoodsImageDetailViewController *ImageDetailVC = [[HSQGoodsImageDetailViewController alloc] init];
    ImageDetailVC.title = @"详情";
    ImageDetailVC.commonId = self.commond_id;
    [self addChildViewController:ImageDetailVC];
    
    HSQGoodsDetailCommentsViewController *GoodsDetailCommentsVC = [[HSQGoodsDetailCommentsViewController alloc] init];
    GoodsDetailCommentsVC.title = @"评论";
    GoodsDetailCommentsVC.commonId = self.commond_id;
    [self addChildViewController:GoodsDetailCommentsVC];
    self.GoodsDetailCommentsVC = GoodsDetailCommentsVC;
}

/**
 * @brief 设置顶部标题栏
 */
- (void)setupTopTitlesView{
    
    HSQTopNavtionView *NavtionView = [[HSQTopNavtionView alloc] initWithFrame:CGRectMake(0, 0, KTitlesViewWitdh, KTitlesViewHeight)];
    
    NavtionView.delegate = self;
        
    NavtionView.TitlesArray = @[@"商品",@"详情",@"评论"];
    
    NavtionView.IsHidden_TitleView = YES;
    
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

/**
 * @brief UIScrollViewDelegate
 */
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
    
//    [self TopNavtionViewButtonClickAction:self.navigationItem.titleView.subviews[index]];
    [self TopNavtionViewButtonClickAction:self.NavtionView.Title_View.subviews[index]];
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    
}

/**
 * @brief 请求商品的详情信息
 */
- (void)RequestGoodsDetailInfoFromeServer{
    
    NSString *url = [NSString stringWithFormat:@"%@/goods/%@",@"http://10.1.8.238/api",self.commond_id];
    
    [[HSQProgressHUDManger Manger] ShowLoadingDataFromeServer:@"" ToView:self.view IsClearColor:YES];
    
    AFNetworkRequestTool *RequestTool = [AFNetworkRequestTool shareRequestTool];
    
    [RequestTool.manger GET:url parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        HSQLog(@"===我的数据===%@",responseObject);
        
        if ([responseObject[@"code"] integerValue] == 200)
        {
            self.DataDiction = responseObject[@"datas"];
            
            // 1.评论的数据
            self.GoodsDetailCommentsVC.dataDiction = responseObject[@"datas"];
            
            // 2.商品
            self.GoodsDetailVC.responseObject = responseObject;
            
            // 3.底部按钮的赋值
            [self AssignValuesToViewControls:responseObject[@"datas"]];

        }
        else
        {
            NSString *errorString = [NSString stringWithFormat:@"%@",responseObject[@"datas"][@"error"]];
            
            [[HSQProgressHUDManger Manger] ShowDisplayFailedToLoadData:errorString SuperView:self.view];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [[HSQProgressHUDManger Manger] ShowDisplayFailedToLoadData:KErrorPlacherString SuperView:self.view];
        
    }];
}

/**
 * @brief 给视图控件赋值
 */
- (void)AssignValuesToViewControls:(NSDictionary *)diction{
    
    if ([diction[@"evaluateGoodsVoList"] containsObject:@"groups"]) // 表明是拼团商品
   {
       
    }
    else // 普通商品
    {
        [self.First_Button setTitle:@"加入购物车" forState:(UIControlStateNormal)];
        
        [self.Second_Button setTitle:@"立即购买" forState:(UIControlStateNormal)];
        
    }
    
//    // 1.拼团的价格和所需的人数
//    self.GoodsArray = [HSQPinTuanDetailGoodsListModel mj_objectArrayWithKeyValuesArray:diction[@"groupGoodsDetailVo"][@"goodsList"]];
//
//    HSQPinTuanDetailGoodsListModel *model = [self.GoodsArray firstObject];
//
//    NSString *count = [NSString stringWithFormat:@"%@",diction[@"groupGoodsDetailVo"][@"groups"][@"groupRequireNum"]];
//
//    self.KaiTuanCount_Label.text = [NSString stringWithFormat:@"¥%@\n%@人团",model.groupPrice,count];
//
//    // 2.单独购买
//    self.Buy_Label.text = [NSString stringWithFormat:@"¥%@\n单独购买",model.appPrice0];
    
}

/**
 * @brief 查看购物车的数量
 */
- (void)LookUpShopCarCount{
    
    // 4.查看本地购物车中商品的个数
    NSMutableArray *ShopCarCount = [[HSQShopCarManger sharedShopCarManger] getAllGoodsModel];
    
    if (ShopCarCount.count == 0)
    {
        self.ShopCarCount_Label.hidden = YES;
    }
    else
    {
        self.ShopCarCount_Label.hidden = NO;
        
        // 对数组进行去重操作
        for (NSInteger i = 0; i < ShopCarCount.count; i++) {
            
            for (NSInteger j = i+1;j < ShopCarCount.count; j++) {
                
                HSQShopCarGoodsListModel *tempModel = ShopCarCount[i];
                
                HSQShopCarGoodsListModel *model = ShopCarCount[j];
                
                if ([tempModel.commonId isEqualToString:model.commonId]) {
                    
                    [ShopCarCount removeObject:model];
                }
            }
        }
        
        self.ShopCarCount_Label.text = [NSString stringWithFormat:@"%ld",ShopCarCount.count];
    }
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
        HSQLoginHomeViewController *LoginVC = [[HSQLoginHomeViewController alloc] init];
        
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
    
    NSDictionary *params = @{@"token":token,@"commonId":self.commond_id};
    
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
                self.Collection_ImageView.image = [UIImage imageNamed:@"xin"];
            }
            else
            {
                self.IsCollection = @"0";
                self.Collection_ImageView.image = [UIImage imageNamed:@"Shape"];
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
        
        [[HSQProgressHUDManger Manger] ShowDisplayFailedToLoadData:KErrorPlacherString SuperView:self.view];
    }];
    
}

/**
 * @brief 购物车按钮的点击
 */
- (IBAction)ShopCarBtnClickAction:(UIButton *)sender {
    
    HSQMallShopCarViewController *ShopCarVC = [[HSQMallShopCarViewController alloc] init];
    
    ShopCarVC.source = @"200";
    
    [self.navigationController pushViewController:ShopCarVC animated:YES];
}

/**
 * @brief 监听用户的登录
 */
- (void)UserLoginSuccessNotif:(NSNotification *)notif{
    
    // 检测商品是否被收藏
    [self RequestDataToDetermineIfTheItemIsCollected];
    
    // 将本地购物车的数据同步到服务器
    // 购物车管理工具
    HSQShopCarManger *ShopCarManger = [HSQShopCarManger sharedShopCarManger];
    
    // 1.取出本地所有的购物车数据
    NSMutableArray *ShopCarCount = [ShopCarManger getAllGoodsModel];
    
    if (ShopCarCount.count != 0)
    {
        [self AftetheUserLogsInSynchronizeTheLocalShoppingCartDataToTheServer];
    }
}

/**
 * @brief 用户登录以后，将本地的购物车数据同步到服务器
 */
- (void)AftetheUserLogsInSynchronizeTheLocalShoppingCartDataToTheServer{
    
    HSQAccount *account = [HSQAccountTool account];
    
    NSString *cartData = [self JsonStringWithDataDiction];
    
    NSDictionary *diction = @{@"token":account.token,@"cartData":cartData};
    
    AFNetworkRequestTool *requestTool = [AFNetworkRequestTool shareRequestTool];
    
    [requestTool.manger POST:UrlAdress(KUpLoadShopCarDataToServerUrl) parameters:diction progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        HSQLog(@"==购物车数据同步==%@",responseObject);
        
        if ([responseObject[@"code"] integerValue] == 200)
        {
            // 同步成功后，将本地的数据删除
//            [[HSQShopCarManger sharedShopCarManger] ClearAllDataFromeFMDB];
        }
        else
        {
             [self AftetheUserLogsInSynchronizeTheLocalShoppingCartDataToTheServer];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [[HSQProgressHUDManger Manger] ShowDisplayFailedToLoadData:KErrorPlacherString SuperView:self.view];
        
    }];
    
}


/**
 * @brief 请求数据判断商品是否被收藏
 */
- (void)RequestDataToDetermineIfTheItemIsCollected{
    
    NSString *token = [HSQAccountTool account].token;
    
    if (token.length == 0) return;
    
    NSDictionary *params = @{@"token":token,@"commonId":self.commond_id};
    
    AFNetworkRequestTool *requestTool = [AFNetworkRequestTool shareRequestTool];
    
    [requestTool.manger POST:UrlAdress(KCheckIsCollectionGoodsUrl) parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if ([responseObject[@"code"] integerValue] == 200)
        {
            self.IsCollection = [NSString stringWithFormat:@"%@",responseObject[@"datas"][@"isExist"]];
            
            if (self.IsCollection.integerValue == 0) // 没有收藏
            {
                self.Collection_ImageView.image = KImageName(@"Shape");
            }
            else
            {
                self.Collection_ImageView.image = KImageName(@"xin");
            }
        }
        else
        {
            NSString *errorString = [NSString stringWithFormat:@"%@",responseObject[@"datas"][@"error"]];
            
            [[HSQProgressHUDManger Manger] ShowDisplayFailedToLoadData:errorString SuperView:self.view];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [[HSQProgressHUDManger Manger] ShowDisplayFailedToLoadData:KErrorPlacherString SuperView:self.view];
    }];
}

/**
 * @brief 根据数据，将数组中的数据转化为字典，并将字典转化为json字符串
 */
- (NSString *)JsonStringWithDataDiction{
    
    // 购物车管理工具
    HSQShopCarManger *ShopCarManger = [HSQShopCarManger sharedShopCarManger];
    
    // 1.取出本地所有的购物车数据
    NSMutableArray *ShopCarCount = [ShopCarManger getAllGoodsModel];
    
    // 2.初始化一个字典
    NSMutableDictionary *dataDiction = [NSMutableDictionary dictionary];
    
    if (ShopCarCount.count != 0) // 说明本地购物车有数据
    {
        for (HSQShopCarGoodsListModel *model in ShopCarCount)
        {
            dataDiction[model.goodsId] = model.buyNum;
        }
    }
    
    NSString *jsonString = [ShopCarManger toJSONDataString:dataDiction];
    
    HSQLog(@"==服务器数据==%@",jsonString);
    
    return jsonString;
    
    
}

/**
 * @brief 加入购物车或者单独购买
 */
- (IBAction)First_ButtonClickAction:(UIButton *)sender {
    
    HSQGoodsModelView *GuiGeAndCouperView = [HSQGoodsModelView initGoodsModelView];
    
    GuiGeAndCouperView.TypeString = @"400";
    
    GuiGeAndCouperView.Ordinary_DatasDiction = self.DataDiction;
    
    GuiGeAndCouperView.delegate = self;
    
    [GuiGeAndCouperView ShowGoodsModelAndPriceView];
}

/**
 * @brief 立即购买或者拼团购买
 */
- (IBAction)SecondButtonClickAction:(UIButton *)sender {
    
    HSQGoodsModelView *GuiGeAndCouperView = [HSQGoodsModelView initGoodsModelView];
    
    GuiGeAndCouperView.TypeString = @"500";
    
    GuiGeAndCouperView.Ordinary_DatasDiction = self.DataDiction;
    
    GuiGeAndCouperView.delegate = self;
    
    [GuiGeAndCouperView ShowGoodsModelAndPriceView];
}

/**
 * @brief 商品规格选中的回调
 * @param Count 商品选择的个数
 * @param typeString 显示商品界面的类型
 * @param goodsId 商品的id
 * @param goodsStorage 商品的库存
 * @param goodsSpecString 商品的规格
 * @param goodsPriceString 商品的价格
 */

-(void)hsqGoodsModelViewCollectionCellClickActionWithGoodsCount:(NSString *)Count Type:(NSString *)typeString goods_id:(NSString *)goodsId
                                                    GoodsKunCun:(NSString *)goodsStorage goodsSpecString:(NSString *)goodsSpecString goodsPrice:(NSString *)goodsPriceString{
    
    self.GoodsDetailVC.goodsFullSpecs = goodsSpecString;
    
    self.GoodsDetailVC.goodsPrice = goodsPriceString;
    
}

/**
 * @brief 商品规格选中的回调
 * @param Count 商品选择的个数
 * @param typeString 显示商品界面的类型
 * @param goodsId 商品的id
 * @param goodsStorage 商品的库存
 * @param goodsSpecString 商品的规格
 * @param goodsPriceString 商品的价格
 */

-(void)hsqGoodsModelViewBottomBtnClickActionWithGoodsCount:(NSString *)Count Type:(NSString *)typeString goods_id:(NSString *)goodsId
                                               GoodsKunCun:(NSString *)goodsStorage goodsSpecString:(NSString *)goodsSpecString goodsPrice:(NSString *)goodsPriceString;{
    
    HSQLog(@"==选好的商品个数==%@==%@==%@===%@",Count,typeString,goodsId,goodsSpecString);
    
    if (typeString.integerValue == 100) // 将商品加入到购物车
    {
//        [self AddItemsToTheShoppingCart:Count Goods_id:goodsId];
        
    }
    else // 开团按钮的点击
    {
        NSLog(@"===立即购买");
        
        HSQSubmitOrdersViewController *SubmitOrderVC = [[HSQSubmitOrdersViewController alloc] init];

        SubmitOrderVC.isCart = @"0"; // 是否从购物车中跳转的购买（1–是 0–否）

        SubmitOrderVC.isGroup = @"0"; // 是否是拼团（1–是 0–否）

        SubmitOrderVC.isExistBundling = [self DecideIfYouHaveASpecialPackage]; // 判断是否含有优惠套装 （1–是 0–否）

        SubmitOrderVC.buyData = [self ShengChengSubmitOrderBuyData:goodsId buyNum:Count]; // 购买的商品(sku)的goodsId 和 购买数量组成的json串

        [self.navigationController pushViewController:SubmitOrderVC animated:YES];
    }
}

/**
 * @brief 生成提交订单界面的buyData数据
 */
- (NSString *)ShengChengSubmitOrderBuyData:(NSString *)goodsid buyNum:(NSString *)buynumber{
    
    HSQShopCarManger *manger = [HSQShopCarManger sharedShopCarManger];
    
    NSMutableArray *goods_array = [NSMutableArray array];
    
    NSDictionary *diction = @{@"buyNum":buynumber,@"goodsId":goodsid};
    
    [goods_array addObject:diction];
    
    return  [manger toJSONDataString:goods_array];
}

/**
 * @brief 判断是否含有优惠套装 （1–是 0–否）
 */
- (NSString *)DecideIfYouHaveASpecialPackage{
    
    NSArray *bundlingList = self.DataDiction[@"goodsDetail"][@"bundlingList"];
    
    if (bundlingList.count == 0)
    {
        return @"0";
    }
    else
    {
        return @"1";
    }
}

#pragma mark -****************************************************************************** MVGoodsDetailViewControllerDelegate  ***********************************************************

/**
 * @brief 选择商品的规格
 */
- (void)ChooseTheSpecificationsOfTheGoods:(NSIndexPath *)indexPath{
    
    HSQGoodsModelView *GuiGeAndCouperView = [HSQGoodsModelView initGoodsModelView];
    
    GuiGeAndCouperView.TypeString = @"400";
    
    GuiGeAndCouperView.Ordinary_DatasDiction = self.DataDiction;
    
    GuiGeAndCouperView.delegate = self;
    
    [GuiGeAndCouperView ShowGoodsModelAndPriceView];
}

/**
 * @brief 查看全部评价
 */
- (void)LookUpAllGoodsComment{
    
    [self TopNavtionViewButtonClickAction:self.NavtionView.Title_View.subviews[2]];
}


/**
 * @brief 上拉查看图文详情
 */
- (void)ScrollupToSeeGraphicDetails:(NSInteger)number{
        
    HSQTopNavtionView *NavtionView = (HSQTopNavtionView *)self.navigationItem.titleView;

    NavtionView.IsHidden_TitleView = (number == 100 ? NO : YES);
    
    self.contentView.scrollEnabled = (number == 100 ? NO : YES);
}















@end
