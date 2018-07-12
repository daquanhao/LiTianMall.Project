//
//  HSQHomePageViewController.m
//  LiTianDecoration
//
//  Created by administrator on 2018/4/9.
//  Copyright © 2018年 administrator. All rights reserved.
//

#define KFirstTypeCell @"FirstTypeCell"   // 商城和积分兑换
#define KSecondTypeCell @"SecondTypeCell"   // 楼市资讯，幸运转盘，线下门店
#define KThirdTypeCell @"ThirdTypeCell"   // 装饰公司，装修黄历，喝一杯
#define KFourTypeCell @"FourTypeCell"   // 预约设计师
#define KFiveTypeCell @"FiveTypeCell"   // 装修计算器
#define KSolutionPackage @"SolutionPackage" // 方案套餐
#define KFurnitureHall @"FurnitureHall" // 家具讲堂
#define Kenvironmental @"environmental"  // 五大环保体系
#define KDesignCase @"DesignCase" // 设计案例
#define KTheDesigner @"TheDesigner" // 设计师
#define KdevelopmentCourse @"developmentCourse" // 发展历程

#import "HSQHomePageViewController.h"
#import "HSQMallHomePageController.h" // 商城首页
#import "HSQHomePageFirstTypeViewCell.h"
#import "HSQHomePageSecondTypeViewCell.h"
#import "HSQHomePageHeaderCollectionReusableView.h"
#import "HSQSolutionPackageViewCell.h"  // 方案套餐
#import "HSQFurnitureHallCollectionViewCell.h"  // 家具讲堂
#import "HSQDesignCaseViewCell.h"  // 设计案例
#import "HSQTheDesignerCollectionViewCell.h" // 设计师
#import "HSQDevelopmentCourseViewCell.h" // 发展历程

@interface HSQHomePageViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,HSQHomePageFirstTypeViewCellDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSMutableArray *section_array;

@property (nonatomic, strong) NSMutableArray *row_array;

@end

@implementation HSQHomePageViewController

- (NSMutableArray *)section_array{
    
    if (_section_array == nil) {
        
        self.section_array = [NSMutableArray array];
    }
    
    return _section_array;
}

- (NSMutableArray *)row_array{
    
    if (_row_array == nil) {
        
        self.row_array = [NSMutableArray array];
    }
    
    return _row_array;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.view.backgroundColor = KViewBackGlobalGroupColor;

    self.navigationItem.title = @"首页";
    
    // 创建集合视图
    [self CreatCollectionView];

    // 请求首页的数据
    [self RequestDataFromTheHomePage];
}

/**
 * @brief  创建集合视图
 */
- (void)CreatCollectionView{
    
    UICollectionViewFlowLayout *Layout = [[UICollectionViewFlowLayout alloc] init];
    
    CGFloat collectionHeight = KScreenHeight - KSafeBottomHeight - KSafeTopeHeight - 50;
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, collectionHeight) collectionViewLayout:Layout];
    
    collectionView.backgroundColor = [UIColor clearColor];
    
    collectionView.dataSource = self;
    
    collectionView.delegate = self;
    
    collectionView.contentInset = UIEdgeInsetsMake(0, 7.5, 0, 7.5);
    
    collectionView.showsVerticalScrollIndicator = NO;
    
    collectionView.showsHorizontalScrollIndicator = NO;
    
