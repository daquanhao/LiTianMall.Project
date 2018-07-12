//
//  MVGoodsDetailCommentListViewCell.m
//  LiTianDecoration
//
//  Created by administrator on 2018/7/5.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import "MVGoodsDetailCommentListViewCell.h"
#import "HSQStarsView.h"
#import "HSQGoodsRateListModel.h"
#import "HSQGoodsRateImageView.h"

@interface MVGoodsDetailCommentListViewCell ()

@property (nonatomic, strong) UILabel *RateNameLabel;  // 评论的人的名字

@property (nonatomic, strong) HSQStarsView *StarView;  // 星星等级

@property (nonatomic, strong) UILabel *GoodsRateContent_Label;  // 商品评价的内容

@property (nonatomic, strong) HSQGoodsRateImageView *GoodsRateImageView;  // 商品评价的图片

@property (nonatomic, strong) UIView *LineView;  //追加评论的时间左边的提示标

@property (nonatomic, strong) UILabel *ZhuiRateTime_Label;  // 追加评论的时间

@property (nonatomic, strong) UILabel *ZhuiRateContent_Label;  // 商品追加评价的内容

@property (nonatomic, strong) HSQGoodsRateImageView *ZhuiRateImageView;  // 商品追加评价的图片

@end

@implementation MVGoodsDetailCommentListViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.contentView.backgroundColor = [UIColor clearColor];
        
        // 1.评论的人的名字
        UILabel *RateNameLabel = [[UILabel alloc] init];
        RateNameLabel.textColor = RGB(150, 150, 150);
        RateNameLabel.font = [UIFont systemFontOfSize:KLabelFont(14.0, 12.0)];
        RateNameLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:RateNameLabel];
        self.RateNameLabel = RateNameLabel;
        
        // 2.评论的星星
        HSQStarsView *StarView = [[HSQStarsView alloc] init];
        [self.contentView addSubview:StarView];
        self.StarView = StarView;
        
        // 商品的评价内容
        UILabel *GoodsRateContent_Label = [[UILabel alloc] init];
        GoodsRateContent_Label.font = [UIFont systemFontOfSize:KLabelFont(14.0, 12.0)];
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
        ZhuiRateTime_Label.font = [UIFont systemFontOfSize:KLabelFont(14.0, 12.0)];
        ZhuiRateTime_Label.numberOfLines = 0;
        [self.contentView addSubview:ZhuiRateTime_Label];
        self.ZhuiRateTime_Label = ZhuiRateTime_Label;
        
        // 商品追加评价的内容
        UILabel *ZhuiRateContent_Label = [[UILabel alloc] init];
        ZhuiRateContent_Label.font = [UIFont systemFontOfSize:KLabelFont(14.0, 12.0)];
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

