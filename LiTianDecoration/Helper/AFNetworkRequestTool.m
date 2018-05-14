//
//  AFNetworkRequestTool.m
//  LiTianDecoration
//
//  Created by administrator on 2018/4/9.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import "AFNetworkRequestTool.h"

@implementation AFNetworkRequestTool

+ (AFNetworkRequestTool *)shareRequestTool{
    
    static AFNetworkRequestTool *Single = nil;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        Single = [[AFNetworkRequestTool alloc] init];
        
        AFHTTPSessionManager *manger = [AFHTTPSessionManager manager];
//        manger.requestSerializer = [AFHTTPRequestSerializer serializer];
//        manger.responseSerializer = [AFHTTPResponseSerializer serializer];
        manger.requestSerializer.timeoutInterval = 30;
        Single.manger = manger;
        
    });
    
    return Single;
}


@end
