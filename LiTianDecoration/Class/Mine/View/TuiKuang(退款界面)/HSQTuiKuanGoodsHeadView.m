//
//  HSQTuiKuanGoodsHeadView.m
//  LiTianDecoration
//
//  Created by administrator on 2018/6/1.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import "HSQTuiKuanGoodsHeadView.h"

@interface HSQTuiKuanGoodsHeadView ()

@property (nonatomic, strong) UIImageView *StoreImageView; // 店铺的小图标

@property (nonatomic, strong) UILabel *StoreName_Label; // 店铺的名字

@property (nonatomic, strong) UIImageView *SanJiao_Image; // 三角图片

@property (nonatomic, strong) UIView *StoreBgView;  // 店铺的背景图


@end

@implementation HSQTuiKuanGoodsHeadView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        
        // 设置控件
        [self SetUpView];
    }
    
    return self;
}

/**
 * @brief 设置控件
 */
- (void)SetUpView{
    
    // .店铺的背景图
    UIView *StoreBgView = [[UIView alloc] init];
    StoreBgView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:StoreBgView];
    self.StoreBgView = StoreBgView;
    
    // 店铺小图标
    UIImageView *StoreImageView = [[UIImageView alloc] initWithImage:KImageName(@"123")];
    [StoreBgView addSubview:StoreImageView];
    self.StoreImageView = StoreImageView;
    
    //店铺的名字
    UILabel *StoreName_Label = [[UILabel alloc] init];
    StoreName_Label.textColor = RGB(74, 74, 74);
    StoreName_Label.font = [UIFont systemFontOfSize:12.0];
    StoreName_Label.numberOfLines = 0;
    [StoreBgView addSubview:StoreName_Label];
    self.StoreName_Label = StoreName_Label;
    
    // 店铺三角图标
    UIImageView *SanJiao_Image = [[UIImageView alloc] initWithImage:KImageName(@"C7F2BC79-AC34-4AB0-AAFA-021F9AD47E36")];
    [StoreBgView addSubview:SanJiao_Image];
    self.SanJiao_Image = SanJiao_Image;
    
}

/**
 * @brief 设置控件的数据
 */
- (void)setOrderDataDiction:(NSDictionary *)OrderDataDiction{
    
    _OrderDataDiction = OrderDataDiction;

    // 4.店铺的背景图
    self.StoreBgView.frame = CGRectMake(0, 5, KScreenWidth, 40);
    
    // 4.1.店铺的小图标
    self.StoreImageView.frame = CGRectMake(10, 10, 20, 20);
    
    // 4.2.店铺的名字
    NSString *StoreName = [NSString stringWithFormat:@"%@",OrderDataDiction[@"ordersVo"][@"storeName"]];
    CGSize StoreName_Size = [NSString SizeOfTheText:StoreName font:[UIFont systemFontOfSize:12.0] MaxSize:CGSizeMake(KScreenWidth - 43, MAXFLOAT)];
    self.StoreName_Label.frame = CGRectMake(40, 0, StoreName_Size.width, 40);
    self.StoreName_Label.text = StoreName;
    
    // 4.3.店铺的三角图片
    self.SanJiao_Image.frame = CGRectMake(CGRectGetMaxX(self.StoreName_Label.frame)+10, 15, 8, 11);
}




















@end
