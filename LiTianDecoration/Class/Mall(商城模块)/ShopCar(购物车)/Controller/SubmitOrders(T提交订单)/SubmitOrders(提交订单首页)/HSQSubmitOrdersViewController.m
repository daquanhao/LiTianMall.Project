//
//  HSQSubmitOrdersViewController.m
//  LiTianDecoration
//
//  Created by administrator on 2018/5/23.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import "HSQSubmitOrdersViewController.h"
#import "HSQAccountTool.h"
#import "HSQHeadSendAdressCell.h"
#import "HSQAdressListViewController.h"
#import "HSQAcceptAddressListModel.h"
#import "HSQSubmitOrderHeaderView.h"
#import "HSQSubmitOrderFooterView.h"
#import "HSQSubmitOrderGoodsListCell.h"
#import "HSQShopCarGoodsGuiGeListView.h"
#import "HSQShopCarVCGoodsDataModel.h"
#import "HSQShopCarGoodsTypeListModel.h"
#import "HSQSubmitOrderHeadAdressView.h"
#import "HSQSubmitCouperListView.h"
#import "HSQSubmitOrderSelectCouperModel.h"
#import "HSQSelecttheInvoiceViewController.h"  // 发票明细
#import "HSQAvailableToPayTypeView.h"  // 可用的支付方式
#import "HSQMyOrderHomeViewController.h"  // 全部的订单
#import "HSQPayMonerySuccessViewController.h" // 支付成功的界面

@interface HSQSubmitOrdersViewController ()<UITableViewDelegate,UITableViewDataSource,HSQSubmitOrderHeadAdressViewDelegate,HSQSubmitOrderFooterViewDelegate,UITextViewDelegate,HSQAvailableToPayTypeViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *TotalMonery_Label; // 总的金额

@property (weak, nonatomic) IBOutlet UIButton *SubmitOrderBtn; // 提交订单的按钮

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ViewBottomLayOut;

@property (nonatomic, strong) UITableView *TableView;

@property (nonatomic, strong) NSMutableArray *adressSource;

@property (nonatomic, strong) NSDictionary *dataDiction;

@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, strong) HSQSubmitOrderHeadAdressView *HeadAdressView;

@property (nonatomic, assign) CGRect Orgin_Frame;

@property (nonatomic, strong) NSMutableArray *YunFei_Array; // 运费数组

@property (nonatomic, copy) NSString *SelectCouper_String; // 选中的优惠券

@property (nonatomic, strong) NSMutableArray *SelectCouperDataSourcen; // 选中的优惠券的数据

@property (nonatomic, strong) NSMutableDictionary *SelectCouper_Diction; // 选中的优惠券的数据

@property (nonatomic, strong) NSMutableDictionary *FaPiaoDiction; // 发票的信息

@property (nonatomic, copy) NSString *addressId;  // 地址的id

@property (nonatomic, copy) NSString *GoodsTotalMonery;  // 商品的总金额

@property (nonatomic, strong) HSQAvailableToPayTypeView *AvailableToPayTypeView; // 可用的支付方式

@property (nonatomic, copy) NSString *payId;  // 支付id

@end

@implementation HSQSubmitOrdersViewController

-(NSMutableArray *)SelectCouperDataSourcen{
    
    if (_SelectCouperDataSourcen == nil) {
        
        self.SelectCouperDataSourcen = [NSMutableArray array];
    }
    
    return _SelectCouperDataSourcen;
}

-(NSMutableArray *)adressSource{
    
    if (_adressSource == nil) {
        
        self.adressSource = [NSMutableArray array];
    }
    
    return _adressSource;
}

-(NSMutableArray *)dataSource{
    
    if (_dataSource == nil) {
        
        self.dataSource = [NSMutableArray array];
    }
    
    return _dataSource;
}

