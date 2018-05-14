//
//  HSQSearchBarViewController.m
//  LiTianDecoration
//
//  Created by administrator on 2018/5/3.
//  Copyright © 2018年 administrator. All rights reserved.
//

#define HWSearchHistoryPath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"SearchHistory.archive"]

#import "HSQSearchBarViewController.h"
#import "HSQSearchListCell.h"
#import "HSQClassHeadCollectionReusableView.h"
#import "HSQClassGoodsListViewController.h"

@interface HSQSearchBarViewController ()<UINavigationControllerDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UITextFieldDelegate,HSQClassHeadCollectionReusableViewDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *TopViewWidth;

@property (weak, nonatomic) IBOutlet UIButton *SearchBtn;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *NavtionHeight;

@property (weak, nonatomic) IBOutlet UITextField *Search_TextField;

@property (weak, nonatomic) IBOutlet UIButton *Goods_Button;

@property (nonatomic, strong) NSMutableArray *keywordList;

@property (nonatomic, strong) NSMutableArray *Search_Array;

@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation HSQSearchBarViewController

- (NSMutableArray *)keywordList{
    
    if (_keywordList == nil) {
        
        self.keywordList = [NSMutableArray array];
    }
    
    return _keywordList;
}

- (NSMutableArray *)Search_Array{
    
    if (_Search_Array == nil) {
        
        self.Search_Array = [NSMutableArray array];
    }
    
    return _Search_Array;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.view.backgroundColor = KViewBackGroupColor;
    
    self.navigationController.delegate = self;
    
    self.TopViewWidth.constant = KScreenWidth * 0.7;
    
    self.NavtionHeight.constant = KSafeTopeHeight;
    
    // 1.创建集合视图
    [self SetUpCollectionView];
    
    // 2.添加热搜的关键词
    [self AddHotKeywords];
    
    // 3.取出本地的历史搜索
    [self TheContentsOfTheSearchArePlacedInTheArrayAndThereIsLocalMobile];
    
}

#pragma mark - UINavigationControllerDelegate

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    // 判断要显示的控制器是否是自己
    BOOL isShowHomePage = [viewController isKindOfClass:[self class]];
    
    [self.navigationController setNavigationBarHidden:isShowHomePage animated:YES];
}

/**
 * @brief 返回上一个界面
 */
- (IBAction)ReturnUpViewBtnClickAction:(UIButton *)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 * @brief 创建集合视图
 */
