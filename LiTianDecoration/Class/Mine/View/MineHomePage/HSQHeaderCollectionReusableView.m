//
//  HSQHeaderCollectionReusableView.m
//  LiTianDecoration
//
//  Created by administrator on 2018/4/10.
//  Copyright © 2018年 administrator. All rights reserved.
//

#define KMargin 5

#import "HSQHeaderCollectionReusableView.h"
#import "HSQAccountTool.h"

@interface HSQHeaderCollectionReusableView ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *Head_Height;

@property (weak, nonatomic) IBOutlet UIButton *Login_Button;

@property (weak, nonatomic) IBOutlet UILabel *NickName_Label;

@property (weak, nonatomic) IBOutlet UILabel *GradeLevel_Label;  // 会员等级

@property (weak, nonatomic) IBOutlet UIButton *AccountManger_Button;

@property (weak, nonatomic) IBOutlet UIImageView *IconImageView;

@property (weak, nonatomic) IBOutlet UILabel *AccountMangerLabel; // 账户管理

@property (weak, nonatomic) IBOutlet UILabel *PlacherLabel; // 未登录状态的提示语

@property (weak, nonatomic) IBOutlet UIButton *LoginStateButton;

@end

@implementation HSQHeaderCollectionReusableView

-(void)setUserInfoDiction:(NSMutableDictionary *)UserInfoDiction{
    
    _UserInfoDiction = UserInfoDiction;
    
    NSString *token = [HSQAccountTool account].token;
    
    if (token.length == 0)
    {
         [self SetUpNoLoginView];
    }
    else
    {
        if (UserInfoDiction.allKeys.count != 0)
        {
            // 昵称
            self.NickName_Label.text = [NSString stringWithFormat:@"%@",UserInfoDiction[@"memberInfo"][@"memberName"]];
            
            // 头像
            NSString *imageUrl = [NSString stringWithFormat:@"%@",UserInfoDiction[@"memberInfo"][@"avatarUrl"]];
            [self.IconImageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:KIconPlacherImage];
            
            // 会员的等级
            self.GradeLevel_Label.text = [NSString stringWithFormat:@" %@会员  ",UserInfoDiction[@"memberInfo"][@"currGrade"][@"gradeName"]];
            
            // 账户管理
            self.AccountMangerLabel.text = @"账户管理 >";
            
            [self.PlacherLabel setHidden:YES];
            
            [self.LoginStateButton setHidden:YES];
            
            [self.NickName_Label setHidden:NO];
            
            [self.GradeLevel_Label setHidden:NO];
            
            [self.AccountMangerLabel setHidden:NO];
        }
        else
        {
            [self SetUpNoLoginView];
        }
    }
}

- (void)SetUpNoLoginView{
    
    [self.PlacherLabel setHidden:NO];
    
    self.PlacherLabel.text = @"登录 / 注册";
    
    [self.LoginStateButton setHidden:NO];
    
    [self.NickName_Label setHidden:YES];
    
    [self.GradeLevel_Label setHidden:YES];
    
    [self.AccountMangerLabel setHidden:YES];
    
    self.IconImageView.image = KIconPlacherImage;
}

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    self.Head_Height.constant = KPersonHeight;
}

- (IBAction)HeaderLoginBtnClickAction:(UIButton *)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(LoginActionClickWithMineHomeHead:)]) {
        
        [self.delegate LoginActionClickWithMineHomeHead:sender];
    }
}

- (IBAction)ZhunBeiLoginButton:(UIButton *)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(ToPrepareLoginAction:)]) {
        
        [self.delegate ToPrepareLoginAction:sender];
    }
}


@end
