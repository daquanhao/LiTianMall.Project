//
//  HSQEvaluationOrderViewController.m
//  LiTianDecoration
//
//  Created by administrator on 2018/5/28.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import "HSQEvaluationOrderViewController.h"
#import "HSQEvaluationOrderHeadView.h"
#import "HSQEvaluationOrderFooterView.h"
#import "HSQOrderGoodsListCell.h"
#import "HSQEvaluationGoodsListCell.h"
#import "HSQShopCarGoodsTypeListModel.h"
#import "HSQAccountTool.h"

@interface HSQEvaluationOrderViewController ()<UITableViewDelegate,UITableViewDataSource,HSQEvaluationGoodsListCellDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UITextFieldDelegate,HSQEvaluationOrderFooterViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, assign) NSInteger Index;

@property (nonatomic, assign) NSInteger ClickIndex;

@property (nonatomic, strong) NSMutableArray *RateContent_Array;

@property (nonatomic, copy) NSString *Miaoshu_StarCount; // 描述的星级

@property (nonatomic, copy) NSString *Server_StarCount; // 服务态度的星级

@property (nonatomic, copy) NSString *SendGoods_StarCount; // 发货速度的星级

@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, copy) NSString *storeId;  // 店铺的id

@property (nonatomic, strong) NSMutableArray *SelectRateImage_Array;

@property (nonatomic, strong) NSMutableArray *SelectRateImageName_Array;

@property (nonatomic, assign) NSInteger number; // 用于判断图片是否全部上传完毕

@property (nonatomic, copy) NSString *isOwnShop; // 是否是自营店

@end

@implementation HSQEvaluationOrderViewController

-(NSMutableArray *)RateContent_Array{
    
    if (_RateContent_Array == nil) {
        
        self.RateContent_Array = [NSMutableArray array];
    }
    
    return _RateContent_Array;
}

-(NSMutableArray *)dataSource{
    
    if (_dataSource == nil) {
        
        self.dataSource = [NSMutableArray array];
    }
    
    return _dataSource;
}

-(NSMutableArray *)SelectRateImage_Array{
    
    if (_SelectRateImage_Array == nil) {
        
        self.SelectRateImage_Array = [NSMutableArray array];
    }
    
    return _SelectRateImage_Array;
}

-(NSMutableArray *)SelectRateImageName_Array{
    
    if (_SelectRateImageName_Array == nil) {
        
        self.SelectRateImageName_Array = [NSMutableArray array];
    }
    
    return _SelectRateImageName_Array;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.view.backgroundColor = KViewBackGroupColor;
    
    self.navigationItem.title = @"评价订单";
    
    self.Miaoshu_StarCount = self.Server_StarCount = self.SendGoods_StarCount = @"5";
    
    // 1.创建tableView
    [self CreatTableView];
    
    // 2.请求商品的详细信息
    [self RequestDetailsOfTheGoods];
    
}

/**
 * @brief 创建tableView
 */
- (void)CreatTableView{
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - KSafeTopeHeight - KSafeBottomHeight) style:UITableViewStyleGrouped];
    
    tableView.backgroundColor = [UIColor clearColor];
    
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    tableView.delegate = self;
    
    tableView.dataSource = self;
    
    [tableView registerNib:[UINib nibWithNibName:@"HSQEvaluationGoodsListCell" bundle:nil] forCellReuseIdentifier:@"HSQEvaluationGoodsListCell"];
    
    [tableView registerClass:[HSQEvaluationOrderHeadView class] forHeaderFooterViewReuseIdentifier:@"HSQEvaluationOrderHeadView"];
    
    [tableView registerNib:[UINib nibWithNibName:@"HSQEvaluationOrderFooterView" bundle:nil] forHeaderFooterViewReuseIdentifier:@"HSQEvaluationOrderFooterView"];
    
    [self.view addSubview:tableView];
    
    self.tableView = tableView;
}

/**
 * @brief 请求商品的详细信息
 */
