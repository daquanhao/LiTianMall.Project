//
//  HSQMallShopCarViewController.m
//  LiTianDecoration
//
//  Created by administrator on 2018/5/8.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import "HSQMallShopCarViewController.h"
#import "HSQShopCarGoodsListModel.h"
#import "HSQShopCarHeadListReusableView.h"
#import "HSQShopCarManger.h"
#import "HSQAccountTool.h"
#import "HSQShopCartListDataCollectionViewCell.h"
#import "HSQShopCarGoodsGuiGeListView.h"
#import "HSQShopCarGoodsFooterReusableView.h"
#import "HSQShopCarGoodsGuiGeDataView.h"
#import "HSQShopCarGoodsGuiGeListView.h"
#import "HSQShopCarVCGoodsDataModel.h"
#import "HSQShopCarGoodsTypeListModel.h"
#import "HSQSubmitOrdersViewController.h"  // 确认订单
#import "HSQLoginHomeViewController.h"  // 登录界面
#import "HSQMineViewController.h"

@interface HSQMallShopCarViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,HSQShopCartListDataCollectionViewCellDelegate,HSQShopCarGoodsGuiGeDataViewDelegate,HSQShopCarHeadListReusableViewDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, strong) NSDictionary *DataDiction;

@property (nonatomic, copy) NSString *ClickActionState; // 是否是编辑状态

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *BottomViewLayOut;

@property (weak, nonatomic) IBOutlet UIView *BottomView;

@property (weak, nonatomic) IBOutlet UIButton *QuanXuan_Btn; // 全选按钮

@property (weak, nonatomic) IBOutlet UILabel *TotalMonery_Label; // 一共多少钱

@property (weak, nonatomic) IBOutlet UIButton *Jiesuan_Btn; // 结算按钮

@property (nonatomic, strong) HSQNoDataView *NoDataView;

@property (nonatomic, copy) NSString *TypeCount; // 选择了几种

@property (nonatomic, copy) NSString *PriceString; // 选中商品的价格

@property (nonatomic, strong) NSMutableArray *SelectGoodsTypeCount_Array; // 选中的商品的种类的数量

@property (nonatomic, strong) NSMutableArray *SelectAllGoods_Array; // 是不是全部被选中

@property (nonatomic, copy) NSString *IsSelectAllGoods; // 全选按钮是否点击

@property (nonatomic, strong) NSMutableArray *Cell_Array; // cell是不是全部被选中

@property (weak, nonatomic) IBOutlet UIButton *Delete_Button; // 删除按钮


@end

@implementation HSQMallShopCarViewController

-(HSQNoDataView *)NoDataView{
    
    if (_NoDataView == nil) {
        
        self.NoDataView = [[HSQNoDataView alloc] initWithTitle:@"亲，您的购物车还没有宝贝哦~" imageName:@"3-1P106112Q1-51" height:0 TopMargin:0];
    }
    
    return _NoDataView;
}

- (NSMutableArray *)dataSource{
    
    if (_dataSource == nil) {
        
        self.dataSource = [NSMutableArray array];
    }
    
    return _dataSource;
}

- (NSMutableArray *)SelectGoodsTypeCount_Array{
    
    if (_SelectGoodsTypeCount_Array == nil) {
        
        self.SelectGoodsTypeCount_Array = [NSMutableArray array];
    }
    
    return _SelectGoodsTypeCount_Array;
}

- (NSMutableArray *)SelectAllGoods_Array{
    
    if (_SelectAllGoods_Array == nil) {
        
        self.SelectAllGoods_Array = [NSMutableArray array];
    }
    
    return _SelectAllGoods_Array;
}

- (NSMutableArray *)Cell_Array{
    
    if (_Cell_Array == nil) {
        
        self.Cell_Array = [NSMutableArray array];
    }
    
    return _Cell_Array;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.view.backgroundColor = KViewBackGroupColor;
    
    self.BottomViewLayOut.constant = KSafeBottomHeight;
    
    self.navigationItem.title = @"购物车";
    
    self.DataDiction = [NSDictionary dictionary];
    
    self.TypeCount = @"共0种0件";
    
    self.PriceString = @"¥ 0.00";
    
    self.IsSelectAllGoods = @"0";
    
    // 创建集合视图
    [self CreatCollectionViewToView];
    
    // 请求购物车的数据
    [self RequestShopCarListDataFromeServer];
    
    // 添加右边的编辑按钮
    self.ClickActionState = @"1";
    self.Delete_Button.hidden = YES;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:(UIBarButtonItemStylePlain) target:self action:@selector(RightEditItemClickAction:)];
    
    // 1.监听用户的登录
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(UserLoginSuccessNotif:) name:@"UserDidLoginSuccessNotif" object:nil];
    
    // 添加左边的导航栏图标
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"LeftBackIcon"] style:(UIBarButtonItemStylePlain) target:self action:@selector(LeftItemClickAction:)];

}

/**
 * @brief 创建集合视图
 */
