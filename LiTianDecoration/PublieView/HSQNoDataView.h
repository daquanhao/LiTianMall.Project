//
//  HSQNoDataView.h
//  ReservationBusiness
//
//  Created by nian on 2016/12/5.
//  Copyright © 2016年 hanshanquan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HSQNoDataView : UIView

- (instancetype)initWithTitle:(NSString *)title imageName:(NSString *)Name height:(CGFloat)Loginheight TopMargin:(CGFloat)TopY;

@property (strong, nonatomic) NSString *title;

@end
