//
//  HSQAdressListModel.h
//  LiTianDecoration
//
//  Created by administrator on 2018/4/18.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HSQAdressListModel : NSObject

//areaDeep = 1;
//areaId = 1;
//areaName = "\U5317\U4eac";
//areaParentId = 0;
//areaRegion = "\U534e\U5317";

@property (nonatomic, copy) NSString *areaDeep;

@property (nonatomic, copy) NSString *areaId;

@property (nonatomic, copy) NSString *areaName;

@property (nonatomic, copy) NSString *areaParentId;

@property (nonatomic, copy) NSString *areaRegion;

@property (nonatomic,assign) BOOL  isSelected;

@end
