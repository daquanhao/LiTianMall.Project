//
//  HSQSelectTheInventoryListViewController.m
//  LiTianDecoration
//
//  Created by administrator on 2018/6/14.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import "HSQSelectTheInventoryListViewController.h"
#import "HSQStoreDetailViewController.h"
#import "HSQSelectGroupGoodsListFooterView.h"
#import "HSQSelectGroupGoodsListHeadView.h"
#import "HSQSelectGroupGoodsListCell.h"
#import "HSQGoodsDataListModel.h"
#import "HSQAccountTool.h"
#import "HSQMobilePromotionProductsView.h"

#import <UShareUI/UShareUI.h>

#import "HSQQRCodeShareView.h" // 二维码分享视图

@interface HSQSelectTheInventoryListViewController ()<UITableViewDelegate,UITableViewDataSource,HSQSelectGroupGoodsListHeadViewDelegate,HSQSelectGroupGoodsListFooterViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, assign) NSInteger currentPage; // 当前的页数

@property (nonatomic, strong) HSQNoDataView *noDataView;

@property (nonatomic, copy) NSString *totalPage; // 总页数

@end

@implementation HSQSelectTheInventoryListViewController

-(NSMutableArray *)dataSource{
    
    if (_dataSource == nil) {
        
        self.dataSource = [NSMutableArray array];
    }
    
    return _dataSource;
}

- (HSQNoDataView *)noDataView{
    
    if (!_noDataView) {
        
        _noDataView = [[HSQNoDataView alloc] initWithTitle:@"亲，您还没有推广商品哦~" imageName:@"WaitingForView" height:50 TopMargin:0];
    }
    return _noDataView;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.view.backgroundColor = KViewBackGroupColor;
    
    self.navigationItem.title = self.Navtion_title;
    
    // 创建tableView
    [self CreatTableView];
    
    // 获取选品库分组的详细信息
    [self AddTableViewRefreshControls];
}

/**
 * @brief 创建tableView
 */
- (void)CreatTableView{
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - KSafeTopeHeight - KSafeBottomHeight) style:(UITableViewStyleGrouped)];
    
    tableView.backgroundColor = [UIColor clearColor];
    
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    tableView.delegate = self;
    
    tableView.dataSource = self;
    
    [tableView registerClass:[HSQSelectGroupGoodsListCell class] forCellReuseIdentifier:@"HSQSelectGroupGoodsListCell"];
    
    [tableView registerClass:[HSQSelectGroupGoodsListFooterView class] forHeaderFooterViewReuseIdentifier:@"HSQSelectGroupGoodsListFooterView"];
    
    [tableView registerClass:[HSQSelectGroupGoodsListHeadView class] forHeaderFooterViewReuseIdentifier:@"HSQSelectGroupGoodsListHeadView"];
    
    [self.view addSubview:tableView];
    
    self.tableView = tableView;
}

/**
 * @brief 添加刷新控件
 */
- (void)AddTableViewRefreshControls{
    
    // 1.下拉加载更多的数据
    self.tableView.mj_header  = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(LoadNewSelectGroupGoodsListData)];
    
    [self.tableView.mj_header beginRefreshing];
    
    // 3.上啦加载更多的代码
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(LoadMoreSelectGroupGoodsListData)];
}

/**
 * @brief 加载最新的选品库商品列表
 */