- (void)CreatCollectionViewToView{
    
    UICollectionViewFlowLayout *Layout = [[UICollectionViewFlowLayout alloc] init];
    
    Layout.minimumLineSpacing = 1;  // 最小的行间距
    
    Layout.minimumInteritemSpacing = 1; // 最小的列间距
    
    CGFloat collectionHeight = KScreenHeight - KSafeBottomHeight - KSafeTopeHeight - 50;
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, collectionHeight) collectionViewLayout:Layout];
    
    collectionView.backgroundColor = [UIColor clearColor];
    
    collectionView.dataSource = self;
    
    collectionView.delegate = self;
    
    [collectionView registerClass:[HSQShopCarHeadListReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HSQShopCarHeadListReusableView"];
    
    [collectionView registerNib:[UINib nibWithNibName:@"HSQShopCarGoodsFooterReusableView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"HSQShopCarGoodsFooterReusableView"];

    [collectionView registerClass:[HSQShopCartListDataCollectionViewCell class] forCellWithReuseIdentifier:@"HSQShopCartListDataCollectionViewCell"];
    
    [self.view addSubview:collectionView];
    
    [self.view sendSubviewToBack:collectionView];
    
    self.collectionView = collectionView;
}

/**
 * @brief 请求购物车的数据
 */
- (void)RequestShopCarListDataFromeServer{
    
    [self.dataSource removeAllObjects];
    
    [[HSQProgressHUDManger Manger] ShowLoadingDataFromeServer:@"" ToView:self.view IsClearColor:YES];
    
    HSQAccount *account = [HSQAccountTool account];
    
    NSString *cartData = [self JsonStringWithDataDiction];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"clientType"] = KClientType;
    if (account.token.length == 0)
    {
        params[@"cartData"] = cartData;
        params[@"token"] = @"";
    }
    else
    {
        params[@"token"] = account.token;
    }
    
    AFNetworkRequestTool *requestTool = [AFNetworkRequestTool shareRequestTool];
    
    [requestTool.manger POST:UrlAdress(KShopCarGoodsListUrl) parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [[HSQProgressHUDManger Manger] DismissProgressHUD];
        
        if ([responseObject[@"code"] integerValue] == 200)
        {
            HSQLog(@"==购物车的列表数据==%@",responseObject);
            self.DataDiction = responseObject[@"datas"];
            
            // 中间的规格列表
            for (NSDictionary *dict in responseObject[@"datas"][@"cartStoreVoList"]){
                
                // 外层数据 有多少个店铺
                HSQShopCarVCGoodsDataModel *ShopCarVCGoodsDataModel = [[HSQShopCarVCGoodsDataModel alloc] initWithDictionary:dict error:nil];
                ShopCarVCGoodsDataModel.IsSelect = @"0";
                ShopCarVCGoodsDataModel.cartSpuVoList = [NSMutableArray array];
                ShopCarVCGoodsDataModel.StoreSelect_Source = [NSMutableArray array];
                ShopCarVCGoodsDataModel.Cell_array = [NSMutableArray array];
                [self.dataSource addObject:ShopCarVCGoodsDataModel];
                
                // 内层数据 每个店铺有几个商品
                for (NSInteger i = 0; i < [dict[@"cartSpuVoList"] count] ; i++) {
                    
                    NSDictionary *ModelDiction = dict[@"cartSpuVoList"][i];
                    HSQShopCarVCSecondGoodsDataModel *ListModel = [[HSQShopCarVCSecondGoodsDataModel alloc] init];
                    ListModel.IsSelect = @"0";
                    ListModel.SecondCartItemVoList = [NSMutableArray array];
                    ListModel.Select_DataSource = [NSMutableArray array];
                    ListModel.Cell_array = [NSMutableArray array];
                    [ListModel setValuesForKeysWithDictionary:ModelDiction];
                    [ShopCarVCGoodsDataModel.cartSpuVoList addObject:ListModel];
                    
                    // 每个商品下有几种规格
                    for (NSDictionary *ThirdDiction in ModelDiction[@"cartItemVoList"]) {
                        HSQShopCarGoodsTypeListModel *ThirdModel = [[HSQShopCarGoodsTypeListModel alloc] init];
                        ThirdModel.IsSelect = @"0";
                        ThirdModel.EditState = @"1";
                        [ThirdModel setValuesForKeysWithDictionary:ThirdDiction];
                        [ListModel.SecondCartItemVoList addObject:ThirdModel];
                        
                    }
                }
            }
        }
        else
        {
            NSString *errorString = [NSString stringWithFormat:@"%@",responseObject[@"datas"][@"error"]];
            
            [[HSQProgressHUDManger Manger] ShowDisplayFailedToLoadData:errorString SuperView:self.view];
        }
        
        if (self.dataSource.count == 0)
        {
            [self.view addSubview:self.NoDataView];
        }
        
        [self.collectionView reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [self.view addSubview:self.NoDataView];
        
        [[HSQProgressHUDManger Manger] ShowDisplayFailedToLoadData:@"购物车数据加载失败" SuperView:self.view];
        
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
 * @brief 编辑按钮的点击
 */
- (void)RightEditItemClickAction:(UIBarButtonItem *)sender{
    
    if (self.ClickActionState.integerValue == 1) // 是否是编辑状态
    {
        self.ClickActionState = @"2";
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:(UIBarButtonItemStylePlain) target:self action:@selector(RightEditItemClickAction:)];
        self.Jiesuan_Btn.hidden = self.TotalMonery_Label.hidden = YES;
        self.Delete_Button.hidden = NO;
    }
    else
    {
        self.ClickActionState = @"1";
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:(UIBarButtonItemStylePlain) target:self action:@selector(RightEditItemClickAction:)];
        self.Jiesuan_Btn.hidden = self.TotalMonery_Label.hidden = NO;
        self.Delete_Button.hidden = YES;
    }
    
    for (HSQShopCarVCGoodsDataModel *firstModel in self.dataSource) {
        
        for (HSQShopCarVCSecondGoodsDataModel *secondModel in firstModel.cartSpuVoList) {
            
            for (HSQShopCarGoodsTypeListModel *thirdModel in secondModel.SecondCartItemVoList) {
                
                thirdModel.EditState = self.ClickActionState;
            }
        }
    }
    
    [self.collectionView reloadData];
}


/**
 * @brief 监听用户的登录
 */
- (void)UserLoginSuccessNotif:(NSNotification *)notif{
    
    // 将本地购物车的数据同步到服务器
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
        if ([responseObject[@"code"] integerValue] != 200)
        {
            [self AftetheUserLogsInSynchronizeTheLocalShoppingCartDataToTheServer];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [[HSQProgressHUDManger Manger] ShowDisplayFailedToLoadData:@"购物车数据同步失败" SuperView:self.view];
        
    }];
    
}

/**
 * @brief 导航栏左侧的item的点击事件
 */
- (void)LeftItemClickAction:(UIBarButtonItem *)item{
    
    if (self.source.integerValue == 100)  // 来自订单
    {
        for (UIViewController *VC in self.navigationController.viewControllers) {
            
            if ([VC isKindOfClass:[HSQMineViewController class]]) {
                
                [self.navigationController popToViewController:VC animated:YES];
            }
        }
    }
    else  // 来自商品详情
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}






#pragma mark *************************************************************************************************************************************************************************************************

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionViewDelegate,UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    self.BottomView.hidden = (self.dataSource.count == 0);
    
    self.NoDataView.hidden = (self.dataSource.count != 0);
    
    return self.dataSource.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    HSQShopCarVCGoodsDataModel *model = self.dataSource[section];
    
    return model.cartSpuVoList.count;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    
    return CGSizeMake(KScreenWidth, 45);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    HSQShopCarVCGoodsDataModel *model = self.dataSource[indexPath.section];
    
    HSQShopCarVCSecondGoodsDataModel *SecondModel = model.cartSpuVoList[indexPath.row];
    
    CGSize photosSize = [HSQShopCarGoodsGuiGeListView SizeWithDataModelArray:SecondModel.SecondCartItemVoList];

    return CGSizeMake(KScreenWidth, KGoodsImageShopCaHeight + 30 + photosSize.height);
    
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    
   return CGSizeMake(KScreenWidth, 55);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionReusableView *reusableView = nil;
    
    if (kind == UICollectionElementKindSectionHeader)
    {
        HSQShopCarHeadListReusableView *headReusableView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HSQShopCarHeadListReusableView" forIndexPath:indexPath];
        
        headReusableView.Model = self.dataSource[indexPath.section];
        
        headReusableView.Section = [NSString stringWithFormat:@"%ld",indexPath.section];
        
        headReusableView.delegate = self;
        
        reusableView = headReusableView;

    }
    
    if (kind == UICollectionElementKindSectionFooter)
    {
        HSQShopCarGoodsFooterReusableView *FooterReusableView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"HSQShopCarGoodsFooterReusableView" forIndexPath:indexPath];
        
        FooterReusableView.RightItemEditState = self.ClickActionState; // 导航栏右边编辑按钮的点击事件
        
        FooterReusableView.FirstModel = self.dataSource[indexPath.section];
        
        reusableView = FooterReusableView;
    }
    
    return reusableView;
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    HSQShopCartListDataCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HSQShopCartListDataCollectionViewCell" forIndexPath:indexPath];
    
     HSQShopCarVCGoodsDataModel *model = self.dataSource[indexPath.section];
    
    cell.SecondModel = model.cartSpuVoList[indexPath.row];
    
    cell.delegate = self;
        
    return cell;

}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
}