- (NSMutableArray *)YunFei_Array{
    
    if (_YunFei_Array == nil) {
        
        self.YunFei_Array = [NSMutableArray array];
    }
    
    return _YunFei_Array;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.view.backgroundColor = KViewBackGroupColor;
    
    self.navigationItem.title = @"确认订单";
    
    self.ViewBottomLayOut.constant = KSafeBottomHeight;
    
    self.dataDiction = [NSDictionary dictionary];
    
    self.SelectCouper_Diction = [NSMutableDictionary dictionary];
        
    self.FaPiaoDiction = [NSMutableDictionary dictionary];
    self.FaPiaoDiction[@"type"] = @"1";
    self.FaPiaoDiction[@"title"] = @"";
    self.FaPiaoDiction[@"code"] = @"";
    self.FaPiaoDiction[@"content"] = @"";
    
    // 创建tableView
    [self CreatTableView];
    
    // 1.请求确认订单的数据
    [self RequestConfirmationOfTheOrderData];

}

/**
 * @brief 请求确认订单的数据
 */
- (void)RequestConfirmationOfTheOrderData{
    
    [[HSQProgressHUDManger Manger] ShowLoadingDataFromeServer:@"" ToView:self.view IsClearColor:YES];
    
    HSQAccount *account = [HSQAccountTool account];
    
    NSDictionary *diction = @{@"token":account.token,@"clientType":KClientType,@"buyData":self.buyData,@"isCart":self.isCart,@"isExistBundling":self.isExistBundling,@"isGroup":self.isGroup};
    
    AFNetworkRequestTool *requestTool = [AFNetworkRequestTool shareRequestTool];
    
    [requestTool.manger POST:UrlAdress(KBuyGoodsFirstBuUrl) parameters:diction progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [[HSQProgressHUDManger Manger] DismissProgressHUD];
        
        HSQLog(@"=提交订单==%@",responseObject);
        
        if ([responseObject[@"code"] integerValue] == 200)
        {
            self.dataDiction = responseObject[@"datas"];
            
            // 配送的地址
            [self SetValueAdressModelDataWithDiction:responseObject];
            
            // 取出商品的列表数据
            [self SetValueModelWithDiction:responseObject[@"datas"][@"buyStoreVoList"]];
            
            // 请求运费
            [self ReturnBuyDataWithRequestData:responseObject[@"datas"]];
            
            // 优惠券的数据
            [self CouperDataWithRequestData:responseObject[@"datas"]];
        }
        else
        {
            NSString *errorString = [NSString stringWithFormat:@"%@",responseObject[@"datas"][@"error"]];
            
            [[HSQProgressHUDManger Manger] ShowDisplayFailedToLoadData:errorString SuperView:self.view];
        }
        
        [self.TableView reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [[HSQProgressHUDManger Manger] ShowDisplayFailedToLoadData:@"数据加载失败" SuperView:self.view];
        
    }];
}

/**
 * @brief 取出数据地址
 */
