//
//  HSQPinTuanDataDealTool.m
//  LiTianDecoration
//
//  Created by administrator on 2018/5/9.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import "HSQPinTuanDataDealTool.h"

@interface HSQPinTuanDataDealTool ()

@property (nonatomic, copy) NSString *IsCollection;

@property (nonatomic, copy) NSString *ImageName;

@end

@implementation HSQPinTuanDataDealTool

/**
 * @brief 初始化一个单利
 */
+ (HSQPinTuanDataDealTool *)shareDataDealTool{
    
    static HSQPinTuanDataDealTool *Single = nil;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        Single = [[HSQPinTuanDataDealTool alloc] init];
        
    });
    
    return Single;
}

/**
 * brief 返回是否收藏的字段  0代表没有收藏 1代表收藏
 */
- (NSString *)IsCollectionString:(NSString *)commonId  token:(NSString *)token View:(UIView *)SupView{
    
    NSDictionary *params = @{@"token":token,@"commonId":commonId};
    
    AFNetworkRequestTool *requestTool = [AFNetworkRequestTool shareRequestTool];
    
    [requestTool.manger POST:UrlAdress(KCheckIsCollectionGoodsUrl) parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

        if ([responseObject[@"code"] integerValue] == 200)
        {
            self.IsCollection = [NSString stringWithFormat:@"%@",responseObject[@"datas"][@"isExist"]];
        }
        else
        {
            NSString *errorString = [NSString stringWithFormat:@"%@",responseObject[@"datas"][@"error"]];
            
            [[HSQProgressHUDManger Manger] ShowDisplayFailedToLoadData:errorString SuperView:SupView];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [[HSQProgressHUDManger Manger] ShowDisplayFailedToLoadData:@"检测是否收藏数据加载失败" SuperView:SupView];
    }];
    
    return self.IsCollection;
}

/**
 * @brief 返回是否收藏的图片
 */
- (NSString *)imageNameWithIsCollection:(NSString *)isCollection{
    
    if (isCollection.integerValue == 0)
    {
        return @"Shape";
    }
    else
    {
        return @"xin";
    }
}

/**
 * @brief 收藏某商品
 */
- (NSString *)AddCollectionGoodsToServer:(NSString *)token  goodsId:(NSString *)commonId supView:(UIView *)SupView State:(NSString *)CollectionState{
    
    [[HSQProgressHUDManger Manger] ShowLoadingDataFromeServer:@"" ToView:SupView IsClearColor:YES];
    
    NSString *url = (CollectionState.integerValue == 0 ? UrlAdress(KAddCollectionGoodsUrl) : UrlAdress(KCancelCollectionGoodsUrl));
    
    NSDictionary *params = @{@"token":token,@"commonId":commonId};
    
    AFNetworkRequestTool *requestTool = [AFNetworkRequestTool shareRequestTool];
    
    [requestTool.manger POST:url parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        HSQLog(@"==收藏商品==%@==%@",responseObject,CollectionState);
        
        [[HSQProgressHUDManger Manger] DismissProgressHUD];
        
        if ([responseObject[@"code"] integerValue] == 200)
        {
            if (CollectionState.integerValue == 0)
            {
                 self.ImageName = @"1";
            }
            else
            {
                 self.ImageName = @"0";
            }
        }
        else
        {
            self.ImageName = CollectionState;
            
            NSString *errorString = [NSString stringWithFormat:@"%@",responseObject[@"datas"][@"error"]];
            
            [[HSQProgressHUDManger Manger] ShowDisplayFailedToLoadData:errorString SuperView:SupView];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        self.ImageName = CollectionState;
        
        [[HSQProgressHUDManger Manger] ShowDisplayFailedToLoadData:@"数据加载失败" SuperView:SupView];
    }];
    
    return self.ImageName;
}
















@end
