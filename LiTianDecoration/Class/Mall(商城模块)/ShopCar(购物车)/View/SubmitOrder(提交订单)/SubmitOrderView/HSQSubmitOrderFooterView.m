//
//  HSQSubmitOrderFooterView.m
//  LiTianDecoration
//
//  Created by administrator on 2018/5/24.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import "HSQSubmitOrderFooterView.h"
#import "HSQShopCarVCGoodsDataModel.h"


@interface HSQSubmitOrderFooterView ()

@property (weak, nonatomic) IBOutlet UIView *CouponsView; //满优惠视图

@property (weak, nonatomic) IBOutlet UILabel *YunFei_Label; // 运费

@property (weak, nonatomic) IBOutlet UIView *LeaveMessage;// 买家留言

@property (weak, nonatomic) IBOutlet UILabel *TotalMonery_Label; // 商品总的价格

@property (weak, nonatomic) IBOutlet UILabel *PayType_Label;  // 支付方式

@end

@implementation HSQSubmitOrderFooterView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        

    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    
    if (self = [super initWithCoder:aDecoder]) {
        
    }
    
    return self;
}

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    self.contentView.backgroundColor = KViewBackGroupColor;
    
    // 带有提示文字的输入框
    HSQCustomTextView *textView = [[HSQCustomTextView alloc] initWithFrame:CGRectMake(10, 5, self.LeaveMessage.mj_w - 20, self.LeaveMessage.mj_h - 10)];
    textView.placeholder = @"选填：给商家留言（100字以内）";
    textView.placeholderColor = RGB(180, 180, 180);
    textView.returnKeyType = UIReturnKeyDone;
    textView.backgroundColor = [UIColor clearColor];
    [self.LeaveMessage addSubview:textView];
    self.textView = textView;
    
}

/**
 * @brief 选择优惠活动
 */
- (IBAction)ChooseCouperActivityBtnClickAction:(UIButton *)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(ChooseABusinessDiscountButtonClickAction:)]) {

        [self.delegate ChooseABusinessDiscountButtonClickAction:sender];
    }
}

/**
 * @brief 设置数据
 */
- (void)setDiction:(NSDictionary *)diction{
    
    _diction = diction;
    
    NSString *IsYunFei = [NSString stringWithFormat:@"%@",diction[@"storeFreightAmount"]];
    
    // 商品的运费
    self.YunFei_Label.text = [NSString stringWithFormat:@"¥%.2f",IsYunFei.floatValue];
}

/**
 * @brief 计算商品的金额
 */
- (void)setShopCarModel:(HSQShopCarVCGoodsDataModel *)ShopCarModel{
    
    _ShopCarModel = ShopCarModel;
    
    // 运费
     NSString *IsYunFei = [NSString stringWithFormat:@"%@",self.diction[@"storeFreightAmount"]];
    
    // 商品的总价
    NSString *total_monery = [NSString stringWithFormat:@"%.2f",ShopCarModel.buyItemAmount.floatValue + IsYunFei.floatValue];

    NSString *GoodsMonery = [NSString stringWithFormat:@"小计  ¥%@ (含运费)",total_monery];
    
    NSRange range = NSMakeRange(4, total_monery.length+1);
    
    NSMutableAttributedString *attribe_string = [NSString attributedStringWithString:GoodsMonery font:[UIFont systemFontOfSize:16.0] color:RGB(258, 58, 68) ColorRange:range FontRang:range];
    
    self.TotalMonery_Label.attributedText = attribe_string;
}









/**
 * @brief 选择发票
 */
- (IBAction)ChooseFaPiaoInfonBtnClickAction:(UIButton *)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(SelectInvoiceInformationBtnClickAction:)]) {
        
        [self.delegate SelectInvoiceInformationBtnClickAction:sender];
    }
}










@end
