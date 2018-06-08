//
//  HSQGoodsRefundViewController.m
//  LiTianDecoration
//
//  Created by administrator on 2018/6/7.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import "HSQGoodsRefundViewController.h"
#import "HSQAccountTool.h"
#import "HSQTuiKuanGoodsListCell.h"
#import "HSQTuiKuanGoodsFooterView.h"
#import "HSQTuiKuanGoodsHeadView.h"
#import "HSQShopCarGoodsTypeListModel.h"
#import "HSQReturnGoodsViewController.h"

@interface HSQGoodsRefundViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,HSQTuiKuanGoodsFooterViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@property (nonatomic, strong) NSDictionary *dataDiction;

@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, copy) NSString *reason; // 原因的说明

@property (nonatomic, assign) NSInteger Index;

@property (nonatomic, strong) NSMutableArray *Picture_Array; // 退款凭证的数组

@property (nonatomic, strong) NSMutableArray *submit_Picture_Array; // 退款凭证的数组

@property (nonatomic, strong) NSMutableArray *SubmitPictureName_Array; // 提交图片的名字

@end

@implementation HSQGoodsRefundViewController

-(NSMutableArray *)dataSource{
    
    if (_dataSource == nil) {
        
        self.dataSource = [NSMutableArray array];
    }
    
    return _dataSource;
}


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
    
    self.view.backgroundColor = KViewBackGroupColor;
    
    self.navigationItem.title = self.Navtion_string;
    
    self.dataDiction = [NSDictionary dictionary];
    
    // 创建tableView
    [self CreatTableView];
    
    // 请求数据
    [self RequestRefundOfMerchandiseData];
}

/**
 * @brief 请求数据
 */
- (void)RequestRefundOfMerchandiseData{
    
    [[HSQProgressHUDManger Manger] ShowLoadingDataFromeServer:@"" ToView:self.view IsClearColor:YES];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"token"] = [HSQAccountTool account].token;
    params[@"ordersId"] = self.ordersId;
    
    HSQLog(@"==参数==%@",params);
    
    AFNetworkRequestTool *requestTool = [AFNetworkRequestTool shareRequestTool];
    
    [requestTool.manger POST:UrlAdress(KAllGoodsTuiKuangUrl) parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [[HSQProgressHUDManger Manger] DismissProgressHUD];
        
        HSQLog(@"==退款商品==%@",responseObject);
        
        if ([responseObject[@"code"] integerValue] == 200)
        {
            self.dataDiction = responseObject[@"datas"];
            
            NSArray *array = responseObject[@"datas"][@"ordersVo"][@"ordersGoodsVoList"];
            
            self.dataSource = [HSQShopCarGoodsTypeListModel mj_objectArrayWithKeyValuesArray:array];
        }
        else
        {
            NSString *errorString = [NSString stringWithFormat:@"%@",responseObject[@"datas"][@"error"]];
            
            [[HSQProgressHUDManger Manger] ShowDisplayFailedToLoadData:errorString SuperView:self.view];
        }
        
        [self.tableView reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [[HSQProgressHUDManger Manger] ShowProgressHUDPromptText:@"网络出问题啦！" SupView:self.view];
    }];
}


/**
 * @brief 创建tableView
 */
- (void)CreatTableView{
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - KSafeTopeHeight - KSafeBottomHeight) style:(UITableViewStyleGrouped)];
    
    tableView.backgroundColor = [UIColor clearColor];
    
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    tableView.delegate = self;
    
    tableView.dataSource = self;
    
    [tableView registerNib:[UINib nibWithNibName:@"HSQTuiKuanGoodsListCell" bundle:nil] forCellReuseIdentifier:@"HSQTuiKuanGoodsListCell"];
    
    [tableView registerNib:[UINib nibWithNibName:@"HSQTuiKuanGoodsFooterView" bundle:nil] forHeaderFooterViewReuseIdentifier:@"HSQTuiKuanGoodsFooterView"];

    [tableView registerClass:[HSQTuiKuanGoodsHeadView class] forHeaderFooterViewReuseIdentifier:@"HSQTuiKuanGoodsHeadView"];
    
    [self.view addSubview:tableView];
    
    self.tableView = tableView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataSource.count;
}


- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section{
    
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 50;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    HSQTuiKuanGoodsHeadView *HeaderView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"HSQTuiKuanGoodsHeadView"];
    
    HeaderView.OrderDataDiction = self.dataDiction;
    
    return HeaderView;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForFooterInSection:(NSInteger)section{
    
    // 提示标语的高度
    NSString *PlacherString = @"特别提示：投诉凭证选择直接拍照或从手机相册上传图片时，请注意图片尺寸控制在1M以内，超出请压缩裁剪后再选择上传！";
    CGSize PlacherSize = [NSString SizeOfTheText:PlacherString font:[UIFont systemFontOfSize:12.0] MaxSize:CGSizeMake(KScreenWidth - 30, MAXFLOAT)];
     return PlacherSize.height + 290;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    // 提示标语的高度
    NSString *PlacherString = @"特别提示：投诉凭证选择直接拍照或从手机相册上传图片时，请注意图片尺寸控制在1M以内，超出请压缩裁剪后再选择上传！";
    CGSize PlacherSize = [NSString SizeOfTheText:PlacherString font:[UIFont systemFontOfSize:12.0] MaxSize:CGSizeMake(KScreenWidth - 30, MAXFLOAT)];
    return PlacherSize.height + 290;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    HSQTuiKuanGoodsFooterView *FooterView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"HSQTuiKuanGoodsFooterView"];
    
    FooterView.OrderDataDiction = self.dataDiction;
    
    FooterView.ShuoMing_TextField.delegate = self;
    
    FooterView.Picture_array = self.Picture_Array;
    
    FooterView.delegate = self;
    
    return FooterView;
}


- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 70;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 70;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HSQTuiKuanGoodsListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HSQTuiKuanGoodsListCell" forIndexPath:indexPath];
    
    if (self.dataSource.count)
    {
        cell.model = self.dataSource[indexPath.row];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

}

/**
 * @brief 选择退款凭证
 */
- (void)ChooseRefundImageViewButtonClickAction:(UIButton *)sender{
    
    self.Index = sender.tag - 400;
    
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
    
    [self.Picture_Array replaceObjectAtIndex:self.Index withObject:iconImage];
    
    [self.tableView reloadData];
}

/**
 * @brief 提交按钮的点击
 */
- (void)SubmitButtonClickAction:(UIButton *)sender{
    
    [self.submit_Picture_Array removeAllObjects];
    
    if (self.reason.length == 0)
    {
        [[HSQProgressHUDManger Manger] ShowProgressHUDPromptText:@"请填写退款说明" SupView:self.view];
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
            // 2.没有退款凭证的图片时直接 提交到服务器
            [self SubmitDataToServer];
        }
        else // 有退款凭证的图片时
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
    params[@"buyerMessage"] = self.reason;
    params[@"picJson"] = [self.SubmitPictureName_Array componentsJoinedByString:@","]; // 退款凭证的图片--字符串类型
    
    AFNetworkRequestTool *requestTool = [AFNetworkRequestTool shareRequestTool];
    
    [requestTool.manger POST:UrlAdress(KAllGoodsTuiKuangSubmitUrl)  parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [[HSQProgressHUDManger Manger] DismissProgressHUD];
        
        HSQLog(@"==全部退款===%@",responseObject);
        if ([responseObject[@"code"] integerValue] == 200)  // 操作成功以后，进入退款
        {
            HSQReturnGoodsViewController *moneryVC = [[HSQReturnGoodsViewController alloc] init];
            
            moneryVC.index_Number = @"300";
            
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















-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    self.reason = [NSString stringWithFormat:@"%@",textField.text];
}














@end