/**
 * @brief 分区头部小圆点的点击事件
 */
- (void)HeaderReusableViewLeftRato_ButtonClickAction:(UIButton *)sender{
    
    HSQShopCarHeadListReusableView *HeaderReusableView = (HSQShopCarHeadListReusableView *)sender.superview;
    
    NSString *Section = HeaderReusableView.Section;
    
    HSQShopCarVCGoodsDataModel *FirstDataModel = self.dataSource[Section.integerValue];
    
    FirstDataModel.IsSelect = (FirstDataModel.IsSelect.integerValue == 0 ? @"1" : @"0");
    
    CGFloat TotalType_Goods = 0;
    
    CGFloat TotalCount_Goods = 0;
    
    CGFloat TotalMonert = 0;
    
    for (HSQShopCarVCSecondGoodsDataModel *secondModel in FirstDataModel.cartSpuVoList) {

        secondModel.IsSelect = FirstDataModel.IsSelect;

        if (FirstDataModel.IsSelect.integerValue == 0)
        {
            [secondModel.Select_DataSource removeAllObjects];
            [FirstDataModel.StoreSelect_Source removeAllObjects];
            
            // 计算商品的种类数
            TotalType_Goods = 0;
        }
        else
        {
            [secondModel.Select_DataSource addObjectsFromArray:secondModel.SecondCartItemVoList];
            [FirstDataModel.StoreSelect_Source removeAllObjects];
            [FirstDataModel.StoreSelect_Source addObjectsFromArray:FirstDataModel.cartSpuVoList];
            
            // 计算商品的种类数
            TotalType_Goods = TotalType_Goods + secondModel.SecondCartItemVoList.count;
        }
        
        for (HSQShopCarGoodsTypeListModel *ThirdModel in secondModel.SecondCartItemVoList) {

            ThirdModel.IsSelect = FirstDataModel.IsSelect;
            
            // 计算商品的个数
            TotalCount_Goods = TotalCount_Goods + ThirdModel.buyNum.floatValue;
            
            // 计算商品的价格
            TotalMonert = TotalMonert + ThirdModel.buyNum.floatValue * ThirdModel.appPrice0.floatValue;
        }
    }
    
    // 选中的商品种类
    FirstDataModel.SelectTypeString = [NSString stringWithFormat:@"%.f",TotalType_Goods];
    
    // 选中的商品的总个数
    if (FirstDataModel.IsSelect.integerValue == 0)
    {
        FirstDataModel.SelectCountString = @"0";
        
        // 选中的商品总价钱
        FirstDataModel.SelectGoodsPrice = @"0.00";
    }
    else
    {
        FirstDataModel.SelectCountString = [NSString stringWithFormat:@"%.f",TotalCount_Goods];
        
        // 选中的商品总价钱
        FirstDataModel.SelectGoodsPrice = [NSString stringWithFormat:@"%.2f",TotalMonert];
    }

    // 判断商品有没有全部被选中
    [self JudgeWhetherTheGoodsAreAllChosen];
    
    // 刷新数据
    [self.collectionView reloadData];

    // 2.计算选中的种类及数量
    [self JiSuanShopCarGoodsTypeAndCountWithCarData];
    

}

/**
 * @brief 每个cell上小圆圈的点击事件
 */
