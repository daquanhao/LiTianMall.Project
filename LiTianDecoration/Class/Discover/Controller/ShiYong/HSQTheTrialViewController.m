//
//  HSQTheTrialViewController.m
//  LiTianDecoration
//
//  Created by administrator on 2018/4/13.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import "HSQTheTrialViewController.h"
#import "HSQPublicMenuView.h"
#import "HSQCustomButton.h"
#import "HSQGoodsCollectionListCell.h"
#import "HSQUsingTheReportCell.h"
#import "HSQCollectionViewLayout.h"
#import "HSQTrialReportListModel.h"
#import "HWPhoto.h"
#import "HSQTrialReportFrameModel.h"
#import "HSQUsingReportDetailViewController.h"

@interface HSQTheTrialViewController ()<HSQPublicMenuViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,HSQCollectionViewLayoutDelegate>

@property (nonatomic, strong) HSQPublicMenuView *publicMenuView;

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, assign) NSInteger ShowType;

@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation HSQTheTrialViewController

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
    self.navigationItem.title = self.NavtionTitle;
}

- (NSMutableArray *)dataSource{
    
    if (_dataSource == nil) {
        
        self.dataSource = [NSMutableArray array];
    }
    
    return _dataSource;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.view.backgroundColor = KViewBackGroupColor;
    
    self.navigationItem.title = self.NavtionTitle;
    
    self.ShowType = 100;
    
    // 1.添加头部标题视图
    [self addHeadClassView];
    
    // 2.创建集合视图
    [self CreatTheTrialCollectionView];
    
    // 3.创建底部tabbar视图
    [self CreatBottomTabBarView];
    
    // 5.请求试用数据
    [self requestTrialDataFromeServer];
}

/**
 * @brief 添加头部标题视图
 */
- (void)addHeadClassView{
    
    NSArray *title_array = @[@"全部",@"服饰鞋帽",@"礼品箱包",@"家居家装",@"数码办公",@"家用电器",@"个护化妆",@"珠宝手表",@"食品饮材",@"运动健康",@"汽车用品",];
    
    HSQPublicMenuView *PublicMenuView = [[HSQPublicMenuView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 45)];
    
    PublicMenuView.dataSource = [NSMutableArray arrayWithArray:title_array];
    
    PublicMenuView.delegate = self;
    
    [self.view addSubview:PublicMenuView];
    
    self.publicMenuView = PublicMenuView;
    
}

/**
 * @brief 创建集合视图
 */
- (void)CreatTheTrialCollectionView{
    
    HSQCollectionViewLayout *Layout = [[HSQCollectionViewLayout alloc] init];
    
    Layout.second = 0;
    
    Layout.delegate = self;
    
    CGFloat collectionHeight = KScreenHeight - KSafeBottomHeight  - KSafeTopeHeight - 49 - self.publicMenuView.mj_h;
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.publicMenuView.frame), KScreenWidth, collectionHeight) collectionViewLayout:Layout];
    
    collectionView.backgroundColor = [UIColor clearColor];
    
    collectionView.dataSource = self;
    
    collectionView.delegate = self;
        
    [collectionView registerClass:[HSQGoodsCollectionListCell class] forCellWithReuseIdentifier:@"HSQGoodsCollectionListCell"];
    
    [collectionView registerClass:[HSQUsingTheReportCell class] forCellWithReuseIdentifier:@"HSQUsingTheReportCell"];
    
    [self.view addSubview:collectionView];
    
    [self.view sendSubviewToBack:collectionView];
    
    self.collectionView = collectionView;
    
    // 当ios是11.0版本以上的时候，系统会自动为视图设置安全区域，如果不想要的话，可以添加一下代码取消
    KCancelSafeSet(collectionView);
    
    self.automaticallyAdjustsScrollViewInsets = NO;
}


/**
 * @brief 创建底部tabbar视图
 */