- (void)SetValueAdressModelDataWithDiction:(NSDictionary *)responseObject{
    
    HSQAcceptAddressListModel *adressModel = [[HSQAcceptAddressListModel alloc] init];
    
    if (responseObject[@"datas"][@"address"] != [NSNull null]) // 说明有配送地址
    {
        // 取出配送的地址
        NSDictionary *address = responseObject[@"datas"][@"address"];
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
    
    self.TableView.contentInset = UIEdgeInsetsMake( self.Orgin_Frame.size.height, 0, 0, 0);
}

/**
 * @brief 取出商品的列表数据
 */
- (void)SetValueModelWithDiction:(NSDictionary *)requestData{
    
    // 中间的规格列表
    for (NSDictionary *dict in requestData){
        
        // 外层数据 有多少个店铺
        HSQShopCarVCGoodsDataModel *ShopCarVCGoodsDataModel = [[HSQShopCarVCGoodsDataModel alloc] initWithDictionary:dict error:nil];
        
        ShopCarVCGoodsDataModel.buyGoodsSpuVoList = [NSMutableArray array];
        
        [self.dataSource addObject:ShopCarVCGoodsDataModel];
        
        // 内层数据 每个店铺有几个商品
        for (NSInteger i = 0; i < [dict[@"buyGoodsSpuVoList"] count] ; i++) {
            
            NSDictionary *ModelDiction = dict[@"buyGoodsSpuVoList"][i];
            
            HSQShopCarVCSecondGoodsDataModel *ListModel = [[HSQShopCarVCSecondGoodsDataModel alloc] init];
            
            ListModel.buyGoodsItemVoListSource = [NSMutableArray array];
            
            [ListModel setValuesForKeysWithDictionary:ModelDiction];
            
            [ShopCarVCGoodsDataModel.buyGoodsSpuVoList addObject:ListModel];
            
            // 每个商品下有几种规格
            for (NSDictionary *ThirdDiction in ModelDiction[@"buyGoodsItemVoList"]) {
                
                HSQShopCarGoodsTypeListModel *ThirdModel = [[HSQShopCarGoodsTypeListModel alloc] init];
                
                [ThirdModel setValuesForKeysWithDictionary:ThirdDiction];
                
                [ListModel.buyGoodsItemVoListSource addObject:ThirdModel];
                
            }
        }
    }
}

/**
 * @brief 取出优惠券的数据
 */
- (void)CouperDataWithRequestData:(NSDictionary *)responseObject{
    
    NSArray *array = responseObject[@"buyStoreVoList"];
    
    for (NSInteger i = 0; i < array.count; i++) {
        
        HSQSubmitOrderSelectCouperModel *model = [[HSQSubmitOrderSelectCouperModel alloc] init];
        model.IsSelect = @"0";
        model.couper_Source = [NSMutableArray array];
        
        [self.SelectCouperDataSourcen addObject:model];
    }
}


/**
 * @brief 创建tableView
 */
- (void)CreatTableView{
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - KSafeTopeHeight - KSafeBottomHeight - 50) style:(UITableViewStyleGrouped)];
    
    tableView.backgroundColor = [UIColor clearColor];
    
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    tableView.delegate = self;
    
    tableView.dataSource = self;
    
    [tableView registerClass:[HSQSubmitOrderGoodsListCell class] forCellReuseIdentifier:@"HSQSubmitOrderGoodsListCell"];
    
    [tableView registerClass:[HSQSubmitOrderHeaderView class] forHeaderFooterViewReuseIdentifier:@"HSQSubmitOrderHeaderView"];
    
    [tableView registerNib:[UINib nibWithNibName:@"HSQSubmitOrderFooterView" bundle:nil] forHeaderFooterViewReuseIdentifier:@"HSQSubmitOrderFooterView"];
        
    [self.view addSubview:tableView];
    
    self.TableView = tableView;
    
    // 顶部的收货地址
    HSQSubmitOrderHeadAdressView *HeadAdressView = [[HSQSubmitOrderHeadAdressView alloc] init];
    HeadAdressView.delegate = self;
    [self.view addSubview:HeadAdressView];
    self.HeadAdressView = HeadAdressView;
    
}


/**
 * @brief 收货地址与商品信息组成的json串。
 */
- (void)ReturnBuyDataWithRequestData:(NSDictionary *)responseObject{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
   
    if (responseObject[@"datas"][@"address"] != [NSNull null]) // 没有地址，这时不能请求运费
    {
        // 设置配送的地址
         params[@"addressId"] = responseObject[@"address"][@"addressId"];
    }
    
    //店铺列表
    NSMutableArray *storeList = [NSMutableArray array];
    
    for (NSDictionary *diction in responseObject[@"buyStoreVoList"]) {
        
        //店铺列表数据
        NSMutableDictionary *storeList_Diction = [NSMutableDictionary dictionary];
        storeList_Diction[@"storeId"] = diction[@"storeId"];
        
        // 商品数组
        NSMutableArray *goodsList = [NSMutableArray array];
        
        for (NSDictionary *GoodsDiction in diction[@"buyGoodsItemVoList"]) {
            
            NSMutableDictionary *goodsList_diction = [NSMutableDictionary dictionary];
            goodsList_diction[@"goodsId"] = GoodsDiction[@"goodsId"];
            goodsList_diction[@"buyNum"] = GoodsDiction[@"buyNum"];
            [goodsList addObject:goodsList_diction];
        }
        
        storeList_Diction[@"goodsList"] = goodsList;
        
        [storeList addObject:storeList_Diction];
    }
    
    params[@"storeList"] = storeList;

    
    NSString *buyData = [NSString toJSONDataString:params];
    
    if (responseObject[@"datas"][@"address"] != [NSNull null]) // 没有地址，这时不能请求运费
    {
        [self CalculateTheFreightWithGroup:@"1" buyData:buyData];
    }
}