- (void)LeftXiaoYuanQuanButtonClickAction:(UIButton *)sender{
    
    HSQShopCartListDataCollectionViewCell *cell = (HSQShopCartListDataCollectionViewCell *)sender.superview.superview;
    
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
    
    HSQShopCarVCGoodsDataModel *FirstModel = self.dataSource[indexPath.section];
        
    CGFloat TotalCount_Goods = 0;
    
    CGFloat TotalMonerty = 0;
    
    HSQShopCarVCSecondGoodsDataModel *SecondModel = FirstModel.cartSpuVoList[indexPath.row];
    
    if (SecondModel.IsSelect.integerValue == 0)
    {
        SecondModel.IsSelect = @"1";
        [SecondModel.Select_DataSource addObjectsFromArray:SecondModel.SecondCartItemVoList];
        [FirstModel.StoreSelect_Source addObject:SecondModel];
    }
    else
    {
        SecondModel.IsSelect = @"0";
        [SecondModel.Select_DataSource removeAllObjects];
        [FirstModel.StoreSelect_Source removeObject:SecondModel];
    }
    
    for (HSQShopCarGoodsTypeListModel *ThirdModel in SecondModel.SecondCartItemVoList) {
        
        ThirdModel.IsSelect = SecondModel.IsSelect;
    }
    
    // 将选中的商品添加到数组中
    for (HSQShopCarVCSecondGoodsDataModel *SecondModel in FirstModel.cartSpuVoList) {
        
        for (HSQShopCarGoodsTypeListModel *ThirdModel in SecondModel.SecondCartItemVoList) {
            
            if (ThirdModel.IsSelect.integerValue == 1)
            {
                // 将选中的商品添加到cell_array中
                if (![FirstModel.Cell_array containsObject:ThirdModel]){
                    
                    [FirstModel.Cell_array addObject:ThirdModel];
                }
            }
            else
            {
                // 将没有选中的商品添加到cell_array中
                [FirstModel.Cell_array removeObject:ThirdModel];
            }
           
        }
    }

    // 计算商品选中的个数
    for (HSQShopCarGoodsTypeListModel *ThirdModel in FirstModel.Cell_array) {
        
        // 商品的选中的个数
        TotalCount_Goods = TotalCount_Goods + ThirdModel.buyNum.floatValue;
        
        // 商品的选中的总钱数
        TotalMonerty = TotalMonerty + ThirdModel.buyNum.floatValue * ThirdModel.appPrice0.floatValue;

    }
    
    // 选中的商品种类
    FirstModel.SelectTypeString = [NSString stringWithFormat:@"%ld",FirstModel.Cell_array.count];
    
    // 商品的选中的个数
    FirstModel.SelectCountString = [NSString stringWithFormat:@"%.f",TotalCount_Goods];
    
    // 商品的选中的总价钱
    FirstModel.SelectGoodsPrice = [NSString stringWithFormat:@"%.2f",TotalMonerty];

    // 判断cell上的子视图是不是全部被选中
    if (FirstModel.StoreSelect_Source.count == FirstModel.cartSpuVoList.count)
    {
        FirstModel.IsSelect = @"1";
        self.QuanXuan_Btn.selected = YES;
    }
    else
    {
        FirstModel.IsSelect = @"0";
        self.QuanXuan_Btn.selected = NO;
    }
    
    [self.collectionView reloadData];
    
    // 2.计算选中的种类及数量
    [self JiSuanShopCarGoodsTypeAndCountWithCarData];
    
}

/**
 * @brief 加好按钮的点击事件
 */
- (void)AddButtonInShopCartListDataCollectionViewCellClickAction:(UIButton *)sender{
    
     HSQLog(@"===加好按钮的点击事件 ");
    
    HSQShopCarGoodsGuiGeDataView *GuiGeDataView = (HSQShopCarGoodsGuiGeDataView *)sender.superview.superview;
    
    HSQShopCarGoodsGuiGeListView *GuiGeView = (HSQShopCarGoodsGuiGeListView *)sender.superview.superview.superview;
    
     HSQShopCartListDataCollectionViewCell *cell = (HSQShopCartListDataCollectionViewCell *)sender.superview.superview.superview.superview.superview;
  
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
    
    HSQShopCarVCGoodsDataModel *FirstModel = self.dataSource[indexPath.section];
    
    HSQShopCarVCSecondGoodsDataModel *SecondModel = FirstModel.cartSpuVoList[indexPath.row];
    
    for (NSInteger i = 0; i < GuiGeView.subviews.count; i++) {
        
        HSQShopCarGoodsGuiGeDataView *dataView = (HSQShopCarGoodsGuiGeDataView *)GuiGeView.subviews[i];
        
        if (dataView == GuiGeDataView){
            
            HSQShopCarGoodsTypeListModel *ThirdModel = SecondModel.SecondCartItemVoList[i];
            
            if (ThirdModel.IsSelect.integerValue == 0)
            {
                ThirdModel.IsSelect = @"1";
                [SecondModel.Select_DataSource addObject:ThirdModel];
            }
            
            if (ThirdModel.buyNum.integerValue >= ThirdModel.goodsStorage.integerValue)
            {
                [[HSQProgressHUDManger Manger] ShowProgressHUDPromptText:@"库存不足" SupView:self.view];
            }
            else
            {
                NSString *NewBuyCount = [NSString stringWithFormat:@"%ld",ThirdModel.buyNum.integerValue + 1];
                
                // 更新本地数据库
                [self UpDateBenDiShopCarDataWithGoodsId:ThirdModel.goodsId buyNumber:NewBuyCount commonId:ThirdModel.commonId ShopCarId:ThirdModel.cartId DataModel:ThirdModel firstModel:FirstModel];
            }
        }
    }
    
    // 判断cell上的子视图是不是全部被选中
    [self JudeAllGoodsIsSelectWithFirstModel:FirstModel secondModel:SecondModel];
}

/**
 * @brief 减号按钮的点击事件
 */
