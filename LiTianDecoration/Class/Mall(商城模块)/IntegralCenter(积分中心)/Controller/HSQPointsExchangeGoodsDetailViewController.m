//
//  HSQPointsExchangeGoodsDetailViewController.m
//  LiTianDecoration
//
//  Created by administrator on 2018/6/21.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import "HSQPointsExchangeGoodsDetailViewController.h"
#import "HSQPointCenterGoodsDetailBannerReusableView.h"
#import "HSQPointsExchangeGoodsListModel.h"
#import "HSQRecommendedGoodsListHeadReusableView.h"
#import "HSQPointGoodsDetailNameCell.h"
#import "HSQGoodsBodyListCell.h"
#import "HSQPointGoodsDetailHeadReusableView.h"
#import "HSQGoodsModelView.h"
#import "HSQAccountTool.h"
#import "HSQLoginHomeViewController.h"
#import "HSQSubmitPointExchangeGoodsViewController.h"

@interface HSQPointsExchangeGoodsDetailViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,HSQPointGoodsDetailNameCellDelegate,HSQGoodsModelViewDelegate,HSQRecommendedGoodsListHeadReusableViewDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSMutableArray *goodsImageList; // 商品图片列表

@property (nonatomic, strong) NSMutableArray *recommendList; // 热门推荐

@property (nonatomic, strong) NSMutableArray *mobileBodyVoList; // 商品的描述

@property (nonatomic, strong) NSDictionary *pointsGoodsDetailVo; // 商品的信息

@property (nonatomic, strong) NSDictionary *datasDiction;

@property (nonatomic, copy) NSString *goodsSpecString; // 商品的规格

@property (nonatomic, strong) UIButton *buy_button; // 我要购买按钮

@property (nonatomic, copy) NSString *pointsGoodsId; // 积分商品编号

@end

@implementation HSQPointsExchangeGoodsDetailViewController

-(NSMutableArray *)goodsImageList{
    
    if (_goodsImageList == nil) {
        
        self.goodsImageList = [NSMutableArray array];
    }
    
    return _goodsImageList;
}

-(NSMutableArray *)recommendList{
    
    if (_recommendList == nil) {
        
        self.recommendList = [NSMutableArray array];
    }
    
    return _recommendList;
}

-(NSMutableArray *)mobileBodyVoList{
    
    if (_mobileBodyVoList == nil) {
        
        self.mobileBodyVoList = [NSMutableArray array];
    }
    
    return _mobileBodyVoList;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.navigationItem.title = @"积分礼品";
    
    self.view.backgroundColor = KViewBackGroupColor;
    
    self.pointsGoodsDetailVo = [NSDictionary dictionary];
    
    self.datasDiction = [NSDictionary dictionary];
    
    // 创建集合视图
    [self CreatCollectionView];
    
    // 积分兑换商品详情的数据
    [self requestPointGoodsDetailrDataFromeserver];
}

/**
 * @brief  创建集合视图
 */
