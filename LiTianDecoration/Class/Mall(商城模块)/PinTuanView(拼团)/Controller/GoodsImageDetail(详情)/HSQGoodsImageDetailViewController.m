//
//  HSQGoodsImageDetailViewController.m
//  LiTianDecoration
//
//  Created by administrator on 2018/5/9.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import "HSQGoodsImageDetailViewController.h"
#import "HSQComputerGoodsDetailViewController.h"
#import "HSQGoodsDetailImageCell.h"

@interface HSQGoodsImageDetailViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *TopViewHeight;

@property (nonatomic, strong) UIButton *Select_Button;

@property (weak, nonatomic) IBOutlet UIButton *First_Button;

@property (nonatomic, strong) UIButton *computer_btn;

@property (nonatomic, assign) NSInteger index;

@property (nonatomic, copy) NSString *protection;

@end

@implementation HSQGoodsImageDetailViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.index = 10;
    
    [self TopButtonClickAction:self.First_Button];
    
    // 创建集合视图
    [self CreatCollectionView];
    
    // 电脑版手机详情
    [self ComputerVersionOfMobilePhoneDetails];
}

/**
 * @brief 商品图片列表
 */
- (void)setGoodsImageList:(NSArray *)goodsImageList{
    
    _goodsImageList = goodsImageList;
    
    [self.collectionView reloadData];
}

/**
 * @brief  创建集合视图
 */
- (void)CreatCollectionView{
    
    UICollectionViewFlowLayout *Layout = [[UICollectionViewFlowLayout alloc] init];
    
    Layout.minimumLineSpacing = 0;  // 最小的行间距
    
    Layout.minimumInteritemSpacing = 0; // 最小的列间距
    
    CGFloat collectionHeight = KScreenHeight - KSafeBottomHeight - KSafeTopeHeight - 50;
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, collectionHeight) collectionViewLayout:Layout];
    
    collectionView.backgroundColor = [UIColor clearColor];
    
    collectionView.contentInset = UIEdgeInsetsMake(self.TopViewHeight.constant, 0, 0, 0);
    
    collectionView.dataSource = self;
    
    collectionView.delegate = self;
    
    [collectionView registerNib:[UINib nibWithNibName:@"HSQGoodsDetailImageCell" bundle:nil] forCellWithReuseIdentifier:@"HSQGoodsDetailImageCell"];
    
    [self.view addSubview:collectionView];
    
    [self.view sendSubviewToBack:collectionView];
    
    self.collectionView = collectionView;
}

/**
 * @brief 电脑版手机详情
 */
- (void)ComputerVersionOfMobilePhoneDetails{
    
    UIButton *computer_btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    
    computer_btn.backgroundColor = [UIColor orangeColor];
    
    computer_btn.frame = CGRectMake(KScreenWidth - 40 - 20, KScreenHeight - KSafeTopeHeight - 50 - 30 - 40, 40, 40);
    
    [computer_btn addTarget:self action:@selector(computer_btnClickAction:) forControlEvents:(UIControlEventTouchUpInside)];
    
    [self.view addSubview:computer_btn];
    
    self.computer_btn = computer_btn;
}

- (void)computer_btnClickAction:(UIButton *)sender{
  
    HSQComputerGoodsDetailViewController *computerVC = [[HSQComputerGoodsDetailViewController alloc] init];
    
    computerVC.commonId = self.commonId;
    
    [self.navigationController pushViewController:computerVC animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionViewDelegate,UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    if (self.index == 100) // 售后服务
    {
        return 1;
    }
    else
    {
        return self.goodsImageList.count;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.index == 100) // 售后服务
    {
        return CGSizeMake(KScreenWidth, self.view.mj_h);
    }
    else
    {
        return CGSizeMake(KScreenWidth, KScreenWidth);
    }
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *diction = self.goodsImageList[indexPath.row];
    
    HSQGoodsDetailImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HSQGoodsDetailImageCell" forIndexPath:indexPath];
    
    if (self.index == 100) // 售后服务
    {
        cell.protection = self.protection;
    }
    else
    {
        cell.ImageUrl = diction[@"imageSrc"];
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
}

/**
 * @brief 顶部按钮的点击事件
 */
- (IBAction)TopButtonClickAction:(UIButton *)sender {
    
    // 修改按钮状态
    self.Select_Button.enabled = YES;
    sender.enabled = NO;
    self.Select_Button = sender;
    
    if (sender.tag == 110)  // 商品介绍
    {
        self.index = 10;
        
        [self.collectionView reloadData];
    }
    else if (sender.tag == 111) // 规格参数
    {
         HSQLog(@"====2222222222");
    }
    else if (sender.tag == 112) // 售后保障
    {
        [self AfterSalesSupportData];
    }
}

/**
 * @brief 售后保障的数据
 */
- (void)AfterSalesSupportData{
    
    [[HSQProgressHUDManger Manger] ShowLoadingDataFromeServer:@"" ToView:self.view IsClearColor:YES];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",UrlAdress(KGoodsDetailAftersalesUrl),self.commonId];
    
    AFNetworkRequestTool *requestTool = [AFNetworkRequestTool shareRequestTool];
    
    [requestTool.manger GET:url parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        self.index = 100;
        
        [[HSQProgressHUDManger Manger] DismissProgressHUD];
        
        if ([responseObject[@"code"] integerValue] == 200)
        {
            self.protection = responseObject[@"datas"][@"protection"];
        }
        
        [self.collectionView reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [[HSQProgressHUDManger Manger] ShowDisplayFailedToLoadData:@"数据加载失败" SuperView:self.view];
    }];
}




@end
