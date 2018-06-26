//
//  HSQSubmitPointExchangeGoodsViewController.m
//  LiTianDecoration
//
//  Created by administrator on 2018/6/22.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import "HSQSubmitPointExchangeGoodsViewController.h"
#import "HSQSubmitOrderHeadAdressView.h"
#import "HSQSubmitPointGoodsCell.h"
#import "HSQAcceptAddressListModel.h"
#import "HSQAdressListViewController.h"
#import "HSQAccountTool.h"
#import "HSQPointExchangeGoodsOrderViewController.h"  // 积分兑换商品订单列表

@interface HSQSubmitPointExchangeGoodsViewController ()<UITableViewDelegate,UITableViewDataSource,HSQSubmitOrderHeadAdressViewDelegate,UITextViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) HSQSubmitOrderHeadAdressView *HeadAdressView;

@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, assign) CGRect Orgin_Frame;

@property (nonatomic, strong) UIButton *SubmitOrderBtn;  // 提交按钮

@property (nonatomic, copy) NSString *addressId;  // 地址的id

@property (nonatomic, copy) NSString *message;  // 买家留言

@end

@implementation HSQSubmitPointExchangeGoodsViewController

-(NSMutableArray *)dataSource{
    
    if (_dataSource == nil) {
        
        self.dataSource = [NSMutableArray array];
    }
    
    return _dataSource;
}


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.view.backgroundColor = KViewBackGroupColor;
    
    self.navigationItem.title = @"积分兑换结算";
    
    // 创建tableView
    [self CreatTableView];
    
    //数据
    [self ReloadDatasWithDiction:self.datas];
}


/**
 * @brief 创建tableView
 */
- (void)CreatTableView{
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - KSafeTopeHeight - KSafeBottomHeight - 44) style:(UITableViewStylePlain)];
    
    tableView.backgroundColor = [UIColor clearColor];
    
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    tableView.delegate = self;
    
    tableView.dataSource = self;
    
    [tableView registerNib:[UINib nibWithNibName:@"HSQSubmitPointGoodsCell" bundle:nil] forCellReuseIdentifier:@"HSQSubmitPointGoodsCell"];
    
    [self.view addSubview:tableView];
    
    self.tableView = tableView;
    
    // 顶部的收货地址
    HSQSubmitOrderHeadAdressView *HeadAdressView = [[HSQSubmitOrderHeadAdressView alloc] init];
    
    HeadAdressView.delegate = self;
    
    [self.view addSubview:HeadAdressView];
    
    self.HeadAdressView = HeadAdressView;
    
    // 提交按钮
    UIButton *SubmitOrderBtn = [UIButton buttonWithType:(UIButtonTypeSystem)];
    
    SubmitOrderBtn.backgroundColor = [UIColor redColor];
    
    [SubmitOrderBtn setTitle:@"确认支付" forState:(UIControlStateNormal)];
    
    [SubmitOrderBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    
    SubmitOrderBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
    
    SubmitOrderBtn.frame = CGRectMake(0, CGRectGetMaxY(tableView.frame), KScreenWidth, 44);
    
    [SubmitOrderBtn addTarget:self action:@selector(SubmitOrderBtnClickAction:) forControlEvents:(UIControlEventTouchUpInside)];
    
    [self.view addSubview:SubmitOrderBtn];
    
    self.SubmitOrderBtn = SubmitOrderBtn;
    
}

/**
 * @brief 刷新数据
 */
- (void)ReloadDatasWithDiction:(NSDictionary *)datas{
    
    // 地址
    HSQAcceptAddressListModel *adressModel = [[HSQAcceptAddressListModel alloc] init];
    
    if (datas[@"address"] != [NSNull null]) // 说明有配送地址
    {
        // 取出配送的地址
        NSDictionary *address = datas[@"address"];
        
        [adressModel setValuesForKeysWithDictionary:address];
        
        self.SubmitOrderBtn.enabled = YES;
        
        self.SubmitOrderBtn.backgroundColor = RGB(238, 58, 68);
        
        // 地址的id
        self.addressId = adressModel.addressId;
    }
    else
    {
        self.SubmitOrderBtn.enabled = NO;
        
        self.SubmitOrderBtn.backgroundColor = RGB(180, 180, 180);
    }
    
    NSString *adress = [NSString stringWithFormat:@"%@%@",adressModel.areaInfo,adressModel.address];
    
    CGSize AdressSize = [NSString SizeOfTheText:adress font:[UIFont systemFontOfSize:14.0] MaxSize:CGSizeMake(KScreenWidth - 80, MAXFLOAT)];
    
    self.HeadAdressView.frame = CGRectMake(0, 0, KScreenWidth, AdressSize.height + 50);
    
    self.Orgin_Frame = self.HeadAdressView.frame;
    
    self.HeadAdressView.model = adressModel;
    
    self.tableView.contentInset = UIEdgeInsetsMake( self.Orgin_Frame.size.height, 0, 0, 0);
    
    [self.dataSource addObject:datas[@"pointsGoodsBuyItemVo"]];
    
    [self.tableView reloadData];
}