- (void)setModel:(HSQGoodsRateListModel *)model{
    
    _model = model;
    
    CGFloat Height = 0;
    
    // 商品评论的星级
    self.StarView.StarsCount = model.scores;
    
    self.StarView.frame = CGRectMake(10, 10, 100, 20);
    
    // 商品的评论时间
    self.RateNameLabel.text = model.memberName;
    
    self.RateNameLabel.frame = CGRectMake(CGRectGetMaxX(self.StarView.frame)+10, 10, KScreenWidth -CGRectGetMaxX(self.StarView.frame) - 10 - 10, 20);
    
    // 商品的评价内容
    self.GoodsRateContent_Label.text = model.evaluateContent1;
    
    CGSize Content_size = [NSString SizeOfTheText:model.evaluateContent1 font:[UIFont systemFontOfSize:KLabelFont(14.0, 12.0)] MaxSize:CGSizeMake(KScreenWidth - 20, MAXFLOAT)];
    
    self.GoodsRateContent_Label.frame = CGRectMake(10, CGRectGetMaxY(self.StarView.frame) +5, KScreenWidth - 20, Content_size.height);
    
    if (model.evaluateContent1.length == 0)
    {
        Height = CGRectGetMaxY(self.StarView.frame) +5;
    }
    else
    {
        Height =  CGRectGetMaxY(self.GoodsRateContent_Label.frame) +5;
    }
    
    // 商品评价的图片
    if (model.image1FullList.count > 0)
    {
        self.GoodsRateImageView.hidden = NO;
        
        CGSize photosSize = [HSQGoodsRateImageView sizeWithCount:model.image1FullList.count];
        
        self.GoodsRateImageView.frame = CGRectMake(10, Height, photosSize.width, photosSize.height);
        
        self.GoodsRateImageView.photos = model.image1FullList;
        
        Height = CGRectGetMaxY(self.GoodsRateImageView.frame) +5;
    }
    else
    {
        self.GoodsRateImageView.hidden = YES;
    }
    
    // ************** 判断是否有追加评论  ************************
    
    if (model.evaluateAgainTimeStr.length == 0)
    {
        self.LineView.hidden = self.ZhuiRateTime_Label.hidden = self.ZhuiRateContent_Label.hidden = self.ZhuiRateImageView.hidden = YES;
        
        self.LineView.frame = self.ZhuiRateTime_Label.frame = self.ZhuiRateContent_Label.frame = self.ZhuiRateImageView.frame = CGRectMake(0, 0, 0, 0);
    }
    else
    {
        self.LineView.hidden = self.ZhuiRateTime_Label.hidden = self.ZhuiRateContent_Label.hidden = self.ZhuiRateImageView.hidden = NO;
        
        // 追评的时间
        CGSize TimetextSize = [NSString SizeOfTheText:model.days font:[UIFont systemFontOfSize:KLabelFont(14.0, 12.0)] MaxSize:CGSizeMake(KScreenWidth - 20, MAXFLOAT)];
        
        self.LineView.frame = CGRectMake(10, Height, 3, TimetextSize.height);
        
        self.ZhuiRateTime_Label.text = [NSString stringWithFormat:@"确认收货并评价后%@天再次追加评价",model.days];
        
        self.ZhuiRateTime_Label.frame = CGRectMake(CGRectGetMaxX(self.LineView.frame) + 5, Height, KScreenWidth - CGRectGetMaxX(self.LineView.frame) - 15, TimetextSize.height);
        
        // 追加评论的内容
        CGSize evaluateContent2_size = [NSString SizeOfTheText:model.evaluateContent2 font:[UIFont systemFontOfSize:KLabelFont(14.0, 12.0)] MaxSize:CGSizeMake(KScreenWidth - 20, MAXFLOAT)];
        
        self.ZhuiRateContent_Label.text = model.evaluateContent2;
        
        self.ZhuiRateContent_Label.frame = CGRectMake(10, CGRectGetMaxY(self.ZhuiRateTime_Label.frame) + 5, KScreenWidth - 20, evaluateContent2_size.height);
        
        Height = (model.evaluateContent2.length == 0 ? CGRectGetMaxY(self.ZhuiRateTime_Label.frame) + 5 : CGRectGetMaxY(self.ZhuiRateContent_Label.frame) + 5);
        
        // 商品追加评价的图片
        if (model.image2FullList.count > 0)
        {
            self.ZhuiRateImageView.hidden = NO;
            
            CGSize photosSize = [HSQGoodsRateImageView sizeWithCount:model.image2FullList.count];
            
            self.ZhuiRateImageView.frame = CGRectMake(10, Height, photosSize.width, photosSize.height);
            
            self.ZhuiRateImageView.photos = model.image2FullList;
        }
        else
        {
            self.ZhuiRateImageView.hidden = YES;
            
            self.ZhuiRateImageView.frame = CGRectMake(10, 0, 0, 0);
        }
    }
}


- (void)setFrame:(CGRect)frame{
    
    frame.origin.y += 1;
    
    frame.size.height -= 2;
    
    [super setFrame:frame];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];

    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

@end
