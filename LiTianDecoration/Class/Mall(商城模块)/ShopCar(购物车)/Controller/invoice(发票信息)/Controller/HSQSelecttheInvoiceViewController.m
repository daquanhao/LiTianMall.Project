//
//  HSQSelecttheInvoiceViewController.m
//  LiTianDecoration
//
//  Created by administrator on 2018/6/5.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import "HSQSelecttheInvoiceViewController.h"
#import "HSQInvoiceListModel.h"
#import "HSQAccountTool.h"
#import "HSQinvoiceHeadView.h"
#import "HSQinvoiceFooterView.h"
#import "HSQContentsOfInvoiceView.h"

@interface HSQSelecttheInvoiceViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,HSQinvoiceFooterViewDelegate>

@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, copy) NSString *IsKai; // cell是否显示

@property (nonatomic, copy) NSString *FaPiao_String; // 发票抬头

@property (nonatomic, strong)  HSQInvoiceListModel *model;

@property (nonatomic, copy) NSString *FaPiaoContent_String; // 发票内容

@property (nonatomic, copy) NSString *Type; // 发票的类型

@property (nonatomic, copy) NSString *ShiBieMa; // 发票的识别码

@end

@implementation HSQSelecttheInvoiceViewController

-(NSMutableArray *)dataSource{
    
    if (_dataSource == nil) {
        
        self.dataSource = [NSMutableArray array];
    }
    
    return _dataSource;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.view.backgroundColor = KViewBackGroupColor;
    
    self.navigationItem.title = @"发票信息设置";
    
    self.IsKai = @"200"; // 关闭cell
    
    self.FaPiaoContent_String = @"明细";
    
    // 创建tableView
    [self CreatTableView];
    
    // 发票信息列表
    [self RequestInvoiceInformationListData];
    
}

/**
 * @brief 发票信息列表
 */
- (void)RequestInvoiceInformationListData{
    
    [[HSQProgressHUDManger Manger] ShowLoadingDataFromeServer:@"" ToView:self.view IsClearColor:YES];
    
    NSDictionary *diction = @{@"token":[HSQAccountTool account].token};
    
    AFNetworkRequestTool *requestTool = [AFNetworkRequestTool shareRequestTool];
    
    [requestTool.manger POST:UrlAdress(KFaPiaoListUrl) parameters:diction progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [[HSQProgressHUDManger Manger] DismissProgressHUD];
        
        HSQLog(@"=提交订单==%@",responseObject);
        
        if ([responseObject[@"code"] integerValue] == 200)
        {
            self.dataSource = [HSQInvoiceListModel mj_objectArrayWithKeyValuesArray:responseObject[@"datas"][@"invoiceList"]];
        }
        else
        {
            NSString *errorString = [NSString stringWithFormat:@"%@",responseObject[@"datas"][@"error"]];
            
            [[HSQProgressHUDManger Manger] ShowDisplayFailedToLoadData:errorString SuperView:self.view];
        }
        
        [self.tableView reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [[HSQProgressHUDManger Manger] ShowDisplayFailedToLoadData:@"网络出问题啦！" SuperView:self.view];
        
    }];
    
}


/**
 * @brief 创建tableView
 */