- (void)JianHaoButtonInShopCartListDataCollectionViewCellClickAction:(UIButton *)sender{
    
    HSQLog(@"===减号按钮的点击事件jiahao ");
    
    HSQShopCarGoodsGuiGeDataView *GuiGeDataView = (HSQShopCarGoodsGuiGeDataView *)sender.superview.superview;
    
    HSQShopCarGoodsGuiGeListView *GuiGeView = (HSQShopCarGoodsGuiGeListView *)sender.superview.superview.superview;
    
    HSQShopCartListDataCollectionViewCell *cell = (HSQShopCartListDataCollectionViewCell *)sender.superview.superview.superview.superview.superview;
    
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
    
    HSQShopCarVCGoodsDataModel *FirstModel = self.dataSource[indexPath.section];
    
    HSQShopCarVCSecondGoodsDataModel *SecondModel = FirstModel.cartSpuVoList[indexPath.row];
    
    for (NSInteger i = 0; i < GuiGeView.subviews.count; i++) {
        
        HSQShopCarGoodsGuiGeDataView *dataView = (HSQShopCarGoodsGuiGeDataView *)GuiGeView.subviews[i];
        
        if (dataView == GuiGeDataView){
            
            HSQShopCarGoodsTypeListModel *ThirdModel = SecondModel.SecondCartItemVoList[i];
            
            if (ThirdModel.IsSelect.integerValue == 0)
            {
                ThirdModel.IsSelect = @"1";
                [SecondModel.Select_DataSource addObject:ThirdModel];
            }
            else
            {
                ThirdModel.IsSelect = @"0";
                [SecondModel.Select_DataSource  removeObject:ThirdModel];
            }
            
            if (ThirdModel.buyNum.integerValue <= 1)
            {
                [[HSQProgressHUDManger Manger] ShowProgressHUDPromptText:@"商品个数不能低于1" SupView:self.view];
                
                [self JiaJianHaoJiSuanGoodsTypeAndCountWithFirstModel:FirstModel];
            }
            else
            {
                NSString *NewBuyCount = [NSString stringWithFormat:@"%ld",ThirdModel.buyNum.integerValue - 1];
                
                // 更新本地数据库
                [self UpDateBenDiShopCarDataWithGoodsId:ThirdModel.goodsId buyNumber:NewBuyCount commonId:ThirdModel.commonId ShopCarId:ThirdModel.cartId DataModel:ThirdModel firstModel:FirstModel];
            }
        }
    }
    
    // 判断cell上的子视图是不是全部被选中
    [self JudeAllGoodsIsSelectWithFirstModel:FirstModel secondModel:SecondModel];
    
    
}

/**
 * @brief 输入框的点击事件
 */
- (void)ShopCarGoodsCountTextFieldInShopCartListDataCollectionViewCellClickAction:(UIButton *)sender{
    
    HSQLog(@"===输入框的点击事件o==");
}

/**
 * @brief 商品规格界面小圆点的点击事件
 */
- (void)LeftXiaoYuanDianButtonInShopCartListDataCollectionViewCellClickAction:(UIButton *)sender{
    
    HSQShopCartListDataCollectionViewCell *cell = (HSQShopCartListDataCollectionViewCell *)sender.superview.superview.superview.superview;
    
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
    
    HSQShopCarGoodsGuiGeListView *GuiGeView = (HSQShopCarGoodsGuiGeListView *)sender.superview.superview;
    
    HSQShopCarGoodsGuiGeDataView *GuiGeDataView = (HSQShopCarGoodsGuiGeDataView *)sender.superview;
    
    HSQShopCarVCGoodsDataModel *FirstModel = self.dataSource[indexPath.section];
    
    HSQShopCarVCSecondGoodsDataModel *SecondModel = FirstModel.cartSpuVoList[indexPath.row];
    
    for (NSInteger i = 0; i < GuiGeView.subviews.count; i++) {
        
        HSQShopCarGoodsGuiGeDataView *dataView = (HSQShopCarGoodsGuiGeDataView *)GuiGeView.subviews[i];
        
        if (dataView == GuiGeDataView){
            
            HSQShopCarGoodsTypeListModel *ThirdModel = SecondModel.SecondCartItemVoList[i];
            
            if (ThirdModel.IsSelect.integerValue == 0)
            {
                ThirdModel.IsSelect = @"1";
                [SecondModel.Select_DataSource addObject:ThirdModel];
            }
            else
            {
                ThirdModel.IsSelect = @"0";
                [SecondModel.Select_DataSource  removeObject:ThirdModel];
            }
        }

    }
    
    // 计算商品的种类
    CGFloat TotalCount = 0;
    CGFloat TotalMonery = 0;
    NSMutableArray *array = [NSMutableArray array];
    for (NSInteger i = 0; i < FirstModel.cartSpuVoList.count; i++) {

        HSQShopCarVCSecondGoodsDataModel *SecondModel = FirstModel.cartSpuVoList[i];

        for (NSInteger i = 0; i < SecondModel.SecondCartItemVoList.count ; i++) {
            
            HSQShopCarGoodsTypeListModel *ThirdModel = SecondModel.SecondCartItemVoList[i];
            
            if (ThirdModel.IsSelect.integerValue == 0)
            {
                [array removeObject:ThirdModel];
            }
            else
            {
                // 计算选中商品的个数
                TotalCount = TotalCount + ThirdModel.buyNum.floatValue;
                
                // 计算总的钱数
                TotalMonery = TotalMonery + ThirdModel.buyNum.floatValue * ThirdModel.appPrice0.floatValue;
                
                [array addObject:ThirdModel];
            }
        }
    }
    
    // 计算选中商品的种类
    FirstModel.SelectTypeString = [NSString stringWithFormat:@"%ld",array.count];
    
    // 计算选中商品的个数
    FirstModel.SelectCountString = [NSString stringWithFormat:@"%.f",TotalCount];
    
    // 计算选中商品的钱数
    FirstModel.SelectGoodsPrice = [NSString stringWithFormat:@"%.2f",TotalMonery];
    
    // 判断cell上的子视图是不是全部被选中
    [self JudeAllGoodsIsSelectWithFirstModel:FirstModel secondModel:SecondModel];
    
    // 2.计算选中的种类及数量
    [self JiSuanShopCarGoodsTypeAndCountWithCarData];
    
}

/**
 * @brief 判断cell上子视图是不是全部选中
 */
- (void)JudeAllGoodsIsSelectWithFirstModel:(HSQShopCarVCGoodsDataModel *)FirstModel secondModel:(HSQShopCarVCSecondGoodsDataModel *)secModel{
    
    // 判断cell上的子视图是不是全部被选中
    if (secModel.cartItemVoList.count == secModel.Select_DataSource .count)
    {
        secModel.IsSelect = @"1";
        [FirstModel.StoreSelect_Source addObject:secModel];
    }
    else
    {
        secModel.IsSelect = @"0";
        [FirstModel.StoreSelect_Source removeObject:secModel];
    }
    
    // 判断cell上的子视图是不是全部被选中
    CGFloat AllGoodsCount = 0;
    NSMutableArray *allGoods_Array = [NSMutableArray array];
    
    for (HSQShopCarVCGoodsDataModel *firstModel in self.dataSource) {
        
        for (HSQShopCarVCSecondGoodsDataModel *secondModel in firstModel.cartSpuVoList) {
            
            AllGoodsCount = AllGoodsCount + secondModel.SecondCartItemVoList.count;
            
            for (HSQShopCarGoodsTypeListModel *ThirdModel in secondModel.SecondCartItemVoList) {
                
                if (ThirdModel.IsSelect.integerValue == 1)
                {
                    [allGoods_Array addObject:ThirdModel];
                }
            }
        }
    }
    
    if (AllGoodsCount == allGoods_Array.count)
    {
        self.QuanXuan_Btn.selected = YES;
    }
    else
    {
        self.QuanXuan_Btn.selected = NO;
    }
    if (FirstModel.StoreSelect_Source.count == FirstModel.cartSpuVoList.count)
    {
        FirstModel.IsSelect = @"1";
    }
    else
    {
        FirstModel.IsSelect = @"0";
    }
    
     [self.collectionView reloadData];

}

