//
//  HSQMallHeiperTool.m
//  LiTianDecoration
//
//  Created by administrator on 2018/5/8.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import "HSQMallHeiperTool.h"
#import "HSQMallHomeDataModel.h"

@implementation HSQMallHeiperTool

/**
 * @brief 返回Item的个数
 */
+ (NSInteger)returnNumberWithModel:(HSQMallHomeDataModel *)dataModel{
    
    if ([dataModel.itemType isEqualToString:@"goods"]) // 为你推荐的商品列表
    {
        return dataModel.itemDataSource.count;
    }
    else if ([dataModel.itemType isEqualToString:@"home10"]) // 四列单行图片模块，4张图片160×210
    {
       return dataModel.itemDataSource.count;
    }
    else if ([dataModel.itemType isEqualToString:@"home9"]) // 左一右二竖排模块，3张图片，左侧1张大图320×210，右侧2张小图160×210
    {
        return dataModel.itemDataSource.count;
    }
    else if ([dataModel.itemType isEqualToString:@"home5"]) // 三列单行图片模块，3张图片213×260
    {
        return dataModel.itemDataSource.count;
    }
    else if ([dataModel.itemType isEqualToString:@"home4"] || [dataModel.itemType isEqualToString:@"home2"]) // 左二右一图片模块，3张图片，左侧2张小图320×130，右侧1张大图320×260
    {
        return 1;
    }
    else if ([dataModel.itemType isEqualToString:@"home3"]) // 双列多行图片模块，不限制数量图片每行2张320×85
    {
        return dataModel.itemDataSource.count;
    }
    else
    {
        return 0;
    }
}

/**
 * @brief 返回Item的大小
 */
+(CGSize)sizeForItemInModel:(HSQMallHomeDataModel *)dataModel index:(NSIndexPath *)indexPath{
    
    if ([dataModel.itemType isEqualToString:@"goods"]) // 为你推荐的商品列表
    {
        return CGSizeMake((KScreenWidth-2)/2, (KScreenWidth-5)/2);
    }
   else if ([dataModel.itemType isEqualToString:@"home10"]) // 四列单行图片模块，4张图片160×210
    {
        return CGSizeMake((KScreenWidth - 3) / 4, (KScreenWidth - 3) / 4 * (21 / 16));
    }
    else if ([dataModel.itemType isEqualToString:@"home9"]) // 左一右二竖排模块，3张图片，左侧1张大图320×210，右侧2张小图160×210
    {
        if (indexPath.row == 0)
        {
            return CGSizeMake((KScreenWidth - 2)/2, KScreenWidth * 21 / 64);
        }
        else
        {
            return CGSizeMake((KScreenWidth - 2)/4, KScreenWidth * 21 / 64);
        }
    }
    else if ([dataModel.itemType isEqualToString:@"home5"]) // 三列单行图片模块，3张图片213×260
    {
       return CGSizeMake((KScreenWidth - 2)/3, (KScreenWidth - 2)/3 * 260 / 213);
    }
    else if ([dataModel.itemType isEqualToString:@"home4"] || [dataModel.itemType isEqualToString:@"home2"]) // 左二右一图片模块，3张图片，左侧2张小图320×130，右侧1张大图320×260
    {
        return CGSizeMake(KScreenWidth, KScreenWidth * 26 / 64);
    }
    else if ([dataModel.itemType isEqualToString:@"home3"]) // 双列多行图片模块，不限制数量图片每行2张320×85
    {
        return CGSizeMake((KScreenWidth - 2)/2, KScreenWidth * 85 / 640);
    }
    else
    {
        return CGSizeMake(0, 0);
    }
}

/**
 * @brief 返回分区的大小
 */
+(CGSize)referenceSizeForHeaderInSection:(HSQMallHomeDataModel *)dataModel{
    
    if ([dataModel.itemType isEqualToString:@"ad"]) // 轮播图
    {
        return CGSizeMake(KScreenWidth, KScreenWidth/2);
    }
    else if ([dataModel.itemType isEqualToString:@"home7"]) // 标题或间隔型模块
    {
        return CGSizeMake(KScreenWidth, KScreenWidth * 5 / 64);
    }
    else if ([dataModel.itemType isEqualToString:@"home1"]) // 单列单张大图模块
    {
        return CGSizeMake(KScreenWidth, KScreenWidth * 26 / 64);
    }
    else if ([dataModel.itemType isEqualToString:@"text"]) // 跑马灯
    {
        return CGSizeMake(KScreenWidth, 50);
    }
    else if ([dataModel.itemType isEqualToString:@"home8"]) // 五列单行小图模块
    {
        if (dataModel.itemDataSource.count <= 5)
        {
             return CGSizeMake(KScreenWidth, KScreenWidth * 0.2);
        }
        else if (dataModel.itemDataSource.count <= 10)
        {
            return CGSizeMake(KScreenWidth, KScreenWidth * 0.4);
        }
        else
        {
            return CGSizeMake(KScreenWidth, KScreenWidth * 0.4 + 20);
        }
    }
    else
    {
        return CGSizeMake(0, 0);
    }
}

@end
