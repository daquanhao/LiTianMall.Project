//
//  HSQPointGoodsDetailNameCell.m
//  LiTianDecoration
//
//  Created by administrator on 2018/6/21.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import "HSQPointGoodsDetailNameCell.h"

@interface HSQPointGoodsDetailNameCell ()

@property (weak, nonatomic) IBOutlet UILabel *GoodsName_Label; // 名字

@property (weak, nonatomic) IBOutlet UILabel *jingle_Label; // 卖点

@property (weak, nonatomic) IBOutlet UILabel *expendPoints_Label;

@property (weak, nonatomic) IBOutlet UILabel *appPrice0_Label;

@property (weak, nonatomic) IBOutlet UILabel *gradeLevel_Label; // 会员等级

@end

@implementation HSQPointGoodsDetailNameCell

/**
 * @brief 商品信息
 */
- (void)setPointsGoodsDetailVo:(NSDictionary *)pointsGoodsDetailVo{
    
    _pointsGoodsDetailVo = pointsGoodsDetailVo;
    
    // 名字
    self.GoodsName_Label.text = [NSString stringWithFormat:@"%@",pointsGoodsDetailVo[@"goodsName"]];
    
    // 卖点
    self.jingle_Label.text = [NSString stringWithFormat:@"%@",pointsGoodsDetailVo[@"jingle"]];
    
    // 商品的兑换积分
    NSString *expendPoints = [NSString stringWithFormat:@"%@",pointsGoodsDetailVo[@"expendPoints"]];
    
    NSString *expendPointsString = [NSString stringWithFormat:@"需%@积分",expendPoints];
    
    NSMutableAttributedString *attribe = [[NSMutableAttributedString alloc] initWithString:expendPointsString];
    
    [attribe addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14.0] range:NSMakeRange(1, expendPoints.length)];
    
    self.expendPoints_Label.attributedText = attribe;
    
    // 商品的价格
    self.appPrice0_Label.text = [NSString stringWithFormat:@"%.2f",[pointsGoodsDetailVo[@"appPrice0"] floatValue]];
    
    // 所需的等级
    self.gradeLevel_Label.text = [NSString stringWithFormat:@"会员等级\n%@及以上专用",pointsGoodsDetailVo[@"limitMemberGradeName"]];
}

/**
 * @brief 选择商品的规格
 */
- (IBAction)ChooseGoodsGuiGeBtnClickAction:(UIButton *)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(ChooseTheSpecificationsOfTheGoods:)]) {
        
        [self.delegate ChooseTheSpecificationsOfTheGoods:sender];
    }
}













- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

@end