- (void)CreatTableView{
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - KSafeTopeHeight - KSafeBottomHeight ) style:(UITableViewStyleGrouped)];
    
    tableView.backgroundColor = [UIColor clearColor];
    
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    tableView.delegate = self;
    
    tableView.dataSource = self;
    
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];

     [tableView registerNib:[UINib nibWithNibName:@"HSQinvoiceHeadView" bundle:nil] forHeaderFooterViewReuseIdentifier:@"HSQinvoiceHeadView"];

    [tableView registerNib:[UINib nibWithNibName:@"HSQinvoiceFooterView" bundle:nil] forHeaderFooterViewReuseIdentifier:@"HSQinvoiceFooterView"];
    
    [self.view addSubview:tableView];
    
    self.tableView = tableView;
    
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
    
    if (self.IsKai.integerValue == 200)
    {
        return 0;
    }
    else
    {
        return self.dataSource.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section{
    
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 50;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    HSQinvoiceHeadView *HeaderView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"HSQinvoiceHeadView"];
    
    if (self.model.title.length != 0)
    {
        HeaderView.FaPiaoTitle_TextField.text = self.model.title;
    }
    else
    {
        if (self.FaPiao_String.length == 0)
        {
            HeaderView.FaPiaoTitle_TextField.text = @"个人";
        }
        else
        {
            HeaderView.FaPiaoTitle_TextField.text = self.FaPiao_String;
        }
    }
    
    self.FaPiao_String = HeaderView.FaPiaoTitle_TextField.text;
    
    HeaderView.FaPiaoTitle_TextField.delegate = self;
    
    [HeaderView.FaPiaoTitle_TextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];

    return HeaderView;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForFooterInSection:(NSInteger)section{
    
    return 150;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 150;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    HSQinvoiceFooterView *FooterView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"HSQinvoiceFooterView"];
    
    FooterView.delegate = self;
    
    FooterView.FaPiaoContent_Label.text = [NSString stringWithFormat:@"%@",self.FaPiaoContent_String];
    
    if (self.Type.integerValue == 1) // 不需要发票
    {
        FooterView.NoUserFaPiao_Button.selected = YES;
        FooterView.SavePiao_Button.selected = NO;
    }
    else
    {
        FooterView.NoUserFaPiao_Button.selected = NO;
        FooterView.SavePiao_Button.selected = YES;
    }
    
    // 识别码
    if (self.model.code.length != 0)
    {
        FooterView.ShiBieMa_TextField.text = self.model.code;
    }
    else
    {
        FooterView.ShiBieMa_TextField.text = (self.ShiBieMa.length == 0 ? @"":self.ShiBieMa);
    }
    
    return FooterView;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    
    if (self.dataSource.count != 0)
    {
        HSQInvoiceListModel *model = self.dataSource[indexPath.row];
        
        cell.textLabel.text = model.title;
        
        cell.textLabel.font = [UIFont systemFontOfSize:14.0];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    HSQInvoiceListModel *model = self.dataSource[indexPath.row];
    
    self.model = model;
    
    self.IsKai = @"200"; // 关闭cell
    
    [self.tableView reloadData];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    
    return YES;
}

-(BOOL)textFieldShouldClear:(UITextField *)textField{
    
    HSQinvoiceHeadView *headView = (HSQinvoiceHeadView *)textField.superview;
    
    headView.FaPiaoTitle_TextField.text = @"";
    
    return YES;
}

-(void)textFieldDidChange:(UITextField *)textField{
    
    HSQLog(@"==%@",textField.text);
    
    if (textField.text.length == 0)
    {
        self.IsKai = @"100"; // 打开cell
    }
    else
    {
        self.IsKai = @"200"; // 关闭cell
    }
    
    [self.tableView reloadData];
}

/**
 * @brief 不使用发票
 */
- (void)ClickEventsThatDoNotUseTheInvoiceButton:(UIButton *)sender{
    
    NSMutableDictionary *diction = [NSMutableDictionary dictionary];
    diction[@"type"] = @"1";
    
    HSQinvoiceFooterView *footerView = (HSQinvoiceFooterView *)sender.superview.superview;
    
     footerView.NoUserFaPiao_Button.selected = YES;
    
    if (self.SelectFaPiaoDataBlock) {
        
        self.SelectFaPiaoDataBlock(diction);
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 * @brief 保存并使用发票KAddFapiaoUrl
 */
- (void)SaveAndUseTheClickEventOfTheInvoiceButton:(UIButton *)sender{
    
    HSQinvoiceFooterView *footerView = (HSQinvoiceFooterView *)sender.superview.superview;
    
    footerView.SavePiao_Button.selected = YES;
    
    [[HSQProgressHUDManger Manger] ShowLoadingDataFromeServer:@"" ToView:self.view IsClearColor:YES];
    
    NSDictionary *diction = @{@"token":[HSQAccountTool account].token,@"title":self.FaPiao_String,@"code":footerView.ShiBieMa_TextField.text};
    
    HSQLog(@"==参数=%@",diction);
    
    AFNetworkRequestTool *requestTool = [AFNetworkRequestTool shareRequestTool];
    
    [requestTool.manger POST:UrlAdress(KFaPiaoListUrl) parameters:diction progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [[HSQProgressHUDManger Manger] DismissProgressHUD];
        
        HSQLog(@"=保存发票==%@",responseObject);
        
        if ([responseObject[@"code"] integerValue] == 200)
        {
            NSMutableDictionary *diction = [NSMutableDictionary dictionary];
            diction[@"type"] = @"2";
            diction[@"title"] = self.FaPiao_String;
            diction[@"code"] = footerView.ShiBieMa_TextField.text;
            diction[@"content"] = self.FaPiaoContent_String;
            
            if (self.SelectFaPiaoDataBlock) {
                
                self.SelectFaPiaoDataBlock(diction);
            }
            
             [self.navigationController popViewControllerAnimated:YES];
        }
        else
        {
            NSString *errorString = [NSString stringWithFormat:@"%@",responseObject[@"datas"][@"error"]];
            
            [[HSQProgressHUDManger Manger] ShowDisplayFailedToLoadData:errorString SuperView:self.view];
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [[HSQProgressHUDManger Manger] ShowDisplayFailedToLoadData:@"网络出问题啦！" SuperView:self.view];
        
    }];
    
}

/**
 * @brief 选择发票的内容
 */
- (void)SelectTheContentOfTheInvoiceBtnClickAction:(UIButton *)sender{
    
    HSQContentsOfInvoiceView *ContentsOfInvoiceView = [HSQContentsOfInvoiceView initContentsOfInvoiceView];
    
    ContentsOfInvoiceView.FaPiaoContent_String = self.FaPiaoContent_String;
    
    ContentsOfInvoiceView.SelectFaPiaoContentDataBlock = ^(NSString *Conent) {
       
        self.FaPiaoContent_String = Conent;
        
        [self.tableView reloadData];
    };
    
    [ContentsOfInvoiceView ShowContentsOfInvoiceView];
}

/**
 * @brief 发票的内容
 */
- (void)setFaPiaoDiction:(NSMutableDictionary *)FaPiaoDiction{
    
    _FaPiaoDiction = FaPiaoDiction;
    
    self.Type = [NSString stringWithFormat:@"%@",FaPiaoDiction[@"type"]];
    
    if (self.Type.integerValue != 1)
    {
        self.FaPiao_String = [NSString stringWithFormat:@"%@",FaPiaoDiction[@"title"]];
        
        self.ShiBieMa = [NSString stringWithFormat:@"%@",FaPiaoDiction[@"code"]];
        
        self.FaPiaoContent_String = [NSString stringWithFormat:@"%@",FaPiaoDiction[@"content"]];
    }
    
    [self.tableView reloadData];
}








@end
