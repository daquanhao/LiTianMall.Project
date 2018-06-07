//
//  HSQTuiGoodsAndMoneryListCell.m
//  LiTianDecoration
//
//  Created by administrator on 2018/6/4.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import "HSQTuiGoodsAndMoneryListCell.h"
#import "HSQTuiGoodsandMoneryListModel.h"

@interface HSQTuiGoodsAndMoneryListCell ()

@property (weak, nonatomic) IBOutlet UILabel *StoreName_Label; // 店铺的名字

@property (weak, nonatomic) IBOutlet UILabel *GoodsStare_Label; // 商品的状态

@property (weak, nonatomic) IBOutlet UIImageView *GoodsImageView; // 商品的图片

@property (weak, nonatomic) IBOutlet UILabel *GoodsName_Label; // 商品的名字

@property (weak, nonatomic) IBOutlet UILabel *GoodsGuiGe_Label; // 商品的规格

@property (weak, nonatomic) IBOutlet UILabel *CreatTime_Label; // 创建的时间

@property (weak, nonatomic) IBOutlet UILabel *OrderMonery_Label; // 退款的金额

@property (weak, nonatomic) IBOutlet UILabel *GoodsCount_Label; // 退货的数量

@property (weak, nonatomic) IBOutlet UIButton *Right_Button; // 右边的按钮

@property (weak, nonatomic) IBOutlet UIButton *Left_Button; // 左边的按钮

@property (weak, nonatomic) IBOutlet UIView *CountBgView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *TopMargin;

@end

@implementation HSQTuiGoodsAndMoneryListCell

- (void)setModel:(HSQTuiGoodsandMoneryListModel *)model{
    
    _model = model;
    
    // 店铺的名字
    self.StoreName_Label.text = model.accusedName;
    
    // 商品的状态
    self.GoodsStare_Label.text = model.complainStateName;
    
    // 商品的图片
    [self.GoodsImageView sd_setImageWithURL:[NSURL URLWithString:model.imageSrc] placeholderImage:KGoodsPlacherImage];
    
    // 商品的名字
    self.GoodsName_Label.text = model.goodsName;
    
    // 商品的规格
    self.GoodsGuiGe_Label.text = model.goodsFullSpecs;
    
    // 区分订单的状态
    if (model.OrderListState.integerValue == 100) // 退款列表
    {
        self.CountBgView.hidden = NO;
        
        self.TopMargin.constant = 1;
        
        self.Left_Button.hidden = YES;
        
        [self.Right_Button setTitle:@"退款详情" forState:(UIControlStateNormal)];
        
        // 创建的时间
        self.CreatTime_Label.text = model.addTime;
    }
    else if (model.OrderListState.integerValue == 200) // 退货列表
    {
        self.CountBgView.hidden = NO;
        
        self.TopMargin.constant = 1;
    }
    else // 投诉列表
    {
        // 是否允许撤销投诉
        if (model.showMemberClose.integerValue == 1) // 允许
        {
            self.Left_Button.hidden = NO;
            [self.Left_Button setTitle:@"撤销投诉" forState:(UIControlStateNormal)];
            [self.Right_Button setTitle:@"投诉详情" forState:(UIControlStateNormal)];
        }
        else
        {
            self.Left_Button.hidden = YES;
            [self.Right_Button setTitle:@"投诉详情" forState:(UIControlStateNormal)];
        }
        
        self.CountBgView.hidden = YES;
        
        self.TopMargin.constant = -40;
        
        self.OrderMonery_Label.text = model.subjectTitle;
        
        // 创建的时间
        self.CreatTime_Label.text = model.accuserTime;
    }

}

/**
 * @brief 右边按钮的点击事件
 */
- (IBAction)RightOrderDetailBtnClickAction:(UIButton *)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(RightBtnWithCellClickAction:)]) {
        
        [self.delegate RightBtnWithCellClickAction:sender];
    }
}

/**
 * @brief 左边按钮的点击事件
 */
- (IBAction)LeftBtnClickAction:(UIButton *)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(LeftBtnWithCellClickAction:)]) {
        
        [self.delegate LeftBtnWithCellClickAction:sender];
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
