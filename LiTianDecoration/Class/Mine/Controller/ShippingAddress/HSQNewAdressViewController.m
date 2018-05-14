//
//  HSQNewAdressViewController.m
//  LiTianDecoration
//
//  Created by administrator on 2018/4/25.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import "HSQNewAdressViewController.h"
#import "HSQPublicAdressView.h"
#import "HSQAccountTool.h"
#import "HSQAcceptAddressListModel.h"

@interface HSQNewAdressViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *Name_TextField;

@property (weak, nonatomic) IBOutlet UITextField *Mobile_TextField;

@property (weak, nonatomic) IBOutlet UITextField *Area_TextField;

@property (weak, nonatomic) IBOutlet UITextField *DetailAdress_TextField;

@property (weak, nonatomic) IBOutlet UISwitch *Defaul_Switch;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ButtonBottomLayout;

@property (nonatomic, copy) NSString *isDefault;

@property (nonatomic, copy) NSString *ProvinceId;   // 省级ID

@property (nonatomic, copy) NSString *cityId;   // 市级ID

@property (nonatomic, copy) NSString *AreaId;   // 县级ID

@property (nonatomic, copy) NSString *addressId;  // 地址的id

@end

@implementation HSQNewAdressViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.view.backgroundColor = KViewBackGroupColor;
    
    self.navigationItem.title = @"新增收货地址";
    
    self.ButtonBottomLayout.constant = 20 + KSafeBottomHeight;
    
    self.isDefault = @"0";
    
    // 1.控件赋值
    [self SetValueToViews];

}

- (void)SetValueToViews{
    
    self.Name_TextField.text = self.model.realName;
    
    self.Mobile_TextField.text = self.model.mobPhone;
    
    self.Area_TextField.text = self.model.areaInfo;
    
    self.DetailAdress_TextField.text = self.model.address;
    
    if (self.model.isDefault.integerValue == 0) // 不是默认
    {
        [self.Defaul_Switch setOn:NO];
    }
    else
    {
        [self.Defaul_Switch setOn:YES];
    }
    
    self.ProvinceId = self.model.areaId1;
    
    self.cityId = self.model.areaId2;
    
    self.AreaId = self.model.areaId;
    
    self.addressId = self.model.addressId;
}

- (void)setModel:(HSQAcceptAddressListModel *)model{
    
    _model = model;
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 * @brief 选择地区
 */
- (IBAction)ChooseAdressAreaClickAction:(UIButton *)sender {
    
    [self.view endEditing:YES];
    
    HSQPublicAdressView *adressView = [HSQPublicAdressView initAdressView];
    
    adressView.placherString = @"配送至";
    
    [adressView ShowAdressView];
    
    adressView.chooseFinish = ^(NSString *adress,NSString *ProvinceId, NSString *cityId, NSString *AreaId){
        
        HSQLog(@"===%@==%@===%@==%@",adress,ProvinceId,cityId,AreaId);
        
        self.Area_TextField.text = adress;
        
        self.ProvinceId = ProvinceId;
        
        self.cityId = cityId;
        
        self.AreaId = AreaId;
        
    };
}


/**
 * @brief 是否设置成默认的地址
 */
- (IBAction)IsSetingDefaulClickAction:(UISwitch *)sender {
    
    if (sender.isOn)
    {
        self.isDefault = @"1";
    }
    else
    {
        self.isDefault = @"0";
    }
}


/**
 * @brief 保存地址按钮的点击事件
 */
- (IBAction)SaveAdressButtonClickAction:(UIButton *)sender {
    
    if (self.Name_TextField.text.length == 0)
    {
        [[HSQProgressHUDManger Manger] ShowProgressHUDPromptText:@"请输入收货人姓名" SupView:self.view];
    }
    else if (self.Mobile_TextField.text.length == 0)
    {
        [[HSQProgressHUDManger Manger] ShowProgressHUDPromptText:@"请输入联系人手机号码" SupView:self.view];
    }
    else if (self.Mobile_TextField.text.isPhone == NO)
    {
        [[HSQProgressHUDManger Manger] ShowProgressHUDPromptText:@"手机号格式不正确" SupView:self.view];
    }
    else if (self.Area_TextField.text.length == 0)
    {
        [[HSQProgressHUDManger Manger] ShowProgressHUDPromptText:@"请选择地区" SupView:self.view];
    }
    else if (self.DetailAdress_TextField.text.length == 0)
    {
        [[HSQProgressHUDManger Manger] ShowProgressHUDPromptText:@"请输入详细地址" SupView:self.view];
    }
    else
    {
        [self UploadTheAddressToTheServer];
    }
  
}

/**
 * @brief 将地址上传至服务器
 */
- (void)UploadTheAddressToTheServer{
    
    [[HSQProgressHUDManger Manger] ShowLoadingDataFromeServer:@"" ToView:self.view IsClearColor:NO];
    
    NSMutableDictionary *diction = [NSMutableDictionary dictionary];
    diction[@"token"]   = [HSQAccountTool account].token;
    diction[@"realName"] = self.Name_TextField.text;
    diction[@"areaInfo"] = self.Area_TextField.text;
    diction[@"address"] = self.DetailAdress_TextField.text;
    diction[@"mobPhone"] = self.Mobile_TextField.text;
    diction[@"isDefault"] = self.isDefault;
    diction[@"areaId1"] = self.ProvinceId;
    diction[@"areaId2"] = self.cityId;
    diction[@"areaId"] = self.AreaId;
    
    if (self.addressId.length != 0)
    {
        diction[@"addressId"] = self.addressId;
    }
    
    AFNetworkRequestTool *RequestTool = [AFNetworkRequestTool shareRequestTool];
    
    [RequestTool.manger POST:self.Adress_Url parameters:diction progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        HSQLog(@"===%@==%@",responseObject,diction);
        [[HSQProgressHUDManger Manger] DismissProgressHUD];
        
        if ([responseObject[@"code"] integerValue] == 200)
        {
            [[HSQProgressHUDManger Manger] ShowLoadDataSuccessWithPlaceholderString:@"添加成功" SuperView:self.view];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                if (self.addNewAdressSuccess)
                {
                    self.addNewAdressSuccess(@"success");
                }
                
                [self.navigationController popViewControllerAnimated:YES];
                
            });
        }
        else
        {
            NSString *errorString = [NSString stringWithFormat:@"%@",responseObject[@"datas"][@"error"]];
            
            [[HSQProgressHUDManger Manger] ShowDisplayFailedToLoadData:errorString SuperView:self.view];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [[HSQProgressHUDManger Manger] ShowProgressHUDPromptText:@"地址添加失败" SupView:self.view];
    }];
}


#pragma mark - UITextFieldDelegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if (textField == self.Name_TextField)
    {
        [self.Mobile_TextField becomeFirstResponder];
    }
    else if (textField == self.Mobile_TextField)
    {
        [self.DetailAdress_TextField becomeFirstResponder];
    }
    else if (textField == self.DetailAdress_TextField)
    {
        [self.DetailAdress_TextField resignFirstResponder];
    }
    
    return YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:YES];
}








@end