/**
 * @brief 计算运费
 * @param isGroup 是否拼团 1–是 0–否
 */
- (void)CalculateTheFreightWithGroup:(NSString *)isGroup buyData:(NSString *)buyData{
    
    [[HSQProgressHUDManger Manger] ShowLoadingDataFromeServer:@"" ToView:self.view IsClearColor:YES];
    
    HSQAccount *account = [HSQAccountTool account];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"token"] = account.token;
    params[@"clientType"] = KClientType;
    params[@"isGroup"] = isGroup;
    params[@"buyData"] = buyData;
    
    AFNetworkRequestTool *requestTool = [AFNetworkRequestTool shareRequestTool];
    
    [requestTool.manger POST:UrlAdress(KBuyGoodsSecondBuUrl) parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [[HSQProgressHUDManger Manger] DismissProgressHUD];
        
        if ([responseObject[@"code"] integerValue] == 200)
        {
            // 运费
            [self.YunFei_Array addObjectsFromArray:responseObject[@"datas"][@"storeList"]];
            
            // 计算总的商品金额
            CGFloat Totalmonery = 0;
            
            for (NSInteger i = 0; i < self.dataSource.count; i++) {
                
                HSQShopCarVCGoodsDataModel *shopcarModel = self.dataSource[i];
                
                NSDictionary *storeFreightAmount_diction = self.YunFei_Array[i];
                
                NSString *storeFreightAmount = [NSString stringWithFormat:@"%@",storeFreightAmount_diction[@"storeFreightAmount"]];
                
                Totalmonery = Totalmonery + shopcarModel.buyItemAmount.floatValue + storeFreightAmount.floatValue;
            }
            
            NSString *GoodsTotalMonery = [NSString stringWithFormat:@"  ¥%.2f  ",Totalmonery];
            
            self.GoodsTotalMonery = [NSString stringWithFormat:@"%.2f",Totalmonery];
            
            NSString *GoodsMonery = [NSString stringWithFormat:@"实付金额%@(含运费)",GoodsTotalMonery];
            
            NSRange range = NSMakeRange(4, GoodsTotalMonery.length);
            
            NSMutableAttributedString *attribe_string = [NSString attributedStringWithString:GoodsMonery font:[UIFont systemFontOfSize:16.0] color:RGB(258, 58, 68) ColorRange:range FontRang:range];
            
            self.TotalMonery_Label.attributedText = attribe_string;
            
        }
        
        [self.TableView reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        
    }];

}


