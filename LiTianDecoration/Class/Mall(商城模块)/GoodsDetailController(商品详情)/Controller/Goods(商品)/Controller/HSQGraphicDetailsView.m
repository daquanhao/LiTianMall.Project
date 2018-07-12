//
//  HSQGraphicDetailsView.m
//  LiTianDecoration
//
//  Created by administrator on 2018/7/9.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import "HSQGraphicDetailsView.h"
#import "HSQProductIntroductionPictureListCell.h"
#import "HSQProductIntroductionTextListCell.h"
#import "HSQGoodsMobileBodyVoListModel.h"
#import <WebKit/WebKit.h>

@interface HSQGraphicDetailsView ()<UITableViewDelegate,UITableViewDataSource,WKNavigationDelegate>

@property (nonatomic, strong) UITableView *tableView;

// 顶部的所有标签
@property (nonatomic, weak) UIView *titlesView;

// 标签栏底部的红色指示器
@property (nonatomic, weak) UIImageView *indicatorView;

// 当前选中的按钮
@property (nonatomic, weak) UIButton *selectedButton;

@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, strong) HSQNoDataView *noDataView;

@property (nonatomic, assign) NSInteger Index_Number;

@property (nonatomic, strong) WKWebView *webView;

// 电脑版详情的按钮
@property (nonatomic, strong) UIButton *computer_btn;

@end

@implementation HSQGraphicDetailsView

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor clearColor];

    }
    
    return self;
}

/**
 * @brief 售后保障的数据
 */
- (void)AfterSalesSupportData:(NSString *)commonId{
    
    [[HSQProgressHUDManger Manger] ShowLoadingDataFromeServer:@"" ToView:self IsClearColor:YES];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",UrlAdress(KGoodsDetailAftersalesUrl),commonId];
    
    AFNetworkRequestTool *requestTool = [AFNetworkRequestTool shareRequestTool];
    
    [requestTool.manger GET:url parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [[HSQProgressHUDManger Manger] DismissProgressHUD];
        
        HSQLog(@"=====%@",responseObject);
        
        if ([responseObject[@"code"] integerValue] == 200)
        {
            // 1.设置顶部标题栏
            [self setupTopTitlesViewWithTitle_Array:@[@"商品介绍",@"售后保障"]];
            
            // 2.设置底布的tableView
            [self setuptableView];
            
            // 添加售后保障
            [self AddViewOfAfterSalesService:responseObject[@"datas"][@"protection"]];
            
             self.dataSource = [HSQGoodsMobileBodyVoListModel mj_objectArrayWithKeyValuesArray:responseObject[@"datas"][@"goodsMobileBodyVoList"]];
        }
        
        [self.tableView reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [[HSQProgressHUDManger Manger] ShowDisplayFailedToLoadData:KErrorPlacherString SuperView:self];
    }];
}

/**
 * @brief 设置顶部标题栏
 */
- (void)setupTopTitlesViewWithTitle_Array:(NSArray *)title_array{
    
    // 标签栏整体
    UIView *titlesView = [[UIView alloc] init];
    titlesView.backgroundColor = [UIColor whiteColor];
    titlesView.mj_w = [UIScreen mainScreen].bounds.size.width;
    titlesView.mj_h = 50;
    titlesView.mj_y = 0;
    [self addSubview:titlesView];
    self.titlesView = titlesView;
    
    // 底部的红色指示器
    UIImageView *indicatorView = [[UIImageView alloc] init];
    indicatorView.backgroundColor = RGB(255, 83, 63);
    indicatorView.mj_h = 2;
    indicatorView.tag = -1;
    indicatorView.mj_y = titlesView.mj_h - indicatorView.mj_h;
    self.indicatorView = indicatorView;
    
    // 内部的子标签
    CGFloat width = titlesView.mj_w / title_array.count;
    CGFloat height = titlesView.mj_h;
    for (NSInteger i = 0; i < title_array.count; i++) {
        
        UIButton *button = [UIButton buttonWithType:(UIButtonTypeCustom)];
        button.tag = i;
        button.mj_h = height;
        button.mj_w = width;
        button.mj_x = i * width;

        [button setTitle:title_array[i] forState:UIControlStateNormal];
        
        [button setTitleColor:RGB(131, 131, 131) forState:UIControlStateNormal];
        
        [button setTitleColor:RGB(255, 83, 63) forState:UIControlStateDisabled];
        
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        
        [button addTarget:self action:@selector(titleClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [titlesView addSubview:button];
        
        // 默认点击了第一个按钮
        if (i == 0)
        {
            button.enabled = NO;
            
            self.selectedButton = button;
            
            // 让按钮内部的label根据文字内容来计算尺寸
            [button.titleLabel sizeToFit];
            
            self.indicatorView.mj_w = button.titleLabel.mj_w;
            
            self.indicatorView.centerX = button.centerX;
        }
    }
    
    [titlesView addSubview:indicatorView];
}

/**
 * @brief 顶部按钮的点击事件
 */
- (void)titleClick:(UIButton *)button{
    
    // 修改按钮状态
    self.selectedButton.enabled = YES;
    
    button.enabled = NO;
    
    self.selectedButton = button;
    
    // 动画
    [UIView animateWithDuration:0.25 animations:^{
        
        self.indicatorView.width = button.titleLabel.mj_w;
        
        self.indicatorView.centerX = button.centerX;
        
        self.tableView.mj_x = - button.tag * KScreenWidth;
        
        self.webView.mj_x = CGRectGetMaxX(self.tableView.frame);
    }];
    
}

/**
 * @brief 设置底布的tableView
 */
- (void)setuptableView{
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.titlesView.frame), KScreenWidth, KScreenHeight - KSafeTopeHeight - KSafeBottomHeight - 100) style:(UITableViewStylePlain)];
    
    tableView.backgroundColor = [UIColor clearColor];
    
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    tableView.delegate = self;
    
    tableView.dataSource = self;
    
    tableView.showsVerticalScrollIndicator = NO;
    
    tableView.showsHorizontalScrollIndicator = NO;
    
    [tableView registerClass:[HSQProductIntroductionPictureListCell class] forCellReuseIdentifier:@"HSQProductIntroductionPictureListCell"];
    
    [tableView registerClass:[HSQProductIntroductionTextListCell class] forCellReuseIdentifier:@"HSQProductIntroductionTextListCell"];
    
    [self addSubview:tableView];
    
    self.tableView = tableView;
    
    //设置UIWebView 有下拉操作
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(HeaderRef)];
    
    header.arrowView.image = KImageName(@"C9EDA7DE-0473-4C43-939C-0572B2084BC9");
    
    [header setTitle:@"下拉查看图文详情" forState:(MJRefreshStateIdle)];
    
    [header setTitle:@"下拉查看图文详情" forState:(MJRefreshStatePulling)];
    
    [header setTitle:@"下拉查看图文详情" forState:(MJRefreshStateRefreshing)];
    
    [header setTitle:@"下拉查看图文详情" forState:(MJRefreshStateWillRefresh)];
    
    header.lastUpdatedTimeLabel.hidden = YES;
    
    self.tableView.mj_header = header;
}

