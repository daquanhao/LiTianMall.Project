//
//  HSQUsingTheReportCell.m
//  LiTianDecoration
//
//  Created by administrator on 2018/4/17.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import "HSQUsingTheReportCell.h"
#import "HSQTrialReportListModel.h"
#import "HSQPhotosView.h"
#import "HSQTrialReportFrameModel.h"

@interface HSQUsingTheReportCell ()

@property (nonatomic, strong) UIImageView *icon_imageView;

@property (nonatomic, strong) UILabel *name_label;

@property (nonatomic, strong) UILabel *time_label;

@property (nonatomic, strong) UILabel *goodsName_label;

@property (nonatomic, strong) UIView *Line_View;

@property (nonatomic, strong) UILabel *content_label; // 评论的内容

@property (nonatomic, strong) HSQPhotosView *photosView;

@end

@implementation HSQUsingTheReportCell

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        // 1.用户的头像
        UIImageView *icon_ImageView = [[UIImageView alloc] init];
        icon_ImageView.image = KImageName(@"3-1P106112Q1-51");
        [self.contentView addSubview:icon_ImageView];
        self.icon_imageView = icon_ImageView;
        
        // 2.用户的昵称
        UILabel *name_label = [[UILabel alloc] init];
        name_label.text = @"匿名用户";
        name_label.textColor = [UIColor blackColor];
        name_label.font = [UIFont systemFontOfSize:14.0];
        [self.contentView addSubview:name_label];
        self.name_label = name_label;
        
        // 3.用户试用的时间
        UILabel *time_label = [[UILabel alloc] init];
        time_label.text = @"2018-04-13 16:06";
        time_label.textColor = [UIColor grayColor];
        time_label.font = [UIFont systemFontOfSize:14.0];
        [self.contentView addSubview:time_label];
        self.time_label = time_label;
        
        // 4.商品的名字
        UILabel *goodsName_label = [[UILabel alloc] init];
        goodsName_label.text = @"MacBook Pro 13.3英寸苹果笔记本电脑（I5  2.7GHz  8G  128G）";
        goodsName_label.textColor = [UIColor blackColor];
        goodsName_label.font = [UIFont systemFontOfSize:13.0];
        [self.contentView addSubview:goodsName_label];
        self.goodsName_label = goodsName_label;
        
        // 5.中间的分割线
        UIView *line_view = [[UIView alloc] init];
        line_view.backgroundColor = [UIColor grayColor];
        [self.contentView addSubview:line_view];
        self.Line_View = line_view;
        
        // 6.用户评论的内容
        UILabel *content_label = [[UILabel alloc] init];
        content_label.textColor = [UIColor blackColor];
        content_label.numberOfLines = 0;
        content_label.font = [UIFont systemFontOfSize:13.0];
        [self.contentView addSubview:content_label];
        self.content_label = content_label;
        
        // 7.用户评论的图片
        HSQPhotosView *photosView = [[HSQPhotosView alloc] init];
        [self.contentView addSubview:photosView];
        self.photosView = photosView;
        
        // 添加约束
//        [self AddContentViewLayout];
    }
    
    return self;
}

/**
 * @brief 添加约束
 */
- (void)AddContentViewLayout{
    
    // 1.用户的头像
    self.icon_imageView.sd_layout.leftSpaceToView(self.contentView, 10).topSpaceToView(self.contentView, 5).widthIs(50).heightEqualToWidth();
    
    // 2.用户的昵称
    self.name_label.sd_layout.leftSpaceToView(self.icon_imageView, 10).rightSpaceToView(self.contentView, 10).topEqualToView(self.icon_imageView).heightIs(25);
    
    // 3.用户试用的时间
    self.time_label.sd_layout.leftEqualToView(self.name_label).rightEqualToView(self.name_label).topSpaceToView(self.name_label, 5).heightIs(25);
    
    // 4.商品的名字
    self.goodsName_label.sd_layout.leftEqualToView(self.icon_imageView).rightSpaceToView(self.contentView, 10).topSpaceToView(self.icon_imageView, 10).autoHeightRatio(0);
    
    // 5.中间的分割线
    self.Line_View.sd_layout.leftEqualToView(self.icon_imageView).rightSpaceToView(self.contentView, 10).topSpaceToView(self.goodsName_label, 10).heightIs(1);
    
    // 6.评论的内容
    self.content_label.sd_layout.leftEqualToView(self.goodsName_label).rightEqualToView(self.goodsName_label).topSpaceToView(self.Line_View, 10).autoHeightRatio(0);
    [self.content_label setMaxNumberOfLinesToShow:3];
    
    // 7.评论的图片
    self.photosView.sd_layout.leftEqualToView(self.goodsName_label).rightEqualToView(self.goodsName_label).topSpaceToView(self.content_label, 10).autoHeightRatio(0);
}

- (void)setFrameModel:(HSQTrialReportFrameModel *)FrameModel{
    
    _FrameModel = FrameModel;
    
    HSQTrialReportListModel *model = FrameModel.model;
    
    // 1.用户的头像
    self.icon_imageView.frame = FrameModel.iconFrame;
    self.icon_imageView.image = [UIImage imageNamed:model.iconImagePath];
    
    // 2.用户的昵称
    self.name_label.frame = FrameModel.NickNameFrame;
    
    // 3.评论的时间
    self.time_label.frame = FrameModel.TimeLabelFrame;
    
    // 4.商品的名字
    self.goodsName_label.frame = FrameModel.GoodsNameFrame;
    
    // 5.分割线
    self.Line_View.frame = FrameModel.LineViewFrame;
    
    // 6.评论的内容
    self.content_label.frame = FrameModel.ContentFrame;
    self.content_label.text = model.reportContent;
    
    // 3.评论的图片
    if (model.images.count > 0)
    {
        self.photosView.frame = FrameModel.PhotosViewFrame;
        self.photosView.photos = model.images;
        [self.photosView setHidden:NO];
    }
    else
    {
        [self.photosView setHidden:YES];
    }

}

















@end
