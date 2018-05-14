//
//  HSQIntegralListViewController.m
//  LiTianDecoration
//
//  Created by administrator on 2018/4/28.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import "HSQIntegralListViewController.h"
#import "HSQIntegralListCell.h"
#import "HSQAccountTool.h"
#import "HSQIntegralListModel.h"

@interface HSQIntegralListViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UILabel *MyIntegral_Label;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UILabel *TopTitle_Label;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *TableViewBottom_Layout;

@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, assign) NSInteger CurrentPage;

@property (nonatomic, copy) NSString *totalPage;  // 总页数

@end

@implementation HSQIntegralListViewController

-(NSMutableArray *)dataSource{
    
    if (_dataSource == nil) {
        
        self.dataSource = [NSMutableArray array];
    }
    
    return _dataSource;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.view.backgroundColor = KViewBackGroupColor;
    
    self.navigationItem.title = self.Navtion_Title;
    
    self.TableViewBottom_Layout.constant = KSafeBottomHeight;
    
    self.MyIntegral_Label.text = [NSString stringWithFormat:@"%@",self.IntegralCount];
    
    self.TopTitle_Label.text = [NSString stringWithFormat:@"%@",self.Top_Title];
    
    // 添加积分列表刷新控件
    [self AddTheIntegralListRefreshControl];
}

/**
 * @brief 添加积分列表刷新控件
 */
- (void)AddTheIntegralListRefreshControl{
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(LoadNewIntegralListData)];
    
    [self.tableView.mj_header beginRefreshing];
    
    // 3.上啦加载更多的代码
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(LoadMoreIntegralListData)];
}

/**
 * @brief 加载最新的数据
 */
- (void)LoadNewIntegralListData{
    
    // 0.清空数组
    [self.dataSource removeAllObjects];
    
    // 结束上啦
    [self.tableView.mj_footer endRefreshing];
    
    self.CurrentPage = 1;
    
    NSDictionary *diction = @{@"token":[HSQAccountTool account].token,@"page":@(self.CurrentPage)};
    
    AFNetworkRequestTool *RequestTool = [AFNetworkRequestTool shareRequestTool];
    
    [RequestTool.manger POST:self.DataUrl parameters:diction progress:^(NSProgress * _Nonnull uploadProgress) {
    
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        HSQLog(@"==%@",responseObject);
        // 总页数
        self.totalPage = [NSString stringWithFormat:@"%@",responseObject[@"datas"][@"pageEntity"][@"totalPage"]];
        
        if ([responseObject[@"code"] integerValue] == 200)
        {
            self.dataSource = [HSQIntegralListModel mj_objectArrayWithKeyValuesArray:responseObject[@"datas"][@"logList"]];
        }
        else
        {
            NSString *errorString = [NSString stringWithFormat:@"%@",responseObject[@"datas"][@"error"]];
            
            [[HSQProgressHUDManger Manger] ShowDisplayFailedToLoadData:errorString SuperView:self.view];
        }
        
        [self.tableView.mj_header endRefreshing];
        
        [self.tableView reloadData];
    
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    
        [self.tableView.mj_header endRefreshing];
        
        [[HSQProgressHUDManger Manger] ShowDisplayFailedToLoadData:@"积分列表数据加载失败" SuperView:self.view];
    
    }];
}

/**
 * @brief 加载更多的数据
 */
- (void)LoadMoreIntegralListData{
    
    // 结束下拉
    [self.tableView.mj_header endRefreshing];
    
    NSDictionary *paraetes = @{@"token":[HSQAccountTool account].token,@"page":@(self.CurrentPage)};
    
    HSQLog(@"求情参数%@",[NSString stringWithFormat:@"%@",paraetes]);
    
    AFNetworkRequestTool *RequestTool = [AFNetworkRequestTool shareRequestTool];
    
    [RequestTool.manger POST:self.DataUrl parameters:paraetes progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        HSQLog(@"加载更多%@",[NSString stringWithFormat:@"%@",responseObject]);
        
        if ([responseObject[@"code"] integerValue] == 200)
        {
            // 1.字典转模型
            NSArray *array1 = [HSQIntegralListModel mj_objectArrayWithKeyValuesArray:responseObject[@"datas"][@"logList"]];
            
            [self.dataSource addObjectsFromArray:array1];
            
            // 3,停止加载
            [self.tableView.mj_footer endRefreshing];
        }
        else
        {
            NSString *errorString = [NSString stringWithFormat:@"%@",responseObject[@"datas"][@"error"]];
            
            [[HSQProgressHUDManger Manger] ShowDisplayFailedToLoadData:errorString SuperView:self.view];
            
            // 3,停止加载
            [self.tableView.mj_footer endRefreshing];
        }
        
        // 2.刷新数据
        [self.tableView reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        // 结束刷新
        [self.tableView.mj_footer endRefreshing];
        
        // 提示数据请求失败
        [[HSQProgressHUDManger Manger] ShowDisplayFailedToLoadData:@"积分列表数据加载失败" SuperView:self.view];
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate,UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (self.CurrentPage == self.totalPage.integerValue || self.totalPage.integerValue == 0)
    {
        self.tableView.mj_footer.hidden = YES;
    }
    else
    {
        self.tableView.mj_footer.hidden = NO;
    }
    
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 70;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 70;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    HSQIntegralListCell *cell = [HSQIntegralListCell HSQIntegralListCellWithXIB];
    
    if (self.dataSource.count != 0)
    {
        cell.model = self.dataSource[indexPath.row];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

@end
