//
//  HSQMyCollectionHomeViewController.m
//  LiTianDecoration
//
//  Created by administrator on 2018/4/29.
//  Copyright © 2018年 administrator. All rights reserved.
//

#define KTitlesViewHeight 44
#define KTitlesViewWitdh 100

#import "HSQMyCollectionHomeViewController.h"
#import "HSQGoodsCollectionViewController.h"
#import "HSQStoreCollectionViewController.h"
#import "HSQTopNavtionView.h"

@interface HSQMyCollectionHomeViewController ()<UIScrollViewDelegate,HSQTopNavtionViewDelegate>

// 顶部的所有标签
@property (nonatomic, weak) HSQTopNavtionView *NavtionView;

// 底部的所有内容
@property (nonatomic, weak) UIScrollView *contentView;

@end

@implementation HSQMyCollectionHomeViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.view.backgroundColor = KViewBackGroupColor;
  
    // 1.初始化子控制器
    [self setupChildVces];
    
    // 2.设置顶部标题栏
    [self setupTopTitlesView];
    
    // 3.设置底布滚动控制器
    [self setupContentView];
    
}

/**
 * @brief 初始化子控制器
 */
-(void)setupChildVces{
    
    HSQGoodsCollectionViewController *GoodsCollectionVC = [[HSQGoodsCollectionViewController alloc] init];
    GoodsCollectionVC.title = @"商品";
    [self addChildViewController:GoodsCollectionVC];
    
    HSQStoreCollectionViewController *StoreCollectionVC = [[HSQStoreCollectionViewController alloc] init];
    StoreCollectionVC.title = @"店铺";
    [self addChildViewController:StoreCollectionVC];
}

/**
 * @brief 设置顶部标题栏
 */
- (void)setupTopTitlesView{
    
    HSQTopNavtionView *NavtionView = [[HSQTopNavtionView alloc] initWithFrame:CGRectMake(0, 0, KTitlesViewWitdh, KTitlesViewHeight)];
    
    NavtionView.TitlesArray = @[@"商品",@"店铺"];
    
    NavtionView.delegate = self;
    
    self.navigationItem.titleView = NavtionView;
    
    self.NavtionView = NavtionView;
}

/**
 * @brief 顶部按钮的点击事件
 */
- (void)TopNavtionViewButtonClickAction:(UIButton *)sender{
    
    // 滚动
    CGPoint offset = self.contentView.contentOffset;
    
    offset.x = sender.tag * self.contentView.width;
    
    [self.contentView setContentOffset:offset animated:YES];
}


/**
 * @brief 设置底布滚动控制器
 */
- (void)setupContentView{
    
    // 不要自动调整inset
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UIScrollView *contentView = [[UIScrollView alloc] init];
    
    CGFloat ScrollerHeight = 0;
    
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
    
    [self TopNavtionViewButtonClickAction:self.NavtionView.subviews[index]];
}


- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
   
}





























@end