- (void)RequestDetailsOfTheGoods{
    
    [[HSQProgressHUDManger Manger] ShowLoadingDataFromeServer:@"" ToView:self.view IsClearColor:YES];
    
    HSQAccount *account = [HSQAccountTool account];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"token"] = account.token;
    params[@"memberId"] = account.memberId;
    params[@"orderId"] = self.orderId;
    
    AFNetworkRequestTool *requestTool = [AFNetworkRequestTool shareRequestTool];
    
    [requestTool.manger POST:UrlAdress(KRateGoodsDetailInfoUrl) parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [[HSQProgressHUDManger Manger] DismissProgressHUD];
        
        HSQLog(@"===评价订单数据===%@",responseObject);
        
        if ([responseObject[@"code"] integerValue] == 200)
        {
            // 取出商品的数据
            NSArray *array = responseObject[@"datas"][@"ordersGoodsList"];
            
            // 是否是自营店
            self.isOwnShop = [NSString stringWithFormat:@"%@",responseObject[@"datas"][@"store"][@"isOwnShop"]];
            
            // 店铺的id
            self.storeId = [NSString stringWithFormat:@"%@",responseObject[@"datas"][@"store"][@"storeId"]];
            
            for (NSInteger i = 0; i < array.count; i++) {
                
                NSDictionary *diction = array[i];
                
                HSQShopCarGoodsTypeListModel *model = [[HSQShopCarGoodsTypeListModel alloc] init];
                
                // 评价的星级
                model.RateStarCount = @"5";
                
                // 评论的图片
                UIImage *imageV = [UIImage imageNamed:@"123"];
                model.Select_Arrays = [NSMutableArray arrayWithObjects:imageV,imageV, imageV, imageV, imageV,  nil];
                
                // 评论时，选中的商品的图片
                model.SelectRateImage_Arrays = [NSMutableArray array];
                
                // 评论时，选中商品的图片的名字
                NSString *name = @"null";
                model.SelectRateImageName_Arrays = [NSMutableArray arrayWithObjects:name,name,name,name,name, nil];
                
                [model setValuesForKeysWithDictionary:diction];
                
                [self.dataSource addObject:model];
            }
        }
        else
        {
            NSString *errorString = [NSString stringWithFormat:@"%@",responseObject[@"datas"][@"error"]];
            
            [[HSQProgressHUDManger Manger] ShowDisplayFailedToLoadData:errorString SuperView:self.view];
        }
        
        [self.tableView reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        // 提示数据请求失败
        [[HSQProgressHUDManger Manger] ShowProgressHUDPromptText:@"网络出现问题" SupView:self.view];
    }];
}











- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return (self.dataSource.count == 0 ? 0 :1);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section{
    
    CGSize HeadSize = [NSString SizeOfTheText:KEvaluationOrderHeadPlacher font:[UIFont systemFontOfSize:12.0] MaxSize:CGSizeMake(KScreenWidth - 40, MAXFLOAT)];
    
    return HeadSize.height + 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    CGSize HeadSize = [NSString SizeOfTheText:KEvaluationOrderHeadPlacher font:[UIFont systemFontOfSize:12.0] MaxSize:CGSizeMake(KScreenWidth - 40, MAXFLOAT)];
    
    return HeadSize.height + 30;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    HSQEvaluationOrderHeadView *HeaderView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"HSQEvaluationOrderHeadView"];
    
    return HeaderView;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForFooterInSection:(NSInteger)section{
    
    return 180;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 180;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    HSQEvaluationOrderFooterView *FooterView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"HSQEvaluationOrderFooterView"];
    
    FooterView.delegate = self;
    
    return FooterView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 190;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HSQEvaluationGoodsListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HSQEvaluationGoodsListCell" forIndexPath:indexPath];
    
    cell.Model = self.dataSource[indexPath.row];
    
    cell.delegate = self;
    
        cell.RateContentBgView.hidden = YES;
    
    cell.RateContent_TextField.delegate = self;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

///**
// * @brief 数据源数据
// */
//- (void)setSecondModel:(HSQOrderListSecondCengModel *)SecondModel{
//
//    _SecondModel = SecondModel;
//
//    for (NSInteger i = 0; i < SecondModel.ordersGoodsVoList_array.count; i++) {
//
//        HSQShopCarGoodsTypeListModel *ThirdModel = SecondModel.ordersGoodsVoList_array[i];
//
//        UIImage *imageV = [UIImage imageNamed:@"123"];
//        ThirdModel.Select_Arrays = [NSMutableArray arrayWithObjects:imageV,imageV, imageV, imageV, imageV,  nil];
//
//        // 评论的星星
//        ThirdModel.RateStarCount = @"5";
//    }
//
//    [self.tableView reloadData];
//}

/**
 * @brief 选择评论的图片
 */
- (void)SelectTheImageOfTheCommentBtnClickAction:(UIButton *)sender{
    
    HSQEvaluationGoodsListCell *cell = (HSQEvaluationGoodsListCell *)sender.superview.superview.superview;

    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];

//    HSQShopCarGoodsTypeListModel *ThirdModel = self.SecondModel.ordersGoodsVoList_array[indexPath.row];
    
    self.Index = indexPath.row;
    
    self.ClickIndex = sender.tag;
    
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
    
    HSQShopCarGoodsTypeListModel *ThirdModel = self.dataSource[self.Index];
    
    [ThirdModel.Select_Arrays replaceObjectAtIndex:self.ClickIndex withObject:iconImage];
    
    [self.tableView reloadData];

}


