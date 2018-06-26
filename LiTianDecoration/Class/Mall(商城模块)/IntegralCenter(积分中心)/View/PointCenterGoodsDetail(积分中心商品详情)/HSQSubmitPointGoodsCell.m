//
//  HSQSubmitPointGoodsCell.m
//  LiTianDecoration
//
//  Created by administrator on 2018/6/22.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import "HSQSubmitPointGoodsCell.h"

@interface HSQSubmitPointGoodsCell ()

@property (weak, nonatomic) IBOutlet UIImageView *GoodsImageView;

@property (weak, nonatomic) IBOutlet UILabel *GoodsName_Label;

@property (weak, nonatomic) IBOutlet UILabel *goodsFullSpecs_Label;

@property (weak, nonatomic) IBOutlet UILabel *totalPoints_Label;

@property (weak, nonatomic) IBOutlet UILabel *buyNum_Label;

@property (weak, nonatomic) IBOutlet UILabel *expendPoints_Label;

@property (weak, nonatomic) IBOutlet UIView *TextView_BgView;



@end

@implementation HSQSubmitPointGoodsCell

/**
 * @brief 数据
 */
- (void)setDiction:(NSDictionary *)diction{
    
    _diction = diction;
    
    // 商品的图片
    [self.GoodsImageView sd_setImageWithURL:[NSURL URLWithString:diction[@"imageSrc"]] placeholderImage:KGoodsPlacherImage];
    
    // 商品的名字
    self.GoodsName_Label.text = [NSString stringWithFormat:@"%@",diction[@"goodsName"]];
    
    // 商品的规格
    self.goodsFullSpecs_Label.text = [NSString stringWithFormat:@"%@",diction[@"goodsFullSpecs"]];
    
    // 商品的兑换的积分
    self.expendPoints_Label.text = [NSString stringWithFormat:@"%@积分",diction[@"expendPoints"]];
    
    // 商品的个数
    self.buyNum_Label.text = [NSString stringWithFormat:@"%@%@",diction[@"buyNum"],diction[@"unitName"]];
    
    // 商品的兑换的总积分
    NSString *totalPoints = [NSString stringWithFormat:@"合计：%@积分",diction[@"totalPoints"]];
    
    NSMutableAttributedString *attribe = [[NSMutableAttributedString alloc] initWithString:totalPoints];
    
    [attribe addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, 3)];
    
    self.totalPoints_Label.attributedText = attribe;
}

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    // 带有提示文字的输入框
    HSQCustomTextView *textView = [[HSQCustomTextView alloc] initWithFrame:CGRectMake(10, 5, self.TextView_BgView.mj_w - 20, self.TextView_BgView.mj_h - 10)];
    
    textView.placeholder = @"我要留言：";
    
    textView.placeholderColor = RGB(180, 180, 180);
    
    textView.backgroundColor = KViewBackGroupColor;
    
    textView.returnKeyType = UIReturnKeyDone;
    
    textView.backgroundColor = [UIColor clearColor];
    
    [self.TextView_BgView addSubview:textView];
    
    self.textView = textView;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