//    [collectionView registerClass:[HSQMallHomeHeadView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HSQMallHomeHeadView"];
//
//    [collectionView registerClass:[HSQModelViewReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HSQModelViewReusableView"];
//
//    [collectionView registerClass:[HSQSecondsKillReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HSQSecondsKillReusableView"];
//
    [collectionView registerClass:[HSQHomePageHeaderCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HSQHomePageHeaderCollectionReusableView"];
    
    // 商城，积分兑换
    [collectionView registerClass:[HSQHomePageFirstTypeViewCell class] forCellWithReuseIdentifier:@"HSQHomePageFirstTypeViewCell"];
    
    [collectionView registerClass:[HSQHomePageSecondTypeViewCell class] forCellWithReuseIdentifier:@"HSQHomePageSecondTypeViewCell"];
    
    // 方案套餐
    [collectionView registerClass:[HSQFurnitureHallCollectionViewCell class] forCellWithReuseIdentifier:@"HSQFurnitureHallCollectionViewCell"];
    
    // 家具讲堂
    [collectionView registerClass:[HSQSolutionPackageViewCell class] forCellWithReuseIdentifier:@"HSQSolutionPackageViewCell"];
    
    // 设计师
    [collectionView registerClass:[HSQTheDesignerCollectionViewCell class] forCellWithReuseIdentifier:@"HSQTheDesignerCollectionViewCell"];
    
    // 设计案例
    [collectionView registerClass:[HSQDesignCaseViewCell class] forCellWithReuseIdentifier:@"HSQDesignCaseViewCell"];
    
    // 发展历程
    [collectionView registerClass:[HSQDevelopmentCourseViewCell class] forCellWithReuseIdentifier:@"HSQDevelopmentCourseViewCell"];
    
    [self.view addSubview:collectionView];
    
    self.collectionView = collectionView;
}

/**
 * @brief 请求首页的数据
 */
- (void)RequestDataFromTheHomePage{
    
    NSMutableDictionary *first_diction = [NSMutableDictionary dictionary];
    first_diction[@"name"] = KFirstTypeCell;
    first_diction[@"count"] = [NSMutableArray arrayWithObjects:@"KFirstTypeCell", nil];
    [self.section_array addObject:first_diction];
    
    NSMutableDictionary *second_diction = [NSMutableDictionary dictionary];
    second_diction[@"name"] = KSecondTypeCell;
    second_diction[@"count"] = [NSMutableArray arrayWithObjects:@"loushizixun",@"shouye_zhuanpan",@"shouye_mendian",@"shouye_gongsi",@"shouye_huangli",@"shouye_kafei", nil];
    [self.section_array addObject:second_diction];
    
    NSMutableDictionary *third_diction = [NSMutableDictionary dictionary];
    third_diction[@"name"] = KThirdTypeCell;
    third_diction[@"count"] = [NSMutableArray arrayWithObjects:@"yuyueshejishi",@"A0A3D813-F8D5-46F3-96C2-C261248D98CF", nil];
    [self.section_array addObject:third_diction];
    
    // 方案套餐
    NSMutableDictionary *SolutionPackage_diction = [NSMutableDictionary dictionary];
    SolutionPackage_diction[@"name"] = KSolutionPackage;
    SolutionPackage_diction[@"count"] = [NSMutableArray arrayWithObjects:@"yuyueshejishi", nil];
    [self.section_array addObject:SolutionPackage_diction];
    
    // 家具讲堂
    NSMutableDictionary *FurnitureHall_diction = [NSMutableDictionary dictionary];
    FurnitureHall_diction[@"name"] = KFurnitureHall;
    FurnitureHall_diction[@"count"] = [NSMutableArray arrayWithObjects:@"yuyueshejishi", nil];
    [self.section_array addObject:FurnitureHall_diction];
    
    // 设计师
    NSMutableDictionary *TheDesigner_diction = [NSMutableDictionary dictionary];
    TheDesigner_diction[@"name"] = KTheDesigner;
    TheDesigner_diction[@"count"] = [NSMutableArray arrayWithObjects:@"baozhang01",nil];
    [self.section_array addObject:TheDesigner_diction];
    
    // 设计案例
    NSMutableDictionary *DesignCase_diction = [NSMutableDictionary dictionary];
    DesignCase_diction[@"name"] = KDesignCase;
    DesignCase_diction[@"count"] = [NSMutableArray arrayWithObjects:@"baozhang01",nil];
    [self.section_array addObject:DesignCase_diction];
    
    // 发展历程
    NSMutableDictionary *developmentCourse_diction = [NSMutableDictionary dictionary];
    developmentCourse_diction[@"name"] = KdevelopmentCourse;
    developmentCourse_diction[@"count"] = [NSMutableArray arrayWithObjects:@"baozhang01",nil];
    [self.section_array addObject:developmentCourse_diction];
    
    // 五大环保体系
    NSMutableDictionary *environmental_diction = [NSMutableDictionary dictionary];
    environmental_diction[@"name"] = Kenvironmental;
    environmental_diction[@"count"] = [NSMutableArray arrayWithObjects:@"baozhang01", @"baozhang02",@"baozhang03",@"baozhang04",@"baozheng05",nil];
    [self.section_array addObject:environmental_diction];
    
    
    [self.collectionView reloadData];

}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    
}