/**
 * @brief 全选按钮的点击事件
 */
- (IBAction)QuanXuanButtonClickAction:(UIButton *)sender {
    
    if (self.IsSelectAllGoods.integerValue == 0) //第一次点击，点击全选
    {
        [self.QuanXuan_Btn setSelected:YES];

        self.IsSelectAllGoods = @"1";
    }
    else
    {
        [self.QuanXuan_Btn setSelected:NO];

        self.IsSelectAllGoods = @"0";
    }
    
    for (HSQShopCarVCGoodsDataModel *FirstModel in self.dataSource) {
        
        if (self.IsSelectAllGoods.integerValue == 0)
        {
            FirstModel.IsSelect = @"0";
            [FirstModel.StoreSelect_Source removeAllObjects];
        }
        else
        {
            FirstModel.IsSelect = @"1";
            [FirstModel.StoreSelect_Source addObjectsFromArray:FirstModel.cartSpuVoList];
            
        }
        
        for (HSQShopCarVCSecondGoodsDataModel *SecondModel in FirstModel.cartSpuVoList) {
            
            if (self.IsSelectAllGoods.integerValue == 1)
            {
                SecondModel.IsSelect = @"1";
                [SecondModel.Select_DataSource addObjectsFromArray:SecondModel.cartItemVoList];
            }
            else
            {
                SecondModel.IsSelect = @"0";
                [SecondModel.Select_DataSource removeAllObjects];
            }
            
            for (NSInteger i = 0; i<SecondModel.SecondCartItemVoList.count; i++) {
                
                HSQShopCarGoodsTypeListModel *ThirdModel = SecondModel.SecondCartItemVoList[i];
                
                ThirdModel.IsSelect = FirstModel.IsSelect;
            }
        }
    }
    
    for (NSInteger i = 0; i<self.dataSource.count; i++) {
        
        CGFloat TotalType = 0;
        
         CGFloat TotalCount = 0;
        
        CGFloat TotalMonery = 0;
        
        HSQShopCarVCGoodsDataModel *FirstModel = self.dataSource[i];
        
        FirstModel.IsSelect = self.IsSelectAllGoods;
        
        if (FirstModel.IsSelect.integerValue == 0)
        {
            FirstModel.SelectGoodsPrice = @"0.00";
            FirstModel.SelectCountString = @"0";
            FirstModel.SelectTypeString = @"0";
        }
        else
        {
            for (HSQShopCarVCSecondGoodsDataModel *SecondModel in FirstModel.cartSpuVoList) {
                
                // 计算选中的种类数
                TotalType = TotalType + SecondModel.SecondCartItemVoList.count;
                FirstModel.SelectTypeString = [NSString stringWithFormat:@"%.f",TotalType];
                
                for (NSInteger i = 0; i<SecondModel.SecondCartItemVoList.count; i++) {
                    
                    HSQShopCarGoodsTypeListModel *ThirdModel = SecondModel.SecondCartItemVoList[i];
                    
                    // 计算总的件数
                    TotalCount = TotalCount + ThirdModel.buyNum.floatValue;
                    FirstModel.SelectCountString =  [NSString stringWithFormat:@"%.f",TotalCount];
                    
                    // 计算总的钱数
                    TotalMonery = TotalMonery + ThirdModel.buyNum.floatValue * ThirdModel.appPrice0.floatValue;
                    FirstModel.SelectGoodsPrice = [NSString stringWithFormat:@"%.2f",TotalMonery];
                }
            }
        }
    }
    
    // 计算商品的种类及总的钱数
    [self JiSuanShopCarGoodsTypeAndCountWithCarData];
    
    [self.collectionView reloadData];
}

/**
 * @brief 去结算的按钮的点击事件
 */
- (IBAction)QuJieSaunButtonClickAction:(UIButton *)sender {
    
    HSQAccount *account = [HSQAccountTool account];
    
    if (account.token.length == 0)
    {
        HSQLoginHomeViewController *LoginVC = [[HSQLoginHomeViewController alloc] init];
        
        [self.navigationController pushViewController:LoginVC animated:YES];
    }
    else
    {
        if (self.SelectGoodsTypeCount_Array.count == 0)
        {
            [[HSQProgressHUDManger Manger] ShowProgressHUDPromptText:@"请选择购买的商品" SupView:self.view];
        }
        else
        {
            HSQSubmitOrdersViewController *SubmitOrderVC = [[HSQSubmitOrdersViewController alloc] init];
            
            // 是否从购物车中跳转的购买（1–是 0–否）
            SubmitOrderVC.isCart = @"1";
            
            // 是否是拼团（1–是 0–否）
            SubmitOrderVC.isGroup = @"1";
            
            // 判断是否含有优惠套装 （1–是 0–否）
            SubmitOrderVC.isExistBundling = [self DecideIfYouHaveASpecialPackage];
            
            // 购买的商品(sku)的goodsId 和 购买数量组成的json串
            SubmitOrderVC.buyData = [self ShengChengSubmitOrderBuyData];
            
            [self.navigationController pushViewController:SubmitOrderVC animated:YES];
        }
        
    }
}


/**
 * @brief 编辑购物车的数量
 */
