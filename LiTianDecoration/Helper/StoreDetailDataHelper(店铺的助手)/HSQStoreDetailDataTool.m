//
//  HSQStoreDetailDataTool.m
//  LiTianDecoration
//
//  Created by administrator on 2018/5/16.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import "HSQStoreDetailDataTool.h"
#import "HSQStoreDetailHomeHeadReusableView.h"
#import "HSQStoreDetailHeadTitleReusableView.h"

@implementation HSQStoreDetailDataTool

/**
 * @brief 初始化一个单利
 */
+ (HSQStoreDetailDataTool *)shareStoreDetailDataTool{
    
    static HSQStoreDetailDataTool *Single = nil;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        Single = [[HSQStoreDetailDataTool alloc] init];
        
    });
    
    return Single;
}

/**
 * @brief 根据标示返回店铺首页，全部商品，商品上新，店铺活动模块的分区数
 * @params ModelType 1.代表店铺首页 2.代表全部商品 3.商品上新 4.代表店铺活动
 */
- (NSInteger)ReturnCollectionSection:(NSString *)ModelType Array:(NSArray *)dataSource ZheKouArray:(NSArray *)ZheKouSource{
    
    if (ModelType.integerValue == 1)  // 店铺首页
    {
        return 3;
    }
    else  if (ModelType.integerValue == 2) // 全部商品
    {
        return 2;
    }
    else  if (ModelType.integerValue == 3) // 商品上新
    {
        return dataSource.count+1;
    }
    else // 店铺活动
    {
        return dataSource.count + 1;
    }
}

/**
 * @brief 根据标示返回店铺首页，全部商品，商品上新，店铺活动模块每个分区的items
 * @params ModelType 1.代表店铺首页 2.代表全部商品 3.商品上新 4.代表店铺活动
 */
- (NSInteger)numberOfItemsInSection:(NSInteger)section dataSource:(NSArray *)array  SecondArray:(NSArray *)SecondArr modelType:(NSString *)ModelType{
    
    if (ModelType.integerValue == 1) // 店铺首页
    {
        if (section == 0)
        {
            return 0;
        }
        else if (section == 1)
        {
            return 1;
        }
        else
        {
            return array.count;
        }
    }
    if (ModelType.integerValue == 2) // 全部商品
    {
        if (section == 0)
        {
            return 0;
        }
        else
        {
            return array.count;
        }
    }
    else if (ModelType.integerValue == 3) // 商品上新
    {
        if (section == 0)
        {
            return 0;
        }
        else
        {
//            NSDictionary *diction = array[section - 1];
//
//            return [diction[@"goodsList"] count];
            
            return array.count;
        }
    }
    else // 店铺活动
    {
        if (section == 0)
        {
            return 0;
        }
        else
        {
            return 1;
        }
    }
}

/**
 * @brief 根据标示返回店铺首页，全部商品，商品上新，店铺活动模块每个分区的尺寸
 * @params ModelType 1.代表店铺首页 2.代表全部商品 3.商品上新 4.代表店铺活动
 */
- (CGSize)referenceSizeForHeaderInSection:(NSInteger)section modelType:(NSString *)ModelType{
    
    if (ModelType.integerValue == 1 || ModelType.integerValue == 3) // 店铺首页，商品上新
    {
        if (section == 0)
        {
            return CGSizeMake(KScreenWidth, 0.3 * KScreenWidth +65);
        }
        else
        {
            return CGSizeMake(KScreenWidth,50);
        }
    }
    if (ModelType.integerValue == 2) // 全部商品
    {
        if (section == 0)
        {
            return CGSizeMake(KScreenWidth, 0.3 * KScreenWidth + 65);
        }
        else
        {
            return CGSizeMake(KScreenWidth,45);
        }
    }
    else // 店铺活动
    {
        if (section == 0)
        {
            return CGSizeMake(KScreenWidth, 0.3 * KScreenWidth +65);
        }
        else
        {
            return CGSizeMake(KScreenWidth,10);
        }
    }
}

/**
 * @brief 根据标示返回店铺首页，全部商品，商品上新，店铺活动模块每个分区的items的尺寸
 * @params ModelType 1.代表店铺首页 2.代表全部商品 3.商品上新 4.代表店铺活动
 */
- (CGSize)sizeForItemAtIndexPath:(NSIndexPath *)indexPath modelType:(NSString *)ModelType{
    
    if (ModelType.integerValue == 1) // 店铺首页
    {
        if (indexPath.section == 0)
        {
            return CGSizeMake(0, 0);
        }
        else if (indexPath.section == 1)
        {
            return  CGSizeMake(KScreenWidth, KScreenWidth * 0.6 + 45);
        }
        else
        {
            return  CGSizeMake((KScreenWidth-2)/2, (KScreenWidth-2)/2);
        }
    }
    else
    {
        return CGSizeMake(0,0);
    }
}



@end
