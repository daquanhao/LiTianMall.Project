//
//  HSQAllGoodsModelTitleCollectionReusableView.m
//  LiTianDecoration
//
//  Created by administrator on 2018/5/16.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import "HSQAllGoodsModelTitleCollectionReusableView.h"
#import "HSQTopShaiXuanView.h"

@interface HSQAllGoodsModelTitleCollectionReusableView ()<HSQTopShaiXuanViewDelegate>

@property (nonatomic, strong) HSQTopShaiXuanView *TopShaiXuanView;

@end

@implementation HSQAllGoodsModelTitleCollectionReusableView

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        // 添加界面的按钮
        [self setupTopTitlesView];
    }
    
    return self;
}

/**
 * @brief 添加界面的按钮
 */
- (void)setupTopTitlesView{
    
    HSQTopShaiXuanView *TopShaiXuanView = [[HSQTopShaiXuanView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, self.mj_h)];
    
    TopShaiXuanView.delegate = self;
    
    [self addSubview:TopShaiXuanView];
    
    self.TopShaiXuanView = TopShaiXuanView;
}

/**
 * @brief 顶部筛选的按钮的点击
 */
- (void)ClickTheButtonOnTheTopScreen:(UIButton *)sender{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(AllGoodsModelTitleCollectionReusableViewButtonClickAction:)]) {
        
        [self.delegate AllGoodsModelTitleCollectionReusableViewButtonClickAction:sender];
    }
}


@end
