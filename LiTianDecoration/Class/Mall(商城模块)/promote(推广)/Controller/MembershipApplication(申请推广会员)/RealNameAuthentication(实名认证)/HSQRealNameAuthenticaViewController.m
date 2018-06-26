//
//  HSQRealNameAuthenticaViewController.m
//  LiTianDecoration
//
//  Created by administrator on 2018/6/11.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import "HSQRealNameAuthenticaViewController.h"

@interface HSQRealNameAuthenticaViewController ()<UITextFieldDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *FrontIdCard_ImageView; // 正面照

@property (weak, nonatomic) IBOutlet UIImageView *ReverseidCard_ImageView; // 反面照

@property (weak, nonatomic) IBOutlet UIImageView *HoldAndCard_ImageView; // 手持身份证照

@property (weak, nonatomic) IBOutlet UITextField *Name_TextField; // 姓名

@property (weak, nonatomic) IBOutlet UITextField *IDNumber_TextField; // 身份证号码

@property (nonatomic, assign) NSInteger ImageView_Type; // 图片的类型

@end

@implementation HSQRealNameAuthenticaViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.view.backgroundColor = KViewBackGroupColor;
    
    self.navigationItem.title = @"会员实名认证";
    
    if (self.CertificationDiction.allKeys.count != 0)
    {
        self.Name_TextField.text = [NSString stringWithFormat:@"%@",self.CertificationDiction[@"name"]];
        
        self.IDNumber_TextField.text = [NSString stringWithFormat:@"%@",self.CertificationDiction[@"IDNumber"]];
        
        self.FrontIdCard_ImageView.image = self.CertificationDiction[@"idCartFrontImage"];
        
        self.ReverseidCard_ImageView.image = self.CertificationDiction[@"idCartBackImage"];
        
        self.HoldAndCard_ImageView.image = self.CertificationDiction[@"naidCartHandImageme"];
    }
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 * @brief 选择身份证正面照
 */
- (IBAction)ChooseTheFrontViewOfYourIdCardClickAction:(UITapGestureRecognizer *)sender {
    
    self.ImageView_Type = 100;
    
    [self PopUpPhotoAlbumAndCamera];
}

/**
 * @brief 选择身份证反面照
 */

- (IBAction)ChooseTheReversePhotoOfYourIdCardClickAction:(UITapGestureRecognizer *)sender {
    
    self.ImageView_Type = 200;
    
    [self PopUpPhotoAlbumAndCamera];
}

/**
 * @brief 手持身份证照
 */
- (IBAction)ChooseToHoldYourIdCardClickAction:(UITapGestureRecognizer *)sender {
    
    self.ImageView_Type = 300;
    
    [self PopUpPhotoAlbumAndCamera];
}

/**
 * @brief 弹出相册，相机
 */
- (void)PopUpPhotoAlbumAndCamera{
    
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
    
    if (self.ImageView_Type == 100) // 正面照
    {
        [self chulitupian:self.FrontIdCard_ImageView image:iconImage];
    }
    else if (self.ImageView_Type == 200) // 反面照
    {
        [self chulitupian:self.ReverseidCard_ImageView image:iconImage];
    }
    else // 手持身份证照
    {
        [self chulitupian:self.HoldAndCard_ImageView image:iconImage];
    }
}

/**
 * @brief 处理选中的图片
 */
- (void)chulitupian:(UIImageView *)ImageView image:(UIImage *)image{
    
    // 开启图形上下文
    UIGraphicsBeginImageContextWithOptions(ImageView.size, YES, 0.0);
    
    // 将下载完的image对象绘制到图形上下文
    CGFloat width = ImageView.width;
    CGFloat height = width * image.size.height / image.size.width;
    [image drawInRect:CGRectMake(0, 0, width, height)];
    
    // 获得图片
    UIImage *BtnImg = UIGraphicsGetImageFromCurrentImageContext();
    
    ImageView.image = BtnImg;
    
    // 结束图形上下文
    UIGraphicsEndImageContext();
    
}


/**
 * @brief 提交
 */
- (IBAction)SubmitButtonClickAction:(UIButton *)sender {
    
    if (self.Name_TextField.text.length == 0)
    {
        [[HSQProgressHUDManger Manger] ShowProgressHUDPromptText:@"请输入您的真实姓名" SupView:self.view];
    }
    else if (self.IDNumber_TextField.text.length == 0)
    {
        [[HSQProgressHUDManger Manger] ShowProgressHUDPromptText:@"请输入身份证号" SupView:self.view];
    }
    else if (self.FrontIdCard_ImageView.image == nil)
    {
         [[HSQProgressHUDManger Manger] ShowProgressHUDPromptText:@"请选择身份证正面照" SupView:self.view];
    }
    else if (self.ReverseidCard_ImageView.image == nil)
    {
        [[HSQProgressHUDManger Manger] ShowProgressHUDPromptText:@"请选择身份证反面照" SupView:self.view];
    }
    else if (self.HoldAndCard_ImageView.image == nil)
    {
        [[HSQProgressHUDManger Manger] ShowProgressHUDPromptText:@"请选择手持身份证照" SupView:self.view];
    }
    else
    {
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        
        params[@"name"] = self.Name_TextField.text;
        
        params[@"IDNumber"] = self.IDNumber_TextField.text;
        
        params[@"idCartFrontImage"] = self.FrontIdCard_ImageView.image;
        
        params[@"idCartBackImage"] = self.ReverseidCard_ImageView.image;
        
        params[@"naidCartHandImageme"] = self.HoldAndCard_ImageView.image;
        
        if (self.SelectNameCertificationDataBlock){
            
            self.SelectNameCertificationDataBlock(params);
        }
        
        [self.navigationController popViewControllerAnimated:YES];
        
    }
}

/**
 * @brief 键盘return键的点击
 */
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if (textField == self.Name_TextField)
    {
        [self.IDNumber_TextField becomeFirstResponder];
    }
    else if (textField == self.IDNumber_TextField)
    {
        [self.IDNumber_TextField resignFirstResponder];
    }
    
    return YES;
}









@end
