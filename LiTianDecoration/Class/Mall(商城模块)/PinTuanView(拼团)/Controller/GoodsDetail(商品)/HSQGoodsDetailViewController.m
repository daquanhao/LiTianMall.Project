//
//  HSQGoodsDetailViewController.m
//  LiTianDecoration
//
//  Created by administrator on 2018/5/9.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import "HSQGoodsDetailViewController.h"
#import "HSQGoodsDetailHeadCell.h"
#import "HSQPinTuanGoodsDetailHomeCell.h"
#import "HSQPublicAdressView.h"
#import "HSQGuiGeAndCouperView.h"
#import "HSQGoodsDetailRateHeadView.h"
#import "HSQGoodsDetailFooterView.h"
#import "HSQStoreHeadIntroCell.h"
#import "HSQRecommendGoodslListCell.h"
#import "HSQContactTheMerchantController.h"
#import "HSQStoreDetailViewController.h"
#import "HSQGoodsRateListModel.h"
#import "HSQGoodsDetailRateListCell.h"

@interface HSQGoodsDetailViewController ()<UITableViewDelegate,UITableViewDataSource,HSQPinTuanGoodsDetailHomeCellDelegate,HSQGuiGeAndCouperViewDelegate,HSQRecommendGoodslListCellDelegate,HSQStoreHeadIntroCellDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSDictionary *TuiJianDiction; // 为你推荐的数据

@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation HSQGoodsDetailViewController

-(NSMutableArray *)dataSource{
    
    if (_dataSource == nil) {
        
        self.dataSource = [NSMutableArray array];
    }
    
    return _dataSource;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.view.backgroundColor = KViewBackGroupColor;
    
    self.TuiJianDiction = [NSDictionary dictionary];
    
    // 1.创建tableView
    [self SetUpTableView];
    
    // 2.请求为你推荐的数据
    [self RequestTheDataYouRecommend];
}

/**
 * @brief 请求为你推荐的数据
 */
