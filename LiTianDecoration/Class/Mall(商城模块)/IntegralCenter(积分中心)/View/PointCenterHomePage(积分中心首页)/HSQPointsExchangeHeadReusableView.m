//
//  HSQPointsExchangeHeadReusableView.m
//  LiTianDecoration
//
//  Created by administrator on 2018/6/21.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import "HSQPointsExchangeHeadReusableView.h"

@interface HSQPointsExchangeHeadReusableView ()

@property (weak, nonatomic) IBOutlet UILabel *Point_Label; // 用户的积分

@property (weak, nonatomic) IBOutlet UILabel *Experience_Label; // 用户的经验值

@property (weak, nonatomic) IBOutlet UIImageView *Icon_ImageView; // 用户的头像

@property (weak, nonatomic) IBOutlet UIButton *Login_Button; // 登录按钮

@property (weak, nonatomic) IBOutlet UILabel *NickName_Label; // 昵称

@property (weak, nonatomic) IBOutlet UILabel *Level_Label; // 等级

@end

@implementation HSQPointsExchangeHeadReusableView

/**
 * @brief 用户信息
 */
- (void)setUserInfoDiction:(NSDictionary *)UserInfoDiction{
    
    _UserInfoDiction = UserInfoDiction;
    
    self.Login_Button.hidden = YES;
        
    // 昵称
    self.NickName_Label.text = [NSString stringWithFormat:@"%@",UserInfoDiction[@"memberInfo"][@"memberName"]];
    
    // 头像
    NSString *imageUrl = [NSString stringWithFormat:@"%@",UserInfoDiction[@"memberInfo"][@"avatarUrl"]];
    [self.Icon_ImageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:KIconPlacherImage];
    
    // 会员的等级
    self.Level_Label.text = [NSString stringWithFormat:@" %@等级",UserInfoDiction[@"memberInfo"][@"currGrade"][@"gradeName"]];
    
    // 经验值
    self.Experience_Label.text = [NSString stringWithFormat:@"%@ 经验值",UserInfoDiction[@"memberInfo"][@"experiencePoints"]];
    
    // 会员积分
    self.Point_Label.text = [NSString stringWithFormat:@"%@ 积分",UserInfoDiction[@"memberInfo"][@"memberPoints"]];
}



/**
 * @brief 登录按钮的点击
 */
- (IBAction)LoginButtonClickAction:(UIButton *)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(HeaderLoginButtonClickEvent:)]) {
        
        [self.delegate HeaderLoginButtonClickEvent:sender];
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

@end
