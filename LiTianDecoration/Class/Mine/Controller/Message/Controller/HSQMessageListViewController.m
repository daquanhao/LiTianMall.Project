//
//  HSQMessageListViewController.m
//  LiTianDecoration
//
//  Created by administrator on 2018/4/27.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import "HSQMessageListViewController.h"
#import "HSQMessageSetViewController.h"
#import "HSQAccountTool.h"
#import "HSQClassMessageListModel.h"
#import "HSQClassMessageListCellTableViewCell.h"
#import "HSQClassMessageDetailListViewController.h"

@interface HSQMessageListViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, strong) HSQNoDataView *noDataView;

@end

@implementation HSQMessageListViewController

-(NSMutableArray *)dataSource{
    
    if (_dataSource == nil) {
        
        self.dataSource = [NSMutableArray array];
    }
    
    return _dataSource;
}

- (HSQNoDataView *)noDataView{
    
    if (!_noDataView) {
        
        _noDataView = [[HSQNoDataView alloc] initWithTitle:@"亲，您还没有收到任何消息哦~" imageName:@"WaitingForView" height:50 TopMargin:0];
    }
    return _noDataView;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.navigationItem.title = @"消息列表";
    
    self.view.backgroundColor = KViewBackGroupColor;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:KImageName(@"E9EB8A8C-F280-4BDC-B704-F17FF9894360") style:(UIBarButtonItemStylePlain) target:self action:@selector(RightItemClickAction:)];
    
    // 创建tableView
    [self CreatTableView];

    // 请求消息列表
    [self requestUserMessageListDataFromeserver];
}

/**
 * @brief 设置消息
 */
- (void)RightItemClickAction:(UIBarButtonItem *)sender{
    
    HSQMessageSetViewController *MessageSetVC = [[HSQMessageSetViewController alloc] init];
    
    [self.navigationController pushViewController:MessageSetVC animated:YES];
}

/**
 * @brief 创建tableView
 */
- (void)CreatTableView{
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - KSafeTopeHeight - KSafeBottomHeight) style:(UITableViewStylePlain)];
    
    tableView.backgroundColor = [UIColor clearColor];
    
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    tableView.delegate = self;
    
    tableView.dataSource = self;
    
    [tableView registerClass:[HSQClassMessageListCellTableViewCell class] forCellReuseIdentifier:@"HSQClassMessageListCellTableViewCell"];
    
    [self.view addSubview:tableView];
    
    self.tableView = tableView;
}


/**
 * @brief 请求消息列表
 */
- (void)requestUserMessageListDataFromeserver{
    
    HSQAccount *account = [HSQAccountTool account];
    
    if (account.token.length == 0) return;
    
    [[HSQProgressHUDManger Manger] ShowLoadingDataFromeServer:nil ToView:self.view IsClearColor:NO];
    
    NSDictionary *diction = @{@"token":account.token};
    
    AFNetworkRequestTool *RequestTool = [AFNetworkRequestTool shareRequestTool];
    
    [RequestTool.manger POST:UrlAdress(KClassMessageListUrl) parameters:diction progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *responseObject) {
        
        HSQLog(@"=消息的数据==%@",responseObject);
        
        [[HSQProgressHUDManger Manger] DismissProgressHUD];
        
        if ([responseObject[@"code"] integerValue] == 200)
        {
            self.dataSource = [HSQClassMessageListModel mj_objectArrayWithKeyValuesArray:responseObject[@"datas"][@"messageClassVoList"]];
        }
        else
        {
            NSString *errorString = [NSString stringWithFormat:@"%@",responseObject[@"datas"][@"error"]];
            
            [[HSQProgressHUDManger Manger] ShowDisplayFailedToLoadData:errorString SuperView:self.view];
        }
        
        if (self.dataSource.count == 0)
        {
            [self.tableView addSubview:self.noDataView];
        }
        
        [self.tableView reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
         [self.tableView addSubview:self.noDataView];
        
        [[HSQProgressHUDManger Manger] ShowDisplayFailedToLoadData:KErrorPlacherString SuperView:self.view];
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    self.noDataView.hidden = (self.dataSource.count != 0);
    
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return [self.tableView cellHeightForIndexPath:indexPath model:self.dataSource[indexPath.row] keyPath:@"model" cellClass:[HSQClassMessageListCellTableViewCell class] contentViewWidth:KScreenWidth] + 5;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HSQClassMessageListCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HSQClassMessageListCellTableViewCell" forIndexPath:indexPath];
    
    if (self.dataSource.count != 0)
    {
        cell.model = self.dataSource[indexPath.row];
    }

    // 此步设置用于实现cell的frame缓存，可以让tableview滑动更加流畅
    [cell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    HSQClassMessageListModel *model = self.dataSource[indexPath.row];
    
    model.messageUnreadCount = 0;
    
    HSQClassMessageDetailListViewController *MessageDetailListVC = [[HSQClassMessageDetailListViewController alloc] init];
    
    MessageDetailListVC.tplClass = model.tplClass;
    
    [self.navigationController pushViewController:MessageDetailListVC animated:YES];
    
    [self.tableView reloadData];
}
















@end
