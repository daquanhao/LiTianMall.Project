
//
//  HSQStoreDetailHomeHeadReusableView.m
//  LiTianDecoration
//
//  Created by administrator on 2018/5/15.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import "HSQStoreDetailHomeHeadReusableView.h"
#import "HSQCustomButton.h"

@interface HSQStoreDetailHomeHeadReusableView ()

@property (weak, nonatomic) IBOutlet UIImageView *BannerView; // 背后的轮播图

@property (weak, nonatomic) IBOutlet UIImageView *StoreImageView; // 店铺的头像

@property (weak, nonatomic) IBOutlet UILabel *StoreType_Label; // 店铺的类型

@property (weak, nonatomic) IBOutlet UILabel *FenSi_Label; // 粉丝

@property (weak, nonatomic) IBOutlet UIView *titlesView;

@property (nonatomic, weak) UIImageView *indicatorView; // 标签栏底部的红色指示器

@property (nonatomic, weak) UIButton *selectedButton; // 当前选中的按钮


@end

@implementation HSQStoreDetailHomeHeadReusableView

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        

    }
    
    return self;
}

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    // 设置顶部标题栏
    [self setupTopTitlesView];
}

/**
 * @brief 设置顶部标题栏
 */
- (void)setupTopTitlesView{
    
    NSArray *array = @[@"店铺首页",@"全部商品",@"商品上新",@"店铺活动"];
    
    // 底部的红色指示器
    UIImageView *indicatorView = [[UIImageView alloc] init];
    indicatorView.backgroundColor = RGB(255, 83, 63);
    indicatorView.mj_h = 2;
    indicatorView.tag = -1;
    indicatorView.mj_y = self.titlesView.mj_h - indicatorView.mj_h;
    self.indicatorView = indicatorView;
    
    // 内部的子标签
    CGFloat width = KScreenWidth / array.count;
    CGFloat height = self.titlesView.mj_h;
    for (NSInteger i = 0; i < array.count; i++) {
        
        HSQCustomButton *button = [HSQCustomButton buttonWithType:(UIButtonTypeCustom)];
        button.tag = i;
        button.mj_h = height;
        button.mj_w = width;
        button.mj_x = i * width;
        
        [button setTitle:array[i] forState:UIControlStateNormal];
        
         button.alignmentType = Button_AlignmentStatusTop;
        
        [button setImage:[UIImage imageNamed:@"123"] forState:(UIControlStateNormal)];
        
        [button setTitleColor:RGB(131, 131, 131) forState:UIControlStateNormal];
        
        [button setTitleColor:RGB(255, 83, 63) forState:UIControlStateDisabled];
        
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        
        [button addTarget:self action:@selector(titleClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.titlesView addSubview:button];
        
        // 默认点击了第一个按钮
        if (i == 0)
        {
            button.enabled = NO;

            self.selectedButton = button;

            // 让按钮内部的label根据文字内容来计算尺寸
            [button.titleLabel sizeToFit];

            self.indicatorView.mj_w = button.titleLabel.mj_w;

            self.indicatorView.centerX = button.centerX;
        }
    }
    
    [self.titlesView addSubview:indicatorView];
}

/**
 * @brief 顶部按钮的点击事件
 */
- (void)titleClick:(UIButton *)button{
    
    // 修改按钮状态
    self.selectedButton.enabled = YES;
    button.enabled = NO;
    self.selectedButton = button;
    
    // 动画
    [UIView animateWithDuration:0.25 animations:^{
        self.indicatorView.width = button.titleLabel.mj_w;
        self.indicatorView.centerX = button.centerX;
    }];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(TopModelViewButtonClickInStoreDetailHomeHeadReusableView:)]) {
        
        [self.delegate TopModelViewButtonClickInStoreDetailHomeHeadReusableView:button];
    }
}

/**
 * @brief 数据赋值
 */
- (void)setDataDiction:(NSDictionary *)dataDiction{
    
    _dataDiction = dataDiction;
    
    // 店铺的轮播图
    [self.BannerView sd_setImageWithURL:[NSURL URLWithString:dataDiction[@"storeInfo"][@"storeBannerUrl"]] placeholderImage:KGoodsPlacherImage];
    
    // 店铺的头像
    [self.StoreImageView sd_setImageWithURL:[NSURL URLWithString:dataDiction[@"storeInfo"][@"storeAvatarUrl"]] placeholderImage:KIconPlacherImage];
    
    // 店铺的类型
    self.StoreType_Label.text = [NSString stringWithFormat:@"%@",dataDiction[@"storeInfo"][@"storeName"]];
    
    // 店铺的粉丝
    NSString *Wan = [NSString ReturnsAStringWithAThousandWords:dataDiction[@"storeInfo"][@"storeCollect"]];
    self.FenSi_Label.text = [NSString stringWithFormat:@"%@\n粉丝",Wan];
    
    // 店铺是否收藏 isFavorite int 该用户是否收藏了该店铺(1–是，0–否)
    NSString *isFavorite = [NSString stringWithFormat:@"%@",dataDiction[@"isFavorite"]];
    
    if (isFavorite.integerValue == 0)
    {
        self.Collectionstate_Label.text = @"收藏";
    }
    else
    {
        self.Collectionstate_Label.text = @"已收藏";
    }
    
}

/**
 * @brief 收藏店铺的点击事件
 */
- (IBAction)shouCangBtnClickAction:(UIButton *)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(HeadViewCollectionButtonClickAction:)]) {
        
        [self.delegate HeadViewCollectionButtonClickAction:sender];
    }
}





@end