- (void)HeaderRef{
    
    [UIView animateWithDuration:0.25 animations:^{
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(TheDropDownShowsTheProductDetails)]) {
            
            [self.delegate TheDropDownShowsTheProductDetails];
        }
        
        [self.tableView.mj_header endRefreshing];
    }];
}

/**
 * @brief 添加售后服务的视图
 */
- (void)AddViewOfAfterSalesService:(NSString *)protection{
    
    WKWebView *webview = [[WKWebView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.tableView.frame), CGRectGetMaxY(self.titlesView.frame), KScreenWidth, KScreenHeight - KSafeTopeHeight - KSafeBottomHeight - 50 - 50)];
    
    webview.backgroundColor = [UIColor clearColor];
    
    [webview loadHTMLString:protection baseURL:nil];
    
    webview.navigationDelegate = self;
    
    [self addSubview:webview];
    
    self.webView = webview;
}

/**
 * @brief 电脑版手机详情
 */
- (void)ComputerVersionOfMobilePhoneDetails{
    
    UIButton *computer_btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    
    computer_btn.backgroundColor = [UIColor orangeColor];
    
    computer_btn.frame = CGRectMake(KScreenWidth - 40 - 20, KScreenHeight - KSafeTopeHeight - 50 - 30 - 40, 40, 40);
    
    [computer_btn addTarget:self action:@selector(computer_btnClickAction:) forControlEvents:(UIControlEventTouchUpInside)];
    
    [self addSubview:computer_btn];
    
    self.computer_btn = computer_btn;
}

- (void)computer_btnClickAction:(UIButton *)sender{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(JoinComputerGoodsDetail:)]) {
        
        [self.delegate JoinComputerGoodsDetail:sender];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    self.noDataView.hidden = (self.dataSource == 0 ? NO : YES);
    
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    HSQGoodsMobileBodyVoListModel *model = self.dataSource[indexPath.row];
    
    if ([model.type isEqualToString:@"image"])
    {
        return KScreenWidth * 1.5;
    }
    else if ([model.type isEqualToString:@"text"])
    {
        return [self.tableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:[HSQProductIntroductionTextListCell class] contentViewWidth:KScreenWidth];
    }
    else
    {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HSQGoodsMobileBodyVoListModel *model = self.dataSource[indexPath.row];
    
    if ([model.type isEqualToString:@"image"])
    {
        HSQProductIntroductionPictureListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HSQProductIntroductionPictureListCell" forIndexPath:indexPath];
        
        [cell.GoodsIntroduction_ImageView sd_setImageWithURL:[NSURL URLWithString:model.value] placeholderImage:KGoodsPlacherImage];
        
        return cell;
    }
    else
    {
        HSQProductIntroductionTextListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HSQProductIntroductionTextListCell" forIndexPath:indexPath];
        
        cell.model = model;
        
        // 此步设置用于实现cell的frame缓存，可以让tableview滑动更加流畅
        [cell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (void)setCommonId:(NSString *)commonId{
    
    _commonId = commonId;
    
    // 请求图文详情的数据
    [self AfterSalesSupportData:commonId];
    
}


@end