- (void)setDatas:(NSDictionary *)datas{
    
    _datas = datas;
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
    
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 200;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 200;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    HSQSubmitPointGoodsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HSQSubmitPointGoodsCell" forIndexPath:indexPath];
    
    cell.diction = self.dataSource[indexPath.row];
    
    cell.textView.delegate = self;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    CGFloat Offset_Y = scrollView.contentOffset.y;
    
    self.HeadAdressView.frame = ({
        
        CGRect image_frame = self.Orgin_Frame;
        
        image_frame.origin.y = -(self.Orgin_Frame.size.height + Offset_Y);
        
        image_frame;
        
    });
}

/**
 * @brief 选择用户的收货地址
 */
- (void)SelectTheCustomerShippingAddressButtonClickAction:(UIButton *)sender{
    
    HSQAdressListViewController *AdressListVC = [[HSQAdressListViewController alloc] init];
    
    AdressListVC.Source = @"100";
    
    AdressListVC.SelectAdressModel = ^(HSQAcceptAddressListModel *model) {
        
        NSString *adress = [NSString stringWithFormat:@"%@%@",model.areaInfo,model.address];
        
        CGSize AdressSize = [NSString SizeOfTheText:adress font:[UIFont systemFontOfSize:14.0] MaxSize:CGSizeMake(KScreenWidth - 80, MAXFLOAT)];
        
        self.HeadAdressView.frame = CGRectMake(0, 0, KScreenWidth, AdressSize.height + 50);
        
        self.Orgin_Frame = self.HeadAdressView.frame;
        
        self.HeadAdressView.model = model;
        
        // 地址的id
        self.addressId = model.addressId;
        
        self.tableView.contentInset = UIEdgeInsetsMake( self.Orgin_Frame.size.height, 0, 0, 0);
        
        [self.tableView reloadData];
    };
    
    [self.navigationController pushViewController:AdressListVC animated:YES];
}

/**
 * @brief 点击输入框return键的时候
 */
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    if ([text isEqualToString:@"\n"]) {
        
        [textView resignFirstResponder];
    }
    return YES;
}

/**
 * @brief 输入框文字将要发生改变的时候
 */
- (void)textViewDidChange:(UITextView *)textView{
    
    self.message = textView.text;
}

/**
 * @brief 确认支付按钮的点击
 */
- (void)SubmitOrderBtnClickAction:(UIButton *)sender{
    
    if (self.datas[@"address"] == [NSNull null]) // 说明没有配送地址
    {
        [[HSQProgressHUDManger Manger] ShowProgressHUDPromptText:@"请选择您的收货地址" SupView:self.view];
    }
    else
    {
        [[HSQProgressHUDManger Manger] ShowLoadingDataFromeServer:@"" ToView:self.view IsClearColor:YES];
        
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        
        params[@"token"] = [HSQAccountTool account].token;
        
        params[@"goodsId"] = self.datas[@"pointsGoodsBuyItemVo"][@"goodsId"];
        
        params[@"buyNum"] = self.datas[@"pointsGoodsBuyItemVo"][@"buyNum"];
        
        params[@"pointsGoodsId"] = self.datas[@"pointsGoodsBuyItemVo"][@"pointsGoodsId"];; // 积分商品编号
        
        params[@"addressId"] = self.addressId;
        
        params[@"message"] = (self.message.length == 0 ? @"" : self.message);
        
        HSQLog(@"===%@",params);
        
        AFNetworkRequestTool *requestTool = [AFNetworkRequestTool shareRequestTool];
        
        [requestTool.manger POST:UrlAdress(KPointGoodsBuySaveUrl) parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            HSQLog(@"===确认支付数据===%@",responseObject);
            
            if ([responseObject[@"code"] integerValue] == 200)
            {
                HSQPointExchangeGoodsOrderViewController *OrderListVC = [[HSQPointExchangeGoodsOrderViewController alloc] init];
                
                OrderListVC.source = 100;
                
                [self.navigationController pushViewController:OrderListVC animated:YES];
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




@end