- (void)CreatBottomTabBarView{
    
    NSArray *array = @[@{@"name":@"试用首页",@"icon":@"123"},@{@"name":@"付邮试用",@"icon":@"123"},@{@"name":@"返券试用",@"icon":@"123"},@{@"name":@"试用报告",@"icon":@"123"}];
    
    UIView *tabbarView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.collectionView.frame) , KScreenWidth, 49)];
    
    tabbarView.backgroundColor = [UIColor whiteColor];
    
    for (NSInteger i = 0; i < array.count; i++) {
        
        NSDictionary *diction = array[i];
        
        HSQCustomButton *CustomButton = [HSQCustomButton buttonWithType:(UIButtonTypeCustom)];
        
        [CustomButton setTitle:diction[@"name"] forState:(UIControlStateNormal)];
        
        [CustomButton setImage:KImageName(diction[@"icon"]) forState:(UIControlStateNormal)];
        
        CustomButton.alignmentType = Button_AlignmentStatusTop;
        
        [CustomButton setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
        
        CustomButton.titleLabel.font = [UIFont systemFontOfSize:12];
        
        [CustomButton addTarget:self action:@selector(tabbarClickAction:) forControlEvents:(UIControlEventTouchUpInside)];
        
        CustomButton.frame = CGRectMake(i * KScreenWidth / array.count, 0, KScreenWidth / array.count, tabbarView.size.height);
        
        [tabbarView addSubview:CustomButton];
    }
    
    [self.view addSubview:tabbarView];
}

/**
 * @brief 请求试用数据
 */
- (void)requestTrialDataFromeServer{
    
    [self creatModelsWithCount:20];
}

- (void)creatModelsWithCount:(NSInteger)count
{
    NSArray *iconImageNamesArray = @[@"icon0.jpg",
                                     @"icon1.jpg",
                                     @"icon2.jpg",
                                     @"icon3.jpg",
                                     @"icon4.jpg",
                                     @"icon0.jpg",
                                     @"icon1.jpg",
                                     @"icon2.jpg",
                                     @"icon3.jpg"
                                     ];
    
    
    NSArray *textArray = @[@"当你的 app 没有提供 3x 的LaunchImage 时。然后等比例拉伸屏幕宽度返回 320；然后等比例拉伸到大屏。这种情况下对界面不会产生任小。但是建议不要长期处于这种模式下，否则在大屏上会显得字大，内容少，容易遭到用户投诉。但是建议不要长期处于这种模式下，否则在大屏上会显得字大，内容少，容易遭到用户投诉。",
                           @"然后等比例拉伸到大屏。屏幕宽度返回 320否则在大屏上会显得字大长期处于这种模式下，否则在大屏上会显得字大，内容少这种情况下对界面不会",
                           @"长期处于这种模式下，否则在大屏上会显得字大，内容少这种情况下对界面不会但是建议不要长期处于这种模式下，否则在大屏上会显得字大，内容少，容易遭到用户投诉。",
                           @"但是建议不要长期处于这种模式下，否则在大屏上会显得字大，内容少，容易遭到用户投诉。",
                           @"屏幕宽度返回 320；然后等比例拉伸到大屏。这种情况下对界面不会产生任小。但是建议不要长期处于这种模式下，否则在大屏上会显得字大，内容少，容易遭到用户投诉。但是建议不要长期处于这种模式下，否则在大屏上会显得字大，内容少，容易遭到用户投诉。但是建议不要长期处于这种模式下，否则在大屏上会显得字大，内容少，容易遭到用户投诉。"
                           ];
    
    NSMutableArray *array = [NSMutableArray array];
    
    for (int i = 0; i < count; i++) {
        
        int nameRandomIndex = arc4random_uniform(5);
        
        HSQTrialReportListModel *model = [HSQTrialReportListModel new];
        
        model.reportContent = textArray[nameRandomIndex];
        
        model.iconImagePath = iconImageNamesArray[arc4random_uniform(9)];
        
        // 模拟“有或者无图片”
        int random = arc4random_uniform(1);
        if (random <= 8) {
            NSMutableArray *temp = [NSMutableArray new];
            
            int randomImagesCount = arc4random_uniform(9);
            for (int i = 0; i < randomImagesCount; i++) {
                int randomIndex = arc4random_uniform(9);
                NSString *text = iconImageNamesArray[randomIndex];
                [temp addObject:text];
            }
            
            model.images = [temp copy];
        }
        
        [array addObject:model];

    }
    
    NSArray *New_Array = [self stausFramesWithStatuses:array];
    
    [self.dataSource addObjectsFromArray:New_Array];
}

