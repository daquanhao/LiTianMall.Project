//
//  HSQClassSecondGoodsListCell.m
//  LiTianDecoration
//
//  Created by administrator on 2018/4/30.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import "HSQClassSecondGoodsListCell.h"
#import "HSQGoodsDataListModel.h"
#import "HSQCustomButton.h"

@interface HSQClassSecondGoodsListCell ()

@property (nonatomic, strong) UIImageView *GoodsImageView;

@property (nonatomic, strong) UILabel *GoodsNameLabel;

@property (nonatomic, strong) UILabel *PriceLabel;

@property (nonatomic, strong) UILabel *XiaoLiang_Label; // 商品的销量

@property (nonatomic, strong) UIButton *isOwnShop;  // 是否是自营店铺

@property (nonatomic, strong) UILabel *GoodsRate_Label; // 商品的好评率

@property (nonatomic, strong) UIButton *isOpen_Button;  // 是否展开

@property (nonatomic, strong) UIView *Describe_BgView; // 商品的描述背景图

@property (nonatomic, strong) UIImageView *SanJiao_ImageView;

@property (nonatomic, strong) UILabel *StoreName_Label; // 店铺的名字

@property (nonatomic, strong) UILabel *GoodsDescription_Label; //商品的描述

@property (nonatomic, strong) UILabel *GoodsServer_Label; //商品的服务

@property (nonatomic, strong) UILabel *GoodsSend_Label; //商品的发货速度

@property (nonatomic, strong) UIButton *JoinStoreDetail_Btn;  // 进入店铺详情

@property (nonatomic, strong) UIButton *Close_Btn;  // 关闭店铺评分界面的按钮

@property (nonatomic, strong) UIView *ShowCollection_BgView; // 商品的收藏背景视图

@property (nonatomic, strong) HSQCustomButton *Collection_Button; // 收藏按钮

@end

@implementation HSQClassSecondGoodsListCell

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        // 商品的控件视图
        [self SetUpGoodsView];
        
        // 商品的描述视图
        [self SetUpGoodsDescribeView];
        
        // 商品的收藏界面
        [self SetUpGoodsCollectionView];
    }
    
    return self;
}

/**
 * @brief 商品的控件视图
 */
