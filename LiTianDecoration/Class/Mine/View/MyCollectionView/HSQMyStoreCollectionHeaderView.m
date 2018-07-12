//
//  HSQMyStoreCollectionHeaderView.m
//  LiTianDecoration
//
//  Created by administrator on 2018/6/8.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import "HSQMyStoreCollectionHeaderView.h"
#import "HSQStoreCollectionListDataModel.h"

@interface HSQMyStoreCollectionHeaderView ()

@property (weak, nonatomic) IBOutlet UIImageView *StoreIcon_imageView; // 商店的头像

@property (weak, nonatomic) IBOutlet UILabel *storeName_Label; // 店铺的名字

@property (weak, nonatomic) IBOutlet UILabel *NewGoodsCount_Label; // 商品上新的个数

@property (weak, nonatomic) IBOutlet UIImageView *SanJiao_ImageView;

@property (weak, nonatomic) IBOutlet UIButton *Select_Button; // 选中按钮

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *LeftMargin;

@end

@implementation HSQMyStoreCollectionHeaderView

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    
    if (self = [super initWithCoder:aDecoder]) {
        
    }
    
    return self;
}

- (void)awakeFromNib{
    
    [super awakeFromNib];
    
}


/**
 * @brief 店铺的数据模型
 */
-(void)setStoreModel:(HSQStoreCollectionListDataModel *)StoreModel{
    
    _StoreModel = StoreModel;
    
    // 店铺的图片
    [self.StoreIcon_imageView sd_setImageWithURL:[NSURL URLWithString:StoreModel.store[@"storeAvatarUrl"]] placeholderImage:KGoodsPlacherImage];
    
    // 店铺的名字
    self.storeName_Label.text = [NSString stringWithFormat:@"%@",StoreModel.store[@"storeName"]];
    
    // 店铺上新商品的个数
    if (StoreModel.StoreNewGoodsList.count == 0)
    {
        self.SanJiao_ImageView.hidden = self.NewGoodsCount_Label.hidden = YES;
        
        self.NewGoodsCount_Label.text = @"";
    }
    else
    {
        self.SanJiao_ImageView.hidden = self.NewGoodsCount_Label.hidden = NO;
        
        self.NewGoodsCount_Label.text = [NSString stringWithFormat:@"%ld\n上新",StoreModel.StoreNewGoodsList.count];
    }
    
    // 判断是否在编辑状态 StoreModel.IsEditState == 1 代表不是编辑状态
    [UIView animateWithDuration:0.25 animations:^{
        
        self.LeftMargin.constant = (StoreModel.IsEditState.integerValue == 1 ? 10 : 40);
    }];
    
    // 是否选中  1代表没有选中 2 代表选中
   self.Select_Button.selected = (StoreModel.IsSelectState.integerValue == 1 ? NO : YES);
    
    // 是否显示商品的视图
    if (StoreModel.IsShow.integerValue == 0) // 不显示
    {
        self.SanJiao_ImageView.transform = CGAffineTransformIdentity;
    }
    else
    {
        self.SanJiao_ImageView.transform = CGAffineTransformMakeRotation(M_PI);
    }
}

/**
 * @brief 编时选中按钮
 */
- (IBAction)Select_ButtonClickAction:(UIButton *)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(SelectTheClickEventOfTheButtonWhenEditing:)]) {
        
        [self.delegate SelectTheClickEventOfTheButtonWhenEditing:sender];
    }
}

/**
 * @brief 点击进入店铺详情
 */
- (IBAction)JoinStoreDetailBtnClickAction:(UIButton *)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(JoinStoreDetailButtonClickAction:)]) {
        
        [self.delegate JoinStoreDetailButtonClickAction:sender];
    }
}

/**
 * @brief 显示商品的个数视图
 */
- (IBAction)ShowGoodsCountBtnClickAction:(UIButton *)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(ShowGoodsViewBtnClickAction:)]) {
        
        [self.delegate ShowGoodsViewBtnClickAction:sender];
    }
}























@end
