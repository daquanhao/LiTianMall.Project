//
//  HSQTuiGoodAndMoneryDetailViewController.m
//  LiTianDecoration
//
//  Created by administrator on 2018/6/4.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import "HSQTuiGoodAndMoneryDetailViewController.h"
#import "HSQTuiHuoAndMonerydetailListCell.h"
#import "HSQTuiMoneryListHeadView.h"
#import "HSQAccountTool.h"

@interface HSQTuiGoodAndMoneryDetailViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, strong) NSDictionary *dataDiction;

@end

@implementation HSQTuiGoodAndMoneryDetailViewController

-(NSMutableArray *)dataSource{
    
    if (_dataSource == nil) {
        
        self.dataSource = [NSMutableArray array];
    }
    
    return _dataSource;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.navigationItem.title = self.Navtion_title;
    
    self.view.backgroundColor = KViewBackGroupColor;
    
    self.dataDiction = [NSDictionary dictionary];
    
    if (self.Order_Type.integerValue == 100)
    {
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"title"] = @"我的退款申请";
        params[@"list"] = @[@"退款编号",@"退款原因",@"退款金额",@"退款说明",@"凭证上传"];
        [self.dataSource addObject:params];
        
        NSMutableDictionary *params01 = [NSMutableDictionary dictionary];
        params01[@"title"] = @"商家处理";
        params01[@"list"] = @[@"审核状态",@"商家备注"];
        [self.dataSource addObject:params01];
        
        NSMutableDictionary *params02 = [NSMutableDictionary dictionary];
        params02[@"title"] = @"平台退款审核";
        params02[@"list"] = @[@"平台确认",@"平台备注"];
        [self.dataSource addObject:params02];
    }
    else if (self.Order_Type.integerValue == 200)
    {
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"title"] = @"我的退货申请";
        params[@"list"] = @[@"退货编号",@"退货原因",@"退货金额",@"退货说明",@"凭证上传"];
        [self.dataSource addObject:params];
        
        NSMutableDictionary *params01 = [NSMutableDictionary dictionary];
        params01[@"title"] = @"商家处理";
        params01[@"list"] = @[@"审核状态",@"商家备注"];
        [self.dataSource addObject:params01];
        
        NSMutableDictionary *params02 = [NSMutableDictionary dictionary];
        params02[@"title"] = @"平台退款审核";
        params02[@"list"] = @[@"平台确认",@"平台备注"];
        [self.dataSource addObject:params02];
    }
    else if (self.Order_Type.integerValue == 300) // 投诉
    {
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"title"] = @"我的投诉信息";
        params[@"list"] = @[@"投诉商品",@"投诉状态",@"投诉时间",@"投诉主题",@"投诉内容",@"凭证上传"];
        [self.dataSource addObject:params];
    }
    
    // 创建tableView
    [self CreatTableView];
    
    // 请求订单详情的数据
    [self RequestOrderDetailDataFromeServer];
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
    
    [tableView registerNib:[UINib nibWithNibName:@"HSQTuiHuoAndMonerydetailListCell" bundle:nil] forCellReuseIdentifier:@"HSQTuiHuoAndMonerydetailListCell"];
    
    [tableView registerClass:[HSQTuiMoneryListHeadView class] forHeaderFooterViewReuseIdentifier:@"HSQTuiMoneryListHeadView"];
    
    [self.view addSubview:tableView];
    
    self.tableView = tableView;
}

/**
 * @brief 请求订单详情的数据
 */