- (void)CreatCollectionView{
    
    UICollectionViewFlowLayout *Layout = [[UICollectionViewFlowLayout alloc] init];
    
    CGFloat collectionHeight = KScreenHeight - KSafeBottomHeight - KSafeTopeHeight - 44;
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, collectionHeight) collectionViewLayout:Layout];
    
    collectionView.backgroundColor = [UIColor clearColor];
    
    collectionView.dataSource = self;
    
    collectionView.delegate = self;
    
    collectionView.showsVerticalScrollIndicator = NO;
    
    collectionView.showsHorizontalScrollIndicator = NO;
    
    // 头部的轮播
    [collectionView registerClass:[HSQPointCenterGoodsDetailBannerReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HSQPointCenterGoodsDetailBannerReusableView"];
    
    // 分区的标题
    UINib *PointGoodsDetailHead = [UINib nibWithNibName:@"HSQPointGoodsDetailHeadReusableView" bundle:nil];
    [collectionView registerNib:PointGoodsDetailHead forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HSQPointGoodsDetailHeadReusableView"];
    
    // 礼品的详情
    [collectionView registerNib:[UINib nibWithNibName:@"HSQGoodsBodyListCell" bundle:nil] forCellWithReuseIdentifier:@"HSQGoodsBodyListCell"];
    
    // 商品的推荐
    [collectionView registerClass:[HSQRecommendedGoodsListHeadReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"HSQRecommendedGoodsListHeadReusableView"];

    [collectionView registerNib:[UINib nibWithNibName:@"HSQPointGoodsDetailNameCell" bundle:nil] forCellWithReuseIdentifier:@"HSQPointGoodsDetailNameCell"];
    
    [self.view addSubview:collectionView];
    
    [self.view sendSubviewToBack:collectionView];
    
    self.collectionView = collectionView;
    
    // 我要换购的按钮
    UIButton *buy_button = [UIButton buttonWithType:(UIButtonTypeSystem)];
    
    buy_button.backgroundColor = [UIColor orangeColor];
    
    [buy_button setTitle:@"我要换购" forState:(UIControlStateNormal)];
    
    [buy_button setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    
    buy_button.titleLabel.font = [UIFont systemFontOfSize:14.0];
    
    [buy_button addTarget:self action:@selector(buy_buttonClickAction:) forControlEvents:(UIControlEventTouchUpInside)];
    
    buy_button.frame = CGRectMake(0, CGRectGetMaxY(collectionView.frame), KScreenWidth, 44);
    
    [self.view addSubview:buy_button];
    
    self.buy_button = buy_button;
    
}


/**
 * @brief 积分兑换商品详情的数据
 */
- (void)requestPointGoodsDetailrDataFromeserver{

    [[HSQProgressHUDManger Manger] ShowLoadingDataFromeServer:nil ToView:self.view IsClearColor:YES];
    
    AFNetworkRequestTool *RequestTool = [AFNetworkRequestTool shareRequestTool];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",UrlAdress(KPointChangeGoodsDetailUrl),self.commonId];
    
    [RequestTool.manger GET:url parameters:nil progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *responseObject) {
        
//        HSQLog(@"=积分兑换商品的数据==%@",responseObject);
        
        [[HSQProgressHUDManger Manger] DismissProgressHUD];
        
        if ([responseObject[@"code"] integerValue] == 200)
        {
            self.datasDiction = responseObject[@"datas"];
            
            self.pointsGoodsId = [NSString stringWithFormat:@"%@",responseObject[@"datas"][@"pointsGoodsDetailVo"][@"pointsGoodsId"]];
            
            // 图片数组
            for (NSDictionary *diction in responseObject[@"datas"][@"pointsGoodsDetailVo"][@"goodsImageList"]) {
                
                [self.goodsImageList addObject:diction[@"imageSrc"]];
            }
            
            // 热门推荐
            self.recommendList = [HSQPointsExchangeGoodsListModel mj_objectArrayWithKeyValuesArray:responseObject[@"datas"][@"recommendList"]];
            
            // 商品的信息
            self.pointsGoodsDetailVo = responseObject[@"datas"][@"pointsGoodsDetailVo"];
            
            // 商品的描述
            self.mobileBodyVoList = responseObject[@"datas"][@"pointsGoodsDetailVo"][@"mobileBodyVoList"];
            
        }
        else
        {
            NSString *errorString = [NSString stringWithFormat:@"%@",responseObject[@"datas"][@"error"]];
            
            [[HSQProgressHUDManger Manger] ShowDisplayFailedToLoadData:errorString SuperView:self.view];
        }
        
        [self.collectionView reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [[HSQProgressHUDManger Manger] ShowDisplayFailedToLoadData:KErrorPlacherString SuperView:self.view];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionViewDelegate,UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 3;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    if (section == 0)
    {
        return 1;
    }
    else if (section == 2)
    {
         return self.mobileBodyVoList.count;
    }
    else
    {
        return 0;
    }
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    
    if (section == 0)
    {
        return CGSizeMake(KScreenWidth, KScreenWidth);
    }
    else if (section == 1)
    {
        return (self.recommendList.count == 0 ? CGSizeMake(KScreenWidth, 0) : CGSizeMake(KScreenWidth, 50));
    }
    else
    {
        return (self.mobileBodyVoList.count == 0 ? CGSizeMake(KScreenWidth, 0) : CGSizeMake(KScreenWidth, 50));
    }
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    
    if (section == 0)
    {
        return CGSizeMake(KScreenWidth, 0);
    }
    else if (section == 1)
    {
        return (self.recommendList.count == 0 ? CGSizeMake(KScreenWidth, 0) : CGSizeMake(KScreenWidth, ((KScreenWidth - 10) / 3 + 50) * 2 + 10));
    }
    else
    {
//        return (self.mobileBodyVoList.count == 0 ? CGSizeMake(KScreenWidth, 0) : CGSizeMake(KScreenWidth, 400));
        return CGSizeMake(KScreenWidth, 0);
    }
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionReusableView *reusableView = nil;
    
    if (kind == UICollectionElementKindSectionHeader)
    {
        if (indexPath.section == 0)
        {
            HSQPointCenterGoodsDetailBannerReusableView *headView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HSQPointCenterGoodsDetailBannerReusableView" forIndexPath:indexPath];
            
            headView.Banners = self.goodsImageList;
            
            reusableView = headView;
        }
        else
        {
            HSQPointGoodsDetailHeadReusableView *PointGoodsDetailHeadView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HSQPointGoodsDetailHeadReusableView" forIndexPath:indexPath];
            
            if (indexPath.section == 1)
            {
                PointGoodsDetailHeadView.Title_Label.text = @"热门推荐";
            }
            else
            {
                PointGoodsDetailHeadView.Title_Label.text = @"礼品详情";
            }
            
            reusableView = PointGoodsDetailHeadView;
        }
    }
    
    if (kind == UICollectionElementKindSectionFooter)
    {
        HSQRecommendedGoodsListHeadReusableView *RecommendedGoodsListHeadView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"HSQRecommendedGoodsListHeadReusableView" forIndexPath:indexPath];
        
        RecommendedGoodsListHeadView.dataSource = self.recommendList;
        
        RecommendedGoodsListHeadView.delegate = self;
        
        reusableView = RecommendedGoodsListHeadView;
    }
    
    return reusableView;
    
    return reusableView;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0)
    {
        // 商品的名字
        NSString *goodsName = [NSString stringWithFormat:@"%@",self.pointsGoodsDetailVo[@"goodsName"]];
        CGSize goodsNameSize = [NSString SizeOfTheText:goodsName font:[UIFont systemFontOfSize:14.0] MaxSize:CGSizeMake(KScreenWidth - 20, MAXFLOAT)];
        
        // 商品的买点
        NSString *jingle = [NSString stringWithFormat:@"%@",self.pointsGoodsDetailVo[@"jingle"]];
        CGSize jingleSize = [NSString SizeOfTheText:jingle font:[UIFont systemFontOfSize:12.0] MaxSize:CGSizeMake(KScreenWidth - 20, MAXFLOAT)];
        
        return CGSizeMake(KScreenWidth, 50 + 1 + 10 + goodsNameSize.height + 5 + jingleSize.height + 10 + 60);
    }
    else
    {
        return CGSizeMake(KScreenWidth, KScreenWidth * 1.5);
    }
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0)
    {
        HSQPointGoodsDetailNameCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HSQPointGoodsDetailNameCell" forIndexPath:indexPath];
        
        cell.pointsGoodsDetailVo = self.pointsGoodsDetailVo;
        
        cell.delegate = self;
        
        if (self.goodsSpecString.length == 0)
        {
            // 规格
            NSArray *goodsList = self.pointsGoodsDetailVo[@"goodsList"];
            
            NSDictionary *diction = goodsList.firstObject;
            
            cell.goodsSpecs_Label.text = [NSString stringWithFormat:@"%@",diction[@"goodsSpecString"]];
        }
        else
        {
            cell.goodsSpecs_Label.text = [NSString stringWithFormat:@"%@",self.goodsSpecString];
        }
        
        return cell;
    }
    else
    {
        
        HSQGoodsBodyListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HSQGoodsBodyListCell" forIndexPath:indexPath];
        
        NSDictionary *diction = self.mobileBodyVoList[indexPath.row];
        
        NSString *type = [NSString stringWithFormat:@"%@",diction[@"type"]];
        
        if ([type isEqualToString:@"image"])
        {
            [cell.GoodsImageView sd_setImageWithURL:[NSURL URLWithString:diction[@"value"]] placeholderImage:KGoodsPlacherImage];
        }
        
        return cell;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    

    
}

/**
 * @brief 我要换购的按钮的点击
 */
- (void)buy_buttonClickAction:(UIButton *)sender{
    
    HSQGoodsModelView *GuiGeAndCouperView = [HSQGoodsModelView initGoodsModelView];
    
    GuiGeAndCouperView.TypeString = @"300";
    
    GuiGeAndCouperView.PointDatasDiction = self.datasDiction;
    
    GuiGeAndCouperView.delegate = self;
    
    [GuiGeAndCouperView ShowGoodsModelAndPriceView];
}

/**
 * @brief 选择商品的规格
 */
- (void)ChooseTheSpecificationsOfTheGoods:(UIButton *)sender{
    
    HSQGoodsModelView *GuiGeAndCouperView = [HSQGoodsModelView initGoodsModelView];
    
    GuiGeAndCouperView.TypeString = @"300";
    
    GuiGeAndCouperView.PointDatasDiction = self.datasDiction;
    
    GuiGeAndCouperView.delegate = self;
    
    [GuiGeAndCouperView ShowGoodsModelAndPriceView];
}

/**
 * @brief 商品的规格及数量选好的回调
 */
-(void)hsqGoodsModelViewBottomBtnClickActionWithGoodsCount:(NSString *)Count Type:(NSString *)typeString goods_id:(NSString *)goodsId GoodsKunCun:(NSString *)goodsStorage goodsSpecString:(NSString *)goodsSpecString{
    
    HSQLog(@"==选好的商品个数==%@==%@==%@==%@",Count,typeString,goodsId,goodsSpecString);
    
    self.goodsSpecString = goodsSpecString;
    
    [self.collectionView reloadData];
    
    if (typeString.integerValue == 300) // 积分换购
    {
        // 判断用户是否登录
        NSString *token = [HSQAccountTool account].token;
        
        if (token.length == 0)
        {
            HSQLoginHomeViewController *LoginVC = [[HSQLoginHomeViewController alloc] init];
            
            [self.navigationController pushViewController:LoginVC animated:YES];
        }
        else
        {
            NSMutableDictionary *params = [NSMutableDictionary dictionary];
            
            params[@"token"] = token;
            
            params[@"goodsId"] = goodsId;
            
            params[@"buyNum"] = Count;
            
            params[@"pointsGoodsId"] = self.pointsGoodsId; // 积分商品编号
            
            HSQLog(@"===%@",params);
            
            AFNetworkRequestTool *requestTool = [AFNetworkRequestTool shareRequestTool];

            [requestTool.manger POST:UrlAdress(KPointGoodsBuyUrl) parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {

            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

                HSQLog(@"===积分兑换商品数据===%@",responseObject);

                if ([responseObject[@"code"] integerValue] == 200)
                {
                    HSQSubmitPointExchangeGoodsViewController *SubmitPointExchangeGoodsVC = [[HSQSubmitPointExchangeGoodsViewController alloc] init];
                    
                    SubmitPointExchangeGoodsVC.datas = responseObject[@"datas"];
                    
                    [self.navigationController pushViewController:SubmitPointExchangeGoodsVC animated:YES];
                }
                else
                {
                    NSString *errorString = [NSString stringWithFormat:@"%@",responseObject[@"datas"][@"error"]];

                    [[HSQProgressHUDManger Manger] ShowDisplayFailedToLoadData:errorString SuperView:self.view];
                }

            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {

                // 提示数据请求失败
                [[HSQProgressHUDManger Manger] ShowProgressHUDPromptText:KErrorPlacherString SupView:self.view];

            }];
        }
    }
}

/**
 * @brief 热门推荐商品的点击
 */
- (void)ClickEventsForRecommendationItems:(UIButton *)sender{
    
    HSQPointsExchangeGoodsListModel *model = self.recommendList[sender.tag];
        
    HSQPointsExchangeGoodsDetailViewController *PointsExchangeGoodsDetailVC  = [[HSQPointsExchangeGoodsDetailViewController alloc] init];
    
    PointsExchangeGoodsDetailVC.commonId = model.commonId;
    
    [self.navigationController pushViewController:PointsExchangeGoodsDetailVC animated:YES];
}



@end
