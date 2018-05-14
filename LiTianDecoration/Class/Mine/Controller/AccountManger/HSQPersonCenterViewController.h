//
//  HSQPersonCenterViewController.h
//  LiTianDecoration
//
//  Created by administrator on 2018/4/18.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^UpLoadSuccess)(id Url);

@interface HSQPersonCenterViewController : UIViewController

@property (nonatomic, copy) UpLoadSuccess Success;

@end
