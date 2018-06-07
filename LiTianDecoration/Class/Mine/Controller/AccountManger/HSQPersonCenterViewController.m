//
//  HSQPersonCenterViewController.m
//  LiTianDecoration
//
//  Created by administrator on 2018/4/18.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import "HSQPersonCenterViewController.h"
#import "HSQRealNameViewController.h"   // 修改用户的真实姓名
#import "HSQUserGenderView.h"   // 修改用户的性别
#import "HSQSelectDatePickerView.h"  // 修改出生日期
#import "HSQPublicAdressView.h"   // 修改所在地
#import "HSQAccountTool.h"

@interface HSQPersonCenterViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate,HSQUserGenderViewDelegate,HSQSelectDatePickerViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *IconImageView;

@property (weak, nonatomic) IBOutlet UILabel *NickNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *RealName_Label;

@property (weak, nonatomic) IBOutlet UILabel *Sex_Label;

@property (weak, nonatomic) IBOutlet UILabel *Date_Label;

@property (weak, nonatomic) IBOutlet UILabel *adress_Label;

@end

@implementation HSQPersonCenterViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.view.backgroundColor = KViewBackGroupColor;
    
    self.navigationItem.title = @"个人信息";
    
    // 1.请求会员详情的数据
    [self RequestPersonDetailDataFromeServer];
}

/**
 * @brief 请求会员详情的数据
 */
- (void)RequestPersonDetailDataFromeServer{
    
    [[HSQProgressHUDManger Manger] ShowLoadingDataFromeServer:@"" ToView:self.view IsClearColor:NO];
    
    NSDictionary *diction = @{@"token":[HSQAccountTool account].token};
    
    AFNetworkRequestTool *RequestTool = [AFNetworkRequestTool shareRequestTool];
    
    [RequestTool.manger POST:UrlAdress(KPersonDetailUrl) parameters:diction progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        HSQLog(@"=用户xiangqing的数据==%@",responseObject);
        
        [[HSQProgressHUDManger Manger] DismissProgressHUD];
        
        if ([responseObject[@"code"] integerValue] == 200)
        {
            // 1.用户的头像
            [self.IconImageView sd_setImageWithURL:[NSURL URLWithString:responseObject[@"datas"][@"memberInfo"][@"avatarUrl"]] placeholderImage:KIconPlacherImage];
            
            // 2.用户的名字
            self.NickNameLabel.text = [NSString stringWithFormat:@"%@",responseObject[@"datas"][@"memberInfo"][@"memberName"]];
            
            // 3.用户的真实姓名
            NSString *trueName = [NSString stringWithFormat:@"%@",responseObject[@"datas"][@"memberInfo"][@"trueName"]];
            self.RealName_Label.text = (trueName.length == 0) ? @"": trueName;
            
            // 4.用户的性别
            self.Sex_Label.text = [NSString stringWithFormat:@"%@",responseObject[@"datas"][@"memberInfo"][@"memberSexText"]];
            
            // 5.用户的出生日期
            NSString *birthday = [NSString stringWithFormat:@"%@",responseObject[@"datas"][@"memberInfo"][@"birthday"]];
            if (![responseObject[@"datas"][@"memberInfo"][@"birthday"] isEqual:[NSNull null]])
            {
                self.Date_Label.text = birthday;
            }
            
            // 6.用户的所在地
            NSString *addressAreaInfo = [NSString stringWithFormat:@"%@",responseObject[@"datas"][@"memberInfo"][@"addressAreaInfo"]];
            self.adress_Label.text = (addressAreaInfo.length == 0) ? @"" : addressAreaInfo;
        }
        else
        {
            NSString *errorString = [NSString stringWithFormat:@"%@",responseObject[@"datas"][@"error"]];

            [[HSQProgressHUDManger Manger] ShowDisplayFailedToLoadData:errorString SuperView:self.view];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        HSQLog(@"==%@",error.description);
        
        [[HSQProgressHUDManger Manger] ShowDisplayFailedToLoadData:@"会员中心数据加载失败" SuperView:self.view];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)ClickActionWithButton:(UIButton *)sender {
    
    if (sender.tag == 100)  // 修改头像
    {
        [self ChangeUserIconFromeLocalPhotoAlbum];
    }
    else if (sender.tag == 101) // 修改真实的名字
    {
        [self ChangeUserRealName];
    }
    else if (sender.tag == 102) // 修改性别
    {
        [self ModifyTheUserGender];
    }
    else if (sender.tag == 103) // 修改出生日期
    {
        [self ModifyTheUserDateOfBirth];
    }
    else if (sender.tag == 104) // 修改所在地
    {
        [self ModifyTheLocationOfTheUser];
    }
}

#pragma mark - 修改用户的头像
- (void)ChangeUserIconFromeLocalPhotoAlbum{
    
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"请选择您的相片" message:nil preferredStyle:(UIAlertControllerStyleActionSheet)];
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"拍照" style:(UIAlertActionStyleDestructive) handler:^(UIAlertAction * _Nonnull action) {
        
        [self pickerImageFromCamera];
    }];
    UIAlertAction *action02 = [UIAlertAction actionWithTitle:@"相册" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        
        [self pickerImageFromPhotoLibrary];
    }];
    UIAlertAction *action03 = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {
        
        
    }];
    
    [alertVC addAction:action];
    [alertVC addAction:action02];
    [alertVC addAction:action03];
    
    [self presentViewController:alertVC animated:YES completion:nil];
}

