//
//  HSQTuiJianGoodsListView.m
//  LiTianDecoration
//
//  Created by administrator on 2018/5/16.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import "HSQTuiJianGoodsListView.h"

@interface HSQTuiJianGoodsListView ()

@property (weak, nonatomic) IBOutlet UIImageView *LeftBigImageView;

@property (weak, nonatomic) IBOutlet UIImageView *SecondImageView;

@property (weak, nonatomic) IBOutlet UIImageView *ThirdImageView;

@property (weak, nonatomic) IBOutlet UILabel *SecondLabel;

@property (weak, nonatomic) IBOutlet UILabel *ThirdLabel;

@property (weak, nonatomic) IBOutlet UILabel *FirstLabel01;

@property (weak, nonatomic) IBOutlet UILabel *FirstLabel02;

@end

@implementation HSQTuiJianGoodsListView

- (instancetype)initTuiJianGoodsListView{
    
    return [[[NSBundle mainBundle] loadNibNamed:@"HSQTuiJianGoodsListView" owner:self options:nil]firstObject];
}

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    
    if (self = [super initWithCoder:aDecoder]) {
        
    }
    
    return self;
}

/**
 * @brief 接收上一个界面的数据
 */
- (void)setData_Array:(NSArray *)data_Array{
    
    _data_Array = data_Array;
    
    NSDictionary *first_diction = [data_Array firstObject];
    [self.LeftBigImageView sd_setImageWithURL:[NSURL URLWithString:first_diction[@"imageSrc"]] placeholderImage:KGoodsPlacherImage];
    self.FirstLabel01.text = [NSString stringWithFormat:@"已销：%@%@",first_diction[@"goodsSaleNum"],first_diction[@"unitName"]];
    self.FirstLabel02.text = [NSString stringWithFormat:@"¥%@",first_diction[@"appPrice0"]];
    
    // 第二个商品
    NSDictionary *Second_diction = data_Array[1];
    [self.SecondImageView sd_setImageWithURL:[NSURL URLWithString:Second_diction[@"imageSrc"]] placeholderImage:KGoodsPlacherImage];
    self.SecondLabel.text = [NSString stringWithFormat:@"已销：%@%@",Second_diction[@"goodsSaleNum"],Second_diction[@"unitName"]];
    
    // 第三个个商品
    NSDictionary *Third_diction = data_Array[2];
    [self.ThirdImageView sd_setImageWithURL:[NSURL URLWithString:Third_diction[@"imageSrc"]] placeholderImage:KGoodsPlacherImage];
    self.ThirdLabel.text = [NSString stringWithFormat:@"已销：%@%@",Third_diction[@"goodsSaleNum"],Third_diction[@"unitName"]];

}
















@end
