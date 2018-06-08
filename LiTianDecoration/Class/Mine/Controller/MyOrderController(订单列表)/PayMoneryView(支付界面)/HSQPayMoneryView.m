//
//  HSQPayMoneryView.m
//  LiTianDecoration
//
//  Created by administrator on 2018/5/10.
//  Copyright © 2018年 administrator. All rights reserved.
//

#define KPlacherLabelHeight 50

#define KViewHeight KScreenHeight - KSafeBottomHeight

#import "HSQPayMoneryView.h"
#import "HSQPayMoneryTypeListCell.h"
#import "HSQPayTypeListModel.h"

@interface HSQPayMoneryView ()<UITableViewDelegate,UITableViewDataSource,HSQPayMoneryTypeListCellDelegate,UITextFieldDelegate>

@property (nonatomic, strong) UIView *BgView;

@property (nonatomic, strong) UIView *TopView;

@property (nonatomic, strong) UILabel *placher_Label;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UIButton *QRPayMonery_Btn;

@property (nonatomic, strong) HSQPayTypeListModel *model;

@property (nonatomic, copy) NSString *IsOn;  // 预存款是否选用

@property (nonatomic, copy) NSString *PayMoneryPassWord;  // 预存款支付时的密码

@end

@implementation HSQPayMoneryView

/**
 * @brief 初始化视图
 */
+ (instancetype)initPayMoneryView{
    
    HSQPayMoneryView *publicView = [[HSQPayMoneryView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KViewHeight- KSafeBottomHeight)];
    
    publicView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
    
    [[[UIApplication sharedApplication] keyWindow] addSubview:publicView];
    
    return publicView;
}

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        // 1.创建控件
        [self SetUpViews];
        
        // 1.监听键盘的弹出或者消失
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(WillChange:) name:UIKeyboardWillShowNotification object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(WillDismissChange:) name:UIKeyboardWillHideNotification object:nil];
        
        [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
        
    }
    
    return self;
}


// 1.创建控件
- (void)SetUpViews{
    
    // 最底部的点击按钮
    UIButton *Bottombtn = [UIButton buttonWithType:(UIButtonTypeSystem)];
    Bottombtn.frame = self.bounds;
    Bottombtn.backgroundColor = [UIColor clearColor];
    [Bottombtn addTarget:self action:@selector(btnClickAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:Bottombtn];

    // 1.屏幕一半的背景图
    UIView *BgView = [[UIView alloc] initWithFrame:CGRectMake(0, KScreenHeight, KScreenWidth,(KViewHeight)/2)];
    BgView.backgroundColor = [UIColor whiteColor];
    [self addSubview:BgView];
    self.BgView = BgView;

    // 2.头部的提示标题
    UILabel *placher_Label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KPlacherLabelHeight)];
    placher_Label.textColor = [UIColor grayColor];
    placher_Label.backgroundColor = [UIColor clearColor];
    placher_Label.font = [UIFont systemFontOfSize:14.0];
    placher_Label.textAlignment = NSTextAlignmentCenter;
    [BgView addSubview:placher_Label];
    self.placher_Label = placher_Label;

    // 3.右边的退出按钮
    UIButton *right_button = [UIButton buttonWithType:(UIButtonTypeCustom)];
    right_button.frame = CGRectMake(KScreenWidth - KPlacherLabelHeight, 0, KPlacherLabelHeight, KPlacherLabelHeight);
    [right_button setImage:KImageName(@"TuiChuButton") forState:(UIControlStateNormal)];
    [right_button addTarget:self action:@selector(dismissAdressView) forControlEvents:(UIControlEventTouchUpInside)];
    [BgView addSubview:right_button];

    // 6.添加tableView
    UITableView * tabbleView = [[UITableView alloc]initWithFrame:CGRectMake(0, KPlacherLabelHeight, KScreenWidth, BgView.mj_h - KPlacherLabelHeight - 65)];
    tabbleView.backgroundColor = KViewBackGroupColor;
    tabbleView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tabbleView.delegate = self;
    tabbleView.dataSource = self;
    [tabbleView registerNib:[UINib nibWithNibName:@"HSQPayMoneryTypeListCell" bundle:nil] forCellReuseIdentifier:@"HSQPayMoneryTypeListCell"];
    [BgView addSubview:tabbleView];
    self.tableView = tabbleView;

    // 确认支付
    UIButton *QRPayMonery_Btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    QRPayMonery_Btn.frame = CGRectMake(20, CGRectGetMaxY(tabbleView.frame)+10, KScreenWidth - 40, 45);
    [QRPayMonery_Btn setBackgroundImage:KImageName(@"LoginButton_Image") forState:(UIControlStateNormal)];
    [QRPayMonery_Btn setTitle:@"确认支付" forState:(UIControlStateNormal)];
    [QRPayMonery_Btn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    QRPayMonery_Btn.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [QRPayMonery_Btn addTarget:self action:@selector(QRPayMonery_BtnClickAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [BgView addSubview:QRPayMonery_Btn];
    self.QRPayMonery_Btn = QRPayMonery_Btn;
    
    // 预存款是否选用
    self.IsOn = @"0";
    
}

#pragma mark - TableViewDatasouce

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.model.paymentList.count + 1;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return (self.IsOn.integerValue == 0 ? 41 : 84);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return (self.IsOn.integerValue == 0 ? 41 : 84);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    HSQPayMoneryTypeListCell * cell = [tableView dequeueReusableCellWithIdentifier:@"HSQPayMoneryTypeListCell" forIndexPath:indexPath];
    
    cell.delegate = self;
    
    // 预存款的可用额度
    cell.MineYuE_Label.text = [NSString stringWithFormat:@"预存款：¥%.2f",self.model.predepositAmount.floatValue];
    
    // 密码背景框
    cell.PassWordBgView.hidden = (self.IsOn.integerValue == 0 ? YES : NO);
    
    // 密码输入框
    cell.PassWord_TextField.delegate = self;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

/**
 * @brief 接收上一个界面的数据
 */
- (void)setDatas:(NSDictionary *)datas{
    
    _datas = datas;
    
    HSQPayTypeListModel *model = [[HSQPayTypeListModel alloc] init];
    [model setValuesForKeysWithDictionary:datas];
    self.model = model;
    
    // 订单的支付金额
    NSString *OrderPrice = [NSString stringWithFormat:@"%.2f",model.payAmount.floatValue];
    NSString *monery = [NSString stringWithFormat:@"本次交易需在线支付%@元",OrderPrice];
    NSMutableAttributedString *attribe = [[NSMutableAttributedString alloc] initWithString:monery];
    [attribe addAttribute:NSForegroundColorAttributeName value:RGB(238, 58, 68) range:NSMakeRange(9, OrderPrice.length)];
    [attribe addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16.0] range:NSMakeRange(9, OrderPrice.length)];
    self.placher_Label.attributedText = attribe;
    
    [self.tableView reloadData];
}

/**
 * @brief 选择支付方式的点击事件
 */
- (void)SelectThePaymentMethodButtonClickEvent:(UISwitch *)sender{
    
    if (sender.isOn == YES)
    {
        self.IsOn = @"1";
    }
    else
    {
        self.IsOn = @"0";
    }

    [self.tableView reloadData];
}

/**
 * @brief  确认支付的按钮点击
 */
- (void)QRPayMonery_BtnClickAction:(UIButton *)sender{
    
    if (self.IsOn.integerValue == 0)
    {
        [[HSQProgressHUDManger Manger] ShowDisplayFailedToLoadData:@"请选择支付方式" SuperView:[UIApplication sharedApplication].keyWindow];
    }
    else if (self.PayMoneryPassWord.length == 0)
    {
        [[HSQProgressHUDManger Manger] ShowDisplayFailedToLoadData:@"请输入支付密码" SuperView:[UIApplication sharedApplication].keyWindow];
    }
    else
    {
        [self dismissAdressView];
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(ConfirmTheClickEventOfThePayButton:PassWord:)]) {
            
            [self.delegate ConfirmTheClickEventOfThePayButton:sender PassWord:self.PayMoneryPassWord];
        }
    }
}