#pragma mark **********************************************************************************************************************************************************************

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate,UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    HSQShopCarVCGoodsDataModel *model = self.dataSource[section];
    
    return model.buyGoodsSpuVoList.count;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section{
    
     return 45;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 45;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    HSQSubmitOrderHeaderView *HeaderView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"HSQSubmitOrderHeaderView"];
    
     HSQShopCarVCGoodsDataModel *model = self.dataSource[section];
    
    HeaderView.model = model;
    
    return HeaderView;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForFooterInSection:(NSInteger)section{
    
    return 310;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 310;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    HSQSubmitOrderFooterView *FooterView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"HSQSubmitOrderFooterView"];
    
    FooterView.delegate = self;
    
    if (self.YunFei_Array.count != 0)
    {
        FooterView.diction = self.YunFei_Array[section];
    }
    
    FooterView.textView.delegate = self;
    
    FooterView.Section = [NSString stringWithFormat:@"%ld",section];

    // 选择的优惠券
    HSQSubmitOrderSelectCouperModel *couperModel = self.SelectCouperDataSourcen[section];
    
    if (couperModel.IsSelect.integerValue != 0)
    {
        NSDictionary *dataDiction = couperModel.couper_Source[0];
         FooterView.YouHuiContent_Label.text = [NSString stringWithFormat:@"参加%@%@",dataDiction[@"conformName"],dataDiction[@"shortRule"]];
    }
    else
    {
        FooterView.YouHuiContent_Label.text = @"不使用优惠券";
    }
    
    // 选中的发票
    NSString *type = [NSString stringWithFormat:@"%@",self.FaPiaoDiction[@"type"]];
    
    if (type.integerValue == 1)
    {
        FooterView.FaPiaoInfo_Label.text = @"不需要发票";
    }
    else
    {
        FooterView.FaPiaoInfo_Label.text = [NSString stringWithFormat:@"普通发票 %@ %@",self.FaPiaoDiction[@"title"],self.FaPiaoDiction[@"content"]];
    }
    
    // 金额小计
    HSQShopCarVCGoodsDataModel *model = self.dataSource[section];
    
    FooterView.ShopCarModel = model;
    
    return FooterView;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 90;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    HSQShopCarVCGoodsDataModel *model = self.dataSource[indexPath.section];
    
    HSQShopCarVCSecondGoodsDataModel *SecondModel = model.buyGoodsSpuVoList[indexPath.row];
    
    CGSize photosSize = [HSQShopCarGoodsGuiGeListView SizeWithDataModelArray:SecondModel.buyGoodsItemVoListSource];
    
    return KGoodsImageShopCaHeight + 40 + photosSize.height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    HSQSubmitOrderGoodsListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HSQSubmitOrderGoodsListCell" forIndexPath:indexPath];
    
    HSQShopCarVCGoodsDataModel *model = self.dataSource[indexPath.section];
    
    cell.SecondModel = model.buyGoodsSpuVoList[indexPath.row];
    
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
            
            self.TableView.contentInset = UIEdgeInsetsMake( self.Orgin_Frame.size.height, 0, 0, 0);
            [self.TableView reloadData];
            
           // 计算运费
            [self ReturnBuyDataWithRequestData:self.dataDiction];
        };

        [self.navigationController pushViewController:AdressListVC animated:YES];
}

/**
 * @brief 选择用户的优惠券
 */
- (void)ChooseABusinessDiscountButtonClickAction:(UIButton *)sender{
    
    HSQSubmitOrderFooterView *footerView = (HSQSubmitOrderFooterView *)sender.superview.superview;
    
     HSQShopCarVCGoodsDataModel *model = self.dataSource[footerView.Section.integerValue];
    
    // 优惠券的数据模型
    HSQSubmitOrderSelectCouperModel *CouperModel = self.SelectCouperDataSourcen[footerView.Section.integerValue];
    
    // 优惠券的展示界面
    HSQSubmitCouperListView *coupListView = [HSQSubmitCouperListView initSubmitCouperListView];
    
    [coupListView SetValueDataWithArray:model.conformList Select_Index:self.SelectCouper_String];
    
    coupListView.SelectCouperDataBlock = ^(NSIndexPath *indexPath) {
                
        if (indexPath.row == 0)
        {
            CouperModel.IsSelect = @"0";
            [CouperModel.couper_Source removeAllObjects];
            self.SelectCouper_String = @"-200";
        }
        else
        {
             CouperModel.IsSelect = @"1";
            
             [CouperModel.couper_Source removeAllObjects];
            
            NSDictionary *dict = model.conformList[indexPath.row - 1];
            
            self.SelectCouper_String = [NSString stringWithFormat:@"%@",dict[@"conformId"]];
            
            [CouperModel.couper_Source addObject:dict];
            
            model.conformId = [NSString stringWithFormat:@"%@",dict[@"conformId"]];
        }
        
        [self.TableView reloadData];
        
    };
    
    [coupListView ShowSubmitCouperListView];

}

/**
 * @brief 买家留言
 */
- (void)textViewDidEndEditing:(UITextView *)textView{
    
    HSQSubmitOrderFooterView *footerView = (HSQSubmitOrderFooterView *)textView.superview.superview.superview;
    
    HSQLog(@"===编辑结束==%@===%@",footerView.Section,textView.text);
    
    HSQShopCarVCGoodsDataModel *firstModel = self.dataSource[footerView.Section.integerValue];
    
    firstModel.receiverMessage = textView.text;
}