- (void)LoadNewSelectGroupGoodsListData{
    
    [[HSQProgressHUDManger Manger] ShowLoadingDataFromeServer:@"" ToView:self.view IsClearColor:YES];
    
    // 0.清空数组
    [self.dataSource removeAllObjects];
    
    // 结束上啦
    [self.tableView.mj_footer endRefreshing];
    
    self.currentPage = 1;
    
    NSDictionary *params = @{@"token":[HSQAccountTool account].token,@"favId":self.distributorFavoritesId,@"page":@(self.currentPage)};
    
    AFNetworkRequestTool *requestTool = [AFNetworkRequestTool shareRequestTool];
    
    [requestTool.manger POST:UrlAdress(KselectionBankGroupGoodsListUrl) parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [[HSQProgressHUDManger Manger] DismissProgressHUD];
        
        HSQLog(@"===获取选品库分组的详细信息==%@",responseObject);
        
        self.totalPage = [NSString stringWithFormat:@"%@",responseObject[@"datas"][@"pageEntity"][@"totalPage"]];
        
        if ([responseObject[@"code"] integerValue] == 200)
        {
            self.dataSource = [HSQGoodsDataListModel mj_objectArrayWithKeyValuesArray:responseObject[@"datas"][@"distributorGoodsList"]];

        }
        else
        {
            NSString *errorString = [NSString stringWithFormat:@"%@",responseObject[@"datas"][@"error"]];
            
            [[HSQProgressHUDManger Manger] ShowDisplayFailedToLoadData:errorString SuperView:self.view];
        }
        
        [self.tableView.mj_header endRefreshing];
        
        [self.tableView reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        // 结束刷新
        [self.tableView.mj_header endRefreshing];
        
        [self.tableView addSubview:self.noDataView];
        
        [[HSQProgressHUDManger Manger] ShowProgressHUDPromptText:KErrorPlacherString SupView:self.view];
        
    }];
}

/**
 * @brief 加载更多的选品库商品列表
 */
