//
//  HSQMySelectionBankHomeViewController.m
//  LiTianDecoration
//
//  Created by administrator on 2018/6/13.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import "HSQMySelectionBankHomeViewController.h"
#import "HSQSelectTheInventoryListViewController.h"
#import "HSQAddSelectionLibraryViewController.h"
#import "HSQChooseproductlibraryFooterView.h"
#import "HSQChooseproductlibraryHeadView.h"
#import "HSQChooseProductionGoodsListCell.h"
#import "HSQCommissionHomeViewController.h"
#import "HSQSelectionListModel.h"
#import "HSQAccountTool.h"
#import "HSQPromoteOrderHomeViewController.h"

@interface HSQMySelectionBankHomeViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,HSQChooseproductlibraryHeadViewDelegate,HSQChooseproductlibraryFooterViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *GoodsCount_Button;

@property (weak, nonatomic) IBOutlet UIButton *OrderCount_Button;

@property (weak, nonatomic) IBOutlet UIButton *Monery_Button;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *BottomMargin;

@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, copy) NSString *payCommission;  // 佣金金额

@end

@implementation HSQMySelectionBankHomeViewController

-(NSMutableArray *)dataSource{
    
    if (_dataSource == nil) {
        
        self.dataSource = [NSMutableArray array];
    }
    
    return _dataSource;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.view.backgroundColor = KViewBackGroupColor;
    
    self.navigationItem.title = @"推广分佣";
    
    self.BottomMargin.constant = KSafeBottomHeight;
    
    self.GoodsCount_Button.titleLabel.numberOfLines = self.OrderCount_Button.titleLabel.numberOfLines = self.Monery_Button.titleLabel.numberOfLines = 0;
    
    self.GoodsCount_Button.titleLabel.textAlignment = self.OrderCount_Button.titleLabel.textAlignment = self.Monery_Button.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    // 创建集合视图
    [self CreatCollectionViewToView];
    
    // 获取推广会员的信息
    [self GetTheInformationOfPromotionMembers];
    
    // 获取选品库分组列表
    [self GetTheListOfSelectedRepositoryGroups];
    
    // 监听商品的移动
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(MoveGoodsToOtherGroupNotif:) name:@"MoveGoodsToOtherGroupNotif" object:nil];
}

/**
 * @brief 创建集合视图
 */