/**
 * @brief 选择发票信息
 */
- (void)SelectInvoiceInformationBtnClickAction:(UIButton *)sender{
    
    HSQSelecttheInvoiceViewController *InvoiceInformationVC = [[HSQSelecttheInvoiceViewController alloc] init];

    InvoiceInformationVC.FaPiaoDiction = self.FaPiaoDiction;
    
    InvoiceInformationVC.SelectFaPiaoDataBlock = ^(NSMutableDictionary *diction) {
        
        self.FaPiaoDiction = diction;
        
        [self.TableView reloadData];
    };

    [self.navigationController pushViewController:InvoiceInformationVC animated:YES];

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
    
    // 计算剩余文字的个数
    [self jisuanCountTextWithTextView:textView];
    
}

/**
 * @brief  计算输入框的文字个数
 */
- (void)jisuanCountTextWithTextView:(UITextView *)textView{
    
    bool isChinese;//判断当前输入法是否是中文
    
    if ([[[UIApplication sharedApplication]textInputMode].primaryLanguage isEqualToString: @"en-US"]) {
        
        isChinese = false;
        
    }else{
        
        isChinese = true;
        
    }
    
    NSString *str = [[textView text] stringByReplacingOccurrencesOfString:@"?" withString:@""];
    
    if (isChinese) { //中文输入法下
        
        UITextRange *selectedRange = [textView markedTextRange];
        
        //获取高亮部分
        UITextPosition *position = [textView positionFromPosition:selectedRange.start offset:0];
        
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            
//            NSString *string = textView.text;
//            NSInteger number = [string length];
//            NSInteger count = 100-number;
//            self.countLabel.text = [NSString stringWithFormat:@"%ld",(long)count]; // 计算剩余文字
            
            if ( str.length>=100) {
                
                NSString *strNew = [NSString stringWithString:str];
                
                [textView setText:[strNew substringToIndex:100]];
                
//                self.countLabel.text = @"0";
                [[HSQProgressHUDManger Manger] ShowProgressHUDPromptText:@"最多输入100字" SupView:self.view];
                
            }
        }
        
    }else{
        
//        NSString *string = textView.text;
//        NSInteger number = [string length];
//        NSInteger count = 100-number;
//        self.countLabel.text = [NSString stringWithFormat:@"%ld",(long)count]; // 计算剩余文字
        
        if ([str length]>=100) {
            
            NSString *strNew = [NSString stringWithString:str];
            
            [textView setText:[strNew substringToIndex:100]];
            
//            self.countLabel.text = @"200";
            [[HSQProgressHUDManger Manger] ShowProgressHUDPromptText:@"最多输入100字" SupView:self.view];
            
        }
    }
}

/**
 * @brief 提交订单的按钮的点击事件
 */