- (void)LoadMoreSelectGroupGoodsListData{
    
    [self.tableView.mj_header endRefreshing];
    
    NSDictionary *params = @{@"token":[HSQAccountTool account].token,@"favId":self.distributorFavoritesId,@"page":@(++self.currentPage)};
    
    AFNetworkRequestTool *requestTool = [AFNetworkRequestTool shareRequestTool];
    
    [requestTool.manger POST:UrlAdress(KselectionBankGroupGoodsListUrl) parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [[HSQProgressHUDManger Manger] DismissProgressHUD];
        
        HSQLog(@"===加载更多数据===%@",responseObject);
        
        if ([responseObject[@"code"] integerValue] == 200)
        {
            NSArray *distributorGoodsList = [HSQGoodsDataListModel mj_objectArrayWithKeyValuesArray:responseObject[@"datas"][@"distributorGoodsList"]];
            
            if (distributorGoodsList.count == 0)
            {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
            else
            {
                 [self.dataSource addObject:distributorGoodsList];
            }
        }
        else
        {
            NSString *errorString = [NSString stringWithFormat:@"%@",responseObject[@"datas"][@"error"]];
            
            [[HSQProgressHUDManger Manger] ShowDisplayFailedToLoadData:errorString SuperView:self.view];
        }
        
        [self.tableView.mj_footer endRefreshing];
        
        [self.tableView reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        // 结束刷新
        [self.tableView.mj_footer endRefreshing];
        
        // 提示数据请求失败
        [[HSQProgressHUDManger Manger] ShowProgressHUDPromptText:KErrorPlacherString SupView:self.view];
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    if (self.currentPage == self.totalPage.integerValue || self.totalPage.integerValue == 0)
    {
        self.tableView.mj_footer.hidden = YES;
    }
    else
    {
        self.tableView.mj_footer.hidden = NO;
    }
    
    self.noDataView.hidden = (self.dataSource.count != 0);
    
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section{
    
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 50;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    HSQSelectGroupGoodsListHeadView *HeaderView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"HSQSelectGroupGoodsListHeadView"];
    
    HSQGoodsDataListModel *model = self.dataSource[section];
    
    HeaderView.StoreName_Label.text = model.storeName;
    
    HeaderView.delegate = self;
    
    HeaderView.section = section;
    
    return HeaderView;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForFooterInSection:(NSInteger)section{
    
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 50;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    HSQSelectGroupGoodsListFooterView *FooterView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"HSQSelectGroupGoodsListFooterView"];
    
    FooterView.section = section;
    
    FooterView.delegate = self;
    
    return FooterView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return [self.tableView cellHeightForIndexPath:indexPath model:self.dataSource[indexPath.section] keyPath:@"model" cellClass:[HSQSelectGroupGoodsListCell class] contentViewWidth:KScreenWidth];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HSQSelectGroupGoodsListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HSQSelectGroupGoodsListCell" forIndexPath:indexPath];
    
    if (self.dataSource.count != 0)
    {
        cell.model = self.dataSource[indexPath.section];
    }
    
    // 此步设置用于实现cell的frame缓存，可以让tableview滑动更加流畅
    [cell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    

}

/**
 * @brief 点击进入店铺详情
 */
- (void)ClickToEnterStoreDetails:(UIButton *)sender{
    
    HSQSelectGroupGoodsListHeadView *HeadView = (HSQSelectGroupGoodsListHeadView *)sender.superview.superview.superview;
    
    HSQGoodsDataListModel *model = self.dataSource[HeadView.section];
    
    HSQStoreDetailViewController *StoreVC = [[HSQStoreDetailViewController alloc] init];
    
    StoreVC.storeId = model.storeId;
    
    [self.navigationController pushViewController:StoreVC animated:YES];
    
}

/**
 * @brief 删除
 */
- (void)DeleteItemsFromTheInventory:(UIButton *)sender{
    
    HSQSelectGroupGoodsListFooterView *footerView = (HSQSelectGroupGoodsListFooterView *)sender.superview.superview;
    
     HSQGoodsDataListModel *model = self.dataSource[footerView.section];
    
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:@"确认删除？" preferredStyle:(UIAlertControllerStyleAlert)];
    
    UIAlertAction *action01 = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:nil];
    
    UIAlertAction *action02 = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        
        [[HSQProgressHUDManger Manger] ShowLoadingDataFromeServer:@"" ToView:self.view IsClearColor:YES];
        
        NSDictionary *params = @{@"token":[HSQAccountTool account].token,@"distributorGoodsId":model.distributorGoodsId};
        
        AFNetworkRequestTool *requestTool = [AFNetworkRequestTool shareRequestTool];
        
        [requestTool.manger POST:UrlAdress(KRemovePromotionalItemsUrl) parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            [[HSQProgressHUDManger Manger] DismissProgressHUD];
            
            if ([responseObject[@"code"] integerValue] == 200)
            {
                [self.dataSource removeObject:model];
                
                [self.tableView reloadData];
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
 * @brief 移动
 */
- (void)MoveItemsFromTheInventory:(UIButton *)sender{
    
    HSQSelectGroupGoodsListFooterView *footerView = (HSQSelectGroupGoodsListFooterView *)sender.superview.superview;
    
    HSQGoodsDataListModel *model = self.dataSource[footerView.section];
    
    HSQMobilePromotionProductsView *PromotionProductsView = [HSQMobilePromotionProductsView initMobilePromotionProductsView];
    
    PromotionProductsView.distributorFavoritesId = self.distributorFavoritesId;
    
    PromotionProductsView.ClickGroupSuccessBlock = ^(NSString *distributorFavoritesId) {
        
        [[HSQProgressHUDManger Manger] ShowLoadingDataFromeServer:@"" ToView:self.view IsClearColor:YES];
        
        NSDictionary *params = @{@"token":[HSQAccountTool account].token,@"distributorGoodsId":model.distributorGoodsId,@"distributorFavoritesId":distributorFavoritesId};
        
        AFNetworkRequestTool *requestTool = [AFNetworkRequestTool shareRequestTool];
        
        [requestTool.manger POST:UrlAdress(KMoveGoodsToOtherGroupUrl) parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            [[HSQProgressHUDManger Manger] DismissProgressHUD];
            
            if ([responseObject[@"code"] integerValue] == 200)
            {
                [self.dataSource removeObject:model];
                
                [self.tableView reloadData];
                
                // 发送移动商品成功的消息
                [[NSNotificationCenter defaultCenter] postNotificationName:@"MoveGoodsToOtherGroupNotif" object:self];
            }
            else
            {
                NSString *errorString = [NSString stringWithFormat:@"%@",responseObject[@"datas"][@"error"]];
                
                [[HSQProgressHUDManger Manger] ShowDisplayFailedToLoadData:errorString SuperView:self.view];
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            [[HSQProgressHUDManger Manger] ShowProgressHUDPromptText:KErrorPlacherString SupView:self.view];
            
        }];
    };

    
    [PromotionProductsView ShowMobilePromotionProductsView];
}

/**
 * @brief 立即推广
 */
- (void)ImmediatelyPromoteTheProductsInTheSelectionBank:(UIButton *)sender{
    
    HSQSelectGroupGoodsListFooterView *footerView = (HSQSelectGroupGoodsListFooterView *)sender.superview.superview;
    
    HSQGoodsDataListModel *model = self.dataSource[footerView.section];
    
    HSQLog(@"=====你点击了立即推广===%@",model.goodsName);
    
     [UMSocialUIManager setPreDefinePlatforms:@[@(UMSocialPlatformType_WechatSession),@(UMSocialPlatformType_WechatTimeLine),@(UMSocialPlatformType_QQ),@(UMSocialPlatformType_Qzone)]];
    
    [UMSocialUIManager addCustomPlatformWithoutFilted:UMSocialPlatformType_UserDefine_Begin + 1  withPlatformIcon:[UIImage imageNamed:@"icon1"] withPlatformName:@"二维码"];
    
    [UMSocialShareUIConfig shareInstance].sharePageGroupViewConfig.sharePageGroupViewPostionType = UMSocialSharePageGroupViewPositionType_Bottom;

    [UMSocialShareUIConfig shareInstance].sharePageScrollViewConfig.shareScrollViewPageItemStyleType = UMSocialPlatformItemViewBackgroudType_IconAndBGRoundAndSuperRadius;
    
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {

        //在回调里面获得点击的
        if (platformType == UMSocialPlatformType_UserDefine_Begin + 1) // 你点击了二维码分享
        {
            NSLog(@"你点击了二维码分享");
            
            [self QRCodeShareClickAction:model];
        }
        else
        {
            [self shareImageAndTextToPlatformType:platformType model:model];
        }
    }];
}

/**
 * @brief 二维码分享
 */
- (void)QRCodeShareClickAction:(HSQGoodsDataListModel *)model{
    
    [[HSQProgressHUDManger Manger] ShowLoadingDataFromeServer:@"" ToView:self.view IsClearColor:YES];
    
    NSString *Url = [NSString stringWithFormat:@"http://10.1.8.238/wap/tmpl/product_detail.html?commonId=%@&distributionGoodsId=%@",model.commonId,model.distributorGoodsId];

    NSDictionary *params = @{@"text":model.goodsName,@"imageUrl":model.imageSrc,@"price":model.appPriceMin,@"url":Url};
    
    HSQLog(@"=参数==%@",params);

    AFNetworkRequestTool *requestTool = [AFNetworkRequestTool shareRequestTool];

    [requestTool.manger POST:UrlAdress(KQRCodeShareUrl) parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {

    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

        [[HSQProgressHUDManger Manger] DismissProgressHUD];

        HSQLog(@"==二维码分享==%@",responseObject);

        if ([responseObject[@"code"] integerValue] == 200)
        {
            HSQQRCodeShareView *shareView = [[HSQQRCodeShareView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - KSafeBottomHeight)];
            
            shareView.shareQRUrl = [NSString stringWithFormat:@"%@",responseObject[@"datas"][@"shareQRUrl"]];
        
            [[[UIApplication sharedApplication] keyWindow] addSubview:shareView];
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
 * @brief 分享网页
 */
- (void)shareImageAndTextToPlatformType:(UMSocialPlatformType)platformType model:(HSQGoodsDataListModel *)model{
    
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    //创建网页内容对象
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:@"云树家具" descr:model.goodsName thumImage:model.imageSrc];
    
    // 设置网页地址
    shareObject.webpageUrl =@"http://mobile.umeng.com/social";
    
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        
        if (error)
        {
            NSLog(@"************Share fail with error %@*********",error);
            [[HSQProgressHUDManger Manger] ShowProgressHUDPromptText:@"分享失败" SupView:self.view];
        }
        else
        {
            NSLog(@"response data is %@",data);
            [[HSQProgressHUDManger Manger] ShowProgressHUDPromptText:@"分享成功" SupView:self.view];
        }
    }];
}

- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}




















@end
