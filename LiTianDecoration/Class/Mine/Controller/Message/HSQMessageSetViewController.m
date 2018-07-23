//
//  HSQMessageSetViewController.m
//  LiTianDecoration
//
//  Created by administrator on 2018/4/26.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import "HSQMessageSetViewController.h"
#import "HSQMessageSetListCell.h"
#import "HSQAccountTool.h"
#import "HSQMessageReceiveModel.h"
#import "HSQHeadMessageView.h"

@interface HSQMessageSetViewController ()<UITableViewDelegate,UITableViewDataSource,HSQMessageSetListCellDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *Sections;

@end

@implementation HSQMessageSetViewController

- (NSMutableArray *)Sections{
    
    if (_Sections == nil) {
        
        self.Sections = [NSMutableArray array];
    }
    
    return _Sections;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.navigationItem.title = @"消息提醒设置";
    
    self.view.backgroundColor = KViewBackGroupColor;
    
    // 创建tableView
    [self CreatTableView];
    
    // 请求消息列表的数据
    [self RequestMessageListDataFromeServer];
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
    
    [tableView registerNib:[UINib nibWithNibName:@"HSQMessageSetListCell" bundle:nil] forCellReuseIdentifier:@"HSQMessageSetListCell"];
    
    [tableView registerClass:[HSQHeadMessageView class] forHeaderFooterViewReuseIdentifier:@"HSQHeadMessageView"];
    
    [self.view addSubview:tableView];
    
    self.tableView = tableView;
}

/**
 * @brief 请求消息列表的数据
 */
- (void)RequestMessageListDataFromeServer{
    
    [[HSQProgressHUDManger Manger] ShowLoadingDataFromeServer:@"" ToView:self.view IsClearColor:YES];
    
    NSDictionary *diction = @{@"token":[HSQAccountTool account].token};
    
    AFNetworkRequestTool *RequestTool = [AFNetworkRequestTool shareRequestTool];
    
    [RequestTool.manger POST:UrlAdress(KMessagedReceiveListUrl) parameters:diction progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [[HSQProgressHUDManger Manger] DismissProgressHUD];
        
        HSQLog(@"===%@",responseObject);
        if ([responseObject[@"code"] integerValue] == 200)
        {
            for (NSDictionary *dict in responseObject[@"datas"][@"messageClassList"])
            {
                // 外层数据
                HSQMessageReceiveModel *ReceiveModel = [[HSQMessageReceiveModel alloc] initWithDictionary:dict error:nil];
                
                ReceiveModel.messageTemplateCommonList = [NSMutableArray array];
                
                [self.Sections addObject:ReceiveModel];
                
                // 内层数据
                for (NSDictionary *InnerDiction in dict[@"messageTemplateCommonList"]) {
                    
                    HSQMessageListModel *ListModel = [[HSQMessageListModel alloc] init];
                    
                    [InnerDiction enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                        
                         [ListModel setValue:obj forKey:key];
                        
                    }];
                    
                    [ReceiveModel.messageTemplateCommonList addObject:ListModel];
                }
            }
        }
        else
        {
            NSString *message = [NSString stringWithFormat:@"%@",responseObject[@"datas"][@"error"]];
            
            [[HSQProgressHUDManger Manger] ShowDisplayFailedToLoadData:message SuperView:self.view];
        }
        
        [self.tableView reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [[HSQProgressHUDManger Manger] ShowDisplayFailedToLoadData:@"消息接收数据加载失败!" SuperView:self.view];
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate,UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.Sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    HSQMessageReceiveModel *model = self.Sections[section];
    
    return model.messageTemplateCommonList.count;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    HSQHeadMessageView *HeadView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"HSQHeadMessageView"];
    
    if (self.Sections.count != 0)
    {
        HeadView.model = self.Sections[section];
    }
    
    return HeadView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    HSQMessageSetListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HSQMessageSetListCell" forIndexPath:indexPath];
    
    if (self.Sections.count != 0)
    {
        HSQMessageReceiveModel *model = self.Sections[indexPath.section];
        
        HSQMessageListModel *ListModel = model.messageTemplateCommonList[indexPath.row];
        
        cell.model = ListModel;
    }
    
    cell.delegate = self;
    
    return cell;
}

/**
 * @brief 开关的点击事件
 */
- (void)ChangeTheReceivingStateOfTheMessage:(UISwitch *)Switch{
    
    HSQMessageSetListCell *cell = (HSQMessageSetListCell *)Switch.superview.superview;
    
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    HSQMessageReceiveModel *model = self.Sections[indexPath.section];
    
    HSQMessageListModel *ListModel = model.messageTemplateCommonList[indexPath.row];
    
    // 是否接收消息 1是 0否
    NSString *isReceive = [NSString stringWithFormat:@"%@",ListModel.isReceive];
    
    if (isReceive.integerValue == 1)
    {
        [self CloseOrOpenTheMessageReceiver:@"0" tplCode:ListModel.tplCode indexPath:indexPath];
    }
    else
    {
        [self CloseOrOpenTheMessageReceiver:@"1" tplCode:ListModel.tplCode indexPath:indexPath];
    }
}

/**
 * @brief 关闭或者打开消息接收
 */
- (void)CloseOrOpenTheMessageReceiver:(NSString *)isReceive tplCode:(NSString *)code indexPath:(NSIndexPath *)index{
    
    [[HSQProgressHUDManger Manger] ShowLoadingDataFromeServer:@"" ToView:self.view IsClearColor:YES];
    
    NSDictionary *diction = @{@"token":[HSQAccountTool account].token,@"tplCode":code,@"isReceive":isReceive};
    
    AFNetworkRequestTool *RequestTool = [AFNetworkRequestTool shareRequestTool];
    
    [RequestTool.manger POST:UrlAdress(KChangeMessageStateUrl) parameters:diction progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        HSQLog(@"===%@",responseObject);
        [[HSQProgressHUDManger Manger] DismissProgressHUD];
        
        if ([responseObject[@"code"] integerValue] == 200)
        {
            HSQMessageReceiveModel *model = self.Sections[index.section];

            HSQMessageListModel *ListModel = model.messageTemplateCommonList[index.row];
            
            ListModel.isReceive = isReceive;
            
        }
        else
        {
            NSString *message = [NSString stringWithFormat:@"%@",responseObject[@"datas"][@"error"]];
            
            [[HSQProgressHUDManger Manger] ShowDisplayFailedToLoadData:message SuperView:self.view];
        }
        
        [self.tableView reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [[HSQProgressHUDManger Manger] ShowDisplayFailedToLoadData:@"消息状态改变失败！" SuperView:self.view];
        
    }];
}















@end
