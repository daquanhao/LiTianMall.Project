//
//  HSQGuiGeAndCouperView.m
//  LiTianDecoration
//
//  Created by administrator on 2018/5/10.
//  Copyright © 2018年 administrator. All rights reserved.
//

#define KPlacherLabelHeight 50

#define KViewHeight KScreenHeight - KSafeBottomHeight

#import "HSQGuiGeAndCouperView.h"
#import "HSQCoupterListCell.h"
#import "HSQVoucherListModel.h"
#import "HSQAccountTool.h"

@interface HSQGuiGeAndCouperView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UIView *BgView;

@property (nonatomic, strong) UIView *TopView;

@property (nonatomic, strong) UILabel *placher_Label;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation HSQGuiGeAndCouperView

- (NSMutableArray *)dataSource{
    
    if (_dataSource == nil) {
        
        self.dataSource = [NSMutableArray array];
    }
    
    return _dataSource;
}


/**
 * @brief 初始化视图
 */
+ (instancetype)initGuiGeAndCouperView{
    
    HSQGuiGeAndCouperView *publicView = [[HSQGuiGeAndCouperView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KViewHeight)];
    
    publicView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
    
    [[[UIApplication sharedApplication] keyWindow]addSubview:publicView];
    
    return publicView;
}

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        // 1.创建控件
        [self SetUpViews];
    }
    
    return self;
}

/**
 * @brief 创建控件
 */
- (void)SetUpViews{
    
    // 最底部的点击按钮
    UIButton *Bottombtn = [UIButton buttonWithType:(UIButtonTypeSystem)];
    Bottombtn.frame = self.bounds;
    Bottombtn.backgroundColor = [UIColor clearColor];
    [Bottombtn addTarget:self action:@selector(btnClickAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:Bottombtn];
    
    // 1.屏幕一半的背景图
    UIView *BgView = [[UIView alloc] initWithFrame:CGRectMake(0, KScreenHeight, KScreenWidth,(KViewHeight)/2)];
    BgView.backgroundColor = [UIColor whiteColor];
    [self addSubview:BgView];
    self.BgView = BgView;
    
    // 2.头部的提示标题
    UILabel *placher_Label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KPlacherLabelHeight)];
    placher_Label.textColor = [UIColor grayColor];
    placher_Label.backgroundColor = [UIColor clearColor];
    placher_Label.font = [UIFont systemFontOfSize:15.0];
    placher_Label.textAlignment = NSTextAlignmentCenter;
    [BgView addSubview:placher_Label];
    self.placher_Label = placher_Label;
    
    // 3.右边的退出按钮
    UIButton *right_button = [UIButton buttonWithType:(UIButtonTypeCustom)];
    right_button.frame = CGRectMake(KScreenWidth - KPlacherLabelHeight, 0, KPlacherLabelHeight, KPlacherLabelHeight);
    [right_button setImage:KImageName(@"TuiChuButton") forState:(UIControlStateNormal)];
    [right_button addTarget:self action:@selector(dismissAdressView) forControlEvents:(UIControlEventTouchUpInside)];
    [BgView addSubview:right_button];
    
    // 6.添加tableView
    UITableView * tabbleView = [[UITableView alloc]initWithFrame:CGRectMake(0, KPlacherLabelHeight, KScreenWidth, BgView.mj_h - KPlacherLabelHeight)];
    tabbleView.backgroundColor = KViewBackGroupColor;
    tabbleView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tabbleView.delegate = self;
    tabbleView.dataSource = self;
    tabbleView.contentInset = UIEdgeInsetsMake(0, 0, 10, 0);
    [tabbleView registerNib:[UINib nibWithNibName:@"HSQCoupterListCell" bundle:nil] forCellReuseIdentifier:@"HSQCoupterListCell"];
    [BgView addSubview:tabbleView];
    self.tableView = tabbleView;
    
}

- (void)setTypeString:(NSString *)TypeString{
    
    _TypeString = TypeString;
    
    [self.tableView reloadData];
}

/**
 * @brief 店铺的id
 */
- (void)setStoreId:(NSString *)storeId{
    
    _storeId = storeId;
    
    // 2.请求店铺的优惠券数据
    [self RequestStoreCouponData];
}

/**
 * @brief 请求店铺的优惠券数据
 */
- (void)RequestStoreCouponData{
    
    [[HSQProgressHUDManger Manger] ShowLoadingDataFromeServer:@"" ToView:self IsClearColor:YES];
    
    [self.dataSource removeAllObjects];
    
    NSString *token = [HSQAccountTool account].token;
    
    if (token.length != 0)
    {
        [self WhenLoggedInRequestCouponList:token];
    }
    else
    {
        [self WhenNotLoggedInRequestCouponList];
    }
}

/**
 * @brief 登录的时候，请求优惠券列表
 */