- (IBAction)SubmitOrderBtnClickAction:(UIButton *)sender {
    
    if (self.dataDiction[@"address"] == [NSNull null]) // 说明没有配送地址
    {
        [[HSQProgressHUDManger Manger] ShowProgressHUDPromptText:@"请选择您的收货地址" SupView:self.view];
    }
    else
    {
        // 店铺数组
        NSMutableDictionary *Submit_Params = [NSMutableDictionary dictionary];

        // 店铺数组
        NSMutableArray *storeList = [NSMutableArray array];

        for (HSQShopCarVCGoodsDataModel *FirstModel in self.dataSource) {

            // 店铺的参数
            NSMutableDictionary *Store_params = [NSMutableDictionary dictionary];

            // 商品数组
            NSMutableArray *goodsList = [NSMutableArray array];

            for (HSQShopCarVCSecondGoodsDataModel *secondModel in FirstModel.buyGoodsSpuVoList) {

                for (HSQShopCarGoodsTypeListModel *ThirdModel in secondModel.buyGoodsItemVoListSource) {

                    // 商品的参数
                    NSMutableDictionary *Goods_params = [NSMutableDictionary dictionary];

                    Goods_params[@"buyNum"] = ThirdModel.buyNum;

                    if (self.isCart.integerValue == 1) // 来源于购物车
                    {
                        Goods_params[@"cartId"] = ThirdModel.cartId;
                    }
                    else // 来源于立即购买
                    {
                        Goods_params[@"goodsId"] = ThirdModel.goodsId;
                    }

                    [goodsList addObject:Goods_params];
                }
            }

            Store_params[@"goodsList"] = goodsList;
            Store_params[@"storeId"] = FirstModel.storeId;
            Store_params[@"receiverMessage"] = FirstModel.receiverMessage;  // 买家留言
            Store_params[@"conformId"] = (FirstModel.conformId.length == 0 ? @"":FirstModel.conformId);  // 优惠活动id
            Store_params[@"voucherId"] = @"";  // 优惠券Id,可为空

            [storeList addObject:Store_params];

        }

        Submit_Params[@"storeList"] = storeList;
        Submit_Params[@"addressId"] = self.addressId;

        // 是否有货到付款
        NSString *allowOffline = [NSString stringWithFormat:@"%@",self.dataDiction[@"allowOffline"]];

        if (allowOffline.integerValue == 0)
        {
            Submit_Params[@"paymentTypeCode"] = @"online"; // 支付方式--在线支付
        }
        else
        {
            Submit_Params[@"paymentTypeCode"] = @"offline"; // 支付方式--货到付款
        }
        Submit_Params[@"isCart"] = [NSString stringWithFormat:@"%@",self.dataDiction[@"isCart"]]; //  是否来源于购物车（1–是 0–否）,必填
        Submit_Params[@"isGroup"] = [NSString stringWithFormat:@"%@",self.dataDiction[@"isGroup"]]; //  是否是团购商品

        // 判断是不是有发票
        NSString *type = [NSString stringWithFormat:@"%@",self.FaPiaoDiction[@"type"]];

        if (type.integerValue == 1)
        {
            Submit_Params[@"invoiceTitle"] = @""; //  发票抬头
            Submit_Params[@"invoiceContent"] = @""; //  发票内容
            Submit_Params[@"invoiceCode"] = @""; //  纳税人识别号
        }
        else
        {
            Submit_Params[@"invoiceTitle"] = [NSString stringWithFormat:@"%@",self.FaPiaoDiction[@"title"]];//  发票抬头
            Submit_Params[@"invoiceContent"] = [NSString stringWithFormat:@"%@",self.FaPiaoDiction[@"content"]]; //  发票内容
            Submit_Params[@"invoiceCode"] = [NSString stringWithFormat:@"%@",self.FaPiaoDiction[@"code"]]; //  纳税人识别号
        }

        Submit_Params[@"redPackageId"] = @""; //  红包Id,选填，不使用时留空
        Submit_Params[@"isExistTrys"] = [NSString stringWithFormat:@"%@",self.dataDiction[@"isExistTrys"]];; //  是否含有拥有试用资格的商品。由buy/step1接口返回不作更改原样提交
        Submit_Params[@"isExistBundling"] = @"0"; // 购买的商品是否含有优惠套装（1–是 0–否）

        NSString *buyData = [NSString toJSONDataString:Submit_Params];

        // 保存生成订单
        [self SaveTheGeneratedOrderWithString:buyData];
    }
}

/**
 * @brief 保存生成订单
 */