- (void)SetUpGoodsView{
    
    // 商品的图片
    UIImageView *GoodsImageView = [[UIImageView alloc] init];
    [self.contentView addSubview:GoodsImageView];
    self.GoodsImageView = GoodsImageView;
    
    // 商品的名字
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.textColor = RGB(33, 33, 33);
    nameLabel.font = [UIFont systemFontOfSize:12.0];
    nameLabel.numberOfLines = 0;
    [self.contentView addSubview:nameLabel];
    self.GoodsNameLabel = nameLabel;
    
    // 商品的价格
    UILabel *priceLabel = [[UILabel alloc] init];
    priceLabel.textColor = RGB(255, 38, 58);
    priceLabel.font = [UIFont systemFontOfSize:14.0];
    [self.contentView addSubview:priceLabel];
    self.PriceLabel = priceLabel;
    
    // 商品的标签
    UIButton *DiscountBtn = [UIButton buttonWithType:(UIButtonTypeSystem)];
    [DiscountBtn setTitle:@"限时折扣" forState:(UIControlStateNormal)];
    [DiscountBtn setTitleColor:RGB(255, 38, 58) forState:(UIControlStateNormal)];
    DiscountBtn.titleLabel.font = [UIFont systemFontOfSize:12.0];
    DiscountBtn.layer.borderWidth = 1;
    DiscountBtn.layer.borderColor = RGB(255, 38, 58).CGColor;
    [self.contentView addSubview:DiscountBtn];
    self.DiscountBtn = DiscountBtn;
    
    // 商品的标签
    UIButton *isOwnShop = [UIButton buttonWithType:(UIButtonTypeSystem)];
    [isOwnShop setTitle:@"自营" forState:(UIControlStateNormal)];
    [isOwnShop setTitleColor:RGB(255, 38, 58) forState:(UIControlStateNormal)];
    isOwnShop.titleLabel.font = [UIFont systemFontOfSize:10.0];
    isOwnShop.layer.borderWidth = 1;
    isOwnShop.layer.borderColor = RGB(255, 38, 58).CGColor;
    isOwnShop.layer.cornerRadius = 5;
    isOwnShop.clipsToBounds = YES;
    [self.contentView addSubview:isOwnShop];
    self.isOwnShop = isOwnShop;
    
    // 是否展开
    UIButton *isOpen_Button = [UIButton buttonWithType:(UIButtonTypeSystem)];
    isOpen_Button.backgroundColor = [UIColor purpleColor];
    [isOpen_Button addTarget:self action:@selector(isOpen_ButtonClickAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.contentView addSubview:isOpen_Button];
    self.isOpen_Button = isOpen_Button;
    
    // 商品的销量
    UILabel *XiaoLiang_Label = [[UILabel alloc] init];
    XiaoLiang_Label.textColor = RGB(150, 150, 150);
    XiaoLiang_Label.font = [UIFont systemFontOfSize:12.0];
    [self.contentView addSubview:XiaoLiang_Label];
    self.XiaoLiang_Label = XiaoLiang_Label;
    
    // 商品的好评率
    UILabel *GoodsRate_Label = [[UILabel alloc] init];
    GoodsRate_Label.textColor = RGB(150, 150, 150);
    GoodsRate_Label.font = [UIFont systemFontOfSize:12.0];
    [self.contentView addSubview:GoodsRate_Label];
    self.GoodsRate_Label = GoodsRate_Label;
}

/**
 * @brief 商品的描述视图
 */
- (void)SetUpGoodsDescribeView{
    
    // 描述背景视图
    UIView *DescribeView = [[UIView alloc] init];
    DescribeView.backgroundColor = KViewBackGroupColor;
    [self.contentView addSubview:DescribeView];
    self.Describe_BgView = DescribeView;
    
    // 店铺的名字
    UILabel *StoreName_Label = [[UILabel alloc] init];
    StoreName_Label.textColor = RGB(150, 150, 150);
    StoreName_Label.font = [UIFont systemFontOfSize:12.0];
    [DescribeView addSubview:StoreName_Label];
    self.StoreName_Label = StoreName_Label;
    
    // 三角的图片
    UIImageView *SanJiao_ImageView = [[UIImageView alloc] init];
    SanJiao_ImageView.image = KImageName(@"C7F2BC79-AC34-4AB0-AAFA-021F9AD47E36");
    [DescribeView addSubview:SanJiao_ImageView];
    self.SanJiao_ImageView = SanJiao_ImageView;
    
    // 商品的描述
    UILabel *GoodsDescription_Label = [[UILabel alloc] init];
    GoodsDescription_Label.textColor = [UIColor blackColor];
    GoodsDescription_Label.font = [UIFont systemFontOfSize:12.0];
    [DescribeView addSubview:GoodsDescription_Label];
    self.GoodsDescription_Label = GoodsDescription_Label;
    
    // 服务态度
    UILabel *GoodsServer_Label = [[UILabel alloc] init];
    GoodsServer_Label.textColor = [UIColor blackColor];
    GoodsServer_Label.font = [UIFont systemFontOfSize:12.0];
    [DescribeView addSubview:GoodsServer_Label];
    self.GoodsServer_Label = GoodsServer_Label;
    
    // 发货速度
    UILabel *GoodsSend_Label = [[UILabel alloc] init];
    GoodsSend_Label.textColor = [UIColor blackColor];
    GoodsSend_Label.font = [UIFont systemFontOfSize:12.0];
    [DescribeView addSubview:GoodsSend_Label];
    self.GoodsSend_Label = GoodsSend_Label;
    
    // 进入店铺
    UIButton *JoinStoreDetail_Btn = [UIButton buttonWithType:(UIButtonTypeSystem)];
    [JoinStoreDetail_Btn addTarget:self action:@selector(JoinStoreDetail_BtnClickAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [DescribeView addSubview:JoinStoreDetail_Btn];
    self.JoinStoreDetail_Btn = JoinStoreDetail_Btn;
    
    // 关闭店铺评分
    UIButton *Close_Btn = [UIButton buttonWithType:(UIButtonTypeSystem)];
    [Close_Btn addTarget:self action:@selector(Close_Btn_BtnClickAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [DescribeView addSubview:Close_Btn];
    self.Close_Btn = Close_Btn;
}

/**
 * @brief 商品的收藏界面
 */
- (void)SetUpGoodsCollectionView{
    
    // 商品的收藏背景视图
    UIView *ShowCollection_BgView = [[UIView alloc] init];
    
    ShowCollection_BgView.backgroundColor = KViewBackGroupColor;
    
    ShowCollection_BgView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.8];
    
    [self.contentView addSubview:ShowCollection_BgView];
    
    self.ShowCollection_BgView = ShowCollection_BgView;
    
    // 收藏按钮
    HSQCustomButton *Collection_Button = [HSQCustomButton buttonWithType:(UIButtonTypeCustom)];
    
    [Collection_Button setTitleColor:RGB(74, 74, 74) forState:(UIControlStateNormal)];
    
    Collection_Button.titleLabel.font = [UIFont systemFontOfSize:14.0];
    
    Collection_Button.alignmentType = Button_AlignmentStatusTop;
    
    [Collection_Button setTitle:@"收藏" forState:(UIControlStateNormal)];
    
    [Collection_Button setTitle:@"已收藏" forState:(UIControlStateSelected)];
    
    [Collection_Button setImage:KImageName(@"Shape") forState:(UIControlStateNormal)];
    
    [Collection_Button setImage:KImageName(@"xin") forState:(UIControlStateSelected)];
    
    [Collection_Button setTintColor:[UIColor clearColor]];
        
    [Collection_Button addTarget:self action:@selector(Collection_ButtonClickAction:) forControlEvents:(UIControlEventTouchUpInside)];
    
    [ShowCollection_BgView addSubview:Collection_Button];
    
    self.Collection_Button = Collection_Button;
}

- (void)setIsGrid:(BOOL)isGrid{
    
    _isGrid = isGrid;
    

}

/**
 * @brief 商品的数据
 */
- (void)setDataDiction:(NSDictionary *)dataDiction{
    
    _dataDiction = dataDiction;
    
    // 1.商品的图片
    [self.GoodsImageView sd_setImageWithURL:[NSURL URLWithString:dataDiction[@"imageSrc"]] placeholderImage:KGoodsPlacherImage];
    
    // 2.商品的名字
    self.GoodsNameLabel.text = [NSString stringWithFormat:@"%@",dataDiction[@"goodsName"]];
    
    // 3.商品的价格
    NSString *appPrice0 = [NSString stringWithFormat:@"%@",dataDiction[@"appPrice0"]];
    
    self.PriceLabel.text = [NSString stringWithFormat:@"¥%.2f",appPrice0.floatValue];
    
    // 4.商品的销量
    self.XiaoLiang_Label.text = [NSString stringWithFormat:@"销量：%@",dataDiction[@"goodsSaleNum"]];
    
}

/**
 * @brief 数据模型
 */
- (void)setModel:(HSQGoodsDataListModel *)model{
    
    _model = model;
    
    // 商品的图片
    [self.GoodsImageView sd_setImageWithURL:[NSURL URLWithString:model.imageSrc] placeholderImage:KGoodsPlacherImage];
    
    // 2.商品的名字
    self.GoodsNameLabel.text = [NSString stringWithFormat:@"%@",model.goodsName];
    
    // 3.商品的价格
    self.PriceLabel.text = [NSString stringWithFormat:@"¥%.2f",model.appPrice0.floatValue];
    
    // 4.商品的销量
    NSString *goodsSaleNum = [NSString ReturnsAStringWithAThousandWords:model.goodsSaleNum];
    
    self.XiaoLiang_Label.text = [NSString stringWithFormat:@"销量 %@%@",goodsSaleNum,model.unitName];
    
    // 5.商品的好评率
    self.GoodsRate_Label.text = [NSString stringWithFormat:@"%@%%好评率",model.goodsRate];
    
    // 店铺的名字
    self.StoreName_Label.text = model.storeName;
    
    // 店铺的描述分数
    NSString *storeDesEval = [NSString stringWithFormat:@"描述相符：%@ %@",model.storeDesEval,[self ReturnStringWithState:model.desEvalArrow]];
    
    self.GoodsDescription_Label.attributedText = [self ReturnAttribeWithString:storeDesEval state:model.desEvalArrow];
    
    // 店铺的服务分数
    NSString *storeServiceEval = [NSString stringWithFormat:@"服务态度：%@ %@",model.storeServiceEval,[self ReturnStringWithState:model.serviceEvalArrow]];
    
    self.GoodsServer_Label.attributedText = [self ReturnAttribeWithString:storeServiceEval state:model.serviceEvalArrow];
    
    // 店铺的发货速度分数
    NSString *storeDeliveryEval = [NSString stringWithFormat:@"发货速度：%@ %@",model.storeDeliveryEval,[self ReturnStringWithState:model.deliveryEvalArrow]];
    
    self.GoodsSend_Label.attributedText = [self ReturnAttribeWithString:storeDeliveryEval state:model.deliveryEvalArrow];
    
    // 视图的尺寸
    [self SetFrameWithModel:model];
}

/**
 * @brief 设置尺寸
 */
- (void)SetFrameWithModel:(HSQGoodsDataListModel *)model{
    
    if (model.isGrid == YES)
    {
        // 商品的图片
        self.GoodsImageView.frame = CGRectMake(10, 10, self.bounds.size.width - 20, self.bounds.size.width - 20);
        
        // 商品的名字
        self.GoodsNameLabel.frame = CGRectMake(10, CGRectGetMaxY(self.GoodsImageView.frame)+10, self.bounds.size.width - 20, 20);
        
        // 限时折扣
        self.DiscountBtn.frame = CGRectMake(self.bounds.size.width - 70, CGRectGetMaxY(self.GoodsNameLabel.frame)+10, 0, 0);
        
        // 商品的价格
        self.PriceLabel.frame = CGRectMake(10, CGRectGetMaxY(self.GoodsNameLabel.frame)+5, self.bounds.size.width - 80, 20);
        
        // 商品的销量
        self.XiaoLiang_Label.frame = CGRectMake(10, CGRectGetMaxY(self.PriceLabel.frame)+5, self.bounds.size.width - 80, 15);
        
        // 是否是自营商品
        self.isOwnShop.frame = CGRectMake(0, 0, 0, 0);
        
        // 是否展开按钮
        self.isOpen_Button.frame = CGRectMake(self.bounds.size.width - 45, 0, 40, 20);
        
        self.isOpen_Button.centerY = self.XiaoLiang_Label.centerY;
        
        // 商品的背景视图
        if (model.IsOpen == 0)
        {
            self.Describe_BgView.frame = CGRectMake(0, self.bounds.size.height / 2, self.bounds.size.width, 0);
            
            self.StoreName_Label.frame = CGRectMake(0, 0, 0, 0);
            
            self.SanJiao_ImageView.frame = CGRectMake(CGRectGetMaxX(self.StoreName_Label.frame) + 5, 8, 0, 0);
            
            // 商品的描述
            self.GoodsDescription_Label.frame = CGRectMake(0, CGRectGetMaxY(self.StoreName_Label.frame) + 5, self.Describe_BgView.mj_w, 0);
            
            // 服务态度
            self.GoodsServer_Label.frame = CGRectMake(0, CGRectGetMaxY(self.GoodsDescription_Label.frame) + 5, self.Describe_BgView.mj_w, 0);
            
            // 发货速度
            self.GoodsSend_Label.frame = CGRectMake(0, CGRectGetMaxY(self.GoodsServer_Label.frame) + 5, self.Describe_BgView.mj_w, 0);
            
            // 进入店铺详情
            self.JoinStoreDetail_Btn.frame = CGRectMake(0, 0, 0, 0);
            
            self.Close_Btn.frame = CGRectMake(0, 0, 0, 0);
        }
        else
        {
            self.Describe_BgView.frame = CGRectMake(0, self.bounds.size.height / 2, self.bounds.size.width, self.bounds.size.height / 2);
            
            self.StoreName_Label.frame = CGRectMake(10, 0, self.Describe_BgView.mj_w - 33, 30);
            
            // 进入店铺详情
            self.JoinStoreDetail_Btn.frame = self.StoreName_Label.frame;
            
            self.SanJiao_ImageView.frame = CGRectMake(self.Describe_BgView.mj_w - 18, 8, 8, 13);
            
            self.SanJiao_ImageView.centerY = self.StoreName_Label.centerY;
            
            // 商品的描述
            self.GoodsDescription_Label.frame = CGRectMake(10, CGRectGetMaxY(self.StoreName_Label.frame) + 5, self.Describe_BgView.mj_w - 20, (self.bounds.size.height / 2 - 45) / 3);
            
            // 服务态度
            self.GoodsServer_Label.frame = CGRectMake(10, CGRectGetMaxY(self.GoodsDescription_Label.frame) + 5, self.Describe_BgView.mj_w - 20, self.GoodsDescription_Label.mj_h);
            
            // 发货速度
            self.GoodsSend_Label.frame = CGRectMake(10, CGRectGetMaxY(self.GoodsServer_Label.frame) + 5, self.Describe_BgView.mj_w - 20, self.GoodsDescription_Label.mj_h);
            
            // 关闭按钮
            self.Close_Btn.frame = CGRectMake(0, CGRectGetMaxY(self.StoreName_Label.frame) + 5, self.Describe_BgView.mj_w, self.bounds.size.height / 2 - 35);
        }
        
        // 商品的收藏界面视图
        if (model.IsShowCollectionView == 0)  // 不显示
        {
            // 收藏界面
            self.ShowCollection_BgView.frame = CGRectMake(0, 0, 0, 0);
            
            // 收藏按钮
            self.Collection_Button.frame = CGRectMake(0, 0, 0, 0);
            
            // 商品是否被收藏
            self.Collection_Button.selected = (model.isExist.integerValue == 0 ? NO : YES);
        }
        else
        {
            // 收藏界面
            self.ShowCollection_BgView.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
            
            // 收藏按钮
            self.Collection_Button.frame = self.ShowCollection_BgView.frame;
            
            // 商品是否被收藏
            self.Collection_Button.selected = (model.isExist.integerValue == 0 ? NO : YES);
        }
        
        HSQLog(@"Collection");
    }
    else
    {
        HSQLog(@"tableView");
        
        // 商品的图片
        self.GoodsImageView.frame = CGRectMake(10, 10, self.bounds.size.height - 20, self.bounds.size.height - 20);
        
        // 商品的名字
        CGSize GoodsNameSize = [NSString SizeOfTheText:model.goodsName font:[UIFont systemFontOfSize:12.0] MaxSize:CGSizeMake(self.bounds.size.width - self.GoodsImageView.mj_w - 30, MAXFLOAT)];
        
        self.GoodsNameLabel.frame = CGRectMake(CGRectGetMaxX(self.GoodsImageView.frame)+10, 10, self.bounds.size.width - self.GoodsImageView.mj_w - 30, GoodsNameSize.height);
        
        // 商品的价格
        self.PriceLabel.frame = CGRectMake(CGRectGetMaxX(self.GoodsImageView.frame)+10, CGRectGetMaxY(self.GoodsNameLabel.frame)+5, 100, 20);
        
        // 显示折扣
        self.DiscountBtn.frame = CGRectMake(0, 0, 0, 0);
        
        // 是否是自营店
        CGFloat XiaoLiang_Label_X = 0;
        
        if (model.isOwnShop.integerValue == 0)
        {
            self.isOwnShop.frame = CGRectMake(CGRectGetMaxX(self.GoodsImageView.frame)+10, CGRectGetMaxY(self.PriceLabel.frame)+10, 0, 20);
            
            XiaoLiang_Label_X = CGRectGetMaxX(self.isOwnShop.frame);
        }
        else
        {
            self.isOwnShop.frame = CGRectMake(CGRectGetMaxX(self.GoodsImageView.frame)+10, CGRectGetMaxY(self.PriceLabel.frame)+10, 30, 20);
            
            XiaoLiang_Label_X = CGRectGetMaxX(self.isOwnShop.frame)+5;
        }
        
        // 商品的销量
        if (model.goodsSaleNum.integerValue == 0)
        {
            self.XiaoLiang_Label.frame = CGRectMake(CGRectGetMaxX(self.isOwnShop.frame)+5, CGRectGetMaxY(self.PriceLabel.frame)+10, 0, 0);
            
            self.GoodsRate_Label.frame = CGRectMake(CGRectGetMaxX(self.XiaoLiang_Label.frame) + 10, 0, 0, 0);
        }
        else
        {
            CGSize goodsSaleNumSize = [NSString SizeOfTheText:self.XiaoLiang_Label.text font:[UIFont systemFontOfSize:12.0] MaxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
            
            self.XiaoLiang_Label.frame = CGRectMake(XiaoLiang_Label_X, CGRectGetMaxY(self.PriceLabel.frame)+10, goodsSaleNumSize.width, goodsSaleNumSize.height);
            
            self.XiaoLiang_Label.centerY = self.isOwnShop.centerY;
            
            // 好评率
            NSString *goodsRate = [NSString stringWithFormat:@"%@%%好评率",model.goodsRate];
            
            CGSize goodsRateSize = [NSString SizeOfTheText:goodsRate font:[UIFont systemFontOfSize:12.0] MaxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
            
            self.GoodsRate_Label.frame = CGRectMake(CGRectGetMaxX(self.XiaoLiang_Label.frame) + 10, 0, goodsRateSize.width, goodsRateSize.height);
            
            self.GoodsRate_Label.centerY = self.isOwnShop.centerY;
        }
        
        // 是否展开按钮
        self.isOpen_Button.frame = CGRectMake(self.bounds.size.width - 45, self.bounds.size.height - 25, 40, 20);
        
        // 商品的背景视图
        if (model.IsOpen == 0)
        {
            self.Describe_BgView.frame = CGRectMake(0, self.bounds.size.width / 2, self.bounds.size.height, 0);
            
            self.StoreName_Label.frame = CGRectMake(0, 0, 0, 0);
            
            self.JoinStoreDetail_Btn.frame = self.StoreName_Label.frame;
            
            self.SanJiao_ImageView.frame = CGRectMake(CGRectGetMaxX(self.StoreName_Label.frame) + 5, 8, 0, 0);
            
            // 商品的描述
            self.GoodsDescription_Label.frame = CGRectMake(0, CGRectGetMaxY(self.StoreName_Label.frame) + 5, self.Describe_BgView.mj_w, 0);
            
            // 服务态度
            self.GoodsServer_Label.frame = CGRectMake(0, CGRectGetMaxY(self.GoodsDescription_Label.frame) + 5, self.Describe_BgView.mj_w, 0);
            
            // 发货速度
            self.GoodsSend_Label.frame = CGRectMake(0, CGRectGetMaxY(self.GoodsServer_Label.frame) + 5, self.Describe_BgView.mj_w, 0);
            
            self.Close_Btn.frame = CGRectMake(0, 0, 0, 0);
        }
        else
        {
            self.Describe_BgView.frame = CGRectMake(CGRectGetMaxX(self.GoodsImageView.frame) +10, 0, self.bounds.size.width - self.GoodsImageView.mj_w, self.bounds.size.height);
            
            self.StoreName_Label.frame = CGRectMake(10, 0, self.Describe_BgView.mj_w - 55, 30);
            
            self.JoinStoreDetail_Btn.frame = self.StoreName_Label.frame;
            
            self.SanJiao_ImageView.frame = CGRectMake(CGRectGetMaxX(self.StoreName_Label.frame) + 5, 8, 8, 13);
            
            self.SanJiao_ImageView.centerY = self.StoreName_Label.centerY;
            
            // 商品的描述
            self.GoodsDescription_Label.frame = CGRectMake(10, CGRectGetMaxY(self.StoreName_Label.frame) + 5, self.Describe_BgView.mj_w, (self.bounds.size.height - 30 - 15) / 3);
            
            // 服务态度
            self.GoodsServer_Label.frame = CGRectMake(10, CGRectGetMaxY(self.GoodsDescription_Label.frame) + 5, self.Describe_BgView.mj_w, self.GoodsDescription_Label.mj_h);
            
            // 发货速度
            self.GoodsSend_Label.frame = CGRectMake(10, CGRectGetMaxY(self.GoodsServer_Label.frame) + 5, self.Describe_BgView.mj_w, self.GoodsDescription_Label.mj_h);
            
            // 关闭按钮
            self.Close_Btn.frame = CGRectMake(0, CGRectGetMaxY(self.StoreName_Label.frame) + 5, self.Describe_BgView.mj_w - 55, self.bounds.size.height - 30);
        }
        
        // 商品的收藏界面视图
        if (model.IsShowCollectionView == 0)  // 不显示
        {
            // 收藏界面
            self.ShowCollection_BgView.frame = CGRectMake(0, 0, 0, 0);
            
            // 收藏按钮
            self.Collection_Button.frame = CGRectMake(0, 0, 0, 0);
            
            // 商品是否被收藏
            self.Collection_Button.selected = (model.isExist.integerValue == 0 ? NO : YES);
        }
        else
        {
            // 收藏界面
            self.ShowCollection_BgView.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
            
            // 收藏按钮
            self.Collection_Button.frame = self.ShowCollection_BgView.frame;
            
            // 商品是否被收藏
            self.Collection_Button.selected = (model.isExist.integerValue == 0 ? NO : YES);
        }
    }
}

- (NSString *)ReturnStringWithState:(NSString *)state{
    
    if ([state isEqualToString:@"low"])
    {
        return @"低";
    }
    else if ([state isEqualToString:@"high"])
    {
        return @"高";
    }
    else
    {
        return @"平";
    }
}

- (NSMutableAttributedString *)ReturnAttribeWithString:(NSString *)string state:(NSString *)state{
    
    NSMutableAttributedString *storeDeliveryEval_attribe = [[NSMutableAttributedString alloc] initWithString:string];
    
    [storeDeliveryEval_attribe addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, 5)];
    
    if ([state isEqualToString:@"low"])
    {
        [storeDeliveryEval_attribe addAttribute:NSForegroundColorAttributeName value:[UIColor greenColor] range:NSMakeRange(5, string.length - 5)];
    }
    else if ([state isEqualToString:@"high"])
    {
        [storeDeliveryEval_attribe addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(5, string.length - 5)];
    }
    else if ([state isEqualToString:@"equal"])
    {
        [storeDeliveryEval_attribe addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(5, string.length - 5)];
    }
    
    return storeDeliveryEval_attribe;
}


/**
 * @brief 是否展开
 */
- (void)isOpen_ButtonClickAction:(UIButton *)sender{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(ExpandViewButtonClickAction:)]) {
        
        [self.delegate ExpandViewButtonClickAction:sender];
    }
}

/**
 * @brief 进入店铺
 */
- (void)JoinStoreDetail_BtnClickAction:(UIButton *)sender{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(JoinStoreDetailButtonClickAction:)]) {
        
        [self.delegate JoinStoreDetailButtonClickAction:sender];
    }
}

/**
 * @brief 关闭店铺评分
 */
- (void)Close_Btn_BtnClickAction:(UIButton *)sender{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(StoreClosingScoreButtonClickAction:)]) {
        
        [self.delegate StoreClosingScoreButtonClickAction:sender];
    }
}

/**
 * @brief 收藏按钮的点击
 */
- (void)Collection_ButtonClickAction:(UIButton *)sender{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(StoreGoodsCollectionButtonClickAction:)]) {
        
        [self.delegate StoreGoodsCollectionButtonClickAction:sender];
    }
}


@end
