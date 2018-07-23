//
//  HSQShopIntroducedViewController.m
//  LiTianDecoration
//
//  Created by administrator on 2018/5/15.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import "HSQShopIntroducedViewController.h"
#import "HSQStoreIntroducedListCell.h"
#import "HSQStoreIntroductHeadCell.h"
#import "HSQAccountTool.h"
#import "HSQLoginViewController.h"

@interface HSQShopIntroducedViewController ()<UITableViewDelegate,UITableViewDataSource,HSQStoreIntroductHeadCellDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, strong) NSDictionary *dataDiction;

@property (nonatomic, copy) NSString *IsCollection; // 是否被收藏

@end

@implementation HSQShopIntroducedViewController

-(NSMutableArray *)dataSource{
    
    if (_dataSource == nil) {
        
        self.dataSource = [NSMutableArray arrayWithObjects:@"描述相符",@"服务态度",@"物流服务",@"所在地",@"开店时间",@"主管商品",@"工商执照",@"食品执照",@"联系电话", nil];
    }
    
    return _dataSource;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.view.backgroundColor = KViewBackGroupColor;
    
    self.navigationItem.title = @"店铺介绍";
    
    self.dataDiction = [NSDictionary dictionary];
    
    // 创建tableView
    [self CreatTableView];
    
    // 1.请求店铺介绍的数据
    [self RequestShopIntroducedFromeServer];
    
    // 监听用户登录的消息
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(UserLoginSuccessNotif:) name:@"UserDidLoginSuccessNotif" object:nil];
}

/**
 * @brief 请求店铺介绍的数据
 */
- (void)RequestShopIntroducedFromeServer{
    
    [[HSQProgressHUDManger Manger] ShowLoadingDataFromeServer:@"" ToView:self.view IsClearColor:YES];
    
    NSMutableDictionary *Params = [[HSQParameterTool shareParameterTool] StoreDetailsOfTheParameter:self.storeId];
    
    AFNetworkRequestTool *requestTool = [AFNetworkRequestTool shareRequestTool];
    
    [requestTool.manger POST:UrlAdress(KStoreIntroducedUrl) parameters:Params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [[HSQProgressHUDManger Manger] DismissProgressHUD];
        
        HSQLog(@"=店铺介绍==%@",responseObject);
        if ([responseObject[@"code"] integerValue] == 200)
        {
            self.dataDiction = responseObject[@"datas"];
            
            // 该用户是否收藏了该店铺(1–是，0–否)
            self.IsCollection = [NSString stringWithFormat:@"%@",responseObject[@"datas"][@"isFavorite"]];
        }
        else
        {
            NSString *message = [NSString stringWithFormat:@"%@",responseObject[@"datas"][@"error"]];
            
            [[HSQProgressHUDManger Manger] ShowDisplayFailedToLoadData:message SuperView:self.view];
        }
        
        [self.tableView reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [[HSQProgressHUDManger Manger] ShowDisplayFailedToLoadData:@"数据加载失败" SuperView:self.view];
        
    }];
}

/**
 * @brief 创建tableView
 */
- (void)CreatTableView{
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - KSafeBottomHeight - KSafeTopeHeight) style:(UITableViewStylePlain)];
    
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    tableView.backgroundColor = [UIColor clearColor];
    
    [tableView registerNib:[UINib nibWithNibName:@"HSQStoreIntroductHeadCell" bundle:nil] forCellReuseIdentifier:@"HSQStoreIntroductHeadCell"];
    
    [tableView registerClass:[HSQStoreIntroducedListCell class] forCellReuseIdentifier:@"HSQStoreIntroducedListCell"];
    
    tableView.delegate = self;
    
    tableView.dataSource = self;
    
    [self.view addSubview:tableView];
    
    self.tableView = tableView;
}

/**
 * @brief 用户登录的消息
 */