- (void)UpDateBenDiShopCarDataWithGoodsId:(NSString *)goodsId  buyNumber:(NSString *)BuyNumber commonId:(NSString *)commonId ShopCarId:(NSString *)CarId DataModel:(HSQShopCarGoodsTypeListModel *)thirdModel firstModel:(HSQShopCarVCGoodsDataModel *)FirstModel{
    
    // 购物车管理工具
    HSQShopCarManger *ShopCarManger = [HSQShopCarManger sharedShopCarManger];
    
    HSQAccount *account = [HSQAccountTool account];
    
    NSMutableDictionary *Params = [NSMutableDictionary dictionary];
    Params[@"clientType"]    = KClientType;
    Params[@"buyNum"]       = BuyNumber;
    Params[@"cartId"]            = CarId;
    if (account.token.length == 0)
    {
        Params[@"token"] = @"";
        
        // 要更新的数据
        NSString *GoodsId_string = [NSString stringWithFormat:@"%@",goodsId];
        NSString *Buy_string = [NSString stringWithFormat:@"%@",BuyNumber];
        NSDictionary *cartData_diction = @{GoodsId_string:Buy_string};
        NSString *cartData = [ShopCarManger toJSONDataStringWithDiction:cartData_diction];
        Params[@"cartData"] = cartData;
    }
    else
    {
        Params[@"token"] = account.token;
    }
    
    AFNetworkRequestTool *RequestTool = [AFNetworkRequestTool shareRequestTool];
    
    [RequestTool.manger POST:UrlAdress(KEditShopCarCountUrl) parameters:Params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        HSQLog(@"==数据加载==%@",responseObject);
        
        if ([responseObject[@"code"] integerValue] == 200)
        {
            if (account.token.length == 0)  // 说明没有登录操作本地数据库，登录以后就不用操作啦
            {
                [self UpDataModelWithBuyNum:BuyNumber goodid:goodsId ShopCarMnager:ShopCarManger commonId:commonId CarData:responseObject[@"datas"][@"cartData"]];
            }
            
            // 更新列表
            thirdModel.buyNum = [NSString stringWithFormat:@"%@",BuyNumber];
            
            // 2.计算选中的种类及数量
            [self JiSuanShopCarGoodsTypeAndCountWithCarData];
            
            [self JiaJianHaoJiSuanGoodsTypeAndCountWithFirstModel:FirstModel];
        }
        else
        {
            NSString *errorString = [NSString stringWithFormat:@"%@",responseObject[@"datas"][@"error"]];
            
            [[HSQProgressHUDManger Manger] ShowDisplayFailedToLoadData:errorString SuperView:self.view];
        }
        
        [self.collectionView reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [[HSQProgressHUDManger Manger] ShowProgressHUDPromptText:@"数据编辑失败" SupView:self.view];
        
    }];
}

/**
 * @brief 点击加减号时，计算选中的商品的种类和数量以及价格
 */
- (void)JiaJianHaoJiSuanGoodsTypeAndCountWithFirstModel:(HSQShopCarVCGoodsDataModel *)FirstModel{
    
    // 计算商品的种类
    CGFloat TotalCount = 0;
    CGFloat TotalMonery = 0;
    NSMutableArray *array = [NSMutableArray array];
    for (NSInteger i = 0; i < FirstModel.cartSpuVoList.count; i++) {
        
        HSQShopCarVCSecondGoodsDataModel *SecondModel = FirstModel.cartSpuVoList[i];
        
        for (NSInteger i = 0; i < SecondModel.SecondCartItemVoList.count ; i++) {
            
            HSQShopCarGoodsTypeListModel *ThirdModel = SecondModel.SecondCartItemVoList[i];
            
            if (ThirdModel.IsSelect.integerValue == 0)
            {
                [array removeObject:ThirdModel];
            }
            else
            {
                // 计算选中商品的个数
                TotalCount = TotalCount + ThirdModel.buyNum.floatValue;
                
                // 计算总的钱数
                TotalMonery = TotalMonery + ThirdModel.buyNum.floatValue * ThirdModel.appPrice0.floatValue;
                
                [array addObject:ThirdModel];
            }
        }
    }
    
    // 计算选中商品的种类
    FirstModel.SelectTypeString = [NSString stringWithFormat:@"%ld",array.count];
    
    // 计算选中商品的个数
    FirstModel.SelectCountString = [NSString stringWithFormat:@"%.f",TotalCount];
    
    // 计算选中商品的钱数
    FirstModel.SelectGoodsPrice = [NSString stringWithFormat:@"%.2f",TotalMonery];
}

/**
 * @brief 点击加号或者减号按钮的时候更新本地数据库
 */
- (void)UpDataModelWithBuyNum:(NSString *)BuyNumber goodid:(NSString *)goodsId ShopCarMnager:(HSQShopCarManger *)ShopCarManger commonId:(NSString *)commonId CarData:(NSString *)cardata{
    
    // 添加购物车数据
    NSDictionary *buyData_diction = @{@"buyNum":BuyNumber,@"goodsId":goodsId};
    NSMutableArray *goods_array = [NSMutableArray array];
    [goods_array addObject:buyData_diction];
    NSString *buydata = [ShopCarManger toJSONDataString:goods_array];
    
    // 要加入购物车的数据
    NSString *GoodsId_string = [NSString stringWithFormat:@"%@",goodsId];
    NSString *Buy_string = [NSString stringWithFormat:@"%@",BuyNumber];
    NSDictionary *cartData_diction = @{GoodsId_string:Buy_string};
    NSString *cartData = [ShopCarManger toJSONDataStringWithDiction:cartData_diction];
    
    // 购物车数据模型
    HSQShopCarGoodsListModel *ShopCarModel = [[HSQShopCarGoodsListModel alloc] init];
    ShopCarModel.goodsId = goodsId;
    ShopCarModel.buyData = buydata;
    ShopCarModel.cartData = cartData;
    ShopCarModel.commonId = commonId;
    ShopCarModel.buyNum = BuyNumber;
    
    // 1.更新本地的数据库数据
    [ShopCarManger updatePGoodsModel:ShopCarModel];
    
}

/**
 * @brief 购物车商品的种类
 */