/**
 * @brief 取消键盘
 */
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    
    return YES;
}

/**
 * @brief 输入框结束编辑
 */
- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    HSQEvaluationGoodsListCell *cell = (HSQEvaluationGoodsListCell *)textField.superview.superview.superview.superview;
    
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
     HSQShopCarGoodsTypeListModel *ThirdModel = self.dataSource[indexPath.row];
    
    ThirdModel.RateContent_String = textField.text;
    
}

/**
 * @brief 评论星星的点击事件
 */
- (void)RateStarBtnClickActionEven:(UIButton *)sender{
    
    HSQEvaluationGoodsListCell *cell = (HSQEvaluationGoodsListCell *)sender.superview.superview.superview;
    
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
     HSQShopCarGoodsTypeListModel *ThirdModel = self.dataSource[indexPath.row];
    
    ThirdModel.RateStarCount = [NSString stringWithFormat:@"%ld",sender.tag - 200];
    
    [self.tableView reloadData];
}

/**
 * @brief 商品描述星星的点击事件
 */
- (void)TheProductDescribesTheStarClickEvent:(UIButton *)sender StarCount:(NSInteger)Count{
        
    NSString *string = [NSString stringWithFormat:@"%ld",Count];
    
    self.Miaoshu_StarCount = [NSString stringWithFormat:@"%.0f",string.floatValue];
}

/**
 * @brief 商品服务态度星星的点击事件
 */
- (void)CommodityServiceAttitudeStarClickEvent:(UIButton *)sender StarCount:(NSInteger)count{
    
        NSString *string = [NSString stringWithFormat:@"%ld",count];
    
    self.Server_StarCount = [NSString stringWithFormat:@"%.0f",string.floatValue];
}

/**
 * @brief 商品发货速度星星的点击事件
 */
- (void)ProductDeliverySpeedStarClickEvent:(UIButton *)sender StarCount:(NSInteger)count{
    
    NSString *string = [NSString stringWithFormat:@"%ld",count];
    
    self.SendGoods_StarCount = [NSString stringWithFormat:@"%.0f",string.floatValue];
}


/**
 * @brief 提交评价按钮的点击 KAddRateContentToServerUrl
 */
- (void)SubmitOrderRateContentButtonClickAction:(UIButton *)sender{
    
    [self.SelectRateImage_Array removeAllObjects];
    
    UIImage *imageV = [UIImage imageNamed:@"123"];
    
    NSData *data = UIImageJPEGRepresentation(imageV, 0.001f);
    
    for (NSInteger i = 0; i < self.dataSource.count; i++) {
        
        HSQShopCarGoodsTypeListModel *model = self.dataSource[i];
        
        [model.SelectRateImage_Arrays removeAllObjects];
        
        for (UIImage *image in model.Select_Arrays) {
            
            NSData *data1 = UIImageJPEGRepresentation(image, 0.001f);
            
            if (![data isEqual:data1]) {
                
                // 评价的图片
                [self.SelectRateImage_Array addObject:image];
                
                [model.SelectRateImage_Arrays addObject:image];
            }
        }
    }
    
    if (self.SelectRateImage_Array.count == 0) // 评论是没有图片，直接提交评论
    {
        // 2.将整体的评论提交到服务器
        [self UploadTheCommentsToTheServer];
    }
    else // 评论时有图片
    {
        // 1.现将图片提交到服务器
        [self NowSubmitTheImageToTheServer];
    }
}

/**
 * @brief 将评论的图片提交到服务器
 */
