//
//  HSQMiaoShaGoodsView.m
//  LiTianDecoration
//
//  Created by administrator on 2018/5/7.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import "HSQMiaoShaGoodsView.h"
#import "HSQMiaoShaGoodsListCell.h"

@interface HSQMiaoShaGoodsView ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation HSQMiaoShaGoodsView

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        // 创建集合视图
        [self CreatCollectionView];
    }
    
    return self;
}

/**
 * @brief  创建集合视图
 */
- (void)CreatCollectionView{
    
    UICollectionViewFlowLayout *Layout = [[UICollectionViewFlowLayout alloc] init];
    
    Layout.minimumLineSpacing = 1;  // 最小的行间距
    
    Layout.minimumInteritemSpacing = 1; // 最小的列间距
    
    Layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;  // 改变滚动方向
        
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KSecondViewHeight - 90) collectionViewLayout:Layout];
    
    collectionView.backgroundColor = [UIColor clearColor];
    
    collectionView.dataSource = self;
    
    collectionView.delegate = self;
    
    collectionView.showsVerticalScrollIndicator = NO;
    
    collectionView.showsHorizontalScrollIndicator = NO;
    
    [collectionView registerNib:[UINib nibWithNibName:@"HSQMiaoShaGoodsListCell" bundle:nil] forCellWithReuseIdentifier:@"HSQMiaoShaGoodsListCell"];
    
    [self addSubview:collectionView];
    
    self.collectionView = collectionView;
}

#pragma mark - UICollectionViewDelegate,UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return 10;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake(KScreenWidth / 4, self.mj_h);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    HSQMiaoShaGoodsListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HSQMiaoShaGoodsListCell" forIndexPath:indexPath];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
}

- (void)setGoods_Array:(NSArray *)Goods_Array{
    
    _Goods_Array = Goods_Array;
    
    [self.collectionView reloadData];
}



@end