/**
 *  将HWStatus模型转为HWStatusFrame模型
 */
- (NSArray *)stausFramesWithStatuses:(NSArray *)statuses{
    
    NSMutableArray *frames = [NSMutableArray array];
    
    for (HSQTrialReportListModel *status in statuses) {
        
        HSQTrialReportFrameModel *frame = [[HSQTrialReportFrameModel alloc] init];
        
        frame.model = status;
        
        [frames addObject:frame];
    }
    return frames;
}

#pragma mark - HSQPublicMenuViewDelegate

- (void)topButtonClickAction:(UIButton *)sender{
    
    HSQLog(@"==头部==%@",sender.titleLabel.text);
}

- (void)MenuButtonClickAction:(UIButton *)sender{
    
    HSQLog(@"==菜单==%@",sender.titleLabel.text);
}

#pragma mark - 底部tabbar的点击事件
- (void)tabbarClickAction:(HSQCustomButton *)sender{
    
    if ([sender.titleLabel.text isEqualToString:@"试用报告"])
    {
        [self.publicMenuView setHidden:YES];
        
        self.collectionView.mj_y = 0;
        
        CGFloat collectionHeight = KScreenHeight - KSafeBottomHeight  - KSafeTopeHeight - 49;
        
        self.collectionView.mj_h = collectionHeight;
        
        self.ShowType = 200;
        
        self.navigationItem.title = @"试用报告";
    }
    else
    {
        [self.publicMenuView setHidden:NO];
        
        self.collectionView.mj_y = self.publicMenuView.mj_h;
        
        CGFloat collectionHeight = KScreenHeight - KSafeBottomHeight  - KSafeTopeHeight - 49 - self.publicMenuView.mj_h;
        
        self.collectionView.mj_h = collectionHeight;
        
        self.ShowType = 100;
        
        self.navigationItem.title = @"试用";
    }
    
    [self.collectionView reloadData];
}


#pragma mark - UICollectionViewDelegate,UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return (self.ShowType == 100 ? 13 : self.dataSource.count);
}

- (CGFloat)DefauilColumns:(HSQCollectionViewLayout *)waterFlowLayout{
    
     return (self.ShowType == 100 ? 2 : 1);
}

- (CGFloat)DefauilRowMargin:(HSQCollectionViewLayout *)waterFlowLayout{
    
    return 5;
}

- (CGFloat)DefauilColumnsMargin:(HSQCollectionViewLayout *)waterFlowLayout{
    
    return 5;
}

- (UIEdgeInsets)collectionViewEdgeInsets:(HSQCollectionViewLayout *)waterFlowLayout{
    
    return UIEdgeInsetsMake(0, 0, 10, 0);
}

- (CGSize)waterFlowLayout:(HSQCollectionViewLayout *)waterFlowLayout atIndexPath:(NSIndexPath *)indexPath{
    
    if (self.ShowType == 100)
    {
        return CGSizeMake((KScreenWidth-5)/2, (KScreenWidth-5)/2);
    }
    else
    {
        HSQTrialReportFrameModel *Framemodel = self.dataSource[indexPath.row];
        
        return CGSizeMake(KScreenWidth, Framemodel.CellHeight);
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.ShowType == 100)
    {
        HSQGoodsCollectionListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HSQGoodsCollectionListCell" forIndexPath:indexPath];
        
        return cell;
    }
    else
    {
        HSQUsingTheReportCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HSQUsingTheReportCell" forIndexPath:indexPath];
        
        cell.FrameModel = self.dataSource[indexPath.row];
        
        return cell;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    if (self.ShowType == 100)
    {
        
    }
    else
    {
        HSQUsingReportDetailViewController *UsingReportDetailVC = [[HSQUsingReportDetailViewController alloc] init];
        
        [self.navigationController pushViewController:UsingReportDetailVC animated:YES];
        
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