/**
 * @brief 调用相机，进行拍照
 */
- (void)pickerImageFromCamera{
    
    // 1.判断相机的摄像头是否可以使用(后置).
    BOOL isAvilable = [UIImagePickerController isCameraDeviceAvailable:(UIImagePickerControllerCameraDeviceRear)];
    
    if (isAvilable == NO)
    {
        [[HSQProgressHUDManger Manger] ShowProgressHUDPromptText:@"后置摄像头不可用" SupView:self.view];
        
        return;
    }
    
    UIImagePickerController *imagePick = [[UIImagePickerController alloc]init];
    
    // 设置图片的来源
    imagePick.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    // 允许图片是否编辑.
    imagePick.allowsEditing = YES;
    
    // 设置代理属性.
    imagePick.delegate = self;
    
    [self presentViewController:imagePick animated:YES completion:nil];
}

/**
 * @brief 调用本地相册
 */
- (void)pickerImageFromPhotoLibrary{
    
    // 从相册中获取图片
    UIImagePickerController *picker = [[UIImagePickerController alloc]init];
    
    // 图片来源
    picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    
    // 是否允许编辑
    picker.allowsEditing = YES;
    
    picker.delegate = self;
    
    // 用模态的方法进入到下一个界面.
    [self presentViewController:picker animated:YES completion:nil];
}

/**
 * @brief 实现相机代理的方法
 */
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    UIImage *iconImage = [info objectForKey:UIImagePickerControllerEditedImage];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    NSString *name4 = @"UserIconImage";
    
    NSString *fileName = [NSString stringWithFormat:@"%@.png",name4];
    
    NSData *data = UIImageJPEGRepresentation(iconImage, 0.001f);
    
    [self ModifyTheMemberAvatar:iconImage fileName:fileName Data:data];
    
}

/**
 * @brief 修改会员的头像
 */
- (void)ModifyTheMemberAvatar:(UIImage *)iconimage fileName:(NSString *)fileName Data:(NSData *)ImageData{
    
    [[HSQProgressHUDManger Manger] ShowLoadingDataFromeServer:nil ToView:self.view IsClearColor:NO];
    
    NSDictionary *Diction = @{@"token":[HSQAccountTool account].token,@"file":iconimage};
    
    AFNetworkRequestTool *RequestTool = [AFNetworkRequestTool shareRequestTool];
    
    [RequestTool.manger POST:UrlAdress(KUpLoadPictureUrl) parameters:Diction constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        [formData appendPartWithFileData:ImageData name:@"file"fileName:fileName mimeType:@"image/jpg/png/jpeg"];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [[HSQProgressHUDManger Manger] DismissProgressHUD];
        
        HSQLog(@"===%@",responseObject);

        if ([responseObject[@"code"] integerValue] == 200)
        {
            [self UpLoadImageViewURLToServer:responseObject[@"datas"][@"name"] image:iconimage];
        }
        else
        {
            NSString *errorString = [NSString stringWithFormat:@"%@",responseObject[@"datas"][@"error"]];
            
            [[HSQProgressHUDManger Manger] ShowDisplayFailedToLoadData:errorString SuperView:self.view];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [[HSQProgressHUDManger Manger] ShowDisplayFailedToLoadData:@"头像修改失败" SuperView:self.view];
    }];
}

/**
 * @brief 将图片的URL上传至服务器
 */
- (void)UpLoadImageViewURLToServer:(NSString *)ImageUrl image:(UIImage *)Picture{
    
    NSDictionary *Diction = @{@"token":[HSQAccountTool account].token,@"avatar":ImageUrl};
    
    AFNetworkRequestTool *RequestTool = [AFNetworkRequestTool shareRequestTool];
    
    [RequestTool.manger POST:UrlAdress(KChangeIconImageUrl) parameters:Diction progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        HSQLog(@"==%@",responseObject);
        
        if ([responseObject[@"code"] integerValue] == 200)
        {
            self.IconImageView.image = Picture;
            
            if (self.Success)
            {
                self.Success(ImageUrl);
            }
        }
        else
        {
            NSString *errorString = [NSString stringWithFormat:@"%@",responseObject[@"datas"][@"error"]];
            
            [[HSQProgressHUDManger Manger] ShowDisplayFailedToLoadData:errorString SuperView:self.view];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
         [[HSQProgressHUDManger Manger] ShowDisplayFailedToLoadData:@"头像修改失败" SuperView:self.view];
        
    }];
}

