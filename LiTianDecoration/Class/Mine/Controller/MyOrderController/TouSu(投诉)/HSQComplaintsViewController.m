//
//  HSQComplaintsViewController.m
//  LiTianDecoration
//
//  Created by administrator on 2018/6/1.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import "HSQComplaintsViewController.h"
#import "HSQAccountTool.h"
#import "HSQChooseTuiKuanReasonView.h"
#import "HSQReturnGoodsViewController.h"

@interface HSQComplaintsViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate,UITextFieldDelegate>

@property (nonatomic, strong) NSDictionary *dataDiction;

@property (weak, nonatomic) IBOutlet UIView *PlacherTitle_bgView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *PlacherView_Height;

@property (weak, nonatomic) IBOutlet UILabel *StoreName_Label; // 店铺的名字

@property (weak, nonatomic) IBOutlet UIImageView *GoodsImageView; // 商品的图片

@property (weak, nonatomic) IBOutlet UILabel *GoodsName_Label; // 商品的名字

@property (weak, nonatomic) IBOutlet UILabel *GoodsPrice_Label; // 商品的价格

@property (weak, nonatomic) IBOutlet UILabel *GoodsGuiGe_Label; // 商品的规格

@property (weak, nonatomic) IBOutlet UILabel *GoodsCount_Label; // 商品的数量

@property (weak, nonatomic) IBOutlet UILabel *Reason_Label; // 投诉的原因

@property (weak, nonatomic) IBOutlet UITextField *TouSuContent_TextField; // 投诉的原因

@property (weak, nonatomic) IBOutlet UIImageView *First_ImageView;

@property (weak, nonatomic) IBOutlet UIImageView *Second_ImageView;

@property (weak, nonatomic) IBOutlet UIImageView *Third_ImageView;

@property (nonatomic, copy) NSString *reasonId;

@property (weak, nonatomic) IBOutlet UIView *TiShi_View;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *BottomViewLayOut;

@property (nonatomic, assign) NSInteger Index; // 选中的第一个图片

@property (nonatomic, strong) NSMutableArray *Picture_Array; // 退款凭证的数组

@property (nonatomic, strong) NSMutableArray *submit_Picture_Array; // 退款凭证的数组

@property (nonatomic, strong) NSMutableArray *SubmitPictureName_Array; // 提交图片的名字


@end

@implementation HSQComplaintsViewController

-(NSMutableArray *)Picture_Array{
    
    if (_Picture_Array == nil) {
        
        UIImage *imageV = [UIImage imageNamed:@"123"];
        self.Picture_Array = [NSMutableArray arrayWithObjects:imageV,imageV,imageV, nil];
    }
    
    return _Picture_Array;
}

- (NSMutableArray *)submit_Picture_Array{
    
    if (_submit_Picture_Array == nil) {
        
        self.submit_Picture_Array = [NSMutableArray array];
    }
    
    return _submit_Picture_Array;
}

- (NSMutableArray *)SubmitPictureName_Array{
    
    if (_SubmitPictureName_Array == nil) {
        
        self.SubmitPictureName_Array = [NSMutableArray array];
    }
    
    return _SubmitPictureName_Array;
}


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.navigationItem.title = @"订单商品投诉";
    
    self.view.backgroundColor = KViewBackGroupColor;
    
    self.BottomViewLayOut.constant = KSafeBottomHeight;
    
    self.dataDiction = [NSDictionary dictionary];
    
    // 提示标语的高度
    NSString *PlacherString = @"特别提示：投诉凭证选择直接拍照或从手机相册上传图片时，请注意图片尺寸控制在1M以内，超出请压缩裁剪后再选择上传！";
    CGSize PlacherSize = [NSString SizeOfTheText:PlacherString font:[UIFont systemFontOfSize:12.0] MaxSize:CGSizeMake(KScreenWidth - 30, MAXFLOAT)];
    self.PlacherView_Height.constant = PlacherSize.height + 15;
    
    // 请求投诉商品的数据
    [self RequestDataOnGoodsComplained];
    
    
}

/**
 * @brief 请求投诉商品的数据
 */
