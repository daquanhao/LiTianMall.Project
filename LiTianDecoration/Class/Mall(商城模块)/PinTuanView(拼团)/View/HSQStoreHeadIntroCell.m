//
//  HSQStoreHeadIntroCell.m
//  LiTianDecoration
//
//  Created by administrator on 2018/5/10.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import "HSQStoreHeadIntroCell.h"

@interface HSQStoreHeadIntroCell ()

@property (weak, nonatomic) IBOutlet UIImageView *StroeImageView;

@property (weak, nonatomic) IBOutlet UILabel *StroeName_Label;

@property (weak, nonatomic) IBOutlet UILabel *GoodScore_Label; // 商品的评分

@property (weak, nonatomic) IBOutlet UILabel *ServerScore_Label; // 服务的评分

@property (weak, nonatomic) IBOutlet UILabel *FaHuoScore_Label; // 发货的评分

@property (weak, nonatomic) IBOutlet UILabel *CollectionPersonCount; // 收藏的人数

@property (weak, nonatomic) IBOutlet UILabel *GoodCountLabel; // 全部的商品

@property (weak, nonatomic) IBOutlet UILabel *StroeScoreLabel; // 店铺的评分

@property (weak, nonatomic) IBOutlet UIButton *LeftButton; // 联系商家

@property (weak, nonatomic) IBOutlet UIButton *Right_Button; // 进入店铺

@end

@implementation HSQStoreHeadIntroCell

/**
 * @brief 数据赋值
 */
- (void)setDataDiction:(NSDictionary *)DataDiction{
    
    _DataDiction = DataDiction;
    
    // 店铺的头像
    NSString *IconUrl = [NSString stringWithFormat:@"%@",DataDiction[@"storeInfo"][@"storeAvatarUrl"]];
    [self.StroeImageView sd_setImageWithURL:[NSURL URLWithString:IconUrl] placeholderImage:KGoodsPlacherImage];
    
    // 店铺的名字
    self.StroeName_Label.text = [NSString stringWithFormat:@"%@",DataDiction[@"storeInfo"][@"storeName"]];
    
    // 商品的分数
    NSString *GoodsFenShu =  [self RuturnRateStateWithFenShu:@"desEvalArrow" diction:DataDiction];
    NSString *GoodsScroe = [NSString stringWithFormat:@"商品 %@ | %@",DataDiction[@"evaluateStoreVo"][@"storeDesEval"],GoodsFenShu];
    self.GoodScore_Label.attributedText = [NSString attributedStringWithString:GoodsScroe Color:RGB(150, 150, 150) range:NSMakeRange(0, 2)];
    
    // 服务的分数
    NSString *ServerFenShu =  [self RuturnRateStateWithFenShu:@"serviceEvalArrow" diction:DataDiction];
    NSString *ServerScore = [NSString stringWithFormat:@"服务 %@ | %@",DataDiction[@"evaluateStoreVo"][@"storeServiceEval"],ServerFenShu];
    self.ServerScore_Label.attributedText = [NSString attributedStringWithString:ServerScore Color:RGB(150, 150, 150) range:NSMakeRange(0, 2)];
    
    // 发货的分数
    NSString *FaHuoFenShu =  [self RuturnRateStateWithFenShu:@"deliveryEvalArrow" diction:DataDiction];
    NSString *FaHuo = [NSString stringWithFormat:@"发货 %@ | %@",DataDiction[@"evaluateStoreVo"][@"storeServiceEval"],FaHuoFenShu];
    self.FaHuoScore_Label.attributedText = [NSString attributedStringWithString:FaHuo Color:RGB(150, 150, 150) range:NSMakeRange(0, 2)];
    
    // 收藏人数
    self.CollectionPersonCount.text = [NSString stringWithFormat:@"%@\n收藏人数",DataDiction[@"storeInfo"][@"storeCollect"]];
    
    // 商品的个数
    self.GoodCountLabel.text = [NSString stringWithFormat:@"%@\n全部商品",DataDiction[@"goodsCommonCount"]];
    
    // 店铺的评分
    self.StroeScoreLabel.text = [NSString stringWithFormat:@"%@\n店铺评分",DataDiction[@"evaluateStoreVo"][@"avgStoreEval"]];
    

}

/**
 * @brief 分数的高低
 */
- (NSString *)RuturnRateStateWithFenShu:(NSString *)String diction:(NSDictionary *)dict{
    
    NSString *GoodsFenShu =  [NSString stringWithFormat:@"%@",dict[@"evaluateStoreVo"][String]];
    
    if ([GoodsFenShu isEqualToString:@""])
    {
        return @"低";
    }
    else if ([GoodsFenShu isEqualToString:@""])
    {
        return @"平";
    }
    else
    {
        return @"高";
    }
}

/**
 * @brief 联系商家
 */
- (IBAction)LianXiShangJiaButton:(UIButton *)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(ContactTheMerchantButtonClickAction:)]) {
        
        [self.delegate ContactTheMerchantButtonClickAction:sender];
    }
}

/**
 * @brief 进入店铺
 */
- (IBAction)JinRuDianPuButtonClickAction:(UIButton *)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(EnterTheStoreButtonClickAction:)]) {
        
        [self.delegate EnterTheStoreButtonClickAction:sender];
    }
}



- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    [self.LeftButton setBackgroundImage:[UIImage ReturnAPictureOfStretching:@"7D99DFED-F3B6-4DB1-9F77-E24CA867DD17"] forState:(UIControlStateNormal)];
    
    [self.Right_Button setBackgroundImage:[UIImage ReturnAPictureOfStretching:@"7D99DFED-F3B6-4DB1-9F77-E24CA867DD17"] forState:(UIControlStateNormal)];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}




@end