- (void)RequestOrderDetailDataFromeServer{
    
    [[HSQProgressHUDManger Manger] ShowLoadingDataFromeServer:@"" ToView:self.view IsClearColor:YES];
    
    NSString *url = nil;
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"token"] = [HSQAccountTool account].token;
    
    if (self.Order_Type.integerValue == 100)
    {
         params[@"refundId"] = self.complainId;
        url = [NSString stringWithFormat:@"%@",UrlAdress(KTuiKuanDetailUrl)];
    }
    else if (self.Order_Type.integerValue == 200)
    {
        params[@"refundId"] = self.complainId;
        url = [NSString stringWithFormat:@"%@",UrlAdress(KTuiHuoDetailDataUrl)];
    }
    else if (self.Order_Type.integerValue == 300)
    {
        params[@"complainId"] = self.complainId;
        url = [NSString stringWithFormat:@"%@",UrlAdress(KTouSuDetailUrl)];
    }
    
    AFNetworkRequestTool *requestTool = [AFNetworkRequestTool shareRequestTool];
    
    [requestTool.manger POST:url parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [[HSQProgressHUDManger Manger] DismissProgressHUD];
        
        HSQLog(@"===列表详情===%@",responseObject);
        
        if ([responseObject[@"code"] integerValue] == 200)
        {
            self.dataDiction = responseObject[@"datas"];
        }
        else
        {
            NSString *errorString = [NSString stringWithFormat:@"%@",responseObject[@"datas"][@"error"]];
            
            [[HSQProgressHUDManger Manger] ShowDisplayFailedToLoadData:errorString SuperView:self.view];
        }

        [self.tableView reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        // 提示数据请求失败
        [[HSQProgressHUDManger Manger] ShowProgressHUDPromptText:@"网络出现问题" SupView:self.view];
        
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSDictionary *diction = self.dataSource[section];
    
    NSArray *array = diction[@"list"];
    
    return array.count;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section{
    
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 40;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    HSQTuiMoneryListHeadView *HeaderView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"HSQTuiMoneryListHeadView"];
    
    HeaderView.BgView.hidden = YES;
    
    NSDictionary *diction = self.dataSource[section];

    HeaderView.Placher_Label.text = [NSString stringWithFormat:@"%@",diction[@"title"]];
    
    return HeaderView;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HSQTuiHuoAndMonerydetailListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HSQTuiHuoAndMonerydetailListCell" forIndexPath:indexPath];
    
    // 左边的标题
    NSDictionary *diction = self.dataSource[indexPath.section];
    NSArray *array = diction[@"list"];
    cell.Left_PlacherLabel.text = [NSString stringWithFormat:@"%@",array[indexPath.row]];
    
    if (self.dataDiction.allKeys.count != 0)
    {
        if (self.Order_Type.integerValue == 100 || self.Order_Type.integerValue == 200) // 退款或者退货
        {
            [self setValueCellWithIndex:indexPath Cell:cell];
        }
        else // 投诉
        {
            if (indexPath.row == 0) // 投诉的商品
            {
                cell.Right_PlacherLabel.text = [NSString stringWithFormat:@"%@",self.dataDiction[@"complain"][@"goodsName"]];
            }
            else if (indexPath.row == 1) // 投诉状态
            {
                cell.Right_PlacherLabel.text = [NSString stringWithFormat:@"%@",self.dataDiction[@"complain"][@"complainStateName"]];
            }
            else if (indexPath.row == 2) // 投诉时间
            {
                cell.Right_PlacherLabel.text = [NSString stringWithFormat:@"%@",self.dataDiction[@"complain"][@"accuserTime"]];
            }
            else if (indexPath.row == 3) // 投诉主题
            {
                cell.Right_PlacherLabel.text = [NSString stringWithFormat:@"%@",self.dataDiction[@"complain"][@"subjectTitle"]];
            }
            else if (indexPath.row == 4) // 投诉内容
            {
                cell.Right_PlacherLabel.text = [NSString stringWithFormat:@"%@",self.dataDiction[@"complain"][@"accuserContent"]];
            }
            else if (indexPath.row == 5) // 凭证上传
            {
                NSArray *array = self.dataDiction[@"complain"][@"accuserImagesList"];
                
                for (NSInteger i = 0; i < array.count; i++) {
                    
                    if (i == 0)
                    {
                        [cell.First_ImageView sd_setImageWithURL:[NSURL URLWithString:array[i]]];
                    }
                    else if (i == 1)
                    {
                        [cell.Second_ImageView sd_setImageWithURL:[NSURL URLWithString:array[i]]];
                    }
                    else
                    {
                        [cell.Third_ImageView sd_setImageWithURL:[NSURL URLWithString:array[i]]];
                    }
                }
            }
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString *adminMessage = [NSString stringWithFormat:@"%@",self.dataDiction[@"refundItemVo"][@"adminMessage"]];
    
    HSQLog(@"===%ld",adminMessage.length);
    
}

/**
 * @brief cell控件赋值
 */
- (void)setValueCellWithIndex:(NSIndexPath *)indexPath Cell:(HSQTuiHuoAndMonerydetailListCell *)cell{
    
    // 右边的标题
    if (indexPath.section == 0 && indexPath.row == 0)
    {
        // 订单编号
        cell.Right_PlacherLabel.text = [NSString stringWithFormat:@"%@",self.dataDiction[@"refundItemVo"][@"refundSn"]];
    }
    else if(indexPath.section == 0 && indexPath.row == 1)
    {
        // 退款原因
        cell.Right_PlacherLabel.text = [NSString stringWithFormat:@"%@",self.dataDiction[@"refundItemVo"][@"reasonInfo"]];
    }
    else if (indexPath.section == 0 && indexPath.row == 2)
    {
        // 退款金额
        NSString *refundAmount = [NSString stringWithFormat:@"%@",self.dataDiction[@"refundItemVo"][@"refundAmount"]];
        cell.Right_PlacherLabel.text = [NSString stringWithFormat:@"¥%.2f",refundAmount.floatValue];
    }
    else if (indexPath.section == 0 && indexPath.row == 3)
    {
        // 退款说明
        cell.Right_PlacherLabel.text = [NSString stringWithFormat:@"%@",self.dataDiction[@"refundItemVo"][@"buyerMessage"]];
    }
    else if (indexPath.section == 0 && indexPath.row == 4)
    {
        // 凭证上传
        NSString *uploadRoot = [NSString stringWithFormat:@"%@",self.dataDiction[@"uploadRoot"]];
        
        NSString *picJson = [NSString stringWithFormat:@"%@",self.dataDiction[@"refundItemVo"][@"picJson"]];
        
        if (picJson.length == 0)
        {
            cell.Right_PlacherLabel.text = @"无";
            
            cell.First_ImageView.hidden = cell.Second_ImageView.hidden = cell.Third_ImageView.hidden = YES;
        }
        else
        {
            cell.First_ImageView.hidden = cell.Second_ImageView.hidden = cell.Third_ImageView.hidden = NO;
            
            NSArray *picture_array = [picJson  componentsSeparatedByString:@","];
            
            HSQLog(@"=wodeshuzu==%@",picture_array);
            
            for (NSInteger i = 0; i < picture_array.count; i++) {
                
                NSString *imageSrc = picture_array[i];
                
                if (![imageSrc isEqualToString:@"null"])
                {
                    if (i == 0)
                    {
                        [cell.First_ImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",uploadRoot,imageSrc]] placeholderImage:KGoodsPlacherImage];
                    }
                    else if (i == 1)
                    {
                        [cell.Second_ImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",uploadRoot,imageSrc]] placeholderImage:KGoodsPlacherImage];
                    }
                    else if (i == 2)
                    {
                        [cell.Third_ImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",uploadRoot,imageSrc]] placeholderImage:KGoodsPlacherImage];
                    }
                }
            }
        }
    }
    else if (indexPath.section == 1 && indexPath.row == 0)
    {
        // 审核状态
        cell.Right_PlacherLabel.text = [NSString stringWithFormat:@"%@",self.dataDiction[@"refundItemVo"][@"sellerStateText"]];
    }
    else if  (indexPath.section == 1 && indexPath.row == 1)
    {
        // 商家备注
        NSString *sellerMessage = [NSString stringWithFormat:@"%@",self.dataDiction[@"refundItemVo"][@"sellerMessage"]];
        
        if ([sellerMessage isEqualToString:@"<null>"])
        {
            cell.Right_PlacherLabel.text = @"";
        }
        else
        {
            cell.Right_PlacherLabel.text = sellerMessage;
        }
    }
    else if  (indexPath.section == 2 && indexPath.row == 0)
    {
        // 平台确认
        cell.Right_PlacherLabel.text = [NSString stringWithFormat:@"%@",self.dataDiction[@"refundItemVo"][@"refundStateText"]];
    }
    else if  (indexPath.section == 2 && indexPath.row == 1)
    {
        //平台备注
        NSString *adminMessage = [NSString stringWithFormat:@"%@",self.dataDiction[@"refundItemVo"][@"adminMessage"]];
        
        if ([adminMessage isEqualToString:@"<null>"])
        {
            cell.Right_PlacherLabel.text = @"";
        }
        else
        {
            cell.Right_PlacherLabel.text = adminMessage;
        }
    }
}




@end
