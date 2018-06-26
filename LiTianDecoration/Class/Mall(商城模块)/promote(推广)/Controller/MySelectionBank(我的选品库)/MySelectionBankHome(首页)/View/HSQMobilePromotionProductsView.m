//
//  HSQMobilePromotionProductsView.m
//  LiTianDecoration
//
//  Created by administrator on 2018/6/14.
//  Copyright © 2018年 administrator. All rights reserved.
//

#define KPlacherLabelHeight 50

#define KViewHeight KScreenHeight - KSafeBottomHeight

#import "HSQMobilePromotionProductsView.h"
#import "HSQSelectionListModel.h"
#import "HSQAccountTool.h"
#import "HSQChooseProductionGoodsListCell.h"
#import "HSQMoveProductListCell.h"
#import "HSQSelectGroupImageListView.h"

@interface HSQMobilePromotionProductsView ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) UIView *WhiteColor_BgView;

@property (nonatomic, strong) UIView *TopView;

@property (nonatomic, strong) UILabel *Plcher_Label;

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, copy) NSString *IndexString;

@end

@implementation HSQMobilePromotionProductsView

-(NSMutableArray *)dataSource{
    
    if (_dataSource == nil) {
        
        self.dataSource = [NSMutableArray array];
    }
    
    return _dataSource;
}

/**
 * @brief 初始化视图
 */
+ (instancetype)initMobilePromotionProductsView{
    
    HSQMobilePromotionProductsView *publicView = [[HSQMobilePromotionProductsView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KViewHeight)];
    
    publicView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
    
    [[[UIApplication sharedApplication] keyWindow]addSubview:publicView];
    
    return publicView;
}

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        // 1.创建控件
        [self SetUpViews];
        
        // 获取选品库分组列表
        [self GetTheListOfSelectedRepositoryGroups];
        
    }
    
    return self;
}


// 1.创建控件
- (void)SetUpViews{
    
    // 最底部的点击按钮
    UIButton *Bottombtn = [UIButton buttonWithType:(UIButtonTypeSystem)];
    Bottombtn.frame = self.bounds;
    Bottombtn.backgroundColor = [UIColor clearColor];
    [Bottombtn addTarget:self action:@selector(btnClickAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:Bottombtn];
    
    // 1.屏幕一半的背景图
    UIView *WhiteColor_BgView = [[UIView alloc] initWithFrame:CGRectMake(0, KScreenHeight, KScreenWidth,(KViewHeight)/2)];
    WhiteColor_BgView.backgroundColor = KViewBackGroupColor;
    [self addSubview:WhiteColor_BgView];
    self.WhiteColor_BgView = WhiteColor_BgView;
    
    // 1.顶部的背景图
    UIView *TopView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth,KPlacherLabelHeight)];
    TopView.backgroundColor = [UIColor whiteColor];
    [WhiteColor_BgView addSubview:TopView];
    self.TopView = TopView;
    
    // 提示问题
    UILabel *Plcher_Label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KPlacherLabelHeight)];
    Plcher_Label.text = @"推广选品库分组";
    Plcher_Label.font = [UIFont systemFontOfSize:14.0];
    Plcher_Label.textAlignment = NSTextAlignmentCenter;
    [TopView addSubview:Plcher_Label];
    self.Plcher_Label = Plcher_Label;
    
    // 6.添加collectionView
    UICollectionViewFlowLayout *Layout = [[UICollectionViewFlowLayout alloc] init];
    
    Layout.minimumLineSpacing = 5;  // 最小的行间距
    
    Layout.minimumInteritemSpacing = 10; // 最小的列间距
    
    CGFloat collectionHeight = (KViewHeight)/2 - 50;
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 50, KScreenWidth, collectionHeight) collectionViewLayout:Layout];
    
    collectionView.backgroundColor = [UIColor clearColor];
    
    collectionView.showsVerticalScrollIndicator = NO;
    
    collectionView.showsHorizontalScrollIndicator = NO;
    
    [collectionView registerClass:[HSQMoveProductListCell class] forCellWithReuseIdentifier:@"HSQMoveProductListCell"];
    
    collectionView.dataSource = self;
    
    collectionView.delegate = self;
    
    collectionView.contentInset = UIEdgeInsetsMake(10, 0, 10, 0);
    
    [WhiteColor_BgView addSubview:collectionView];
    
    self.collectionView = collectionView;
    
}