- (void)WhenLoggedInRequestCouponList:(NSString *)token{
    
    NSDictionary *params = @{@"storeId":self.storeId,@"token":token};
    
    AFNetworkRequestTool *requestTool = [AFNetworkRequestTool shareRequestTool];  // KtemplateFreeUrl
    
    [requestTool.manger POST:UrlAdress(KtemplateFreeUrl) parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [[HSQProgressHUDManger Manger] DismissProgressHUD];
        
        HSQLog(@"===优惠券列表数据===%@",[NSString stringWithFormat:@"%@",responseObject]);
        
        if ([responseObject[@"code"] integerValue] == 200)
        {
            self.dataSource = [HSQVoucherListModel mj_objectArrayWithKeyValuesArray:responseObject[@"datas"][@"voucherTemplateList"]];
        }
        else
        {
            NSString *errorString = [NSString stringWithFormat:@"%@",responseObject[@"datas"][@"error"]];
            
            [[HSQProgressHUDManger Manger] ShowDisplayFailedToLoadData:errorString SuperView:self];
        }
        
        [self.tableView reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        // 提示数据请求失败
        [[HSQProgressHUDManger Manger] ShowProgressHUDPromptText:KErrorPlacherString SupView:self];
    }];
}

/**
 * @brief 没有登录的时候，请求优惠券列表
 */
- (void)WhenNotLoggedInRequestCouponList{
    
    NSDictionary *params = @{@"storeId":self.storeId};
    
    AFNetworkRequestTool *requestTool = [AFNetworkRequestTool shareRequestTool];  // KtemplateFreeUrl
    
    [requestTool.manger GET:UrlAdress(KStoreActivityUrl) parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [[HSQProgressHUDManger Manger] DismissProgressHUD];
        
        HSQLog(@"===优惠券列表数据===%@",[NSString stringWithFormat:@"%@",responseObject]);
        
        if ([responseObject[@"code"] integerValue] == 200)
        {
            self.dataSource = [HSQVoucherListModel mj_objectArrayWithKeyValuesArray:responseObject[@"datas"][@"voucherTemplateList"]];
        }
        else
        {
            NSString *errorString = [NSString stringWithFormat:@"%@",responseObject[@"datas"][@"error"]];
            
            [[HSQProgressHUDManger Manger] ShowDisplayFailedToLoadData:errorString SuperView:self];
        }
        
        [self.tableView reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        // 提示数据请求失败
        [[HSQProgressHUDManger Manger] ShowProgressHUDPromptText:KErrorPlacherString SupView:self];
    }];
}

#pragma mark - TableViewDatasouce

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 85;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    HSQCoupterListCell * cell = [tableView dequeueReusableCellWithIdentifier:@"HSQCoupterListCell" forIndexPath:indexPath];
    
    cell.model = self.dataSource[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    HSQVoucherListModel *model = self.dataSource[indexPath.row];
    
    NSString *token = [HSQAccountTool account].token;
    
    if (token.length == 0)
    {
        if (self.delegate && [self.delegate respondsToSelector:@selector(ChooseGuiGeAndCoupter:templateId:)]) {
            
            [self.delegate ChooseGuiGeAndCoupter:indexPath templateId:model.templateId];
        }
    }
    else
    {
        if (model.memberIsReceive.integerValue == 1)
        {
            [[HSQProgressHUDManger Manger] ShowProgressHUDPromptText:@"您已领取过该优惠券" SupView:self];
        }
        else
        {
            [self NotifyTheServerToCollectCoupons:model];
        }
    }
}

/**
 * @brief 领取优惠券
 */
- (void)NotifyTheServerToCollectCoupons:(HSQVoucherListModel *)model{
    
    [[HSQProgressHUDManger Manger] ShowLoadingDataFromeServer:@"" ToView:self IsClearColor:YES];
    
    NSDictionary *params = @{@"token":[HSQAccountTool account].token,@"templateId":model.templateId};
    
    AFNetworkRequestTool *requestTool = [AFNetworkRequestTool shareRequestTool];
    
    [requestTool.manger POST:UrlAdress(KfreeGetCouponsUrl) parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        HSQLog(@"==领取优惠券==%@===",responseObject);
        
        [[HSQProgressHUDManger Manger] DismissProgressHUD];
        
        if ([responseObject[@"code"] integerValue] == 200)
        {
            model.memberIsReceive = @"1";
            
            [[HSQProgressHUDManger Manger] ShowProgressHUDPromptText:@"领取成功" SupView:self];
            
            [self.tableView reloadData];
        }
        else
        {
            NSString *errorString = [NSString stringWithFormat:@"%@",responseObject[@"datas"][@"error"]];
            
            [[HSQProgressHUDManger Manger] ShowDisplayFailedToLoadData:errorString SuperView:self];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [[HSQProgressHUDManger Manger] ShowProgressHUDPromptText:KErrorPlacherString SupView:self];
        
    }];
}

- (void)setPlacherString:(NSString *)placherString{
    
    _placherString = placherString;
    
    self.placher_Label.text = placherString;
}

/**
 * @brief 点击背景按钮的点击事件
 */
- (void)btnClickAction:(UIButton *)sender{
    
    [self dismissAdressView];
}


/**
 * @brief 显示视图
 */
- (void)ShowGuiGeAndCouperView{
    
    [UIView animateWithDuration:0.25 animations:^{
        
        self.BgView.frame = ({
            
            CGRect frame = self.BgView.frame;
            
            frame.origin.y = (KScreenHeight) / 2;
            
            frame;
        });
    }];
}

/**
 * @brief 隐藏视图
 */
- (void)dismissAdressView{
    
    [UIView animateWithDuration:0.25 animations:^{
        
        self.BgView.frame = ({
            
            CGRect frame = self.BgView.frame;
            
            frame.origin.y = KScreenHeight;
            
            frame;
        });
    }completion:^(BOOL finished) {
        
        [self.BgView removeFromSuperview];
        
        [self removeFromSuperview];
    }];
}


@end