#pragma mark - 修改用户的真实名字
-(void)ChangeUserRealName{
    
    HSQRealNameViewController*RealNameVC = [[HSQRealNameViewController alloc] init];
    
    RealNameVC.RealName_String = self.RealName_Label.text;
    
    RealNameVC.RealNameBlock = ^(NSString *string) {
        
        self.RealName_Label.text = string;
    };
    
    [self.navigationController pushViewController:RealNameVC animated:YES];
}


#pragma mark - 修改用户的性别
- (void)ModifyTheUserGender{
    
    NSArray *array = @[@"选择性别",@"男",@"女",@"保密"];
    
    HSQUserGenderView *genderView = [HSQUserGenderView ShowUserGnederView];
    
    genderView.dataSource = array;
    
    genderView.SelectGender = self.Sex_Label.text.length == 0 ? @"保密":self.Sex_Label.text;
    
    genderView.delegate = self;
    
    [genderView Show];
}

- (void)SelectUserGenderfromeButton:(UIButton *)sender selectGender:(NSString *)gender Sex:(NSString *)sexNumber{
    
    NSString *memberSex = [NSString stringWithFormat:@"%@",gender];
    
    NSDictionary *diction = @{@"token":[HSQAccountTool account].token,@"memberSex":sexNumber};
    
    [self NotifyTheServerToModifyTheUserInformation:UrlAdress(KChangeSexUrl) parameters:diction label_type:self.Sex_Label string:memberSex placher:@"性别修改失败"];
}

#pragma mark - 修改用户的出生日期
- (void)ModifyTheUserDateOfBirth{
    
    HSQSelectDatePickerView *pickerView = [[HSQSelectDatePickerView alloc] init];
    
    pickerView.delegate = self;
    
    pickerView.pickerViewMode = DatePickerViewDateMode;
    
    [[[UIApplication sharedApplication] keyWindow] addSubview:pickerView];
    
    [pickerView showHSQSelectDatePickerView];
}

#pragma mark - delegate

-(void)didClickFinishHSQSelectDatePickerView:(NSString*)date{
    
    NSString *Timestamp = [NSString timeStampWithString:date TimeType:@"YYYY-MM-dd"];
    
    NSString *datestring = [NSString stringWithTheTimeStamp:Timestamp TimeType:@"YYYY-MM-dd hh:mm:ss.S"];
    
    NSDictionary *diction = @{@"token":[HSQAccountTool account].token,@"birthday":datestring};
    
     [self NotifyTheServerToModifyTheUserInformation:UrlAdress(KChangebirthdayUrl) parameters:diction label_type:self.Date_Label string:date placher:@"出生日期修改失败"];
    
}

#pragma mark - 修改用户的所在地
- (void)ModifyTheLocationOfTheUser{
    
    HSQPublicAdressView *adressView = [HSQPublicAdressView initAdressView];
    
    adressView.placherString = @"地区选择";
    
    [adressView ShowAdressView];
    
    adressView.chooseFinish = ^(NSString *adress,NSString *ProvinceId, NSString *cityId, NSString *AreaId){
        
        HSQLog(@"===%@==%@===%@==%@",adress,ProvinceId,cityId,AreaId);
        
        NSDictionary *diction = @{@"token":[HSQAccountTool account].token,@"addressProvinceId":ProvinceId,@"addressCityId":cityId,@"addressAreaId":AreaId,@"addressAreaInfo":adress};

        [self NotifyTheServerToModifyTheUserInformation:UrlAdress(KMembersModifyTheLocation) parameters:diction label_type:self.adress_Label string:adress placher:@"所在地数据修改失败"];
    };
}

/**
 * @brief 通知服务器修改用户的信息
 * param parameters :请求的参数
 */
- (void)NotifyTheServerToModifyTheUserInformation:(NSString *)requestUrl  parameters:(NSDictionary *)parameters label_type:(UILabel *)label string:(NSString *)successString placher:(NSString *)PlacherString{
    
    [[HSQProgressHUDManger Manger] ShowLoadingDataFromeServer:@"" ToView:self.view IsClearColor:NO];
    
    AFNetworkRequestTool *RequestTool = [AFNetworkRequestTool shareRequestTool];
    
    [RequestTool.manger POST:requestUrl parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [[HSQProgressHUDManger Manger] DismissProgressHUD];
        
        HSQLog(@"=修改的数据==%@",responseObject);
        
        if ([responseObject[@"code"] integerValue] == 200)
        {
            label.text = successString;
        }
        else
        {
            NSString *errorString = [NSString stringWithFormat:@"%@",responseObject[@"datas"][@"error"]];
            
            [[HSQProgressHUDManger Manger] ShowDisplayFailedToLoadData:errorString SuperView:self.view];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        HSQLog(@"%@",error.description);
        
        [[HSQProgressHUDManger Manger] ShowDisplayFailedToLoadData:PlacherString SuperView:self.view];
        
    }];
}









@end
