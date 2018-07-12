//
//  HSQShopCarManger.m
//  LiTianDecoration
//
//  Created by administrator on 2018/5/18.
//  Copyright © 2018年 administrator. All rights reserved.
//


#import "HSQShopCarManger.h"
#import "HSQShopCarGoodsListModel.h"
#import <FMDB.h>

@interface HSQShopCarManger ()

{
     FMDatabase  *_db;
}

@end

@implementation HSQShopCarManger

/**
 * @brief 初始化单例
 */
+ (instancetype)sharedShopCarManger{
    
    static HSQShopCarManger *Single = nil;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        Single = [[HSQShopCarManger alloc] init];
        
        [Single initDataBase];
        
    });
    
    return Single;
}

/**
 * @brief 将字典或者数组转化为JSON串
 * @param theData 要转化的数据
 */
- (NSString *)toJSONDataString:(id)theData{
    
    NSError *error = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:theData options:NSJSONReadingMutableLeaves | NSJSONReadingAllowFragments error:nil];
    
    NSString *JsonString = [[NSString alloc] initWithData:jsonData encoding:(NSUTF8StringEncoding)];
    
    if ([JsonString length]&&error== nil)
    {
        return JsonString;
    }
    else
    {
        return nil;
    }
}

/**
 * @brief 将字典转化为JSON串
 * @param theDataDiction 要转化的数据NSJSONReadingMutableContainers
 */
- (NSString *)toJSONDataStringWithDiction:(NSDictionary *)theDataDiction{
    
    NSError *error = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:theDataDiction options:NSJSONWritingPrettyPrinted error:nil];
    
    NSString *JsonString = [[NSString alloc] initWithData:jsonData encoding:(NSUTF8StringEncoding)];
    
    if ([JsonString length]&&error== nil)
    {
        return JsonString;
    }
    else
    {
        return nil;
    }
}


-(void)initDataBase{
    
    // 获得Documents目录路径
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    
    // 文件路径
    NSString *filePath = [documentsPath stringByAppendingPathComponent:@"model.sqlite"];
    
    HSQLog(@"=文件路径==%@",filePath);
    
    // 实例化FMDataBase对象
    _db = [FMDatabase databaseWithPath:filePath];
    
    [_db open];
    
    // 初始化数据表
    NSString *personSql = @"CREATE TABLE 'person' ('id' INTEGER PRIMARY KEY AUTOINCREMENT  NOT NULL ,'goodsId' VARCHAR(255),'commonId' VARCHAR(255),'buyData' VARCHAR(255),'cartData'VARCHAR(255),'buyNum' VARCHAR(255)) ";
    
    //监测数据库中我要需要的表是否已经存在
    NSString *existsSql = [NSString stringWithFormat:@"select count(name) as countNum from sqlite_master where type = 'table' and name = '%@'", @"person" ];
    
    FMResultSet *rs = [_db executeQuery:existsSql];
    
    if ([rs next])
    {
        NSInteger count = [rs intForColumn:@"countNum"];
        
        NSLog(@"The table count: %li", count);
        
        if (count == 1)
        {
            NSLog(@"存在");
        }
        else
        {
             [_db executeUpdate:personSql];
        }
    }
    
    [_db close];
    
}

/**
 *  @brief 查询某个商品是否存在
 *  @param Goods_id 商品的ID
 */
- (BOOL)LoookUpGoodsIsExitWithGoods_id:(NSString *)Goods_id{
    
    BOOL Isexit = NO;
    
    FMResultSet *set = [_db executeQuery:@"select * from person where goodsId = ?", Goods_id];
    
    while ([set next])
    {
        Isexit = YES;
    }

    return Isexit;
}


/**
 * @brief 根据商品的id取出商品的模型
 */
- (HSQShopCarGoodsListModel *)TakeOutTheModelOfTheProductAccordingToTheIdOfTheProduct:(NSString *)GoodsId{
    
    [_db open];
    
    HSQShopCarGoodsListModel *goodsModel = [[HSQShopCarGoodsListModel alloc] init];
    
    //根据条件查询
    FMResultSet *resultSet = [_db executeQuery:@"select * from person where goodsId = ?", GoodsId];
    
    //遍历结果集合
    while ([resultSet  next])
    {
        goodsModel.goodsId = [resultSet stringForColumn:@"goodsId"];
        
        goodsModel.buyData = [resultSet stringForColumn:@"buyData"];
        
        goodsModel.cartData = [resultSet stringForColumn:@"cartData"];
        
        goodsModel.commonId = [resultSet stringForColumn:@"commonId"];
        
        goodsModel.buyNum = [resultSet stringForColumn:@"buyNum"];
    }
    
    [_db close];
    
    return goodsModel;
}