- (void)SetUpCollectionView{
    
    UICollectionViewFlowLayout *flowlayout = [[UICollectionViewFlowLayout alloc] init];
    [flowlayout setScrollDirection:UICollectionViewScrollDirectionVertical]; //设置滚动方向
    flowlayout.minimumInteritemSpacing = 0; //左右间距
    flowlayout.minimumLineSpacing = 0; //上下间距
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0 , self.NavtionHeight.constant , KScreenWidth, KScreenHeight - KSafeTopeHeight - KSafeBottomHeight) collectionViewLayout:flowlayout];
    
    collectionView.delegate = self;
    
    collectionView.dataSource = self;
    
    collectionView.showsVerticalScrollIndicator = NO;
    
    collectionView.showsHorizontalScrollIndicator = NO;
    
    [collectionView setBackgroundColor:[UIColor whiteColor]];
    
    [collectionView registerClass:[HSQSearchListCell class] forCellWithReuseIdentifier:@"HSQSearchListCell"];
    
    [collectionView registerClass:[HSQClassHeadCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HSQClassHeadCollectionReusableView"];
    
    [self.view addSubview:collectionView];
    
    self.collectionView = collectionView;
    
}

/**
 * @brief 热搜的关键词
 */
- (void)AddHotKeywords{
    
    [[HSQProgressHUDManger Manger] ShowLoadingDataFromeServer:@"" ToView:self.view IsClearColor:YES];
    
    AFNetworkRequestTool *RequestTool = [AFNetworkRequestTool shareRequestTool];
    
    [RequestTool.manger GET:UrlAdress(KHotSearchUrl) parameters:nil progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [[HSQProgressHUDManger Manger] DismissProgressHUD];
        
        if ([responseObject[@"code"] integerValue] == 200)
        {
            [self.keywordList addObjectsFromArray: responseObject[@"datas"][@"keywordList"]];
        }
        
        [self.collectionView reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [[HSQProgressHUDManger Manger] DismissProgressHUD];
        
    }];
}

/**
 * @brief 右边item的点击事件
 */
- (IBAction)SeachBarItemClickAction:(UIButton *)sender {
    
    HSQClassGoodsListViewController *ClassGoodsVC = [[HSQClassGoodsListViewController alloc] init];
    
    [self.navigationController pushViewController:ClassGoodsVC animated:YES];
    
    [self SearchItemClickAction];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionViewDelegate,UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 3;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    if (section == 0)
    {
        return self.keywordList.count;
    }
    else if (section == 1)
    {
        return self.Search_Array.count;
    }
    else
    {
        return 0;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0)
    {
        NSString *name = self.keywordList[indexPath.row];
        
        CGSize nameSize = [NSString SizeOfTheText:name font:[UIFont systemFontOfSize:14.0] MaxSize:CGSizeMake(100, 30)];
        
        return CGSizeMake(nameSize.width + 40, 60);
    }
    else
    {
        return CGSizeMake(KScreenWidth, 50);
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    HSQSearchListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HSQSearchListCell" forIndexPath:indexPath];
    
    if (indexPath.section == 0)
    {
        if (self.keywordList.count != 0)
        {
            cell.nameLabel.text = self.keywordList[indexPath.row];
            
            cell.nameLabel.textAlignment = NSTextAlignmentCenter;
            
            [cell.nameLabel setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"SearchBackGroupImageView"]]];
        }
    }
    else if (indexPath.section == 1)
    {
        cell.nameLabel.text = self.Search_Array[indexPath.row];
        
        cell.nameLabel.textAlignment = NSTextAlignmentLeft;
        
        [cell.nameLabel setBackgroundColor:[UIColor whiteColor]];
    }
    
    return cell;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    
    if (section != 2)
    {
        return CGSizeMake(KScreenWidth, 40);
    }
    else
    {
        return CGSizeMake(KScreenWidth, 90);
    }
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    HSQClassHeadCollectionReusableView *headView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HSQClassHeadCollectionReusableView" forIndexPath:indexPath];
    
    headView.delegate = self;
    
    [headView.head_imageView setHidden:YES];
    
    if (indexPath.section != 2)
    {
        [headView.BottomView setHidden:YES];
        
        if (indexPath.section == 0)
        {
            headView.title_label.text = @"   热搜";
        }
        else
        {
            headView.title_label.text = @"   历史记录";
        }
    }
    else
    {
         [headView.BottomView setHidden:NO];
    }
    
    headView.title_label.font = [UIFont systemFontOfSize:15.0];
    
    return headView;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    HSQClassGoodsListViewController *ClassGoodsVC = [[HSQClassGoodsListViewController alloc] init];
    
    [self.navigationController pushViewController:ClassGoodsVC animated:YES];
}

/**
 * @brief 清除搜索的历史记录
 */
- (void)ClearSearchHistoryButtonClickAction:(UIButton *)sender{
    
    NSFileManager *manger = [NSFileManager defaultManager];
    
    [manger removeItemAtPath:HWSearchHistoryPath error:nil];
    
    [self.Search_Array removeAllObjects];
    
    [self.collectionView reloadData];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    HSQClassGoodsListViewController *ClassGoodsVC = [[HSQClassGoodsListViewController alloc] init];
    
    [self.navigationController pushViewController:ClassGoodsVC animated:YES];

    [self SearchItemClickAction];
    
    return YES;
}

/**
 * @brief 搜索按钮的点击事件
 */
- (void)SearchItemClickAction{
    
    [self.Search_TextField resignFirstResponder];
    
    if (self.Search_TextField.text.length == 0)
    {
        [self.Search_Array addObject:self.Search_TextField.placeholder];
    }
    else
    {
        [self.Search_Array addObject:self.Search_TextField.text];
    }
    
    [self SaveSearchHistory];
    
    [self TheContentsOfTheSearchArePlacedInTheArrayAndThereIsLocalMobile];
}

/**
 * 将搜索的内容放在数组中，存在手机本地
 */
- (void)SaveSearchHistory{
    
    NSMutableArray *SearchArray = [NSKeyedUnarchiver unarchiveObjectWithFile:HWSearchHistoryPath];
    
    if (![SearchArray containsObject:self.Search_TextField.text] && ![SearchArray containsObject:self.Search_TextField.placeholder])
    {
        [NSKeyedArchiver archiveRootObject:self.Search_Array toFile:HWSearchHistoryPath];
    }
}

/**
 * 取出本地的搜索历史
 */
- (void)TheContentsOfTheSearchArePlacedInTheArrayAndThereIsLocalMobile{
    
    [self.Search_Array removeAllObjects];
    
    NSArray *SearchArray = [NSKeyedUnarchiver unarchiveObjectWithFile:HWSearchHistoryPath];
    
    [self.Search_Array addObjectsFromArray:SearchArray];
    
    [self.collectionView reloadData];
}









@end
