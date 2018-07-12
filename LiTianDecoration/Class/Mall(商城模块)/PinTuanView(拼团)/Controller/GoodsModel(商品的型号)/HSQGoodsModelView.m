//
//  HSQGoodsModelView.m
//  LiTianDecoration
//
//  Created by administrator on 2018/5/14.
//  Copyright © 2018年 administrator. All rights reserved.
//

#define KViewHeight KScreenHeight - KSafeBottomHeight

#import "HSQGoodsModelView.h"
#import "HSQGuiGeLIstHeadReusableView.h"
#import "HSQGoodsGuiGeListCell.h"
#import "HSQGoodsGuiGeTypeModel.h"
#import "HSQGoodsGuiGeFooterReusableView.h"

@interface HSQGoodsModelView ()<UICollectionViewDelegate,UICollectionViewDataSource,HSQGoodsGuiGeFooterReusableViewDelegate>

@property (nonatomic, strong) UIView *BackGroupView;

@property (nonatomic, strong) UIButton *exit_Btn; // 退出按钮

@property (nonatomic, strong) UIImageView *GoodsImageView; // 商品的图片

@property (nonatomic, strong) UILabel *GoodsPrice; // 商品的价格及库存

@property (nonatomic, strong) UILabel *YiXuanGoods; // 已选的商品

@property (nonatomic, strong) UIView *LineView;  // 商品图片下面的分割线

@property (nonatomic, strong) UIButton *BottomClickBtn; // 底部点击的按钮

@property (nonatomic, strong) UICollectionView *collectionView; // 中间的规格列表

@property (nonatomic, strong) NSMutableArray *dataSource;

@property(nonatomic,strong)NSIndexPath *lastPath; // 并且对其synthesize

@property (nonatomic, copy) NSString *GoodsKuCunString; // 商品的库存

@property (nonatomic, copy) NSString *SelectKuCunString; // 商品的选好的库存

@property (nonatomic, copy) NSString *Goods_id; // 商品的id

@property (nonatomic, copy) NSString *goodsSpecString; // 商品规格

@property (nonatomic, copy) NSString *goodsPriceString; // 商品价格

@end

@implementation HSQGoodsModelView

@synthesize lastPath;

- (NSMutableArray *)dataSource{
    
    if (_dataSource == nil) {
        
        self.dataSource = [NSMutableArray array];
    }
    
    return _dataSource;
}

/**
 * @brief 初始化视图
 */
+ (instancetype)initGoodsModelView{
    
    HSQGoodsModelView *publicView = [[HSQGoodsModelView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KViewHeight)];
    
    publicView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
    
    [[[UIApplication sharedApplication] keyWindow]addSubview:publicView];
    
    return publicView;
}

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        // 1.创建控件
        [self SetUpViews];
        
    }
    
    return self;
}