- (void)RequestDataOnGoodsComplained{
    
    [[HSQProgressHUDManger Manger] ShowLoadingDataFromeServer:@"" ToView:self.view IsClearColor:YES];
    
    NSDictionary *params = @{@"token":[HSQAccountTool account].token,@"ordersId":self.ordersId,@"ordersGoodsId":self.Goods_Id};
        
    AFNetworkRequestTool *requestTool = [AFNetworkRequestTool shareRequestTool];
    
    [requestTool.manger POST:UrlAdress(KComplainInitiationPageUrl) parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [[HSQProgressHUDManger Manger] DismissProgressHUD];
        
        HSQLog(@"==投诉商品==%@",responseObject);
        
        if ([responseObject[@"code"] integerValue] == 200)
        {
            self.dataDiction = responseObject[@"datas"];
            
            // 控件赋值
            [self SetValueViewWithDiction:responseObject[@"datas"]];
            
             self.TiShi_View.hidden = YES;
        }
        else
        {
            NSString *errorString = [NSString stringWithFormat:@"%@",responseObject[@"datas"][@"error"]];
            
            [[HSQProgressHUDManger Manger] ShowDisplayFailedToLoadData:errorString SuperView:self.view];
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [[HSQProgressHUDManger Manger] ShowProgressHUDPromptText:@"网络出问题啦！" SupView:self.view];
    }];
}

/**
 * @brief 控件赋值
 */
- (void)SetValueViewWithDiction:(NSDictionary *)diction{
    
    // 店铺的名字
    self.StoreName_Label.text = [NSString stringWithFormat:@"%@",diction[@"ordersVo"][@"storeName"]];
    
    // 商品的图片
    NSString *GoodsImageSrc = [NSString stringWithFormat:@"%@",diction[@"ordersGoodsVo"][@"imageSrc"]];
    [self.GoodsImageView sd_setImageWithURL:[NSURL URLWithString:GoodsImageSrc] placeholderImage:KGoodsPlacherImage];
    
    // 商品的名字
    self.GoodsName_Label.text = [NSString stringWithFormat:@"%@",diction[@"ordersGoodsVo"][@"goodsName"]];
    
    // 商品的价格
    NSString *GoodsPrice = [NSString stringWithFormat:@"%@",diction[@"ordersGoodsVo"][@"goodsPrice"]];
    self.GoodsPrice_Label.text = [NSString stringWithFormat:@"¥%.2f",GoodsPrice.floatValue];
    
    // 商品的规格
    self.GoodsGuiGe_Label.text = [NSString stringWithFormat:@"%@",diction[@"ordersGoodsVo"][@"goodsFullSpecs"]];
    
    // 商品的数量
    self.GoodsCount_Label.text = [NSString stringWithFormat:@"X%@",diction[@"ordersGoodsVo"][@"buyNum"]];
    
    // 退款的原因
    self.Reason_Label.text = [NSString stringWithFormat:@"%@",diction[@"complainSubjectList"][0][@"title"]];
    self.reasonId = [NSString stringWithFormat:@"%@",diction[@"complainSubjectList"][0][@"subjectId"]];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 * @brief 投诉原因
 */
- (IBAction)chooseTouSuReasonBtnClickAction:(UIButton *)sender {
    
    NSArray *array = self.dataDiction[@"complainSubjectList"];
    
    HSQChooseTuiKuanReasonView *coupListView = [HSQChooseTuiKuanReasonView initChooseTuiKuanReasonView];
    
    [coupListView SetValueDataWithArray:array Select_Index:self.reasonId];
    
    coupListView.SelectReasonDataBlock = ^(NSIndexPath *indexPath) {
        
        NSDictionary *diction = array[indexPath.row];
        
        self.Reason_Label.text = [NSString stringWithFormat:@"%@",diction[@"title"]];
        
        self.reasonId = [NSString stringWithFormat:@"%@",diction[@"subjectId"]];
        
    };
    
    [coupListView ShowChooseTuiKuanReasonView];
}


/**
 * @brief 投诉凭证
 */
- (IBAction)ChooseTouSuImageViewBtnClickAction:(UIButton *)sender {
    
    self.Index = sender.tag - 410;
    
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"请选择您的相片" message:nil preferredStyle:(UIAlertControllerStyleActionSheet)];
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"拍照" style:(UIAlertActionStyleDestructive) handler:^(UIAlertAction * _Nonnull action) {
        
        [self pickerImageFromCamera];
    }];
    UIAlertAction *action02 = [UIAlertAction actionWithTitle:@"相册" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        
        [self pickerImageFromPhotoLibrary];
    }];
    UIAlertAction *action03 = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:nil];
    
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
    
    if (self.Index == 0) // 第一张
    {
        self.First_ImageView.image = iconImage;
    }
    else if (self.Index == 1) // 第二章
    {
        self.Second_ImageView.image = iconImage;
    }
    else
    {
        self.Third_ImageView.image = iconImage;
    }
    
    [self.Picture_Array replaceObjectAtIndex:self.Index withObject:iconImage];
}


/**
 * @brief 提交
 */