- (void)RequestTheDataYouRecommend{
    
    NSDictionary *diction = @{@"commonId":self.commonId};
    
    AFNetworkRequestTool *RequestTool = [AFNetworkRequestTool shareRequestTool];
    
    [RequestTool.manger POST:UrlAdress(KWeiNiTuiJianGoodsUrl) parameters:diction progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        HSQLog(@"=为你推荐=%@",responseObject);
        
        if ([responseObject[@"code"] integerValue] == 200)
        {
            self.TuiJianDiction = responseObject[@"datas"];
        }
        
        [self.tableView reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

/**
 * @brief 创建tableView
 */
- (void)SetUpTableView{
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - KSafeTopeHeight - KSafeBottomHeight - 50) style:(UITableViewStyleGrouped)];
    
    tableView.backgroundColor = [UIColor clearColor];
    
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    tableView.delegate = self;
    
    tableView.dataSource = self;
    
    [tableView registerClass:[HSQGoodsDetailHeadCell class] forCellReuseIdentifier:@"HSQGoodsDetailHeadCell"];
    
    [tableView registerClass:[HSQGoodsDetailRateListCell class] forCellReuseIdentifier:@"HSQGoodsDetailRateListCell"];
    
    [tableView registerClass:[HSQRecommendGoodslListCell class] forCellReuseIdentifier:@"HSQRecommendGoodslListCell"];
    
    [tableView registerNib:[UINib nibWithNibName:@"HSQStoreHeadIntroCell" bundle:nil] forCellReuseIdentifier:@"HSQStoreHeadIntroCell"];
    
    [tableView registerNib:[UINib nibWithNibName:@"HSQPinTuanGoodsDetailHomeCell" bundle:nil] forCellReuseIdentifier:@"HSQPinTuanGoodsDetailHomeCell"];
    
    [tableView registerClass:[HSQGoodsDetailRateHeadView class] forHeaderFooterViewReuseIdentifier:@"HSQGoodsDetailRateHeadView"];
    
    [tableView registerClass:[HSQGoodsDetailFooterView class] forHeaderFooterViewReuseIdentifier:@"HSQGoodsDetailFooterView"];
    
    [self.view addSubview:tableView];
    
    self.tableView = tableView;
}

/**
 * @brief 接收上一个界面的数据
 */
- (void)setGoodsDetailDict:(NSDictionary *)GoodsDetailDict{
    
    _GoodsDetailDict = GoodsDetailDict;
    
    self.dataSource = [HSQGoodsRateListModel mj_objectArrayWithKeyValuesArray:GoodsDetailDict[@"evaluateGoodsVoList"]];
        
    [self.tableView reloadData];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate,UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 2)
    {
        return (self.dataSource.count > 2 ? 2: self.dataSource.count);
    }
    else
    {
        return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return KScreenWidth;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) // 头部的商品介绍图片
    {
        CGSize TextHeight = [NSString SizeOfTheText:self.GoodsDetailDict[@"groupGoodsDetailVo"][@"goodsName"] font:[UIFont systemFontOfSize:14.0] MaxSize:CGSizeMake(KScreenWidth - 20, MAXFLOAT)];
        
        CGSize DescribeTextHeight = [NSString SizeOfTheText:self.GoodsDetailDict[@"groupGoodsDetailVo"][@"jingle"] font:[UIFont systemFontOfSize:14.0] MaxSize:CGSizeMake(KScreenWidth - 20, MAXFLOAT)];
        
        return KScreenWidth + 50 + TextHeight.height + DescribeTextHeight.height + 30;
    }
    else if (indexPath.section == 1) // 商品的优惠券，规格等
    {
        return 305;
    }
    else if (indexPath.section == 2) // 评论的cell的高度
    {
        HSQGoodsRateListModel *model = self.dataSource[indexPath.row];
        
        return model.CellHeight;
    }
    else if (indexPath.section == 3) // 店铺的介绍
    {
        return 200;
    }
    else
    {
        NSArray *array = self.TuiJianDiction[@"goodsCombo"][@"goodsVo"][@"goodsList"];
        if (array.count > 3)
        {
             return KScreenWidth + 70; // 为你推荐
        }
        else if (array.count > 0)
        {
             return KScreenWidth/2 + 70; // 为你推荐
        }
        else
        {
            return 0;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section == 2)
    {
         return 50;
    }
    else
    {
         return 0;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    HSQGoodsDetailRateHeadView *headView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"HSQGoodsDetailRateHeadView"];
    
    headView.DataDiction = self.GoodsDetailDict;
    
    return headView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    if (section == 2)
    {
        return 70;
    }
    else
    {
        return 0;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    HSQGoodsDetailFooterView *footerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"HSQGoodsDetailFooterView"];
    
    return footerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) // 商品的头部轮播图片
    {
        HSQGoodsDetailHeadCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HSQGoodsDetailHeadCell" forIndexPath:indexPath];
        
        if (self.GoodsDetailDict.allKeys.count != 0)
        {
            cell.dataDiction = self.GoodsDetailDict;
        }
        
        return cell;
    }
    else if (indexPath.section == 1)  // 商品的规格，优惠券
    {
        HSQPinTuanGoodsDetailHomeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HSQPinTuanGoodsDetailHomeCell" forIndexPath:indexPath];
        
        if (self.GoodsDetailDict.allKeys.count != 0)
        {
            cell.DataDiction = self.GoodsDetailDict;
        }
        
        cell.delegate = self;
        
        return cell;
    }
    else if (indexPath.section == 2)  // 评论的cell
    {
        HSQGoodsDetailRateListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HSQGoodsDetailRateListCell" forIndexPath:indexPath];
        
        if (self.dataSource.count != 0)
        {
            cell.model = self.dataSource[indexPath.row];
        }
        
        return cell;
    }
    else if (indexPath.section == 3)  // 店铺的介绍
    {
        HSQStoreHeadIntroCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HSQStoreHeadIntroCell" forIndexPath:indexPath];
        
        if (self.GoodsDetailDict.allKeys.count != 0)
        {
            cell.DataDiction = self.GoodsDetailDict;
        }
        
        cell.delegate = self;
        
        return cell;
    }
    else  // 为你推荐
    {
        HSQRecommendGoodslListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HSQRecommendGoodslListCell" forIndexPath:indexPath];
        
        if (self.TuiJianDiction.allKeys.count != 0)
        {
            cell.DataSource = self.TuiJianDiction[@"goodsCombo"][@"goodsVo"][@"goodsList"];
        }
        
        cell.delegate = self;
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

/**
 * @brief 显示领券列表
 */
- (void)ShowTheCouponListClickAction:(UIButton *)sender{
    
    HSQGuiGeAndCouperView *GuiGeAndCouperView = [HSQGuiGeAndCouperView initGuiGeAndCouperView];
    
    GuiGeAndCouperView.placherString = @"适用优惠券";
    
    GuiGeAndCouperView.delegate = self;
    
    GuiGeAndCouperView.TypeString = @"100";
    
    [GuiGeAndCouperView ShowGuiGeAndCouperView];

}

/**
 * @brief 促销，显示满减优惠列表
 */
- (void)ShowAListOfDiscountsClickAction:(UIButton *)sender{
    
    HSQGuiGeAndCouperView *GuiGeAndCouperView = [HSQGuiGeAndCouperView initGuiGeAndCouperView];
    
    GuiGeAndCouperView.placherString = @"促销";
    
    GuiGeAndCouperView.delegate = self;
    
    GuiGeAndCouperView.TypeString = @"200";
    
    [GuiGeAndCouperView ShowGuiGeAndCouperView];
}

#pragma mark - 选择规格或者优惠券
-  (void)ChooseGuiGeAndCoupter:(NSIndexPath *)indexPath{
    
    HSQLog(@"===你点击了优惠券");
}

/**
 * @brief 显示商品的规格列表
 */
- (void)DisplaysAListOfSpecificationsForAProduct:(UIButton *)sender{
    
    
}

/**
 * @brief  选择配送的地址
 */
- (void)ChooseSendAdressClickAction:(UIButton *)sender{
    
    HSQPublicAdressView *adressView = [HSQPublicAdressView initAdressView];
    
    adressView.placherString = @"配送至";
    
    [adressView ShowAdressView];
    
    adressView.chooseFinish = ^(NSString *adress,NSString *ProvinceId, NSString *cityId, NSString *AreaId){
        
        HSQLog(@"===%@==%@===%@==%@",adress,ProvinceId,cityId,AreaId);
        
//        self.Area_TextField.text = adress;
//
//        self.ProvinceId = ProvinceId;
//
//        self.cityId = cityId;
//
//        self.AreaId = AreaId;
        
    };
}

/**
 * @brief 推荐商品的点击
 */
- (void)RecommendGoodslListButtonClickAction:(UIButton *)sender goodID:(NSString *)commonId{
    
    HSQLog(@"=为你推荐==%@",commonId);
}

/**
 * @brief 联系商家
 */
- (void)ContactTheMerchantButtonClickAction:(UIButton *)sender{
    
    HSQContactTheMerchantController *ContactTheMerchantVC = [[HSQContactTheMerchantController alloc] init];
    
    [self.navigationController pushViewController:ContactTheMerchantVC animated:YES];
}


/**
 * @brief 进入店铺
 */
- (void)EnterTheStoreButtonClickAction:(UIButton *)sender{
    
    HSQStoreDetailViewController *StoreDetailVC = [[HSQStoreDetailViewController alloc] init];
    
    [self.navigationController pushViewController:StoreDetailVC animated:YES];
}




@end
