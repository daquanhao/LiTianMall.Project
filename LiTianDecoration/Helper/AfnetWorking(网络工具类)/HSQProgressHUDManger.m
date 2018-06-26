//
//  HSQProgressHUDManger.m
//  LiTianDecoration
//
//  Created by administrator on 2018/4/16.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import "HSQProgressHUDManger.h"

@interface HSQProgressHUDManger ()

@property (nonatomic, strong) MBProgressHUD *HUD;

@end

@implementation HSQProgressHUDManger

/**
 * @brief 初始化一个单利
 */
+ (HSQProgressHUDManger *)Manger{
    
    static HSQProgressHUDManger *singleton = nil;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        singleton = [[HSQProgressHUDManger alloc] init];
        
        [singleton CreatHUD];
    });
    
    return singleton;
}

- (void)CreatHUD{
    
    MBProgressHUD *HUD = [[MBProgressHUD alloc] init];
    self.HUD = HUD;
}

/**
 * @brief 只显示提示文字
 */
- (void)ShowProgressHUDPromptText:(NSString *)string SupView:(UIView *)SuperView{
    
     MBProgressHUD *HUD = [[MBProgressHUD alloc] init];
    [SuperView addSubview:HUD];
    
    //1,设置显示的模式
    HUD.mode = MBProgressHUDModeText; //只显示文本
    
    //2,设置背景框的背景颜色是透明的
    HUD.bezelView.backgroundColor = [UIColor blackColor];
    
    //3,设置提示信息 信息颜色，字体
    HUD.label.textColor = [UIColor whiteColor];
    HUD.label.font = [UIFont systemFontOfSize:14];
    HUD.label.text = string;
    HUD.label.numberOfLines = 0;
    
    //4，设置提示框的相对于父视图中心点的便宜，正值 向右下偏移，负值左上
    [HUD setOffset:CGPointMake(0, -64)];
    
    //5,设置显示和隐藏动画类型  有三种动画效果，如下
    HUD.animationType = MBProgressHUDAnimationFade; //默认类型的，渐变

    // 6.显示加载框
    [HUD showAnimated:YES];
    
    // 7.隐藏加载框
    [HUD hideAnimated:YES afterDelay:2.0f];
    
}

/**
 * @brief 显示加载数据成功
 */
- (void)ShowLoadDataSuccessWithPlaceholderString:(NSString *)SuccessString SuperView:(UIView *)superView{
  
    [self show:SuccessString icon:@"SuccessFul" view:superView];
    
}

/**
 * @brief 显示加载数据失败
 */
- (void)ShowDisplayFailedToLoadData:(NSString *)ErrorString SuperView:(UIView *)superView{
    
    [self DismissProgressHUD];
    
    [self show:ErrorString icon:@"ErrorIcon" view:superView];
    
}

/**
 *  显示信息
 *
 *  @param text 信息内容
 *  @param icon 图标
 *  @param view 显示的视图
 */
- (void)show:(NSString *)text icon:(NSString *)icon view:(UIView *)view{
    
    if (view == nil) view = [[UIApplication sharedApplication].windows lastObject];
    
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    
    // 背景框的颜色
     hud.bezelView.backgroundColor = [UIColor blackColor];
    
    // 设置图片
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:icon]];
    
    // 再设置模式
    hud.mode = MBProgressHUDModeCustomView;
    
    // 修改文字的颜色
    hud.label.textColor = [UIColor whiteColor];
    hud.label.font = [UIFont systemFontOfSize:15.0f];
    hud.label.text = text;
    
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    
    // 1秒之后再消失
    [hud hideAnimated:YES afterDelay:2.0];
}


/**
 * @brief 现在正在加载的等待框
 */
- (void)ShowLoadingDataFromeServer:(NSString *)loadText ToView:(UIView *)SuperView IsClearColor:(BOOL)ClearColor{

    [SuperView addSubview:self.HUD];

    //2,设置背景框的背景颜色是透明的
    if (ClearColor == YES)
    {
        self.HUD.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
        self.HUD.bezelView.backgroundColor = [UIColor clearColor];
        //6，设置菊花颜色  只能设置菊花的颜色
        if (@available(iOS 9.0, *))
        {
            [UIActivityIndicatorView appearanceWhenContainedInInstancesOfClasses:@[[MBProgressHUD class]]].color = [UIColor grayColor];
            
            [UIActivityIndicatorView appearanceWhenContainedInInstancesOfClasses:@[[MBProgressHUD class]]].activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
        }
    }
    else
    {
        self.HUD.bezelView.backgroundColor = [UIColor blackColor];
        // 6，设置菊花颜色  只能设置菊花的颜色
        if (@available(iOS 9.0, *))
        {
            [UIActivityIndicatorView appearanceWhenContainedInInstancesOfClasses:@[[MBProgressHUD class]]].color = [UIColor whiteColor];
            
            [UIActivityIndicatorView appearanceWhenContainedInInstancesOfClasses:@[[MBProgressHUD class]]].activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
        }
    }
    
    //4,设置提示信息 信息颜色，字体
    if (loadText.length != 0 || loadText != nil)
    {
        self.HUD.label.textColor = [UIColor whiteColor];
        self.HUD.label.font = [UIFont systemFontOfSize:15];
        self.HUD.label.text = loadText;
    }

    //9，设置提示框的相对于父视图中心点的便宜，正值 向右下偏移，负值左上
    [self.HUD setOffset:CGPointMake(0, -KSafeTopeHeight/2)];

    //14,设置显示和隐藏动画类型  有三种动画效果，如下
    self.HUD.animationType = MBProgressHUDAnimationZoomOut; //HUD的整个view后退 然后逐渐的后退

    //16,设置隐藏的时候是否从父视图中移除，默认是NO
    self.HUD.removeFromSuperViewOnHide = YES;
    
    [self.HUD showAnimated:YES];

}

