//
//  HSQStoreIntroductHeadCell.m
//  LiTianDecoration
//
//  Created by administrator on 2018/5/15.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import "HSQStoreIntroductHeadCell.h"

@interface HSQStoreIntroductHeadCell ()

@property (weak, nonatomic) IBOutlet UIImageView *StoreImageView; // 店铺的图片

@property (weak, nonatomic) IBOutlet UILabel *StoreName_Label; // 店铺的名字

@property (weak, nonatomic) IBOutlet UILabel *StoreBuyType_Label; // 店铺是买什么的

@property (weak, nonatomic) IBOutlet UIButton *StoreType_Label; // 店铺的类型

@property (weak, nonatomic) IBOutlet UILabel *FenSiLabel; // 粉丝


@end

@implementation HSQStoreIntroductHeadCell


/**
 * @brief 数据赋值
 */
-(void)setDataDiction:(NSDictionary *)DataDiction{
    
    _DataDiction = DataDiction;
    
    // 店铺的照片
    [self.StoreImageView sd_setImageWithURL:[NSURL URLWithString:DataDiction[@"storeInfo"][@"storeAvatarUrl"]] placeholderImage:KGoodsPlacherImage];
    
    // 店铺的名字
    self.StoreName_Label.text = [NSString stringWithFormat:@"%@",DataDiction[@"storeInfo"][@"storeName"]];
    
    // 店铺是买什么的
    self.StoreBuyType_Label.text = [NSString stringWithFormat:@"%@",DataDiction[@"storeInfo"][@"className"]];
    
    // 店铺的类型
    [self.StoreType_Label setTitle:[NSString stringWithFormat:@"%@",DataDiction[@"storeInfo"][@"gradeName"]] forState:(UIControlStateDisabled)];
    
    // 店铺的粉丝
    NSString *Wan = [NSString ReturnsAStringWithAThousandWords:DataDiction[@"storeInfo"][@"storeCollect"]];
    self.FenSiLabel.text = [NSString stringWithFormat:@"%@位粉丝",Wan];
    
    // 店铺是否收藏 isFavorite int 该用户是否收藏了该店铺(1–是，0–否)
    NSString *isFavorite = [NSString stringWithFormat:@"%@",DataDiction[@"isFavorite"]];
    
    if (isFavorite.integerValue == 0)
    {
        [self.Collection_Btn setTitle:@"收藏" forState:(UIControlStateNormal)];
    }
    else
    {
        [self.Collection_Btn setTitle:@"已收藏" forState:(UIControlStateNormal)];
    }
    
}

/**
 * @brief 收藏按钮的点击事件
 */
- (IBAction)ShouCangBtnClickAction:(UIButton *)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(CollectStoreNotiftioncClickAction:)]) {
        
        [self.delegate CollectStoreNotiftioncClickAction:sender];
    }
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

