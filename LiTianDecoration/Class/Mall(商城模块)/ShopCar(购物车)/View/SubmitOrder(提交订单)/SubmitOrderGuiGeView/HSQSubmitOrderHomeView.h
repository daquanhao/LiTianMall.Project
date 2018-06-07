//
//  HSQSubmitOrderHomeView.h
//  LiTianDecoration
//
//  Created by administrator on 2018/5/25.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HSQSubmitOrderHomeView : UIView

/**
 * @brief 数据源数据
 */
@property (nonatomic, strong) NSArray *GuiGeData_Array;

/**
 * @brief 根据数组返回view的尺寸
 */
+(CGSize)SizeWithDataModelArray:(NSArray *)dataSource;

@end
