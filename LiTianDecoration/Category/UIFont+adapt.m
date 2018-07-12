//
//  UIFont+adapt.m
//  LiTianDecoration
//
//  Created by administrator on 2018/6/26.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import "UIFont+adapt.h"

@implementation UIFont (adapt)


//+(void)load{
//    
//    //获取替换后的类方法
//    Method newMethod = class_getClassMethod([self class], @selector(adjustFont:));
//    
//    //获取替换前的类方法
//    Method method = class_getClassMethod([self class], @selector(systemFontOfSize:));
//    
//    //然后交换类方法
//    method_exchangeImplementations(newMethod, method);
//}
//
//
//+(UIFont *)adjustFont:(CGFloat)fontSize{
//    
//    UIFont *newFont=nil;
//    
//    if ([UIDevice iPhonesModel] == iPhone6Plus){
//        
//        newFont = [UIFont adjustFont:fontSize + IPHONE6_INCREMENT];
//        
//    }else{
//        
//        newFont = [UIFont adjustFont:fontSize];
//    }
//    
//    return newFont;
//}

@end