- (void)JiSuanShopCarGoodsTypeAndCountWithCarData{
    
    [self.SelectGoodsTypeCount_Array removeAllObjects];
    
    for (HSQShopCarVCGoodsDataModel *FirstModel in self.dataSource) {
      
        for (HSQShopCarVCSecondGoodsDataModel *SecondModel in FirstModel.cartSpuVoList) {
            
            for (NSInteger i = 0; i<SecondModel.SecondCartItemVoList.count; i++) {
                
                HSQShopCarGoodsTypeListModel *ThirdModel = SecondModel.SecondCartItemVoList[i];
                
                if (ThirdModel.IsSelect.integerValue == 0) // 没有被选中
                {
                    [self.SelectGoodsTypeCount_Array removeObject:ThirdModel];
                }
                else // 选中
                {
                    [self.SelectGoodsTypeCount_Array addObject:ThirdModel];
                }
            }
        }
    }
    
    // 商品的种类数
    NSString *TypeCountString = [NSString stringWithFormat:@"%ld",self.SelectGoodsTypeCount_Array.count];
    
    // 取出商品的总个数
    CGFloat TotalCount = 0;
    CGFloat TotalMonery = 0;
    for (HSQShopCarGoodsTypeListModel *ThirdModel in self.SelectGoodsTypeCount_Array) {
        
        TotalCount = TotalCount + ThirdModel.buyNum.floatValue;
        
        // 总的钱数
        TotalMonery = TotalMonery + ThirdModel.buyNum.floatValue * ThirdModel.appPrice0.floatValue;
    }
    
    NSString *TotalCountString = [NSString stringWithFormat:@"%.f",TotalCount];
    
    // 计算共有几种几件
    self.TypeCount = [NSString stringWithFormat:@"共%@种%@件",TypeCountString,TotalCountString];
    
    self.PriceString = [NSString stringWithFormat:@"¥%.2f",TotalMonery];
    
    // 合计的钱数
    self.TotalMonery_Label.text = [NSString stringWithFormat:@"合计   ¥%.2f",TotalMonery];
    
    // 判断商品有没有全部被选中
    [self JudgeWhetherTheGoodsAreAllChosen];
    
}

/**
 * @brief 判断是否含有优惠套装 （1–是 0–否）
 */
- (NSString *)DecideIfYouHaveASpecialPackage{
    
    NSMutableArray *array = [NSMutableArray array];
    
    for (HSQShopCarVCGoodsDataModel *FirstModel in self.dataSource) {
        
        if (FirstModel.cartStoreVoList.count != 0)
        {
            [array addObjectsFromArray:FirstModel.cartStoreVoList];
        }
    }
    
    if (array.count == 0)
    {
        return @"0";
    }
    else
    {
        return @"1";
    }
}

/**
 * @brief 生成提交订单界面的buyData数据
 */
- (NSString *)ShengChengSubmitOrderBuyData{
    
    HSQShopCarManger *manger = [HSQShopCarManger sharedShopCarManger];
    
    NSMutableArray *goods_array = [NSMutableArray array];
    
    for (HSQShopCarGoodsTypeListModel *ThirdModel in self.SelectGoodsTypeCount_Array) {
        
        NSDictionary *buyData_diction = @{@"buyNum":ThirdModel.buyNum,@"goodsId":ThirdModel.cartId};
        
        [goods_array addObject:buyData_diction];
        
    }
    
    return  [manger toJSONDataString:goods_array];
}

/**
 * @brief 判断商品是不是全部被选择
 */
- (void)JudgeWhetherTheGoodsAreAllChosen{
    
    for (HSQShopCarVCGoodsDataModel *FirstModel in self.dataSource) {
        
        if (FirstModel.IsSelect.integerValue == 1)
        {
            if (![self.SelectAllGoods_Array containsObject:FirstModel])
            {
                [self.SelectAllGoods_Array addObject:FirstModel];
            }
        }
        else
        {
            [self.SelectAllGoods_Array removeObject:FirstModel];
        }
    }
    
    if (self.SelectAllGoods_Array.count == self.dataSource.count) // 全部选中
    {
        [self.QuanXuan_Btn setSelected:YES];
        
        self.IsSelectAllGoods = @"1";
    }
    else
    {
        [self.QuanXuan_Btn setSelected:NO];
        
        self.IsSelectAllGoods = @"0";
    }
}


/**
 * @brief 购物车删除按钮的点击
 */
- (IBAction)ShopCarDeleteButtonClickAction:(UIButton *)sender {
    
    if (self.SelectGoodsTypeCount_Array.count == 0)
    {
        [[HSQProgressHUDManger Manger] ShowDisplayFailedToLoadData:@"请选择你要删除的商品" SuperView:self.view];
    }
    else
    {
        [[HSQProgressHUDManger Manger] ShowLoadingDataFromeServer:@"" ToView:self.view IsClearColor:YES];
        
        NSMutableArray *goods_array = [NSMutableArray array];
        
        for (HSQShopCarGoodsTypeListModel *ThirdModel in self.SelectGoodsTypeCount_Array) {
            
            [goods_array addObject:ThirdModel.cartId];
            
        }
        
        NSString *cartId = [goods_array componentsJoinedByString:@","];
        
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        
        HSQAccount *account = [HSQAccountTool account];
        
        if (account.token.length == 0)
        {
            // 购买的商品(sku)的goodsId 和 购买数量组成的json串
            NSString *cartData = [self ShengChengSubmitOrderBuyData];
            params[@"cartData"] = cartData;
            params[@"token"] = @"";
            params[@"cartId"] = cartId;
        }
        else
        {
            params[@"token"] = account.token;
            params[@"cartId"] = cartId;
        }
        
        HSQLog(@"===删除数据==%@",params);
        
        AFNetworkRequestTool *requestTool = [AFNetworkRequestTool shareRequestTool];
    
        [requestTool.manger POST:UrlAdress(KDeteleShopCarGoodsUrl) parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
    
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
    
            [[HSQProgressHUDManger Manger] DismissProgressHUD];
    
            HSQLog(@"=删除购物车数据==%@",responseObject);
            if ([responseObject[@"code"] integerValue] == 200)
            {
                [self RequestShopCarListDataFromeServer];
            }
            else
            {
                NSString *errorString = [NSString stringWithFormat:@"%@",responseObject[@"datas"][@"error"]];
                
                [[HSQProgressHUDManger Manger] ShowDisplayFailedToLoadData:errorString SuperView:self.view];
            }
    
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    
            [[HSQProgressHUDManger Manger] ShowProgressHUDPromptText:@"网络出问题啦！" SupView:self.view];
        }];
    }
    

}
























@end
