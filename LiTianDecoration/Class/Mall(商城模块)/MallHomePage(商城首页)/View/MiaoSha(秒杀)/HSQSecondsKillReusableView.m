//
//  HSQSecondsKillReusableView.m
//  LiTianDecoration
//
//  Created by administrator on 2018/5/7.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import "HSQSecondsKillReusableView.h"
#import "HSQMallHomeDataModel.h"
#import "TXScrollLabelView.h"
#import "HSQMiaoShaGoodsView.h"

@interface HSQSecondsKillReusableView ()<TXScrollLabelViewDelegate>

@property (nonatomic, strong) UIImageView *LeftHeader_Image;

@property (nonatomic,strong) TXScrollLabelView *scrollLabelView;

@property (nonatomic, strong) UIImageView *MiaoSha_Image;  // 秒杀提示图片

@property (nonatomic, strong) UILabel *MiaoSha_Label;  // 秒杀提示文字

@property (nonatomic, strong) UILabel *TimePlacher_Label;  // 秒杀提示时间

@property (nonatomic, strong) UILabel *Right_Label;  // 右边的点击文字

@property (nonatomic, strong) HSQMiaoShaGoodsView *GoodsView;  // 秒杀的商品视图

@end

@implementation HSQSecondsKillReusableView

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        UIImageView *LeftHeader_Image = [[UIImageView alloc] init];
        LeftHeader_Image.image = KImageName(@"123");
        [self addSubview:LeftHeader_Image];
        self.LeftHeader_Image = LeftHeader_Image;
        
        // 秒杀提示图片
        UIImageView *MiaoSha_Image = [[UIImageView alloc] init];
        MiaoSha_Image.image = KImageName(@"123");
        [self addSubview:MiaoSha_Image];
        self.MiaoSha_Image = MiaoSha_Image;
        
        // 跑马灯文字视图
        TXScrollLabelView *scrollLabelView = [TXScrollLabelView scrollWithTextArray:nil type:TXScrollLabelViewTypeUpDown velocity:2 options:UIViewAnimationOptionCurveEaseInOut inset:UIEdgeInsetsZero];;
        scrollLabelView.scrollLabelViewDelegate = self;
        [self addSubview:scrollLabelView];
        self.scrollLabelView = scrollLabelView;
        scrollLabelView.scrollSpace = 10;
        scrollLabelView.font = [UIFont systemFontOfSize:KLabelFont(14.0, 12.0)];
        scrollLabelView.textAlignment = NSTextAlignmentLeft;
        scrollLabelView.backgroundColor = [UIColor clearColor];
        scrollLabelView.scrollTitleColor = RGB(74, 74, 74);
        
        // 秒杀提示文字
        UILabel *MiaoSha_Label = [[UILabel alloc] init];
        MiaoSha_Label.text = @"秒杀专区";
        MiaoSha_Label.textColor = [UIColor redColor];
        MiaoSha_Label.font = [UIFont systemFontOfSize:14.0];
        [self addSubview:MiaoSha_Label];
        self.MiaoSha_Label = MiaoSha_Label;
        
        // 秒杀提示时间
        UILabel *TimePlacher_Label = [[UILabel alloc] init];
        TimePlacher_Label.text = @"08点场";
        TimePlacher_Label.textColor = [UIColor blackColor];
        TimePlacher_Label.font = [UIFont systemFontOfSize:14.0];
        [self addSubview:TimePlacher_Label];
        self.TimePlacher_Label = TimePlacher_Label;
        
        // 右边的点击文字
        UILabel *Right_Label = [[UILabel alloc] init];
        Right_Label.text = @"超低价格尽情抢>";
        Right_Label.textColor = [UIColor redColor];
        Right_Label.font = [UIFont systemFontOfSize:12.0];
        [self addSubview:Right_Label];
        self.Right_Label = Right_Label;
        
        // 秒杀的商品视图
        HSQMiaoShaGoodsView *goodsView = [[HSQMiaoShaGoodsView alloc] init];
        [self addSubview:goodsView];
        self.GoodsView = goodsView;
        
        // 添加约束
        [self addViewLayOut];
    }
    return self;
}

/**
 * @brief 添加约束
 */
- (void)addViewLayOut{
    
    self.LeftHeader_Image.sd_layout.leftSpaceToView(self, 10).topSpaceToView(self, 10).widthIs(70).heightIs(30);
    
    // 秒杀提示图片
    self.MiaoSha_Image.sd_layout.leftEqualToView(self.LeftHeader_Image).topSpaceToView(self.LeftHeader_Image, 10).widthIs(30).heightIs(30);
    
    // 跑马灯文本视图
    self.scrollLabelView.sd_layout.leftSpaceToView(self.LeftHeader_Image, 10).rightSpaceToView(self, 10).centerYEqualToView(self.LeftHeader_Image).heightIs(30);
    
    // 秒杀提示文字
    self.MiaoSha_Label.sd_layout.leftSpaceToView(self.MiaoSha_Image, 5).centerYEqualToView(self.MiaoSha_Image).heightIs(20).autoWidthRatio(0);
    [self.MiaoSha_Label setSingleLineAutoResizeWithMaxWidth:100];
    
    // 秒杀提示时间
    self.TimePlacher_Label.sd_layout.leftSpaceToView(self.MiaoSha_Label, 10).centerYEqualToView(self.MiaoSha_Image).heightIs(20).autoWidthRatio(0);
    [self.TimePlacher_Label setSingleLineAutoResizeWithMaxWidth:100];
    
    // 右边的点击文字
    self.Right_Label.sd_layout.rightSpaceToView(self, 10).centerYEqualToView(self.MiaoSha_Image).heightRatioToView(self.MiaoSha_Image, 1.0).autoWidthRatio(0);
    [self.Right_Label setSingleLineAutoResizeWithMaxWidth:150];
    
    // 秒杀的商品视图
    self.GoodsView.sd_layout.leftSpaceToView(self, 0).topSpaceToView(self.MiaoSha_Image, 10).rightSpaceToView(self, 0).bottomSpaceToView(self, 0);
}

/**
 *  @brief  跑马灯的代理事件
 * @param scrollLabelView 滚动的视图
 *  @param text 跑马灯的文字
 *  @param index 第几段文字
 */
- (void)scrollLabelView:(TXScrollLabelView *)scrollLabelView didClickWithText:(NSString *)text atIndex:(NSInteger)index{
    
    NSLog(@"%@--%ld",text, (long)index);
}

/**
 * @brief 控件赋值
 */
- (void)setModel:(HSQMallHomeDataModel *)model{
    
    _model = model;
    
    NSMutableArray *banners = [NSMutableArray array];
    
    for (NSDictionary *diction in model.itemDataSource) {
        
        [banners addObject:diction[@"text"]];
    }
    
    // 跑马灯的文字
    self.scrollLabelView.textArray = banners;
    
    [self.scrollLabelView beginScrolling];  // 开始滚动
    
    self.GoodsView.Goods_Array = @[@"1",@"2"];
}












@end