#pragma mark - UICollectionViewDelegate,UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return self.section_array.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    NSDictionary *diction = self.section_array[section];

    NSArray *array = diction[@"count"];

    return array.count;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{

    NSDictionary *diction = self.section_array[section];
    
    NSString *type = diction[@"name"];
    
    if ([type isEqualToString:KSolutionPackage]) // 方案套餐
    {
        return CGSizeMake(KScreenWidth , 50);
    }
    else if([type isEqualToString:KFurnitureHall]) // 家具讲堂
    {
        return CGSizeMake(KScreenWidth , 50);
    }
    else if([type isEqualToString:KTheDesigner]) // 设计师
    {
        return CGSizeMake(KScreenWidth , 50);
    }
    else if([type isEqualToString:KDesignCase]) // 设计案例
    {
        return CGSizeMake(KScreenWidth , 50);
    }
    else if([type isEqualToString:KdevelopmentCourse]) // 发展历程
    {
        return CGSizeMake(KScreenWidth , 50);
    }
    else if([type isEqualToString:Kenvironmental]) // 五大环保体系
    {
        return CGSizeMake(KScreenWidth , 50);
    }
    else
    {
        return CGSizeMake(0, 0);
    }
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{

    NSDictionary *diction = self.section_array[indexPath.section];
    
    NSString *type = diction[@"name"];
    
    HSQHomePageHeaderCollectionReusableView *headView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HSQHomePageHeaderCollectionReusableView" forIndexPath:indexPath];
    
    if ([type isEqualToString:KSolutionPackage]) // 方案套餐
    {
        headView.Placher_Label.text = @"方案套餐";
        headView.More_Button.hidden = NO;
    }
    else if([type isEqualToString:KFurnitureHall]) // 家具讲堂
    {
        headView.Placher_Label.text = @"家具讲堂";
        headView.More_Button.hidden = NO;
    }
    else if([type isEqualToString:KTheDesigner]) // 设计师
    {
        headView.Placher_Label.text = @" 设计师";
        headView.More_Button.hidden = NO;
    }
    else if([type isEqualToString:KDesignCase]) // 设计案例
    {
        headView.Placher_Label.text = @"设计案例";
        headView.More_Button.hidden = NO;
    }
    else if([type isEqualToString:KdevelopmentCourse]) // 发展历程
    {
        headView.Placher_Label.text = @"发展历程";
        headView.More_Button.hidden = YES;
    }
    else if([type isEqualToString:Kenvironmental]) // 五大质保体系
    {
        headView.Placher_Label.text = @"五大质保体系";
        headView.More_Button.hidden = YES;
    }
    else
    {
       headView.Placher_Label.text = @"";
        headView.More_Button.hidden = YES;
    }
    
    return headView;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *diction = self.section_array[indexPath.section];

    NSString *type = diction[@"name"];

    if ([type isEqualToString:KFirstTypeCell]) // 商城，积分兑换
    {
        return CGSizeMake(KScreenWidth - 15 , (KScreenWidth - 15) * 11 / 35);
    }
    else if([type isEqualToString:KSecondTypeCell])
    {
        return CGSizeMake((KScreenWidth - 15) / 3, (KScreenWidth - 15) / 3);
    }
    else if([type isEqualToString:KThirdTypeCell])
    {
       return CGSizeMake(KScreenWidth - 15 , (KScreenWidth - 15) * 11 / 35);
    }
    else if ([type isEqualToString:KSolutionPackage]) // 方案套餐
    {
        return CGSizeMake(KScreenWidth - 15  , (KScreenWidth - 15 ) * 4 / 7);
    }
    else if([type isEqualToString:KFurnitureHall]) // 家具讲堂
    {
        return CGSizeMake(KScreenWidth - 15 , (KScreenWidth - 15) * 5 / 7);
    }
    else if([type isEqualToString:KTheDesigner]) // 设计师
    {
        return CGSizeMake(KScreenWidth - 15 , (KScreenWidth - 15) * 22 / 35);
    }
    else if([type isEqualToString:KDesignCase]) // 设计案例
    {
        return CGSizeMake(KScreenWidth - 15 , (KScreenWidth - 15) * 22 / 35);
    }
    else if([type isEqualToString:KdevelopmentCourse]) // 发展历程
    {
        return CGSizeMake(KScreenWidth - 15 , (KScreenWidth - 15) * 11 / 7);
    }
    else if([type isEqualToString:Kenvironmental]) // 五大质保体系
    {
        if (indexPath.row == 0)
        {
            return CGSizeMake(KScreenWidth - 15 , (KScreenWidth - 15) * 17 / 35);
        }
        else
        {
            return CGSizeMake((KScreenWidth - 15)/2 , ((KScreenWidth - 15)/2 ) * 11 / 17);
        }
    }
    else
    {
        return CGSizeMake(0, 0);
    }
}

// 两个cell之间的最小间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    
    return 0;
}