- (void)SaveTheGeneratedOrderWithString:(NSString *)buyData{
    
    [[HSQProgressHUDManger Manger] ShowLoadingDataFromeServer:@"" ToView:self.view IsClearColor:YES];
    
    NSDictionary *params = @{@"token":[HSQAccountTool account].token,@"clientType":KClientType,@"buyData":buyData};
    
    AFNetworkRequestTool *requestTool = [AFNetworkRequestTool shareRequestTool];
    
    [requestTool.manger POST:UrlAdress(KBuySetup2Url) parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [[HSQProgressHUDManger Manger] DismissProgressHUD];
        
        HSQLog(@"===提交的订单=%@",responseObject);
        
        if ([responseObject[@"code"] integerValue] == 200)
        {
            // 支付id
            NSString *payId = [NSString stringWithFormat:@"%@",responseObject[@"datas"][@"payId"]];
            
            // 获取可用的支付方式
            [self GetsAListOfPaymentOptionsAvailable:payId];
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
 * @brief 获取可用支付方式列表
 */
- (void)GetsAListOfPaymentOptionsAvailable:(NSString *)payId{
    
    [[HSQProgressHUDManger Manger] ShowLoadingDataFromeServer:@"" ToView:self.view IsClearColor:YES];
    
    NSDictionary *params = @{@"token":[HSQAccountTool account].token,@"clientType":@"app",@"payId":payId};
    
    AFNetworkRequestTool *requestTool = [AFNetworkRequestTool shareRequestTool];
    
    [requestTool.manger POST:UrlAdress(KGetUserPayTypeListUrl) parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [[HSQProgressHUDManger Manger] DismissProgressHUD];
        
        HSQLog(@"===获取可用支付方式列表=%@",responseObject);
        
        if ([responseObject[@"code"] integerValue] == 200)
        {
            HSQAvailableToPayTypeView *AvailableToPayTypeView = [[[NSBundle mainBundle] loadNibNamed:@"HSQAvailableToPayTypeView" owner:self options:nil] firstObject];
            
            AvailableToPayTypeView.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight - KSafeBottomHeight);
            
            AvailableToPayTypeView.datas = responseObject[@"datas"];
            
            AvailableToPayTypeView.delegate = self;
            
            [[UIApplication sharedApplication].keyWindow addSubview:AvailableToPayTypeView];
            
            self.AvailableToPayTypeView = AvailableToPayTypeView;
            
            // 支付单Id
            self.payId = [NSString stringWithFormat:@"%@",responseObject[@"datas"][@"payId"]];
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
 * @brief 稍后支付按钮的点击事件
 */
- (void)TheClickEventOfThePayButtonLater:(UIButton *)sender{
    
    [UIView animateWithDuration:0.25 animations:^{
        
        self.AvailableToPayTypeView.hidden = YES;
        
    }completion:^(BOOL finished) {
        
        [self.AvailableToPayTypeView removeFromSuperview];
        
        HSQMyOrderHomeViewController *MyOrderHomeVC = [[HSQMyOrderHomeViewController alloc] init];

        MyOrderHomeVC.indexNumber = @"0";

        MyOrderHomeVC.JumpType_string = @"100";

        [self.navigationController pushViewController:MyOrderHomeVC animated:YES];
        
    }];
}

/**
 * @brief 确认支付按钮的点击事件
 */
- (void)ConfirmTheClickEventOfThePaymentButton:(UIButton *)sender PassWord:(NSString *)PayPassWord{
    
    [UIView animateWithDuration:0.25 animations:^{
        
        self.AvailableToPayTypeView.hidden = YES;
        
    }completion:^(BOOL finished) {
        
        [self.AvailableToPayTypeView removeFromSuperview];
    }];
    
    [[HSQProgressHUDManger Manger] ShowLoadingDataFromeServer:@"" ToView:self.view IsClearColor:YES];
    
    NSDictionary *params = @{@"token":[HSQAccountTool account].token,@"payId":self.payId,@"predepositPay":@"1",@"payPwd":PayPassWord};
    
    AFNetworkRequestTool *requestTool = [AFNetworkRequestTool shareRequestTool];
    
    [requestTool.manger POST:UrlAdress(KYuCunKuanPayMoneryUrl) parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [[HSQProgressHUDManger Manger] DismissProgressHUD];
        
        HSQLog(@"==支付===%@==%@",responseObject,params);
        
        HSQPayMonerySuccessViewController *PayMoneryVC = [[HSQPayMonerySuccessViewController alloc] init];
        
        if ([responseObject[@"code"] integerValue] == 200)
        {
            PayMoneryVC.payId = [NSString stringWithFormat:@"%@",responseObject[@"datas"][@"payId"]];
        }
        else
        {
            PayMoneryVC.Code = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
        }
        
        PayMoneryVC.Source = @"100";
        
        [self.navigationController pushViewController:PayMoneryVC animated:YES];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [[HSQProgressHUDManger Manger] ShowDisplayFailedToLoadData:@"网络出问题啦！" SuperView:self.view];
        
    }];
    
}














- (void) dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    
}









@end