/**
 * @brief 根据商品的SKU查询商品的个数
 */
- (NSMutableArray *)ChaXunGoodsCountWithCommondId:(NSString *)commond_id{
    
        [_db open];
    
      NSMutableArray *dataArray = [[NSMutableArray alloc] init];
    
    // 根据条件查询
     FMResultSet *res = [_db executeQuery:@"select * from person where commonId = ?", commond_id];
    
    while ([res next]) {
        
        HSQShopCarGoodsListModel *goodsModel = [[HSQShopCarGoodsListModel alloc] init];
        
        goodsModel.goodsId = [res stringForColumn:@"goodsId"];
        
        goodsModel.buyData = [res stringForColumn:@"buyData"];
        
        goodsModel.cartData = [res stringForColumn:@"cartData"];
        
        goodsModel.commonId = [res stringForColumn:@"commonId"];
        
        goodsModel.buyNum = [res stringForColumn:@"buyNum"];
        
        [dataArray addObject:goodsModel];
        
    }
    
    [_db close];
    
    return dataArray;
}

/**
 * @brief 添加商品的模型
 */
- (void)addGoodsModel:(HSQShopCarGoodsListModel *)GoodModel{
    
    [_db open];
    
    BOOL IsSucess = [_db executeUpdate:@"INSERT INTO person(commonId,goodsId,buyData,cartData,buyNum)VALUES(?,?,?,?,?)",GoodModel.commonId,GoodModel.goodsId,GoodModel.buyData,GoodModel.cartData,GoodModel.buyNum];
    
    if (IsSucess)
    {
        HSQLog(@"===添加成功");
    }
    else
    {
        HSQLog(@"===添加失败");
    }

    [_db close];
    
}

/**
 * @brief 根据商品的SKU删除模型
 */
- (void)RemoveGoodsModel:(NSString *)commonId{
    
    [_db open];
    
    [_db executeUpdate:@"DELETE FROM person WHERE commonId = ?",commonId];
    
    [_db close];
}

/**
 * @brief 删除商品的模型
 */
- (void)deleteGoodsModel:(HSQShopCarGoodsListModel *)GoodModel{
    
    [_db open];
    
    [_db executeUpdate:@"DELETE FROM person WHERE goodsId = ?",GoodModel.goodsId];
    
    [_db close];
}



/**
 * @brief 更新商品的数据
 */
- (void)updatePGoodsModel:(HSQShopCarGoodsListModel *)GoodModel{
    
    [_db open];
    
    [_db executeUpdate:@"UPDATE 'person' SET buyData = ?  WHERE goodsId = ? ",GoodModel.buyData,GoodModel.goodsId];
    
    [_db executeUpdate:@"UPDATE 'person' SET cartData = ?  WHERE goodsId = ? ",GoodModel.cartData,GoodModel.goodsId];
    
    [_db executeUpdate:@"UPDATE 'person' SET buyNum = ?  WHERE goodsId = ? ",GoodModel.buyNum,GoodModel.goodsId];

    [_db close];
}

/**
 * @brief 取出数据库中所有的数据
 */
- (NSMutableArray *)getAllGoodsModel{
    
    [_db open];
    
    NSMutableArray *dataArray = [[NSMutableArray alloc] init];
    
    FMResultSet *res = [_db executeQuery:@"SELECT * FROM person"];
    
    while ([res next]) {
        
        HSQShopCarGoodsListModel *goodsModel = [[HSQShopCarGoodsListModel alloc] init];
        
        goodsModel.goodsId = [res stringForColumn:@"goodsId"];
        
        goodsModel.buyData = [res stringForColumn:@"buyData"];
        
        goodsModel.cartData = [res stringForColumn:@"cartData"];
        
        goodsModel.commonId = [res stringForColumn:@"commonId"];
        
        goodsModel.buyNum = [res stringForColumn:@"buyNum"];

        [dataArray addObject:goodsModel];
        
    }
    
    [_db close];

    return dataArray;

}

/**
 * @brief 清除所有的数据
 */
- (void)ClearAllDataFromeFMDB{
    
    [_db open];
    
    BOOL Successful = [_db executeUpdate:@"DELETE FROM person"];
    
    if (Successful == YES)
    {
        HSQLog(@"====数据库删除成功");
    }
    else
    {
        HSQLog(@"====数据库删除失败");
    }
    
    [_db close];
}


















@end