/**
 * @brief 输入框编辑结束的时候
 */
- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    self.PayMoneryPassWord = [NSString stringWithFormat:@"%@",textField.text];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    
    return YES;
}

/**
 * @brief 点击背景按钮的点击事件
 */
- (void)btnClickAction:(UIButton *)sender{
    
    [self dismissAdressView];
}

/**
 * @brief 显示视图
 */
- (void)ShowPayMoneryView{
    
    [UIView animateWithDuration:0.25 animations:^{
        
        self.BgView.frame = ({

            CGRect frame = self.BgView.frame;

            frame.origin.y = (KViewHeight) /2;

            frame;
        });
    }];
}

/**
 * @brief 隐藏视图
 */
- (void)dismissAdressView{
    
    [UIView animateWithDuration:0.25 animations:^{

        self.BgView.frame = ({

            CGRect frame = self.BgView.frame;

            frame.origin.y = KScreenHeight;

            frame;
        });
    }completion:^(BOOL finished) {

        [self.BgView removeFromSuperview];

        [self removeFromSuperview];
    }];
}

- (void)WillChange:(NSNotification *)notif{
    
    NSDictionary *keyboardInfo = notif.userInfo;
    
    CGRect keyboardFrame = [keyboardInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    CGFloat animationDuration = [keyboardInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    [UIView animateWithDuration:animationDuration animations:^{
        
        self.BgView.frame = ({
            
            CGRect frame = self.BgView.frame;
            
            frame.origin.y = KScreenHeight - KSafeBottomHeight - keyboardFrame.size.height - 140;
            
            frame;
        });
        
    }];
    
    
}

- (void)WillDismissChange:(NSNotification *)notif{
    
    NSDictionary *keyboardInfo = notif.userInfo;
    
    CGFloat animationDuration = [keyboardInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    [UIView animateWithDuration:animationDuration animations:^{
        
        self.BgView.frame = ({
            
            CGRect frame = self.BgView.frame;
            
            frame.origin.y = (KViewHeight)/2;
            
            frame;
        });
        
    }];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    [scrollView setContentOffset:CGPointMake(0, 0) animated:NO];
}

-(void)dealloc{
    
    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
}


@end
