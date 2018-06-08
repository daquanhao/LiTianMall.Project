//
//  HSQAvailableToPayTypeView.m
//  LiTianDecoration
//
//  Created by administrator on 2018/6/6.
//  Copyright © 2018年 administrator. All rights reserved.
//

#define KViewHeight KScreenHeight - KSafeBottomHeight

#import "HSQAvailableToPayTypeView.h"
#import "HSQPayMoneryTypeListCell.h"
#import "HSQPayTypeListModel.h"

@interface HSQAvailableToPayTypeView ()<UITableViewDelegate,UITableViewDataSource,HSQPayMoneryTypeListCellDelegate,UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIButton *PayLater_Button; // 稍后支付

@property (weak, nonatomic) IBOutlet UILabel *TotalMonery_Label; // 支付的总金额

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, copy) NSString *IsOn;  // 预存款是否选用

@property (nonatomic, copy) NSString *PayMoneryPassWord;  // 预存款支付时的密码

@property (weak, nonatomic) IBOutlet UIView *BgView;

@property (nonatomic, strong) HSQPayTypeListModel *model;

@end

@implementation HSQAvailableToPayTypeView

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    
    if (self = [super initWithCoder:aDecoder]) {

        
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
    }
    
    return self;
}

- (void)awakeFromNib{
    
    [super awakeFromNib];
    
    // 添加边框
    self.PayLater_Button.layer.borderWidth = 1;
    self.PayLater_Button.layer.borderColor = RGB(74, 74, 74).CGColor;
    
    // 设置边角
    self.PayLater_Button.layer.cornerRadius = 5;
    self.PayLater_Button.clipsToBounds = YES;

    // 6.添加tableView
    UITableView * tabbleView = [[UITableView alloc]initWithFrame:CGRectMake(0, 40, KScreenWidth, 90)];
    tabbleView.backgroundColor = KViewBackGroupColor;
    tabbleView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tabbleView.delegate = self;
    tabbleView.dataSource = self;
    [tabbleView registerNib:[UINib nibWithNibName:@"HSQPayMoneryTypeListCell" bundle:nil] forCellReuseIdentifier:@"HSQPayMoneryTypeListCell"];
    [self.BgView addSubview:tabbleView];
    self.tableView = tabbleView;
    
    // 预存款是否选用
    self.IsOn = @"0";
    
    // 1.监听键盘的弹出或者消失
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(WillChange:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(WillDismissChange:) name:UIKeyboardWillHideNotification object:nil];
    
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
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
    
    self.TotalMonery_Label.attributedText = attribe;
    
    [self.tableView reloadData];
}

/**
 * @brief 稍后支付的点击事件
 */
- (IBAction)ShaoHouPayMoneryBtnClickAction:(UIButton *)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(TheClickEventOfThePayButtonLater:)]) {
        
        [self.delegate TheClickEventOfThePayButtonLater:sender];
    }
}

/**
 * @brief 确认支付的点击事件
 */
- (IBAction)QueRenPayMoneryButtonClickAction:(UIButton *)sender {
    
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
        if (self.delegate && [self.delegate respondsToSelector:@selector(ConfirmTheClickEventOfThePaymentButton: PassWord:)]) {
            
            [self.delegate ConfirmTheClickEventOfThePaymentButton:sender PassWord:self.PayMoneryPassWord];
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
