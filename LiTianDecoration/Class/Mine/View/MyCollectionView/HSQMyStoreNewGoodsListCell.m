//
//  HSQMyStoreNewGoodsListCell.m
//  LiTianDecoration
//
//  Created by administrator on 2018/6/29.
//  Copyright © 2018年 administrator. All rights reserved.
//

#define KCollectionViewHeight  (KScreenWidth / 4) + 40

#import "HSQMyStoreNewGoodsListCell.h"
#import "HSQStoreCollectionListDataModel.h"
#import "HSQStoreNewGoodsListCell.h"

@interface HSQMyStoreNewGoodsListCell ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation HSQMyStoreNewGoodsListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.contentView.backgroundColor = [UIColor purpleColor];
        
        // 创建CollectionView
        [self SetUpCollectionView];
    }
    
    return self;
}

/**
 * @brief 创建CollectionView
 */
- (void)SetUpCollectionView{
    
    UICollectionViewFlowLayout *Layout = [[UICollectionViewFlowLayout alloc] init];
    
    Layout.minimumLineSpacing = 0;  // 最小的行间距
    
    Layout.minimumInteritemSpacing = 0; // 最小的列间距
    
    Layout.scrollDirection = UICollectionViewScrollDirectionHorizontal; // 横向滚动
    
//    CGFloat collectionHeight = KCollectionViewHeight;
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) collectionViewLayout:Layout];
    
    collectionView.backgroundColor = [UIColor clearColor];
    
    collectionView.dataSource = self;
    
    collectionView.delegate = self;
    
    collectionView.showsVerticalScrollIndicator = NO;
    
    collectionView.showsHorizontalScrollIndicator = NO;
    
    [collectionView registerNib:[UINib nibWithNibName:@"HSQStoreNewGoodsListCell" bundle:nil] forCellWithReuseIdentifier:@"HSQStoreNewGoodsListCell"];
    
    [self.contentView addSubview:collectionView];
    
    self.collectionView = collectionView;
    
    self.collectionView.sd_layout.leftSpaceToView(self.contentView, 0).topSpaceToView(self.contentView, 0).rightSpaceToView(self.contentView, 0).bottomSpaceToView(self.contentView, 0);
    
}

#pragma mark - UICollectionViewDelegate,UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.StoreListModel.StoreNewGoodsList.count + 1;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake(KCollectionViewHeight - 40, KCollectionViewHeight);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    HSQStoreNewGoodsListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HSQStoreNewGoodsListCell" forIndexPath:indexPath];
    
    if (indexPath.row == self.StoreListModel.StoreNewGoodsList.count)
    {
        cell.Goods_BgView.hidden = YES;
        
        cell.Placher_View.hidden = NO;
    }
    else
    {
        cell.Goods_BgView.hidden = NO;
        
        cell.Placher_View.hidden = YES;
        
        HSQNewGoodsListModel *NewGoodsModel = self.StoreListModel.StoreNewGoodsList[indexPath.row];
        
        [cell.Goods_ImageView sd_setImageWithURL:[NSURL URLWithString:NewGoodsModel.imageSrc] placeholderImage:KGoodsPlacherImage];
        
        cell.GoodsPrice_Label.text = [NSString stringWithFormat:@"¥%.2f",NewGoodsModel.appPrice0.floatValue];
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(JoinGoodsDetailViewControllerWithindexPath:StoreModel:)]) {
        
        [self.delegate JoinGoodsDetailViewControllerWithindexPath:indexPath StoreModel:self.StoreListModel];
    }
}

/**
 * @brief 数据模型
 */
- (void)setStoreListModel:(HSQStoreCollectionListDataModel *)StoreListModel{
    
    _StoreListModel = StoreListModel;
    
    [self.collectionView reloadData];
}

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];

    self.selectionStyle = UITableViewCellSelectionStyleNone;
}



@end