#pragma mark - UICollectionViewDelegate,UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.dataSource.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    HSQSelectionListModel *ListModel = self.dataSource[indexPath.row];
    
    CGSize NameSize = [NSString SizeOfTheText:ListModel.distributorFavoritesName font:[UIFont systemFontOfSize:12.0] MaxSize:CGSizeMake((KScreenWidth - 10)/2 - 20, MAXFLOAT)];
    
    CGSize ImageSize = [HSQSelectGroupImageListView sizeWithCount:4];
    
   return CGSizeMake((KScreenWidth - 10)/2, 5 + NameSize.height + 10 + 20 + 5 + ImageSize.height + 5);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    HSQMoveProductListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HSQMoveProductListCell" forIndexPath:indexPath];
    
    HSQSelectionListModel *ListModel = self.dataSource[indexPath.row];
    
    cell.model = ListModel;
    
    return cell;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    HSQSelectionListModel *model = self.dataSource[indexPath.row];
    
    if (self.ClickGroupSuccessBlock)
    {
        self.ClickGroupSuccessBlock(model.distributorFavoritesId);
    }
    
    [self dismissMobilePromotionProductsView];
}

/**
 * @brief 获取选品库分组列表
 */
- (void)GetTheListOfSelectedRepositoryGroups{
    
    [[HSQProgressHUDManger Manger] ShowLoadingDataFromeServer:@"" ToView:self.WhiteColor_BgView IsClearColor:YES];
    
    NSDictionary *params = @{@"token":[HSQAccountTool account].token};
    
    AFNetworkRequestTool *requestTool = [AFNetworkRequestTool shareRequestTool];
    
    [requestTool.manger POST:UrlAdress(KGetsListofSelectedGroupsUrl) parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [[HSQProgressHUDManger Manger] DismissProgressHUD];
        
        if ([responseObject[@"code"] integerValue] == 200){
            
            // 中间的规格列表
            for (NSDictionary *dict in responseObject[@"datas"][@"favList"]){
                
                // 外层数据 有多少个店铺
                HSQSelectionListModel *SelectionListModel = [[HSQSelectionListModel alloc] initWithDictionary:dict error:nil];
                
                SelectionListModel.distributionGoodsVoList = [NSMutableArray array];
                
                SelectionListModel.ImageArrayUrl = [NSMutableArray array];
                
                if (![SelectionListModel.distributorFavoritesId isEqualToString:self.distributorFavoritesId])
                {
                     [self.dataSource addObject:SelectionListModel];
                }
                
                // 内层数据 每个店铺有几个商品
                for (NSInteger i = 0; i < [dict[@"distributionGoodsVoList"] count] ; i++) {
                    
                    NSDictionary *ModelDiction = dict[@"distributionGoodsVoList"][i];
                    
                    HSQSelectionGoodsListModel *GoodsListModel = [[HSQSelectionGoodsListModel alloc] init];
                    
                    [GoodsListModel setValuesForKeysWithDictionary:ModelDiction];
                    
                    [SelectionListModel.distributionGoodsVoList addObject:GoodsListModel];
                    
                    [SelectionListModel.ImageArrayUrl addObject:GoodsListModel.imageSrc];
                }
            }
            
            [self.collectionView reloadData];
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

/**
 * @brief 分组的id
 */
- (void)setDistributorFavoritesId:(NSString *)distributorFavoritesId{
    
    _distributorFavoritesId = distributorFavoritesId;
    
}


















/**
 * @brief 点击背景按钮的点击事件
 */
- (void)btnClickAction:(UIButton *)sender{
    
    [self dismissMobilePromotionProductsView];
}


/**
 * @brief 显示视图
 */
- (void)ShowMobilePromotionProductsView{
    
    [UIView animateWithDuration:0.25 animations:^{
        
        self.WhiteColor_BgView.frame = ({
            
            CGRect frame = self.WhiteColor_BgView.frame;
            
            frame.origin.y = (KScreenHeight) / 2;
            
            frame;
        });
    }];
}

/**
 * @brief 隐藏视图
 */
- (void)dismissMobilePromotionProductsView{
    
    [UIView animateWithDuration:0.25 animations:^{
        
        self.WhiteColor_BgView.frame = ({
            
            CGRect frame = self.WhiteColor_BgView.frame;
            
            frame.origin.y = KScreenHeight;
            
            frame;
        });
    }completion:^(BOOL finished) {
        
        [self.WhiteColor_BgView removeFromSuperview];
        
        [self removeFromSuperview];
    }];
}



@end
