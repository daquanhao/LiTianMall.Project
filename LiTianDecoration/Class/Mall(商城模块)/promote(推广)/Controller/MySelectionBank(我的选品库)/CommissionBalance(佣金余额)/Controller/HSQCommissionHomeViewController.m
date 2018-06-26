//
//  HSQCommissionHomeViewController.m
//  LiTianDecoration
//
//  Created by administrator on 2018/6/15.
//  Copyright © 2018年 administrator. All rights reserved.
//

#define KTopBgViewHeight 50

#import "HSQCommissionHomeViewController.h"
#import "HSQCommissionYuEListViewController.h"
#import "HSQBalanceOfWithdrawalViewController.h"
#import "HSQAccountSettingsViewController.h"
#import "HSQAccountTool.h"

@interface HSQCommissionHomeViewController ()<UIScrollViewDelegate>

// 顶部的所有标签
@property (nonatomic, weak) UIView *titlesView;

// 标签栏底部的红色指示器
@property (nonatomic, weak) UIImageView *indicatorView;

// 当前选中的按钮
@property (nonatomic, weak) UIButton *selectedButton;

// 底部的所有内容
@property (nonatomic, weak) UIScrollView *contentView;

// 佣金背景图
@property (nonatomic, weak) UIView *BgView;

// 佣金
@property (nonatomic, weak) UILabel *Commission_Label;

@end

@implementation HSQCommissionHomeViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.view.backgroundColor = KViewBackGroupColor;
    
    self.navigationItem.title = @"佣金";
    
    [self GetTheInformationOfPromotionMembers];
    
    // 1.初始化子控制器
    [self setupChildVces];
    
    // 2.设置顶部标题栏
    [self setupTopTitlesView];
    
    // 3.设置底布滚动控制器
    [self setupContentView];
}

/**
 * @brief 获取推广会员的信息
 */
- (void)GetTheInformationOfPromotionMembers{
    
    [[HSQProgressHUDManger Manger] ShowLoadingDataFromeServer:@"" ToView:self.view IsClearColor:YES];
    
    NSDictionary *params = @{@"token":[HSQAccountTool account].token};
    
    AFNetworkRequestTool *requestTool = [AFNetworkRequestTool shareRequestTool];
    
    [requestTool.manger POST:UrlAdress(KGetPromotionMemberInformationUrl) parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [[HSQProgressHUDManger Manger] DismissProgressHUD];
        
        if ([responseObject[@"code"] integerValue] == 200)
        {
            // 佣金金额
            NSString *payCommission = [NSString stringWithFormat:@"%@",responseObject[@"datas"][@"distributor"][@"commissionAvailable"]];
            
            // 设置顶部的佣金金额
            [self SetTheTopCommissionAmount:payCommission];
        }
        else
        {
            NSString *errorString = [NSString stringWithFormat:@"%@",responseObject[@"datas"][@"error"]];
            
            [[HSQProgressHUDManger Manger] ShowDisplayFailedToLoadData:errorString SuperView:self.view];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [[HSQProgressHUDManger Manger] ShowProgressHUDPromptText:KErrorPlacherString SupView:self.view];
        
    }];
}

/**
 * @brief 设置顶部的佣金金额
 */
- (void)SetTheTopCommissionAmount:(NSString *)payCommission{
    
    // 佣金背景图
    UIView *BgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KTopBgViewHeight)];
    BgView.backgroundColor = [UIColor redColor];
    [self.view addSubview:BgView];
    self.BgView = BgView;
    
    // 佣金
    UILabel *Commission_Label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth-10, KTopBgViewHeight)];
    Commission_Label.text = [NSString stringWithFormat:@"佣金金额\n¥%.2f",payCommission.floatValue];
    Commission_Label.numberOfLines = 0;
    Commission_Label.textColor = [UIColor whiteColor];
    Commission_Label.font = [UIFont systemFontOfSize:12.0];
    Commission_Label.textAlignment = NSTextAlignmentRight;
    [BgView addSubview:Commission_Label];
    self.Commission_Label = Commission_Label;
}

/**
 * @brief 初始化子控制器
 */
