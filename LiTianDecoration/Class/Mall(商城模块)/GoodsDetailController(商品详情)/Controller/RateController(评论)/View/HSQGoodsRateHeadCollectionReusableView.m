//
//  HSQGoodsRateHeadCollectionReusableView.m
//  LiTianDecoration
//
//  Created by administrator on 2018/5/11.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import "HSQGoodsRateHeadCollectionReusableView.h"
#import "HSQGoodsRateListModel.h"
#import "HSQStarsView.h"
#import "HSQGoodsRateListFrameModel.h"

@interface HSQGoodsRateHeadCollectionReusableView ()

@property (nonatomic, strong) UIView *TopLineView;  // 分割线

@property (nonatomic, strong) UIImageView *IconImageView;

@property (nonatomic, strong) UILabel *NickNameLabel;

@property (nonatomic, strong) UILabel *RateTimeLabel;

@property (nonatomic, strong) UIView *LineView;  // 分割线

@property (nonatomic, strong) HSQStarsView *StarView;  // 星星等级

@end

@implementation HSQGoodsRateHeadCollectionReusableView

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        // 创建控件
        [self SetUpHeadView];
        
        // 添加控件的约束
        [self SetUpHeadViewLayOut];
    }
    
    return self;
}

/**
 * @brief 创建控件
 */
- (void)SetUpHeadView{
    
    // 4.分割线
    UIView *TopLineView = [[UIView alloc] init];
    TopLineView.backgroundColor = KViewBackGroupColor;
    [self addSubview:TopLineView];
    self.TopLineView = TopLineView;
    
    // 1.会员的头像
    UIImageView *IconImageView = [[UIImageView alloc] init];
    [self addSubview:IconImageView];
    self.IconImageView = IconImageView;
    
    // 2.会员的名字
    UILabel *NickNameLabel = [[UILabel alloc] init];
    NickNameLabel.textColor = RGB(74, 74, 74);
    NickNameLabel.font = [UIFont systemFontOfSize:14];
    [self addSubview:NickNameLabel];
    self.NickNameLabel = NickNameLabel;
    
    // 3.评论的时间
    UILabel *RateTimeLabel = [[UILabel alloc] init];
    RateTimeLabel.textColor = RGB(150, 150, 150);
    RateTimeLabel.font = [UIFont systemFontOfSize:KLabelFont(14.0, 12.0)];
    [self addSubview:RateTimeLabel];
    self.RateTimeLabel = RateTimeLabel;
    
    // 4.分割线
    UIView *LineView = [[UIView alloc] init];
    LineView.backgroundColor = KViewBackGroupColor;
    [self addSubview:LineView];
    self.LineView = LineView;
    
    // 5.评论的星星
    HSQStarsView *StarView = [[HSQStarsView alloc] init];
    [self addSubview:StarView];
    self.StarView = StarView;
    
}

/**
 * @brief 添加控件的约束
 */
- (void)SetUpHeadViewLayOut{
    
    // 0.分割线
    self.TopLineView.sd_layout.leftSpaceToView(self, 0).rightSpaceToView(self, 0).topSpaceToView(self, 0).heightIs(10);
    
    // 1.会员的头像
    self.IconImageView.sd_layout.leftSpaceToView(self, 10).topSpaceToView(self.TopLineView, 10).widthIs(30).heightEqualToWidth();
    [self.IconImageView setSd_cornerRadiusFromWidthRatio:@(0.5)];
    
    // 2.会员的名字
    self.NickNameLabel.sd_layout.leftSpaceToView(self.IconImageView, 10).centerYEqualToView(self.IconImageView).heightIs(20).autoWidthRatio(0);
    [self.NickNameLabel setSingleLineAutoResizeWithMaxWidth:(KScreenWidth - 65)/2];
    
    // 3.评论的时间
    self.RateTimeLabel.sd_layout.rightSpaceToView(self, 10).centerYEqualToView(self.IconImageView).heightIs(20).autoWidthRatio(0);
    [self.RateTimeLabel setSingleLineAutoResizeWithMaxWidth:(KScreenWidth - 65)/2];
    
    // 4.分割线
    self.LineView.sd_layout.leftSpaceToView(self, 0).rightSpaceToView(self, 0).topSpaceToView(self.IconImageView, 10).heightIs(1);
    
    // 5.评论的星星
    self.StarView.frame = CGRectMake(10, 66, KScreenWidth - 20, 20);
    
}

/**
 * @brief 数据赋值
 */
- (void)setFrameModel:(HSQGoodsRateListFrameModel *)FrameModel{
    
    _FrameModel = FrameModel;
    
    HSQGoodsRateListModel *rateModel = FrameModel.model;
    
    // 会员的头像
    [self.IconImageView sd_setImageWithURL:[NSURL URLWithString:rateModel.memberHeadUrl] placeholderImage:KIconPlacherImage];
    
    // 会员的名字
    self.NickNameLabel.text = rateModel.memberName;
    
    // 评论的时间
    self.RateTimeLabel.text = rateModel.evaluateTimeStr;
    
    // 评论的星星
    self.StarView.StarsCount = rateModel.scores;
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

@end