// 行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *diction = self.section_array[indexPath.section];

    NSArray *array = diction[@"count"];

    NSString *type = diction[@"name"];

    if ([type isEqualToString:KFirstTypeCell]) // 商城，积分兑换
    {
        HSQHomePageFirstTypeViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HSQHomePageFirstTypeViewCell" forIndexPath:indexPath];
        
        cell.delegate = self;

        return cell;
    }
    else if([type isEqualToString:KSecondTypeCell] || [type isEqualToString:KThirdTypeCell] || [type isEqualToString:Kenvironmental])
    {
        HSQHomePageSecondTypeViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HSQHomePageSecondTypeViewCell" forIndexPath:indexPath];

        cell.Placher_ImageView.image = KImageName(array[indexPath.row]);

        return cell;
    }
    else if([type isEqualToString:KFurnitureHall]) //家具讲堂
    {
        HSQSolutionPackageViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HSQSolutionPackageViewCell" forIndexPath:indexPath];
        
        return cell;
    }
    else if([type isEqualToString:KTheDesigner]) // 设计师
    {
        HSQTheDesignerCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HSQTheDesignerCollectionViewCell" forIndexPath:indexPath];
        
         cell.TheDesign_array = [NSMutableArray arrayWithObjects:@"",@"",@"",@"",@"",@"", nil];
        
        return cell;
    }
    else if([type isEqualToString:KDesignCase]) // 设计案例
    {
        HSQDesignCaseViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HSQDesignCaseViewCell" forIndexPath:indexPath];
        
        cell.DesignCase_array = [NSMutableArray arrayWithObjects:@"",@"",@"",@"",@"",@"", nil];
        
        return cell;
    }
    else if([type isEqualToString:KdevelopmentCourse]) // 发展历程
    {
        HSQDevelopmentCourseViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HSQDevelopmentCourseViewCell" forIndexPath:indexPath];
        
        return cell;
    }
    else // 方案套餐
    {
        HSQFurnitureHallCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HSQFurnitureHallCollectionViewCell" forIndexPath:indexPath];

        return cell;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
}

/**
 * @brief 点击商城
 */
- (void)EnterTheMallModuleBtnClickAction:(UIButton *)sender{
    
    HSQMallHomePageController *mallHomeVC = [[HSQMallHomePageController alloc] init];
    
    mallHomeVC.Index_Number = @"100";
    
    [self.navigationController pushViewController:mallHomeVC animated:YES];
}

/**
 * @brief 积分兑换
 */
- (void)EntryPointExchangeBtnClickAction:(UIButton *)sender{
    
    
}








@end