// 1.创建控件
- (void)SetUpViews{
    
    // 1.最底部的点击按钮
    UIButton *Bottombtn = [UIButton buttonWithType:(UIButtonTypeSystem)];
    Bottombtn.backgroundColor = [UIColor clearColor];
    Bottombtn.frame = self.bounds;
    [Bottombtn addTarget:self action:@selector(btnClickAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:Bottombtn];
    
    // 2.屏幕一半的背景图
    UIView *BackGroupView = [[UIView alloc] initWithFrame:CGRectMake(0, KScreenHeight, KScreenWidth,(KViewHeight)/2)];
    BackGroupView.backgroundColor = [UIColor whiteColor];
    [self addSubview:BackGroupView];
    self.BackGroupView = BackGroupView;
    
    // 3.商品的图片
    UIImageView *GoodsImageView = [[UIImageView alloc] init];
    GoodsImageView.layer.cornerRadius = 5;
    GoodsImageView.clipsToBounds = YES;
    GoodsImageView.frame = CGRectMake(10, -30, KScreenWidth*100/375, KScreenWidth*100/375);
    [BackGroupView addSubview:GoodsImageView];
    self.GoodsImageView = GoodsImageView;
    
    // 3.1.商品下面的图片
    UIView *LineView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.GoodsImageView.frame)+10, KScreenWidth, 1)];
    LineView.backgroundColor = KViewBackGroupColor;
    [BackGroupView addSubview:LineView];
    self.LineView = LineView;
    
    // 4.商品的已选规格
    UILabel *YiXuanGoods = [[UILabel alloc] init];
    YiXuanGoods.textColor = RGB(150, 150, 150);
    YiXuanGoods.font = [UIFont systemFontOfSize:12.0];
    YiXuanGoods.numberOfLines = 0;
    [BackGroupView addSubview:YiXuanGoods];
    self.YiXuanGoods = YiXuanGoods;

    // 5.商品的价格和库存
    UILabel *GoodsPrice = [[UILabel alloc] init];
    GoodsPrice.textColor = RGB(238, 58, 68);
    GoodsPrice.font = [UIFont systemFontOfSize:14.0];
    [BackGroupView addSubview:GoodsPrice];
    self.GoodsPrice = GoodsPrice;
    
    // 底部点击的按钮
    UIButton *BottomClickBtn = [UIButton buttonWithType:(UIButtonTypeSystem)];
    [BottomClickBtn setBackgroundImage:[UIImage ImageWithColor:RGB(238, 58, 68)] forState:(UIControlStateNormal)];
    [BottomClickBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    BottomClickBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
    BottomClickBtn.frame = CGRectMake(0, BackGroupView.mj_h - 50, KScreenWidth, 50);
    BottomClickBtn.titleLabel.numberOfLines = 0;
    BottomClickBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [BottomClickBtn addTarget:self action:@selector(BottomClickBtnClickAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [BackGroupView addSubview:BottomClickBtn];
    self.BottomClickBtn = BottomClickBtn;
    
    // 中间的规格列表
    UICollectionViewFlowLayout *Layout = [[UICollectionViewFlowLayout alloc] init];
    Layout.minimumLineSpacing = 1;  // 最小的行间距
    Layout.minimumInteritemSpacing = 1; // 最小的列间距
    CGFloat collectionHeight = BackGroupView.mj_h - CGRectGetMaxY(self.LineView.frame) - 50;
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.LineView.frame), KScreenWidth, collectionHeight) collectionViewLayout:Layout];
    collectionView.backgroundColor = [UIColor clearColor];
    collectionView.dataSource = self;
    collectionView.delegate = self;
    collectionView.showsVerticalScrollIndicator = NO;
    collectionView.showsHorizontalScrollIndicator = NO;
    [collectionView registerClass:[HSQGuiGeLIstHeadReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HSQGuiGeLIstHeadReusableView"];
    [collectionView registerNib:[UINib nibWithNibName:@"HSQGoodsGuiGeListCell" bundle:nil] forCellWithReuseIdentifier:@"HSQGoodsGuiGeListCell"];
    [collectionView registerNib:[UINib nibWithNibName:@"HSQGoodsGuiGeFooterReusableView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"HSQGoodsGuiGeFooterReusableView"];
    [BackGroupView addSubview:collectionView];
    self.collectionView = collectionView;
    
}

/**
 * @brief 数据赋值
 */
- (void)setDataDiction:(NSDictionary *)dataDiction{
    
    _dataDiction = dataDiction;
    
    NSDictionary *GoodsDiction = [dataDiction[@"groupGoodsDetailVo"][@"specJson"] firstObject];
    
    // 商品的图片
    [self.GoodsImageView sd_setImageWithURL:[NSURL URLWithString:GoodsDiction[@"specValueList"][0][@"imageSrc"]] placeholderImage:KGoodsPlacherImage];
    
    // 购买的价格及库存
    NSArray *GoodsListArray = dataDiction[@"groupGoodsDetailVo"][@"goodsList"];
    NSDictionary *FirstGoodsDiction = GoodsListArray[0];
    
    // 已选的规格
    self.goodsSpecString = [NSString stringWithFormat:@"%@",FirstGoodsDiction[@"goodsSpecString"]];
    NSString *GuiGeString = [NSString stringWithFormat:@"已选: %@",FirstGoodsDiction[@"goodsSpecString"]];
    CGSize GuiGeSize = [NSString SizeOfTheText:GuiGeString font:[UIFont systemFontOfSize:12.0] MaxSize:CGSizeMake(KScreenWidth - CGRectGetMaxX(self.GoodsImageView.frame)-20, MAXFLOAT)];
    self.YiXuanGoods.text = GuiGeString;
    self.YiXuanGoods.frame = CGRectMake(CGRectGetMaxX(self.GoodsImageView.frame)+10, CGRectGetMaxY(self.GoodsImageView.frame) - GuiGeSize.height, KScreenWidth -CGRectGetMaxX(self.GoodsImageView.frame) -20 , GuiGeSize.height);
    
    // 价格及库存
    NSString *Keys = (self.TypeString.integerValue == 100 ? @"appPrice0":@"groupPrice");
    self.GoodsPrice.text = [NSString stringWithFormat:@"¥%@(库存: %@%@)",FirstGoodsDiction[Keys],FirstGoodsDiction[@"goodsStorage"],dataDiction[@"groupGoodsDetailVo"][@"unitName"]];
    self.GoodsPrice.frame = CGRectMake(self.YiXuanGoods.mj_x, self.YiXuanGoods.mj_y - 25, self.YiXuanGoods.mj_w , 20);
    self.GoodsKuCunString = [NSString stringWithFormat:@"%@",FirstGoodsDiction[@"goodsStorage"]];
    
    // 商品的id
    self.Goods_id = [NSString stringWithFormat:@"%@",FirstGoodsDiction[@"goodsId"]];

    // 拼团的人数及价格（判断商品是否有拼团信息）
  NSString *groups = [NSString stringWithFormat:@"%@",dataDiction[@"groupGoodsDetailVo"][@"groups"]];
    
    if (![groups isEqualToString:@"<null>"])
    {
        NSString *count = [NSString stringWithFormat:@"%@",dataDiction[@"groupGoodsDetailVo"][@"groups"][@"groupRequireNum"]];
        
        NSString *PlacherString = (self.TypeString.integerValue == 100 ? @"单独购买":@"拼团");
        
        NSString *BottomText = (self.TypeString.integerValue == 100 ? [NSString stringWithFormat:@"¥%@\n%@",FirstGoodsDiction[Keys],PlacherString] :[NSString stringWithFormat:@"¥%@\n%@%@",FirstGoodsDiction[Keys],count,PlacherString]);
        
        [self.BottomClickBtn setTitle:BottomText forState:(UIControlStateNormal)];
    }
    
    if (self.Source == 200) // 收藏列表详情跳转过里的
    {
        [self.BottomClickBtn setTitle:@"加入购物车" forState:(UIControlStateNormal)];
    }

    // 中间的规格列表
    for (NSDictionary *dict in dataDiction[@"groupGoodsDetailVo"][@"specJson"])
    {
        // 外层数据
        HSQGoodsGuiGeTypeModel *ReceiveModel = [[HSQGoodsGuiGeTypeModel alloc] initWithDictionary:dict error:nil];
        
        ReceiveModel.specValueList = [NSMutableArray array];
        
        [self.dataSource addObject:ReceiveModel];
        
        // 内层数据
        for (NSInteger i = 0; i < [dict[@"specValueList"] count] ; i++) {
            
            NSDictionary *ModelDiction = dict[@"specValueList"][i];
            
            HSQGoodsGuiGeListModel *ListModel = [[HSQGoodsGuiGeListModel alloc] init];
            
            [ListModel setValuesForKeysWithDictionary:ModelDiction];
            
            ListModel.IsSelect = (i == 0 ? @"1" : @"0");
            
            [ReceiveModel.specValueList addObject:ListModel];
        }
    }
    
    [self.collectionView reloadData];
   
    
}

/**
 * @brief 积分商品详情的规格数据
 */
-(void)setPointDatasDiction:(NSDictionary *)PointDatasDiction{
    
    _PointDatasDiction = PointDatasDiction;
    
    NSDictionary *GoodsDiction = [PointDatasDiction[@"pointsGoodsDetailVo"][@"specJson"] firstObject];
    
    // 商品的图片
    [self.GoodsImageView sd_setImageWithURL:[NSURL URLWithString:GoodsDiction[@"specValueList"][0][@"imageSrc"]] placeholderImage:KGoodsPlacherImage];
    
    // 购买的价格及库存
    NSArray *GoodsListArray = PointDatasDiction[@"pointsGoodsDetailVo"][@"goodsList"];
    NSDictionary *FirstGoodsDiction = GoodsListArray[0];
    
    // 已选的规格
     self.goodsSpecString = [NSString stringWithFormat:@"%@",FirstGoodsDiction[@"goodsSpecString"]];
    NSString *GuiGeString = [NSString stringWithFormat:@"已选: %@",FirstGoodsDiction[@"goodsSpecString"]];
    CGSize GuiGeSize = [NSString SizeOfTheText:GuiGeString font:[UIFont systemFontOfSize:12.0] MaxSize:CGSizeMake(KScreenWidth - CGRectGetMaxX(self.GoodsImageView.frame)-20, MAXFLOAT)];
    self.YiXuanGoods.text = GuiGeString;
    self.YiXuanGoods.frame = CGRectMake(CGRectGetMaxX(self.GoodsImageView.frame)+10, CGRectGetMaxY(self.GoodsImageView.frame) - GuiGeSize.height, KScreenWidth -CGRectGetMaxX(self.GoodsImageView.frame) -20 , GuiGeSize.height);
    
    // 价格及库存
    NSString *Keys = (self.TypeString.integerValue == 100 ? @"appPrice0":@"groupPrice");
    
    self.GoodsPrice.text = [NSString stringWithFormat:@"¥%@(库存: %@%@)",FirstGoodsDiction[Keys],FirstGoodsDiction[@"goodsStorage"],PointDatasDiction[@"pointsGoodsDetailVo"][@"unitName"]];
    
    self.GoodsPrice.frame = CGRectMake(self.YiXuanGoods.mj_x, self.YiXuanGoods.mj_y - 25, self.YiXuanGoods.mj_w , 20);
    
    self.GoodsKuCunString = [NSString stringWithFormat:@"%@",FirstGoodsDiction[@"goodsStorage"]];
    
    // 商品的id
    self.Goods_id = [NSString stringWithFormat:@"%@",FirstGoodsDiction[@"goodsId"]];
    
    // 拼团的人数及价格（判断商品是否有拼团信息）
    NSString *groups = [NSString stringWithFormat:@"%@",PointDatasDiction[@"pointsGoodsDetailVo"][@"groups"]];
    
    if (![groups isEqualToString:@"<null>"])
    {
        NSString *count = [NSString stringWithFormat:@"%@",PointDatasDiction[@"pointsGoodsDetailVo"][@"groups"][@"groupRequireNum"]];
        
        if (self.TypeString.integerValue == 300)
        {
             [self.BottomClickBtn setTitle:@"我要换购" forState:(UIControlStateNormal)];
        }
        else
        {
            NSString *PlacherString = (self.TypeString.integerValue == 100 ? @"单独购买":@"拼团");
            
            NSString *BottomText = (self.TypeString.integerValue == 100 ? [NSString stringWithFormat:@"¥%@\n%@",FirstGoodsDiction[Keys],PlacherString] :[NSString stringWithFormat:@"¥%@\n%@%@",FirstGoodsDiction[Keys],count,PlacherString]);
            
            [self.BottomClickBtn setTitle:BottomText forState:(UIControlStateNormal)];
        }
    }
    
    if (self.Source == 200) // 收藏列表详情跳转过里的
    {
        [self.BottomClickBtn setTitle:@"加入购物车" forState:(UIControlStateNormal)];
    }
    
    // 中间的规格列表
    for (NSDictionary *dict in PointDatasDiction[@"pointsGoodsDetailVo"][@"specJson"])
    {
        // 外层数据
        HSQGoodsGuiGeTypeModel *ReceiveModel = [[HSQGoodsGuiGeTypeModel alloc] initWithDictionary:dict error:nil];
        
        ReceiveModel.specValueList = [NSMutableArray array];
        
        [self.dataSource addObject:ReceiveModel];
        
        // 内层数据
        for (NSInteger i = 0; i < [dict[@"specValueList"] count] ; i++) {
            
            NSDictionary *ModelDiction = dict[@"specValueList"][i];
            
            HSQGoodsGuiGeListModel *ListModel = [[HSQGoodsGuiGeListModel alloc] init];
            
            [ListModel setValuesForKeysWithDictionary:ModelDiction];
            
            ListModel.IsSelect = (i == 0 ? @"1" : @"0");
            
            [ReceiveModel.specValueList addObject:ListModel];
        }
    }
    
    [self.collectionView reloadData];
}

/**
 * @brief 普通商品详情的规格数据
 */
- (void)setOrdinary_DatasDiction:(NSDictionary *)Ordinary_DatasDiction{
    
    _Ordinary_DatasDiction = Ordinary_DatasDiction;
    
    NSDictionary *GoodsDiction = [Ordinary_DatasDiction[@"goodsDetail"][@"specJson"] firstObject];
    
    // 商品的图片
    [self.GoodsImageView sd_setImageWithURL:[NSURL URLWithString:GoodsDiction[@"specValueList"][0][@"imageSrc"]] placeholderImage:KGoodsPlacherImage];
    
    // 购买的价格及库存
    NSArray *GoodsListArray = Ordinary_DatasDiction[@"goodsDetail"][@"goodsList"];
    NSDictionary *FirstGoodsDiction = GoodsListArray[0];
    
    // 已选的规格
    self.goodsSpecString = [NSString stringWithFormat:@"%@",FirstGoodsDiction[@"goodsSpecString"]];
    NSString *GuiGeString = [NSString stringWithFormat:@"已选: %@",FirstGoodsDiction[@"goodsSpecString"]];
    CGSize GuiGeSize = [NSString SizeOfTheText:GuiGeString font:[UIFont systemFontOfSize:12.0] MaxSize:CGSizeMake(KScreenWidth - CGRectGetMaxX(self.GoodsImageView.frame)-20, MAXFLOAT)];
    self.YiXuanGoods.text = GuiGeString;
    self.YiXuanGoods.frame = CGRectMake(CGRectGetMaxX(self.GoodsImageView.frame)+10, CGRectGetMaxY(self.GoodsImageView.frame) - GuiGeSize.height, KScreenWidth -CGRectGetMaxX(self.GoodsImageView.frame) -20 , GuiGeSize.height);
    
    // 价格及库存
    self.GoodsPrice.text = [NSString stringWithFormat:@"¥%@(库存: %@%@)",FirstGoodsDiction[@"appPrice0"],FirstGoodsDiction[@"goodsStorage"],Ordinary_DatasDiction[@"goodsDetail"][@"unitName"]];
    self.GoodsPrice.frame = CGRectMake(self.YiXuanGoods.mj_x, self.YiXuanGoods.mj_y - 25, self.YiXuanGoods.mj_w , 20);
    self.GoodsKuCunString = [NSString stringWithFormat:@"%@",FirstGoodsDiction[@"goodsStorage"]];
    
    if (self.TypeString.integerValue == 400)
    {
         [self.BottomClickBtn setTitle:@"加入购物车" forState:(UIControlStateNormal)];
    }
    else
    {
         [self.BottomClickBtn setTitle:@"立即购买" forState:(UIControlStateNormal)];
    }
    
    // 商品的id
    self.Goods_id = [NSString stringWithFormat:@"%@",FirstGoodsDiction[@"goodsId"]];

    if (self.Source == 200) // 收藏列表详情跳转过里的
    {
        [self.BottomClickBtn setTitle:@"加入购物车" forState:(UIControlStateNormal)];
    }
    
    // 中间的规格列表
    for (NSDictionary *dict in Ordinary_DatasDiction[@"goodsDetail"][@"specJson"])
    {
        // 外层数据
        HSQGoodsGuiGeTypeModel *ReceiveModel = [[HSQGoodsGuiGeTypeModel alloc] initWithDictionary:dict error:nil];
        
        ReceiveModel.specValueList = [NSMutableArray array];
        
        [self.dataSource addObject:ReceiveModel];
        
        // 内层数据
        for (NSInteger i = 0; i < [dict[@"specValueList"] count] ; i++) {
            
            NSDictionary *ModelDiction = dict[@"specValueList"][i];
            
            HSQGoodsGuiGeListModel *ListModel = [[HSQGoodsGuiGeListModel alloc] init];
            
            [ListModel setValuesForKeysWithDictionary:ModelDiction];
            
            ListModel.IsSelect = (i == 0 ? @"1" : @"0");
            
            [ReceiveModel.specValueList addObject:ListModel];
        }
    }
    
    [self.collectionView reloadData];
}

#pragma mark - UICollectionViewDelegate,UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return self.dataSource.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
   HSQGoodsGuiGeTypeModel *model = self.dataSource[section];
    
    return model.specValueList.count;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    
    return CGSizeMake(KScreenWidth, 40);
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    
    if (section == self.dataSource.count - 1)
    {
        return CGSizeMake(KScreenWidth, 50);
    }
    else
    {
        return CGSizeMake(KScreenWidth, 0);
    }
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    HSQGoodsGuiGeTypeModel *model = self.dataSource[indexPath.section];
    
    UICollectionReusableView *reusableView = nil;
    
    if (kind == UICollectionElementKindSectionHeader)
    {
        HSQGuiGeLIstHeadReusableView *headView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HSQGuiGeLIstHeadReusableView" forIndexPath:indexPath];
        
        if (self.dataSource.count != 0)
        {
            headView.NameLabel.text = [NSString stringWithFormat:@"%@",model.specName];
        }
        
        reusableView = headView;
    }
    if (kind == UICollectionElementKindSectionFooter)
    {
        HSQGoodsGuiGeFooterReusableView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"HSQGoodsGuiGeFooterReusableView" forIndexPath:indexPath];
        
        footerView.delegate = self;
        
        self.SelectKuCunString = footerView.Count_TextField.text;
        
        reusableView = footerView;
    }
    return reusableView;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
   HSQGoodsGuiGeTypeModel *model = self.dataSource[indexPath.section];
    
    HSQGoodsGuiGeListModel *ListModel = model.specValueList[indexPath.row];
    
    CGSize NameSize = [NSString SizeOfTheText:ListModel.specValueName font:[UIFont systemFontOfSize:12.0] MaxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    
    return CGSizeMake(NameSize.width+30, 40);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    HSQGoodsGuiGeListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HSQGoodsGuiGeListCell" forIndexPath:indexPath];
    
    HSQGoodsGuiGeTypeModel *model = self.dataSource[indexPath.section];
    
    cell.ListModel = model.specValueList[indexPath.row];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    HSQGoodsGuiGeTypeModel *TypeModel = self.dataSource[indexPath.section];
    
    for (HSQGoodsGuiGeListModel *model in TypeModel.specValueList) {
        
        model.IsSelect = @"0";
    }
    
    HSQGoodsGuiGeListModel *ListModel = TypeModel.specValueList[indexPath.row];
    
    ListModel.IsSelect = @"1";
    
    [self.collectionView reloadData];
    
    NSMutableArray *GuiGeArray = [NSMutableArray array];
    
    for (HSQGoodsGuiGeTypeModel *SecondModel in self.dataSource) {
        
        for (HSQGoodsGuiGeListModel *SecondListModel in SecondModel.specValueList) {
            
            if (SecondListModel.IsSelect.integerValue == 1) {
                
                [GuiGeArray addObject:SecondListModel.specValueName];
            }
        }
    }
    
    NSString *name = [NSString stringWithFormat:@"%@",[GuiGeArray componentsJoinedByString:@"；"]];
    
//    NSArray *goodsList = self.dataDiction[@"groupGoodsDetailVo"][@"goodsList"];
    
    NSArray *goodsList = [NSArray array];
    
    if (self.TypeString.integerValue == 300)
    {
        goodsList = self.PointDatasDiction[@"pointsGoodsDetailVo"][@"goodsList"];
    }
    else  if (self.TypeString.integerValue == 400 || self.TypeString.integerValue == 500)
    {
       goodsList = self.Ordinary_DatasDiction[@"goodsDetail"][@"goodsList"];
    }
    else
    {
        goodsList = self.dataDiction[@"groupGoodsDetailVo"][@"goodsList"];
    }
    
    for (NSInteger i = 0; i < goodsList.count ; i++) {
        
        NSDictionary *GoodsDiction = goodsList[i];
        
        NSString *goodsSpecString = [NSString stringWithFormat:@"%@",GoodsDiction[@"goodsSpecString"]];
        
        if ([goodsSpecString containsString:name]){
            
            NSString *GuiGeString = [NSString stringWithFormat:@"已选: %@",goodsSpecString];
            
             self.goodsSpecString = [NSString stringWithFormat:@"%@",goodsSpecString];
            
            CGSize GuiGeSize = [NSString SizeOfTheText:GuiGeString font:[UIFont systemFontOfSize:12.0] MaxSize:CGSizeMake(KScreenWidth - CGRectGetMaxX(self.GoodsImageView.frame)-20, MAXFLOAT)];
            
            self.YiXuanGoods.text = GuiGeString;
            
            self.YiXuanGoods.frame = CGRectMake(CGRectGetMaxX(self.GoodsImageView.frame)+10, CGRectGetMaxY(self.GoodsImageView.frame) - GuiGeSize.height, KScreenWidth -CGRectGetMaxX(self.GoodsImageView.frame) -20 , GuiGeSize.height);
            
            // 价格及库存
            if (self.TypeString.integerValue == 300)
            {
                self.GoodsPrice.text = [NSString stringWithFormat:@"¥%@(库存: %@%@)",GoodsDiction[@"groupPrice"],GoodsDiction[@"goodsStorage"],self.PointDatasDiction[@"pointsGoodsDetailVo"][@"unitName"]];
                
                self.goodsPriceString = [NSString stringWithFormat:@"%@",GoodsDiction[@"groupPrice"]];
            }
            else  if (self.TypeString.integerValue == 400 || self.TypeString.integerValue == 500)
            {
                 self.GoodsPrice.text = [NSString stringWithFormat:@"¥%@(库存: %@%@)",GoodsDiction[@"appPrice0"],GoodsDiction[@"goodsStorage"],self.Ordinary_DatasDiction[@"goodsDetail"][@"unitName"]];
                
                self.goodsPriceString = [NSString stringWithFormat:@"%@",GoodsDiction[@"appPrice0"]];
            }
            else
            {
                self.GoodsPrice.text = [NSString stringWithFormat:@"¥%@(库存: %@%@)",GoodsDiction[@"appPrice0"],GoodsDiction[@"goodsStorage"],self.dataDiction[@"groupGoodsDetailVo"][@"unitName"]];
                
                self.goodsPriceString = [NSString stringWithFormat:@"%@",GoodsDiction[@"appPrice0"]];
            }
            
            self.GoodsPrice.frame = CGRectMake(self.YiXuanGoods.mj_x, self.YiXuanGoods.mj_y - 25, self.YiXuanGoods.mj_w , 20);
            
            self.GoodsKuCunString = [NSString stringWithFormat:@"%@",GoodsDiction[@"goodsStorage"]];
            
            // 商品的图片
            [self.GoodsImageView sd_setImageWithURL:[NSURL URLWithString:GoodsDiction[@"imageSrc"]] placeholderImage:KGoodsPlacherImage];
            
            // 商品的id
            self.Goods_id = [NSString stringWithFormat:@"%@",GoodsDiction[@"goodsId"]];
        
        }
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(hsqGoodsModelViewCollectionCellClickActionWithGoodsCount:Type:goods_id:GoodsKunCun:goodsSpecString:goodsPrice:)]) {
        
        [self.delegate hsqGoodsModelViewCollectionCellClickActionWithGoodsCount:self.SelectKuCunString Type:self.TypeString goods_id:self.Goods_id GoodsKunCun:self.GoodsKuCunString goodsSpecString:self.goodsSpecString goodsPrice:self.goodsPriceString];
    }
}

/**
 * @brief 添加商品的数量
 */
- (void)AddGoodsCountToShapCarBtnClickAction:(UIButton *)sender{
    
    HSQGoodsGuiGeFooterReusableView *FooterView = (HSQGoodsGuiGeFooterReusableView *)sender.superview;
    
    if (FooterView.Count_TextField.text.integerValue >= self.GoodsKuCunString.integerValue)
    {
        [[HSQProgressHUDManger Manger] ShowProgressHUDPromptText:@"商品库存不足" SupView:self];
    }
    else
    {
        FooterView.Count_TextField.text = [NSString stringWithFormat:@"%ld",FooterView.Count_TextField.text.integerValue + 1];
    }
    
    self.SelectKuCunString =  FooterView.Count_TextField.text;
}

/**
 * @brief 减少商品的数量
 */
- (void)JianShaoGoodsCountInShopCarBtnClickAction:(UIButton *)sender{
    
     HSQGoodsGuiGeFooterReusableView *FooterView = (HSQGoodsGuiGeFooterReusableView *)sender.superview;
    
    if (FooterView.Count_TextField.text.integerValue <= 1)
    {
        [[HSQProgressHUDManger Manger] ShowProgressHUDPromptText:@"商品个数不能低于1" SupView:self];
    }
    else
    {
        FooterView.Count_TextField.text = [NSString stringWithFormat:@"%ld",FooterView.Count_TextField.text.integerValue - 1];
    }
    
    self.SelectKuCunString =  FooterView.Count_TextField.text;
}

/**
 * @brief 底部按钮的点击事件
 */
- (void)BottomClickBtnClickAction:(UIButton *)sender{
    
    if (self.SelectKuCunString.integerValue > self.GoodsKuCunString.integerValue)
    {
        [[HSQProgressHUDManger Manger] ShowProgressHUDPromptText:@"商品库存不足" SupView:self];
    }
    else
    {
         [self dismissAdressView];
        
        [UIView animateWithDuration:0.25 animations:^{
            
            if (self.delegate && [self.delegate respondsToSelector:@selector(hsqGoodsModelViewBottomBtnClickActionWithGoodsCount:Type:goods_id:GoodsKunCun:goodsSpecString:goodsPrice:)]) {
                
                [self.delegate hsqGoodsModelViewBottomBtnClickActionWithGoodsCount:self.SelectKuCunString Type:self.TypeString goods_id:self.Goods_id GoodsKunCun:self.GoodsKuCunString goodsSpecString:self.goodsSpecString goodsPrice:self.goodsPriceString];
            }
        }];
    }
}

/**
 * @brief 点击背景按钮的点击事件
 */
- (void)btnClickAction:(UIButton *)sender{
    
    [self dismissAdressView];
}


/**
 * @brief 显示视图
 */
- (void)ShowGoodsModelAndPriceView{
    
    [UIView animateWithDuration:0.25 animations:^{
        
        self.BackGroupView.frame = ({
            
            CGRect frame = self.BackGroupView.frame;
            
            frame.origin.y = (KScreenHeight) / 2;
            
            frame;
        });
    }];
}

/**
 * @brief 隐藏视图
 */
- (void)dismissAdressView{
    
    [UIView animateWithDuration:0.25 animations:^{
        
        self.BackGroupView.frame = ({
            
            CGRect frame = self.BackGroupView.frame;
            
            frame.origin.y = KScreenHeight;
            
            frame;
        });
    }completion:^(BOOL finished) {
        
        [self.BackGroupView removeFromSuperview];
        
        [self removeFromSuperview];
    }];
}









@end
