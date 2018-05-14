//
//  HSQImageListCollectionViewCell.m
//  LiTianDecoration
//
//  Created by administrator on 2018/5/8.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import "HSQImageListCollectionViewCell.h"
#import "HSQMallHomeDataModel.h"

@interface HSQImageListCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *ShowImageView;

@property (weak, nonatomic) IBOutlet UIImageView *First_ImageView;

@property (weak, nonatomic) IBOutlet UIImageView *Second_ImageView;

@property (weak, nonatomic) IBOutlet UIImageView *Third_ImageView;

@property (weak, nonatomic) IBOutlet UIView *BgView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *LeftImageLayout;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *RightImageLayOut;

@end

@implementation HSQImageListCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        
    }
    
    return self;
}

/**
 * @brief 数据赋值
 */
- (void)setImageUrl:(NSString *)ImageUrl{
    
    _ImageUrl = ImageUrl;
    
    [self.BgView setHidden:YES];
    
    [self.ShowImageView setHidden:NO];
    
     // 商品的图片
    [self.ShowImageView sd_setImageWithURL:[NSURL URLWithString:ImageUrl] placeholderImage:KGoodsPlacherImage];
}


- (void)setModel:(HSQMallHomeDataModel *)model{
    
    _model = model;
    
    [self.BgView setHidden:NO];
    
    [self.ShowImageView setHidden:YES];
    
    if ([model.itemType isEqualToString:@"home2"]) // 左一右二图片模块
    {
        self.RightImageLayOut.constant = KScreenWidth/2;
        self.LeftImageLayout.constant = KScreenWidth/2;
    }
    else
    {
        self.RightImageLayOut.constant = 0;
        self.LeftImageLayout.constant = 0;
    }
    
    NSDictionary *first_diction = [model.itemDataSource firstObject];
    [self.First_ImageView sd_setImageWithURL:[NSURL URLWithString:first_diction[@"imageUrl"]] placeholderImage:KGoodsPlacherImage];
    
    NSDictionary *Second_diction = model.itemDataSource[1];
    [self.Second_ImageView sd_setImageWithURL:[NSURL URLWithString:Second_diction[@"imageUrl"]] placeholderImage:KGoodsPlacherImage];
    
    NSDictionary *Third_diction = [model.itemDataSource lastObject];
    [self.Third_ImageView sd_setImageWithURL:[NSURL URLWithString:Third_diction[@"imageUrl"]] placeholderImage:KGoodsPlacherImage];
}









- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

@end
