//
//  HSQOtherAdressView.h
//  LiTianDecoration
//
//  Created by administrator on 2018/7/6.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HSQOtherAdressView : UIView

/**
 * @brief 选中地址的回调
 */
@property (nonatomic, copy) void(^chooseFinish)(id string, id proId, id cityId, id areaId);

@end
