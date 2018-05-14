//
//  DiscoverViewController.m
//  LiTianDecoration
//
//  Created by administrator on 2018/4/9.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import "DiscoverViewController.h"
#import "DiscoverListModel.h"
#import "HSQDiscoverHeadView.h"
#import "HSQPubShaiBaoView.h"
#import "HSQShaiBaoViewController.h" // 晒宝
#import "HSQPinTuanViewController.h" // 拼团
#import "HSQTheTrialViewController.h"   // 试用
#import "HSQToPromoteViewController.h"  // 推广分佣
#import "HSQIntegralCenterViewController.h"  // 积分中心

@interface DiscoverViewController ()<HSQDiscoverHeadViewDelegate,HSQPubShaiBaoViewDelegate>

@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, strong) NSMutableArray *ViewControllerArray;

@property (nonatomic, strong) HSQDiscoverHeadView *headView;  // 头部的视图

@property (nonatomic, strong) HSQPubShaiBaoView *publieView;

@end

@implementation DiscoverViewController

- (NSMutableArray *)dataSource{
    
    if (_dataSource == nil) {
        
        self.dataSource = [NSMutableArray array];
    }
    
    return _dataSource;
}

- (NSMutableArray *)ViewControllerArray{
    
    if (_ViewControllerArray == nil) {
        
        HSQShaiBaoViewController *ShaiBaoVC = [[HSQShaiBaoViewController alloc] init];
        ShaiBaoVC.Nav_Title = @"晒宝精选";
        
        HSQToPromoteViewController *ToPromoteVC = [[HSQToPromoteViewController alloc] init];
        ToPromoteVC.NavtionTitle = @"推广分佣";
        
        HSQPinTuanViewController *pinTuanVC = [[HSQPinTuanViewController alloc] init];
        pinTuanVC.NavtionTitle = @"拼团";
        
        HSQTheTrialViewController *TheTrialVC = [[HSQTheTrialViewController alloc] init];
        TheTrialVC.NavtionTitle = @"试用";
        
        HSQIntegralCenterViewController *IntegralCenterVC = [[HSQIntegralCenterViewController alloc] init];
        IntegralCenterVC.NavtionTitle = @"积分兑换";
        
        self.ViewControllerArray = [NSMutableArray arrayWithObjects:ShaiBaoVC,ToPromoteVC,pinTuanVC,TheTrialVC,IntegralCenterVC, nil];
    }
    
    return _ViewControllerArray;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.view.backgroundColor = KViewBackGroupColor;
    
    // 1.创建头部按钮视图
    [self CreatHeaderBtnView];

    [self adddata];

    // 请求服务器的数据
//    [self RequestServerData];
}

- (void)adddata{
    
    for (NSInteger i = 0; i < 30; i++) {
        
        DiscoverListModel *model = [[DiscoverListModel alloc] init];
        
        model.imageUrl = @"3-1P106112Q1-51";
        
        model.title = @"超级续航嗨翻天——华为G9 Plus";
        
        model.author = @"作者 member_cj";
        
        model.readcount = @"12300";
        
        model.goodcount = @"13230";
        
        [self.dataSource addObject:model];
    }
    
    self.publieView.dataSource = self.dataSource;

}

/**
 * @brief 创建头部按钮视图
 */
- (void)CreatHeaderBtnView{
    
    NSMutableArray *array = [NSMutableArray array];
    
    NSDictionary *diction1 = @{@"name":@"晒宝",@"icon":@"123"};
    NSDictionary *diction2 = @{@"name":@"推广分佣",@"icon":@"123"};
    NSDictionary *diction3 = @{@"name":@"拼团",@"icon":@"123"};
    NSDictionary *diction4 = @{@"name":@"试用",@"icon":@"123"};
    NSDictionary *diction5 = @{@"name":@"积分兑换",@"icon":@"123"};
    
    [array addObjectsFromArray:@[diction1,diction2,diction3,diction4,diction5]];
    
    HSQDiscoverHeadView *headView = [[HSQDiscoverHeadView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 64)];
    
    headView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.8];
    
    headView.dataSource = array;
    
    headView.delegate = self;
    
    [self.view addSubview:headView];
    
    self.headView = headView;

    // 1.晒宝界面
    CGRect ViewFrame = CGRectMake(0, self.headView.mj_h, KScreenWidth, KScreenHeight - KSafeTopeHeight - KSafeBottomHeight - 49 - self.headView.mj_h);
    
    HSQPubShaiBaoView *publieView = [[HSQPubShaiBaoView alloc] initWithFrame:ViewFrame];
    
    publieView.delegate = self;
    
    [self.view addSubview:publieView];
    
    self.publieView = publieView;
}


/**
 * @brief 请求服务器的数据
 */
- (void)RequestServerData{
    
    NSDictionary *diction = @{@"page":@"0"};
    
    AFNetworkRequestTool *RequestTool = [AFNetworkRequestTool shareRequestTool];
    
    RequestTool.manger.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/html", nil];
    
    [RequestTool.manger POST:UrlAdress(KGetSunTreasureListDataUrl) parameters:diction progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"=晒宝=%@",responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"==%@",error.description);
        
    }];
}

/**
 * @brief 头部按钮的点击事件
 */
- (void)headerViewButtonClickAction:(UIButton *)sender{
    
    HSQLog(@"==点击头部按钮");
    
    [self.navigationController pushViewController:self.ViewControllerArray[sender.tag - 100] animated:YES];
     

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - HSQPubShaiBaoViewDelegate

- (void)PublieTableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    HSQLog(@"==你单击lecell");
}




@end