/**
 * @brief 隐藏提示框
 */
- (void)DismissProgressHUD{
    
    [self.HUD hideAnimated:YES];
}





























- (void)text{
//    MBProgressHUD *HUD = [[MBProgressHUD alloc] init];
//    [SuperView addSubview:HUD];
//    
//    //2,设置背景框的背景颜色是透明的
//    //    HUD.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
//    //    HUD.bezelView.backgroundColor = [UIColor clearColor];
//    HUD.bezelView.backgroundColor = [UIColor blackColor];
//    
//    //3,设置背景框的圆角值，默认是10
//    //    HUD.bezelView.layer.cornerRadius = 20.0;
//    
//    //4,设置提示信息 信息颜色，字体
//    HUD.label.textColor = [UIColor blueColor];
//    HUD.label.font = [UIFont systemFontOfSize:13];
//    HUD.label.text = @"Loading...";
//    
//    //5,设置提示信息详情 详情颜色，字体
//    HUD.detailsLabel.textColor = [UIColor blueColor];
//    HUD.detailsLabel.font = [UIFont systemFontOfSize:13];
//    HUD.detailsLabel.text = @"LoadingLoading...";
//    
//    //6，设置菊花颜色  只能设置菊花的颜色
//    [UIActivityIndicatorView appearanceWhenContainedInInstancesOfClasses:@[[MBProgressHUD class]]].color = [UIColor purpleColor];
//    
//    //7,设置一个渐变层
//    HUD.backgroundView.color = [[UIColor orangeColor] colorWithAlphaComponent:0.3];
//    
//    //8,设置动画的模式
//    //    HUD.mode = MBProgressHUDModeIndeterminate;//菊花，默认值
//    //    HUD.mode = MBProgressHUDModeDeterminate;//圆饼，饼状图
//    //    HUD.mode = MBProgressHUDModeDeterminateHorizontalBar;//进度条
//    //     HUD.mode = MBProgressHUDModeAnnularDeterminate;//圆环作为进度条
//    //    HUD.mode = MBProgressHUDModeCustomView; //需要设置自定义视图时候设置成这个
//    HUD.mode = MBProgressHUDModeText; //只显示文本
//    
//    //9，设置提示框的相对于父视图中心点的便宜，正值 向右下偏移，负值左上
//    [HUD setOffset:CGPointMake(0, -100)];
//    
//    //10，设置各个元素距离矩形边框的距离
//    HUD.margin = 0;
//    
//    //11，背景框的大小
//    HUD.minSize = CGSizeMake(150, 150);
//    
//    //12设置背景框的实际大小   readonly
//    //    CGSize size = HUD.bezelView.frame.size;
//    
//    //13,是否强制背景框宽高相等
//    HUD.square = YES;
//    
//    //14,设置显示和隐藏动画类型  有三种动画效果，如下
//    HUD.animationType = MBProgressHUDAnimationFade; //默认类型的，渐变
//    //        HUD.animationType = MBProgressHUDAnimationZoomOut; //HUD的整个view后退 然后逐渐的后退
//    //    HUD.animationType = MBProgressHUDAnimationZoomIn; //和上一个相反，前近，最后淡化消失
//    
//    //15,设置最短显示时间，为了避免显示后立刻被隐藏   默认是0
//    //        HUD.minShowTime = 10;
//    
//    //16,设置隐藏的时候是否从父视图中移除，默认是NO
//    HUD.removeFromSuperViewOnHide = NO;
//    
//    //17,隐藏时候的回调 隐藏动画结束之后
//    HUD.completionBlock = ^(){
//        
//        NSLog(@"abnnfsfsf");
//        
//    };
//    
//    
//    
//    
//    [HUD showAnimated:YES];
//    
//    [HUD hideAnimated:YES afterDelay:3.0f];
}


@end