- (void)setupChildVces{
    
    // 我的余额
    HSQCommissionYuEListViewController *MyBalanceVC = [[HSQCommissionYuEListViewController alloc] init];
    MyBalanceVC.title = @"佣金余额";
    [self addChildViewController:MyBalanceVC];
    
    // 余额提现
    HSQBalanceOfWithdrawalViewController *TopUpDetailVC = [[HSQBalanceOfWithdrawalViewController alloc] init];
    TopUpDetailVC.title = @"余额提现";
    [self addChildViewController:TopUpDetailVC];
    
    // 账户设置
    HSQAccountSettingsViewController *WithdrawalVC = [[HSQAccountSettingsViewController alloc] init];
    WithdrawalVC.title = @"账户设置";
    [self addChildViewController:WithdrawalVC];
    
}

/**
 * @brief 设置顶部标题栏
 */
- (void)setupTopTitlesView{
    
    // 标签栏整体
    UIView *titlesView = [[UIView alloc] init];
    titlesView.backgroundColor = [UIColor whiteColor];
    titlesView.mj_w = [UIScreen mainScreen].bounds.size.width;
    titlesView.mj_h = 50;
    titlesView.mj_y = KTopBgViewHeight;
    [self.view addSubview:titlesView];
    self.titlesView = titlesView;
    
    // 底部的红色指示器
    UIImageView *indicatorView = [[UIImageView alloc] init];
    indicatorView.backgroundColor = RGB(255, 83, 63);
    indicatorView.mj_h = 2;
    indicatorView.tag = -1;
    indicatorView.mj_y = titlesView.mj_h - indicatorView.mj_h;
    self.indicatorView = indicatorView;
    
    // 内部的子标签
    CGFloat width = titlesView.mj_w / self.childViewControllers.count;
    CGFloat height = titlesView.mj_h;
    for (NSInteger i = 0; i < self.childViewControllers.count; i++) {
        
        UIButton *button = [UIButton buttonWithType:(UIButtonTypeCustom)];
        button.tag = i;
        button.mj_h = height;
        button.mj_w = width;
        button.mj_x = i * width;
        UIViewController *vc = self.childViewControllers[i];
        [button setTitle:vc.title forState:UIControlStateNormal];
        
        [button setTitleColor:RGB(131, 131, 131) forState:UIControlStateNormal];
        
        [button setTitleColor:RGB(255, 83, 63) forState:UIControlStateDisabled];
        
        button.titleLabel.font = [UIFont systemFontOfSize:KTextFont_(14)];
        
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
    }];
    
    // 滚动
    CGPoint offset = self.contentView.contentOffset;
    offset.x = button.tag * self.contentView.width;
    [self.contentView setContentOffset:offset animated:YES];
}

/**
 * @brief 设置底布滚动控制器
 */
- (void)setupContentView{
    
    // 不要自动调整inset
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UIScrollView *contentView = [[UIScrollView alloc] init];
    
    CGFloat ScrollerHeight = CGRectGetMaxY(self.titlesView.frame);
    
    contentView.showsVerticalScrollIndicator = NO;
    
    contentView.showsHorizontalScrollIndicator = NO;
    
    contentView.frame = CGRectMake(0, ScrollerHeight, KScreenWidth, KScreenHeight - ScrollerHeight - KSafeTopeHeight - KSafeBottomHeight);
    
    contentView.delegate = self;
    
    contentView.pagingEnabled = YES;
    
    contentView.backgroundColor = KViewBackGroupColor;
    
    [self.view insertSubview:contentView atIndex:0];
    
    contentView.contentSize = CGSizeMake(contentView.mj_w * self.childViewControllers.count, 0);
    
    self.contentView = contentView;
    
    // 添加第一个控制器的view
    [self scrollViewDidEndScrollingAnimation:contentView];
}

#pragma mark - <UIScrollViewDelegate>
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    
    // 当前的索引
    NSInteger index = scrollView.contentOffset.x / scrollView.mj_w;
    
    // 取出子控制器
    UIViewController *vc = self.childViewControllers[index];
    
    vc.view.mj_x = scrollView.contentOffset.x;
    
    vc.view.mj_y = 0; // 设置控制器view的y值为0(默认是20)
    
    vc.view.mj_h = scrollView.mj_h; // 设置控制器view的height值为整个屏幕的高度(默认是比屏幕高度少个20)
    
    vc.view.mj_w = KScreenWidth;
    
    [scrollView addSubview:vc.view];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    [self scrollViewDidEndScrollingAnimation:scrollView];
    
    // 点击按钮
    NSInteger index = scrollView.contentOffset.x / scrollView.mj_w;
    
    [self titleClick:self.titlesView.subviews[index]];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




























@end
