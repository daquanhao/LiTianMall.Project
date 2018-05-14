//
//  HSQUserGenderView.h
//  LiTianDecoration
//
//  Created by administrator on 2018/4/18.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HSQUserGenderViewDelegate <NSObject>

- (void)SelectUserGenderfromeButton:(UIButton *)sender selectGender:(NSString *)gender Sex:(NSString *)sexNumber;

@end

@interface HSQUserGenderView : UIView

+ (instancetype)ShowUserGnederView;

/** 显示的数据源 */
@property (nonatomic, strong) NSArray *dataSource;

/** 选中的性别 */
@property (nonatomic, copy) NSString *SelectGender;

@property (nonatomic, weak) id <HSQUserGenderViewDelegate>delegate;

/** 显示视图 */
- (void)Show;

@end
