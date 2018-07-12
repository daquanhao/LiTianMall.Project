//
//  HSQStoreCollectionListDataModel.m
//  LiTianDecoration
//
//  Created by administrator on 2018/6/29.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import "HSQStoreCollectionListDataModel.h"

@implementation HSQNewGoodsListModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
    
}

@end

@implementation HSQStoreCollectionListDataModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
    if ([key isEqualToString:@"newGoodsList"]) {
        
        self.StoreNewGoodsList = value[@"newGoodsList"];
        
    }
}

@end