- (void)CreatCollectionViewToView{
    
    UICollectionViewFlowLayout *Layout = [[UICollectionViewFlowLayout alloc] init];
    
    Layout.minimumLineSpacing = 1;  // 最小的行间距
    
    Layout.minimumInteritemSpacing = 0; // 最小的列间距
    
    CGFloat collectionHeight = KScreenHeight - KSafeBottomHeight - KSafeTopeHeight - 50 - 50;
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 50, KScreenWidth, collectionHeight) collectionViewLayout:Layout];
    
    collectionView.backgroundColor = [UIColor clearColor];
    
    collectionView.showsVerticalScrollIndicator = NO;
    
    collectionView.showsHorizontalScrollIndicator = NO;
    
    collectionView.dataSource = self;
    
    collectionView.delegate = self;
    
    [collectionView registerClass:[HSQChooseproductlibraryHeadView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HSQChooseproductlibraryHeadView"];
    
    [collectionView registerClass:[HSQChooseproductlibraryFooterView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"HSQChooseproductlibraryFooterView"];
    
    [collectionView registerClass:[HSQChooseProductionGoodsListCell class] forCellWithReuseIdentifier:@"HSQChooseProductionGoodsListCell"];
    
    [self.view addSubview:collectionView];
    
    [self.view sendSubviewToBack:collectionView];
    
    self.collectionView = collectionView;
}

/**
 * @brief 获取选品库分组列表
 */
- (void)GetTheListOfSelectedRepositoryGroups{
        
    [[HSQProgressHUDManger Manger] ShowLoadingDataFromeServer:@"" ToView:self.view IsClearColor:YES];
    
    NSDictionary *params = @{@"token":[HSQAccountTool account].token};
    
    AFNetworkRequestTool *requestTool = [AFNetworkRequestTool shareRequestTool];
    
    [requestTool.manger POST:UrlAdress(KGetsListofSelectedGroupsUrl) parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [[HSQProgressHUDManger Manger] DismissProgressHUD];
        
        if ([responseObject[@"code"] integerValue] == 200){
            
            // 中间的规格列表
            for (NSDictionary *dict in responseObject[@"datas"][@"favList"]){
                
                // 外层数据 有多少个店铺
                HSQSelectionListModel *SelectionListModel = [[HSQSelectionListModel alloc] initWithDictionary:dict error:nil];
                
                SelectionListModel.distributionGoodsVoList = [NSMutableArray array];

                [self.dataSource addObject:SelectionListModel];
                
                // 内层数据 每个店铺有几个商品
                for (NSInteger i = 0; i < [dict[@"distributionGoodsVoList"] count] ; i++) {
                    
                    NSDictionary *ModelDiction = dict[@"distributionGoodsVoList"][i];
                    
                    HSQSelectionGoodsListModel *GoodsListModel = [[HSQSelectionGoodsListModel alloc] init];
                    
                    [GoodsListModel setValuesForKeysWithDictionary:ModelDiction];
                    
                    [SelectionListModel.distributionGoodsVoList addObject:GoodsListModel];
   
                }
            }
            
            [self.collectionView reloadData];
        }
        else
        {
            NSString *errorString = [NSString stringWithFormat:@"%@",responseObject[@"datas"][@"error"]];
            
            [[HSQProgressHUDManger Manger] ShowDisplayFailedToLoadData:errorString SuperView:self.view];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [[HSQProgressHUDManger Manger] ShowProgressHUDPromptText:KErrorPlacherString SupView:self.view];
        
    }];
}

/**
 * @brief 获取推广会员的信息
 */
- (void)GetTheInformationOfPromotionMembers{
    
    [[HSQProgressHUDManger Manger] ShowLoadingDataFromeServer:@"" ToView:self.view IsClearColor:YES];
    
    NSDictionary *params = @{@"token":[HSQAccountTool account].token};
    
    AFNetworkRequestTool *requestTool = [AFNetworkRequestTool shareRequestTool];
    
    [requestTool.manger POST:UrlAdress(KGetPromotionMemberInformationUrl) parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [[HSQProgressHUDManger Manger] DismissProgressHUD];
        
        if ([responseObject[@"code"] integerValue] == 200)
        {
            // 推广商品的数量
            [self.GoodsCount_Button setTitle:[NSString stringWithFormat:@"%@种\n推广商品",responseObject[@"datas"][@"distributorGoodsCount"]] forState:(UIControlStateNormal)];
            
            // 推广订单的数量
            [self.OrderCount_Button setTitle:[NSString stringWithFormat:@"%@笔\n推广订单",responseObject[@"datas"][@"distributorOrdersCount"]] forState:(UIControlStateNormal)];
            
            // 佣金金额
            NSString *payCommission = [NSString stringWithFormat:@"%@",responseObject[@"datas"][@"distributor"][@"commissionAvailable"]];
            
            self.payCommission = payCommission;
            
            [self.Monery_Button setTitle:[NSString stringWithFormat:@"¥%.2f\n佣金金额",payCommission.floatValue] forState:(UIControlStateNormal)];
        }
        else
        {
            NSString *errorString = [NSString stringWithFormat:@"%@",responseObject[@"datas"][@"error"]];
            
            [[HSQProgressHUDManger Manger] ShowDisplayFailedToLoadData:errorString SuperView:self.view];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [[HSQProgressHUDManger Manger] ShowProgressHUDPromptText:KErrorPlacherString SupView:self.view];
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionViewDelegate,UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{

    return self.dataSource.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    HSQSelectionListModel *model = self.dataSource[section];
    
    return model.distributionGoodsVoList.count;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    
    return CGSizeMake(KScreenWidth, 55);
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    
    HSQSelectionListModel *model = self.dataSource[section];
    
    if (model.isDefault.integerValue == 1) // 默认文件夹
    {
        return CGSizeMake(KScreenWidth, 0);
    }
    else
    {
        return CGSizeMake(KScreenWidth, 50);
    }
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionReusableView *reusableView = nil;
    
    if (kind == UICollectionElementKindSectionHeader)
    {
        HSQChooseproductlibraryHeadView *headReusableView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HSQChooseproductlibraryHeadView" forIndexPath:indexPath];
        
        headReusableView.model = self.dataSource[indexPath.section];
        
        headReusableView.delegate = self;
        
        headReusableView.section = indexPath.section;
        
        reusableView = headReusableView;
        
    }
    
    if (kind == UICollectionElementKindSectionFooter)
    {
        HSQChooseproductlibraryFooterView *FooterReusableView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"HSQChooseproductlibraryFooterView" forIndexPath:indexPath];
        
        FooterReusableView.section = indexPath.section;
        
        FooterReusableView.delegate = self;
        
        reusableView = FooterReusableView;
    }
    
    return reusableView;
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake((KScreenWidth - 5) / 6 , (KScreenWidth - 5) / 6);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    HSQChooseProductionGoodsListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HSQChooseProductionGoodsListCell" forIndexPath:indexPath];
    
    HSQSelectionListModel *ListModel = self.dataSource[indexPath.section];
    
    HSQSelectionGoodsListModel *GoodsListModel = ListModel.distributionGoodsVoList[indexPath.row];
    
    cell.model = GoodsListModel;
    
    return cell;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    HSQSelectionListModel *model = self.dataSource[indexPath.section];
    
    HSQSelectTheInventoryListViewController *SelectTheInventoryListVC = [[HSQSelectTheInventoryListViewController alloc] init];
    
    SelectTheInventoryListVC.distributorFavoritesId = model.distributorFavoritesId;
    
    SelectTheInventoryListVC.Navtion_title = model.distributorFavoritesName;
    
    [self.navigationController pushViewController:SelectTheInventoryListVC animated:YES];
}

/**
 * @brief 进入分组详情
 */
- (void)DetailsOfAccessToTheSelectiveLibrary:(UIButton *)sender{
    
    HSQChooseproductlibraryHeadView *HeadView = (HSQChooseproductlibraryHeadView *)sender.superview.superview;
    
    HSQSelectionListModel *model = self.dataSource[HeadView.section];
    
    HSQSelectTheInventoryListViewController *SelectTheInventoryListVC = [[HSQSelectTheInventoryListViewController alloc] init];
    
    SelectTheInventoryListVC.distributorFavoritesId = model.distributorFavoritesId;
    
    SelectTheInventoryListVC.Navtion_title = model.distributorFavoritesName;
    
    [self.navigationController pushViewController:SelectTheInventoryListVC animated:YES];
}

/**
 * @brief 删除 KDeteleSelectLibraryUrl
 */
- (void)DeleteTheClickEventOfTheSelectedRepository:(UIButton *)sender{
    
    HSQChooseproductlibraryFooterView *footerView = (HSQChooseproductlibraryFooterView *)sender.superview.superview;
    
    HSQSelectionListModel *model = self.dataSource[footerView.section];
    
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:@"删除分组将移除其中商品确认删除吗？" preferredStyle:(UIAlertControllerStyleAlert)];
    
    UIAlertAction *action01 = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:nil];
    
    UIAlertAction *action02 = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        
        [[HSQProgressHUDManger Manger] ShowLoadingDataFromeServer:@"" ToView:self.view IsClearColor:YES];
        
        NSDictionary *params = @{@"token":[HSQAccountTool account].token,@"distributorFavoritesId":model.distributorFavoritesId};
        
        AFNetworkRequestTool *requestTool = [AFNetworkRequestTool shareRequestTool];
        
        [requestTool.manger POST:UrlAdress(KDeteleSelectLibraryUrl) parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            [[HSQProgressHUDManger Manger] DismissProgressHUD];
                        
            if ([responseObject[@"code"] integerValue] == 200)
            {
                [self.dataSource removeObject:model];
  
                [self.collectionView reloadData];
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
    
    [alertVC addAction:action01];
    
    [alertVC addAction:action02];
    
    [self presentViewController:alertVC animated:YES completion:nil];

}

/**
 * @brief 编辑
 */
- (void)EditTheClickEventsForTheRepository:(UIButton *)sender{
    
    HSQChooseproductlibraryFooterView *footerView = (HSQChooseproductlibraryFooterView *)sender.superview.superview;
    
    HSQSelectionListModel *model = self.dataSource[footerView.section];
    
    HSQAddSelectionLibraryViewController *AddSelectionLibraryVC = [[HSQAddSelectionLibraryViewController alloc] init];
    
    AddSelectionLibraryVC.distributorFavoritesName = model.distributorFavoritesName;
    
    AddSelectionLibraryVC.distributorFavoritesId = model.distributorFavoritesId;
    
    AddSelectionLibraryVC.source = 200;
    
    AddSelectionLibraryVC.TheCallbackNameBlock = ^(NSString *NewName) {
        
        model.distributorFavoritesName = NewName;
        
        [self.collectionView reloadData];
    };
    
    [self.navigationController pushViewController:AddSelectionLibraryVC animated:YES];
}

/**
 * @brief 新增
 */
- (IBAction)NewCommodityWarehouseGroupingBtnClickAction:(UIButton *)sender {
    
    HSQAddSelectionLibraryViewController *AddSelectionLibraryVC = [[HSQAddSelectionLibraryViewController alloc] init];
    
    AddSelectionLibraryVC.source = 100;
    
    AddSelectionLibraryVC.TheCallbackNameBlock = ^(NSString *NewName) {
        
        [self.dataSource removeAllObjects];
        
        [self GetTheListOfSelectedRepositoryGroups];
    };
    
    [self.navigationController pushViewController:AddSelectionLibraryVC animated:YES];
}

/**
 * @brief 监听商品的移动
 */
- (void)MoveGoodsToOtherGroupNotif:(NSNotification *)notif{
    
    // 获取选品库分组列表
    [self GetTheListOfSelectedRepositoryGroups];
}

/**
 * @brief 佣金金额
 */
- (IBAction)LookUpTheAmountOfCommission:(UIButton *)sender {
    
    HSQCommissionHomeViewController *CommissionHomeVC = [[HSQCommissionHomeViewController alloc] init];
        
    [self.navigationController pushViewController:CommissionHomeVC animated:YES];
}

/**
 * @brief 查看推广订单
 */
- (IBAction)ViewPromotionOrdersListBtnClickAction:(UIButton *)sender {
    
    HSQPromoteOrderHomeViewController *PromoteOrderHomeVC = [[HSQPromoteOrderHomeViewController alloc] init];
    
    [self.navigationController pushViewController:PromoteOrderHomeVC animated:YES];
}
































/**
 * @brief 移除消息
 */
- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
