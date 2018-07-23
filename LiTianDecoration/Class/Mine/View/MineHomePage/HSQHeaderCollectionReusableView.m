//
//  HSQHeaderCollectionReusableView.m
//  LiTianDecoration
//
//  Created by administrator on 2018/4/10.
//  Copyright © 2018年 administrator. All rights reserved.
//

#define KMargin 5

#import "HSQHeaderCollectionReusableView.h"
#import "HSQCustomViewWithButton.h"
#import "HSQAccountTool.h"

@interface HSQHeaderCollectionReusableView ()<HSQCustomViewWithButtonDelegate>

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
            self.AccountMangerLabel.text = @"账户管理>";
            
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
    
    NSMutableArray *dataSource = [NSMutableArray arrayWithObjects:@{@"title":@"待付款",@"icon":@"123"},@{@"title":@"待收/取货",@"icon":@"123"},@{@"title":@"待评价",@"icon":@"123"},@{@"title":@"退换/售后",@"icon":@"123"},@{@"title":@"我的订单",@"icon":@"123"}, nil];
    HSQCustomViewWithButton *BtnView = [[HSQCustomViewWithButton alloc] initWithFrame:CGRectMake(0, KPersonHeight, KScreenWidth, 60)];
    BtnView.dataSource = dataSource;
    BtnView.delegate = self;
    [self addSubview:BtnView];
    
    NSMutableArray *dataSource02 = [NSMutableArray arrayWithObjects:@{@"title":@"预存款",@"icon":@"123"},@{@"title":@"优惠券",@"icon":@"123"},@{@"title":@"红包",@"icon":@"123"},@{@"title":@"积分",@"icon":@"123"},@{@"title":@"我的财产",@"icon":@"123"}, nil];
    HSQCustomViewWithButton *BtnView02 = [[HSQCustomViewWithButton alloc] initWithFrame:CGRectMake(0, KPersonHeight + KBtnViewH + KMargin, KScreenWidth, KBtnViewH)];
    BtnView02.dataSource = dataSource02;
    BtnView02.delegate = self;
    [self addSubview:BtnView02];
    
    NSMutableArray *dataSource03 = [NSMutableArray arrayWithObjects:@{@"title":@"我的收藏",@"icon":@"123"},@{@"title":@"预约到店",@"icon":@"123"},@{@"title":@"浏览足迹",@"icon":@"123"},@{@"title":@"商品咨询",@"icon":@"123"}, nil];
    HSQCustomViewWithButton *BtnView03 = [[HSQCustomViewWithButton alloc] initWithFrame:CGRectMake(0, KPersonHeight + KMargin + KBtnViewH + KMargin + KBtnViewH, KScreenWidth, KBtnViewH)];
    BtnView03.dataSource = dataSource03;
    BtnView03.delegate = self;
    [self addSubview:BtnView03];
    
//    NSMutableArray *dataSource04 = [NSMutableArray arrayWithObjects:@{@"title":@"积分兑换",@"icon":@"123"},@{@"title":@"试用",@"icon":@"123"},@{@"title":@"晒宝",@"icon":@"123"},@{@"title":@"推广分佣",@"icon":@"123"}, nil];
//    HSQCustomViewWithButton *BtnView04 = [[HSQCustomViewWithButton alloc] initWithFrame:CGRectMake(0, KPersonHeight + KMargin + KBtnViewH + KMargin + KBtnViewH+3+KBtnViewH, KScreenWidth, KBtnViewH)];
//    BtnView04.dataSource = dataSource04;
//    [self addSubview:BtnView04];
    
    NSMutableArray *dataSource05 = [NSMutableArray arrayWithObjects:@{@"title":@"收货地址",@"icon":@"123"},@{@"title":@"个人信息",@"icon":@"123"},@{@"title":@"登录绑定",@"icon":@"123"},@{@"title":@"消息接收",@"icon":@"123"},@{@"title":@"设置",@"icon":@"123"}, nil];
    HSQCustomViewWithButton *BtnView05 = [[HSQCustomViewWithButton alloc] initWithFrame:CGRectMake(0, KPersonHeight + KMargin  + KBtnViewH + KMargin + KBtnViewH + KMargin + KBtnViewH + 3, KScreenWidth, KBtnViewH)];
    BtnView05.dataSource = dataSource05;
    BtnView05.delegate = self;
    [self addSubview:BtnView05];
    
    UIButton *Like_Btn = [UIButton buttonWithType:(UIButtonTypeSystem)];
    
    Like_Btn.backgroundColor = [UIColor clearColor];
    
    [Like_Btn setTitle:@"猜  你  喜  欢" forState:(UIControlStateNormal)];
    
    [Like_Btn setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    
    Like_Btn.frame = CGRectMake(0, CGRectGetMaxY(BtnView05.frame), KScreenWidth, KBtnViewH);
    
    [self addSubview:Like_Btn];
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

#pragma mark - HSQCustomViewWithButtonDelegate
- (void)CustomViewWithButtonClickAction:(UIButton *)sender{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(UnderLogineCustomeButtonClickAction:)]) {
        
        [self.delegate UnderLogineCustomeButtonClickAction:sender];
    }
    
}


@end