- (void)NowSubmitTheImageToTheServer{
    
    [self.SelectRateImageName_Array removeAllObjects];
    
    for (NSInteger i = 0; i < self.dataSource.count; i++) {
        
        HSQShopCarGoodsTypeListModel *model = self.dataSource[i];
        
//        [model.SelectRateImageName_Arrays removeAllObjects];
        
        for (NSInteger j = 0; j < model.SelectRateImage_Arrays.count; j++) {
            
            UIImage *iconimage = model.SelectRateImage_Arrays[j];
            
            NSDictionary *params = @{@"token":[HSQAccountTool account].token,@"file":iconimage};
            
            NSData *data = UIImageJPEGRepresentation(iconimage, 0.001f);
            
            NSString *fileName = [NSString stringWithFormat:@"img%ld.png",j+1];
            
            // 1.现将图片批量上传至服务器
            AFNetworkRequestTool *requestTool = [AFNetworkRequestTool shareRequestTool];
            
            [requestTool.manger POST:UrlAdress(KUpLoadPictureUrl) parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
                
                [formData appendPartWithFileData:data  name:@"file"fileName:fileName mimeType:@"image/jpg/png/jpeg"];
                
            } progress:^(NSProgress * _Nonnull uploadProgress) {
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                HSQLog(@"=====%@",responseObject);
                if ([responseObject[@"code"] integerValue] == 200)
                {
                    NSString *name = [NSString stringWithFormat:@"%@",responseObject[@"datas"][@"name"]];
                    [model.SelectRateImageName_Arrays replaceObjectAtIndex:j withObject:name];
                    
                    [self.SelectRateImageName_Array addObject:responseObject[@"datas"][@"name"]];
                    
                    if (self.SelectRateImageName_Array.count == self.SelectRateImage_Array.count) // 图片全部上传完成
                    {
                        // 2.将整体的评论提交到服务器
                        [self UploadTheCommentsToTheServer];
                        
                    }
                }
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
                [[HSQProgressHUDManger Manger] ShowProgressHUDPromptText:@"网络出问题啦" SupView:self.view];
                
            }];
        }
    }
    
}





/**
 * @brief 将评论的内容上传至服务器
 */
- (void)UploadTheCommentsToTheServer{
    
    // 评分数组
    NSMutableArray *scoreList = [NSMutableArray array];

    // 商品编号数组
    NSMutableArray *goodsIdList = [NSMutableArray array];

    // 订单商品编号数组
    NSMutableArray *orderGoodsIdList = [NSMutableArray array];

    // 商品的图片的名字
    NSMutableArray *imageList = [NSMutableArray array];
    
    // 商品是否匿名评价
    NSMutableArray *isAnonymousList = [NSMutableArray array];

    for (NSInteger i = 0; i < self.dataSource.count; i++) {

        HSQShopCarGoodsTypeListModel *model = self.dataSource[i];
        
        [isAnonymousList addObject:@"0"];

        // 评论的内容
        if (model.RateContent_String.length != 0)
        {
             [self.RateContent_Array addObject:model.RateContent_String];
        }

        [scoreList addObject:model.RateStarCount];

        [goodsIdList addObject:model.goodsId];

        [orderGoodsIdList addObject:model.commonId];

        // 评论的图片的名字
        NSString *imageName_String = [model.SelectRateImageName_Arrays componentsJoinedByString:@"_"];
        [imageList addObject:imageName_String];
    }

    HSQLog(@"==我的字典==%@",imageList);

    [[HSQProgressHUDManger Manger] ShowLoadingDataFromeServer:@"" ToView:self.view IsClearColor:YES];

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"token"] = [HSQAccountTool account].token;
    params[@"memberId"] = [HSQAccountTool account].memberId;
    params[@"memberName"] = [HSQAccountTool account].memberName;
    params[@"orderId"] = self.orderId;
    params[@"storeId"] = self.storeId;
    params[@"isAnonymousList"] = [isAnonymousList componentsJoinedByString:@","]; // 不匿名评价
    params[@"contentList"] = [self.RateContent_Array componentsJoinedByString:@","];  // 评论内容
    params[@"scoreList"] = [scoreList componentsJoinedByString:@","]; // 评分的数组---字符串类型
    params[@"descriptionCredit"] = self.Miaoshu_StarCount; // 店铺描述相符评分
    params[@"serviceCredit"] = self.Server_StarCount; // 店铺服务态度评分
    params[@"deliveryCredit"] = self.SendGoods_StarCount; // 店铺发货速度评分
    params[@"goodsIdList"] = [goodsIdList componentsJoinedByString:@","]; // 商品编号数组---字符串类型
    params[@"orderGoodsIdList"] = [orderGoodsIdList componentsJoinedByString:@","]; // 订单商品编号数组---字符串类型
    params[@"imageList"] = [imageList componentsJoinedByString:@","]; // 评论的图片--字符串类型
    params[@"isOwnShop"] = self.isOwnShop;  // 是否是自营店

    HSQLog(@"===%@",params);

    AFNetworkRequestTool *requestTool = [AFNetworkRequestTool shareRequestTool];

    [requestTool.manger POST:UrlAdress(KAddRateContentToServerUrl)  parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {

    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [[HSQProgressHUDManger Manger] DismissProgressHUD];

        HSQLog(@"==responseObject===%@",responseObject);
        if ([responseObject[@"code"] integerValue] == 200)  // 操作成功以后，进入追加评论
        {
            if (self.SelectFirstRateSuccessModel) {
                
                self.SelectFirstRateSuccessModel(@"200");
            }
            
            [self.navigationController popViewControllerAnimated:YES];
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




@end