- (void)UserLoginSuccessNotif:(NSNotification *)notif{
    
    // 重新加载数据，判断店铺是否被收藏
    [self RequestShopIntroducedFromeServer];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate,UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return (self.dataDiction.allKeys.count == 0 ? 0 : 4);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    if (section == 1)
    {
        return 3;
    }
    else if (section == 2)
    {
        // 是否有食品流通许可证
        NSString *hasFoodCirculationPermit = [NSString stringWithFormat:@"%@",self.dataDiction[@"storeInfo"][@"hasFoodCirculationPermit"]];
        
        // 是否有营业执照
        NSString *hasBusinessLicence = [NSString stringWithFormat:@"%@",self.dataDiction[@"storeInfo"][@"hasBusinessLicence"]];
        
        if (hasFoodCirculationPermit.integerValue == 0 && hasBusinessLicence.integerValue == 0) // 没有
        {
            return 3;
        }
        else if (hasFoodCirculationPermit.integerValue != 0 && hasBusinessLicence.integerValue != 0) // 没有
        {
            return 5;
        }
        else
        {
            return 4;
        }
    }
    else
    {
        return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 100;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0)
    {
        return 120;
    }
    else
    {
        return 50;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section != 0)
    {
        return 20;
    }
    else
    {
        return 0.01;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *HeadView = [[UIView alloc] init];
    HeadView.backgroundColor = KViewBackGroupColor;
    return HeadView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0)
    {
        HSQStoreIntroductHeadCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HSQStoreIntroductHeadCell"];
        
        cell.DataDiction = self.dataDiction;
        
        cell.delegate = self;
        
        return cell;
    }
    else
    {
        HSQStoreIntroducedListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HSQStoreIntroducedListCell"];
        
        [cell SetValueDataDiction:self.dataDiction indexPath:indexPath];
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    

}

/**
 * @brief 收藏店铺的点击事件
 */
- (void)CollectStoreNotiftioncClickAction:(UIButton *)sender{
    
    HSQStoreIntroductHeadCell *cell = (HSQStoreIntroductHeadCell *)sender.superview.superview;
    
    HSQAccount *account = [HSQAccountTool account];
    
    if (account.token.length == 0)  // 没有登录
    {
        HSQLoginViewController *LoginVC = [[HSQLoginViewController alloc] init];
        
        [self.navigationController pushViewController:LoginVC animated:YES];
    }
    else
    {
        // 该用户是否收藏了该店铺(1–是，0–否)
        if (self.IsCollection.integerValue == 0) // 没有收藏，点击收藏
        {
            [self UserCollectionStore:account.token HeadCell:cell];
        }
        else if (self.IsCollection.integerValue == 1) // 收藏，点击取消收藏
        {
            [self UserCancelCollectionStore: account.token HeadCell:cell];
        }
    }
}

/**
 * @brief 收藏店铺
 */
- (void)UserCollectionStore:(NSString *)token HeadCell:(HSQStoreIntroductHeadCell *)cell{
    
    [[HSQProgressHUDManger Manger] ShowLoadingDataFromeServer:@"" ToView:self.view IsClearColor:YES];
    
    NSDictionary *diction = @{@"storeId":self.storeId,@"token":token};
    
    AFNetworkRequestTool *requestTool = [AFNetworkRequestTool shareRequestTool];
    
    [requestTool.manger POST:UrlAdress(KCollectionStoreUrl) parameters:diction progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [[HSQProgressHUDManger Manger] DismissProgressHUD];
        
        if ([responseObject[@"code"] integerValue] == 200)
        {
            self.IsCollection = @"1";
            
            [cell.Collection_Btn setTitle:@"已收藏" forState:(UIControlStateNormal)];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"StoreCollectionStaeNotif" object:self userInfo:@{@"CollectionState":self.IsCollection}];
        }
        else
        {
            NSString *message = [NSString stringWithFormat:@"%@",responseObject[@"datas"][@"error"]];
            
            [[HSQProgressHUDManger Manger] ShowDisplayFailedToLoadData:message SuperView:self.view];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [[HSQProgressHUDManger Manger] ShowDisplayFailedToLoadData:@"收藏店铺失败" SuperView:self.view];
        
    }];
}

/**
 * @brief 取消收藏店铺
 */
- (void)UserCancelCollectionStore:(NSString *)token HeadCell:(HSQStoreIntroductHeadCell *)cell{
    
    [[HSQProgressHUDManger Manger] ShowLoadingDataFromeServer:@"" ToView:self.view IsClearColor:YES];
    
    NSDictionary *diction = @{@"storeId":self.storeId,@"token":token};
    
    AFNetworkRequestTool *requestTool = [AFNetworkRequestTool shareRequestTool];
    
    [requestTool.manger POST:UrlAdress(KCancelCollectionStoreUrl) parameters:diction progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [[HSQProgressHUDManger Manger] DismissProgressHUD];
        
        if ([responseObject[@"code"] integerValue] == 200)
        {
            self.IsCollection = @"0";
            
            [cell.Collection_Btn setTitle:@"收藏" forState:(UIControlStateNormal)];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"StoreCollectionStaeNotif" object:self userInfo:@{@"CollectionState":self.IsCollection}];
        }
        else
        {
            NSString *message = [NSString stringWithFormat:@"%@",responseObject[@"datas"][@"error"]];
            
            [[HSQProgressHUDManger Manger] ShowDisplayFailedToLoadData:message SuperView:self.view];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [[HSQProgressHUDManger Manger] ShowDisplayFailedToLoadData:@"取消收藏店铺失败" SuperView:self.view];
        
    }];
}





@end