- (IBAction)SubmitBtnClickAction:(UIButton *)sender {
    
    [self.submit_Picture_Array removeAllObjects];
    
    if (self.TouSuContent_TextField.text.length == 0)
    {
        [[HSQProgressHUDManger Manger] ShowProgressHUDPromptText:@"请填写投诉内容" SupView:self.view];
    }
    else
    {
        UIImage *imageV = [UIImage imageNamed:@"123"];
        
        NSData *data = UIImageJPEGRepresentation(imageV, 0.001f);
        
        for (NSInteger i = 0; i < self.Picture_Array.count; i++) {
            
            UIImage *Picture = self.Picture_Array[i];
            
            NSData *data1 = UIImageJPEGRepresentation(Picture, 0.001f);
            
            if (![data isEqual:data1]) {
                
                [self.submit_Picture_Array addObject:Picture];
            }
        }
        if (self.submit_Picture_Array.count == 0) // 没有图片，直接提交
        {
            // 2.将整体的评论提交到服务器
            [self SubmitDataToServer];
        }
        else // 评论时有图片
        {
            // 1.现将图片提交到服务器
            [self SubmitPictureToServer];
        }
    }
}

/**
 * @brief 1.如果有图片，将图片上传至服务器
 */
- (void)SubmitPictureToServer{
    
    [self.SubmitPictureName_Array removeAllObjects];
    
    for (NSInteger i = 0; i < self.submit_Picture_Array.count; i++) {
        
        UIImage *iconimage = self.submit_Picture_Array[i];
        
        NSDictionary *params = @{@"token":[HSQAccountTool account].token,@"file":iconimage};
        
        NSData *data = UIImageJPEGRepresentation(iconimage, 0.001f);
        
        NSString *fileName = [NSString stringWithFormat:@"img%ld.png",i+1];
        
        // 1.现将图片批量上传至服务器
        AFNetworkRequestTool *requestTool = [AFNetworkRequestTool shareRequestTool];
        
        [requestTool.manger POST:UrlAdress(KUpLoadPictureUrl) parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            
            [formData appendPartWithFileData:data  name:@"file"fileName:fileName mimeType:@"image/jpg/png/jpeg"];
            
        } progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            HSQLog(@"=====%@",responseObject);
            if ([responseObject[@"code"] integerValue] == 200)
            {
                [self.SubmitPictureName_Array addObject:responseObject[@"datas"][@"name"]];
                
                if (self.SubmitPictureName_Array.count == self.submit_Picture_Array.count) // 图片全部上传完成
                {
                    // 2.将整体提交到服务器
                    [self SubmitDataToServer];
                    
                }
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            [[HSQProgressHUDManger Manger] ShowProgressHUDPromptText:@"网络出问题啦" SupView:self.view];
            
        }];
    }
}

/**
 * @brief 2.提交数据到服务器
 */
- (void)SubmitDataToServer{
    
    [[HSQProgressHUDManger Manger] ShowLoadingDataFromeServer:@"" ToView:self.view IsClearColor:YES];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"token"] = [HSQAccountTool account].token;
    params[@"ordersId"] = self.ordersId;
    params[@"accuserContent"] = self.TouSuContent_TextField.text;
    params[@"ordersGoodsId"] = self.Goods_Id;
    params[@"subjectId"] = self.reasonId;
    params[@"accuserImages"] = [self.SubmitPictureName_Array componentsJoinedByString:@","]; // 退款凭证的图片--字符串类型
    
    AFNetworkRequestTool *requestTool = [AFNetworkRequestTool shareRequestTool];
    
    [requestTool.manger POST:UrlAdress(KTouSuDataSaveUrl)  parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [[HSQProgressHUDManger Manger] DismissProgressHUD];
        
        HSQLog(@"==responseObject===%@",responseObject);
        if ([responseObject[@"code"] integerValue] == 200)  // 操作成功以后，进入投诉列表
        {
            HSQReturnGoodsViewController *moneryVC = [[HSQReturnGoodsViewController alloc] init];
            
            moneryVC.index_Number = @"100";
            
            [self.navigationController pushViewController:moneryVC animated:YES];
        }
        else
        {
            NSString *errorString = [NSString stringWithFormat:@"%@",responseObject[@"datas"][@"error"]];
            
            [[HSQProgressHUDManger Manger] ShowDisplayFailedToLoadData:errorString SuperView:self.view];
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [[HSQProgressHUDManger Manger] ShowProgressHUDPromptText:@"网络出问题啦" SupView:self.view];
        
    }];
}

/**
 * @brief 点击return键取消键盘
 */
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    
    return YES;
}













@end
