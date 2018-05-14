//
//  HSQGoodsRateListCollectionViewCell.m
//  LiTianDecoration
//
//  Created by administrator on 2018/5/12.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import "HSQGoodsRateListCollectionViewCell.h"
#import "HSQGoodsRateImageView.h"
#import "HSQGoodsRateListModel.h"
#import "HSQGoodsRateListFrameModel.h"

@interface HSQGoodsRateListCollectionViewCell ()

@property (nonatomic, strong) UILabel *GoodsRateContent_Label;  // 商品评价的内容

@property (nonatomic, strong) HSQGoodsRateImageView *GoodsRateImageView;  // 商品评价的图片

@property (nonatomic, strong) UIView *LineView;  //追加评论的时间左边的提示标

@property (nonatomic, strong) UILabel *ZhuiRateTime_Label;  // 追加评论的时间

@property (nonatomic, strong) UILabel *ZhuiRateContent_Label;  // 商品追加评价的内容

@property (nonatomic, strong) HSQGoodsRateImageView *ZhuiRateImageView;  // 商品追加评价的图片

@end

@implementation HSQGoodsRateListCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        // 商品的评价内容
        UILabel *GoodsRateContent_Label = [[UILabel alloc] init];
        GoodsRateContent_Label.font = [UIFont systemFontOfSize:14];
        GoodsRateContent_Label.numberOfLines = 0;
        [self.contentView addSubview:GoodsRateContent_Label];
        self.GoodsRateContent_Label = GoodsRateContent_Label;
        
        // 商品评价的图片
        HSQGoodsRateImageView *GoodsRateImageView = [[HSQGoodsRateImageView alloc] init];
        [self.contentView addSubview:GoodsRateImageView];
        self.GoodsRateImageView = GoodsRateImageView;
        
        // 追加评论时间的提示图片
        UIView *LineView = [[UIView alloc] init];
        LineView.backgroundColor = RGB(238, 58, 68);
        [self.contentView addSubview:LineView];
        self.LineView = LineView;
        
        // 商品追加评价的时间
        UILabel *ZhuiRateTime_Label = [[UILabel alloc] init];
        ZhuiRateTime_Label.font = [UIFont systemFontOfSize:14];
        ZhuiRateTime_Label.numberOfLines = 0;
        [self.contentView addSubview:ZhuiRateTime_Label];
        self.ZhuiRateTime_Label = ZhuiRateTime_Label;
        
        // 商品追加评价的内容
        UILabel *ZhuiRateContent_Label = [[UILabel alloc] init];
        ZhuiRateContent_Label.font = [UIFont systemFontOfSize:14];
        ZhuiRateContent_Label.numberOfLines = 0;
        [self.contentView addSubview:ZhuiRateContent_Label];
        self.ZhuiRateContent_Label = ZhuiRateContent_Label;
        
        // 商品追加评价的图片
        HSQGoodsRateImageView *ZhuiRateImageView = [[HSQGoodsRateImageView alloc] init];
        [self.contentView addSubview:ZhuiRateImageView];
        self.ZhuiRateImageView = ZhuiRateImageView;
    }
    
    return self;
}

- (void)setFrameModel:(HSQGoodsRateListFrameModel *)FrameModel{
    
    _FrameModel = FrameModel;
    
    HSQGoodsRateListModel *RateModel = FrameModel.model;
    
    // 商品的评价内容
    self.GoodsRateContent_Label.text = RateModel.evaluateContent1;
    self.GoodsRateContent_Label.frame = FrameModel.ContentFrame;
    
    // 商品评价的图片
    if (RateModel.image1FullList.count > 0)
    {
        self.GoodsRateImageView.hidden = NO;
        self.GoodsRateImageView.frame = FrameModel.ContentImageViewFrame;
        self.GoodsRateImageView.photos = RateModel.image1FullList;
    }
    else
    {
        self.GoodsRateImageView.hidden = YES;
    }
    
    // 追加评论时间的提示图片
    if (RateModel.days.length != 0)
    {
        self.LineView.hidden = NO;
        self.LineView.frame = FrameModel.LeftImageFrame;
    }
    else
    {
        self.LineView.hidden = YES;
    }

    // 追加评论的时间
    self.ZhuiRateTime_Label.text = [NSString stringWithFormat:@"确认收货并评价后%@天再次追加评价",RateModel.days];
    self.ZhuiRateTime_Label.frame = FrameModel.ZhuiJiaRateTimeFrame;

    // 商品追加评价的内容
    self.ZhuiRateContent_Label.text = RateModel.evaluateContent2;
    self.ZhuiRateContent_Label.frame = FrameModel.ZhuiJiaContentFrame;

    // 商品追加评价的图片
    if (RateModel.image2FullList.count > 0)
    {
        self.ZhuiRateImageView.hidden = NO;
        self.ZhuiRateImageView.frame = FrameModel.ZhuiJiaRateImageFrame;
        self.ZhuiRateImageView.photos = RateModel.image2FullList;
    }
    else
    {
        self.ZhuiRateImageView.hidden = YES;
    }

}














@end
