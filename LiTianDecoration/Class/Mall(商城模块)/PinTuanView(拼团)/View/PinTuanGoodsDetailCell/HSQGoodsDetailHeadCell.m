//
//  HSQGoodsDetailHeadCell.m
//  LiTianDecoration
//
//  Created by administrator on 2018/5/9.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import "HSQGoodsDetailHeadCell.h"
#import "HSQCountdownView.h"

@interface HSQGoodsDetailHeadCell ()<SDCycleScrollViewDelegate>

@property (nonatomic, strong) SDCycleScrollView *CycleScrollView;

@property (nonatomic, strong) UILabel *countLabel;

@property (nonatomic, strong) HSQCountdownView *CountdownView;  // 倒计时的视图

@property (nonatomic, strong) UILabel *GoodsName_Label;  // 商品的名字

@property (nonatomic, strong) UILabel *GoodsDescribe_Label; // 商品的描述

@end

@implementation HSQGoodsDetailHeadCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        // 1.添加视图
        [self AddGoodsDetailBannerView];
        
        // 2.添视图约束
        [self SetUpCountLabelLayOut];
    }
    
    return self;
}

/**
 * @brief 添加视图
 */
- (void)AddGoodsDetailBannerView{
    
    // 添加轮播视图
    SDCycleScrollView *CycleScrollView = [[SDCycleScrollView alloc] init];
    CycleScrollView.backgroundColor = [UIColor clearColor];
    CycleScrollView.pageDotColor = RGB(180, 180, 180);
    CycleScrollView.currentPageDotColor = [UIColor whiteColor];
    CycleScrollView.placeholderImage = [UIImage imageNamed:@"icon3"];
    CycleScrollView.delegate = self;
    CycleScrollView.autoScroll = NO;
    CycleScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleNone;
    [self.contentView addSubview:CycleScrollView];
    self.CycleScrollView = CycleScrollView;
    
    // 添加计数的label
    UILabel *countLabel = [[UILabel alloc] init];
    countLabel.backgroundColor = [UIColor orangeColor];
    countLabel.textColor = [UIColor whiteColor];
    countLabel.font = [UIFont systemFontOfSize:14];
    countLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:countLabel];
    self.countLabel = countLabel;
    
     // 倒计时的视图
    HSQCountdownView *CountdownView = [[HSQCountdownView alloc] initCountdownViewWithXIB];
    [self.contentView addSubview:CountdownView];
    self.CountdownView = CountdownView;
    
    // 商品的名字
    UILabel *GoodsName_Label = [[UILabel alloc] init];
    GoodsName_Label.textColor = RGB(51, 51, 51);
    GoodsName_Label.font = [UIFont systemFontOfSize:14];
    GoodsName_Label.numberOfLines = 0;
    [self.contentView addSubview:GoodsName_Label];
    self.GoodsName_Label = GoodsName_Label;
    
    // 商品的描述
    UILabel *GoodsDescribe_Label = [[UILabel alloc] init];
    GoodsDescribe_Label.textColor = RGB(238, 58, 68);
    GoodsDescribe_Label.font = [UIFont systemFontOfSize:12];
    GoodsDescribe_Label.numberOfLines = 0;
    [self.contentView addSubview:GoodsDescribe_Label];
    self.GoodsDescribe_Label = GoodsDescribe_Label;
}

/**
 * @brief 添视图约束
 */
- (void)SetUpCountLabelLayOut{
    
     // 添加轮播视图
    self.CycleScrollView.sd_layout.leftSpaceToView(self.contentView, 0).topSpaceToView(self.contentView, 0).rightSpaceToView(self.contentView, 0).heightIs(KScreenWidth);
    
    // 添加计数的label
    self.countLabel.sd_layout.rightSpaceToView(self.contentView, 20).topSpaceToView(self.contentView, KScreenWidth - 70).widthIs(50).heightEqualToWidth();
    [self.countLabel setSd_cornerRadiusFromWidthRatio:@(0.5)];
    
    // 倒计时的视图
    self.CountdownView.sd_layout.leftSpaceToView(self.contentView, 0).topSpaceToView(self.CycleScrollView, 0).rightSpaceToView(self.contentView, 0).heightIs(60);
    
    // 商品的名字
    self.GoodsName_Label.sd_layout.leftSpaceToView(self.contentView, 10).topSpaceToView(self.CountdownView, 10).rightSpaceToView(self.contentView, 10).autoHeightRatio(0);
    
    // 商品的描述
    self.GoodsDescribe_Label.sd_layout.leftEqualToView(self.GoodsName_Label).rightEqualToView(self.GoodsName_Label).topSpaceToView(self.GoodsName_Label, 10).autoHeightRatio(0);

}


/**
 * @brief 轮播视图的点击事件
 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index{
    
    NSInteger countIndex = index + 1;
    
     self.countLabel.text = [NSString stringWithFormat:@"%ld/%ld",countIndex,[self.dataDiction[@"groupGoodsDetailVo"][@"goodsImageList"] count]];
}

/**
 * @brief 数据赋值
 */
- (void)setDataDiction:(NSDictionary *)dataDiction{
    
    _dataDiction = dataDiction;
    
    NSMutableArray *array = [ NSMutableArray array];
    
    for (NSDictionary *dict in dataDiction[@"groupGoodsDetailVo"][@"goodsImageList"]) {
        
        [array addObject:dict[@"imageSrc"]];
    }
    
    self.CycleScrollView.imageURLStringsGroup = array;
    
    self.countLabel.text = [NSString stringWithFormat:@"%@/%ld",@"1",array.count];
    
    // 商品的名字
    self.GoodsName_Label.text = [NSString stringWithFormat:@"%@",dataDiction[@"groupGoodsDetailVo"][@"goodsName"]];
    
    // 商品的描述
    self.GoodsDescribe_Label.text = [NSString stringWithFormat:@"%@",dataDiction[@"groupGoodsDetailVo"][@"jingle"]];
    
    // 倒计时界面
    self.CountdownView.dataDiction = dataDiction;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
