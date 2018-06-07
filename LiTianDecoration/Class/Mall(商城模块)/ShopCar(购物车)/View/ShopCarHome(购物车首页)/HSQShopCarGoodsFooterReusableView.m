//
//  HSQShopCarGoodsFooterReusableView.m
//  LiTianDecoration
//
//  Created by administrator on 2018/5/21.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import "HSQShopCarGoodsFooterReusableView.h"
#import "HSQShopCarVCGoodsDataModel.h"

@interface HSQShopCarGoodsFooterReusableView ()

/**
 * @brief 总的价格
 */
@property (weak, nonatomic) IBOutlet UILabel *TotalPrice_Label;

@property (nonatomic, copy) NSString *TotalTypeString; // 一共有几中

@property (nonatomic, copy) NSString *TotalPrice; // 总的价钱

@end

@implementation HSQShopCarGoodsFooterReusableView

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        
    }
    
    return self;
}

- (void)setRightItemEditState:(NSString *)RightItemEditState{
    
    _RightItemEditState = RightItemEditState;
    
    if (RightItemEditState.integerValue == 1) // 是否是编辑状态
    {
        [self.TotalPrice_Label setHidden:NO];
    }
    else
    {
        [self.TotalPrice_Label setHidden:YES];
    }
}


- (void)setFirstModel:(HSQShopCarVCGoodsDataModel *)FirstModel{
    
    _FirstModel = FirstModel;
    
    if (FirstModel.SelectTypeString.length == 0)
    {
        self.TotalTypeString = [NSString stringWithFormat:@"共0种0件"];
        
        self.TotalPrice = @"¥0.00";
    }
    else
    {
        self.TotalTypeString = [NSString stringWithFormat:@"共%@种%@件",FirstModel.SelectTypeString,FirstModel.SelectCountString];
        
        self.TotalPrice = [NSString stringWithFormat:@"¥%@",FirstModel.SelectGoodsPrice];
    }
    
    NSString *goodsPrice = [NSString stringWithFormat:@"%@    %@",self.TotalTypeString,self.TotalPrice];
    
    NSMutableAttributedString *attribeString =[NSString attributedStringWithString:goodsPrice Color:RGB(71, 71, 71) range:NSMakeRange(0, self.TotalTypeString.length)];
    
    self.TotalPrice_Label.attributedText = attribeString;

}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

@end
