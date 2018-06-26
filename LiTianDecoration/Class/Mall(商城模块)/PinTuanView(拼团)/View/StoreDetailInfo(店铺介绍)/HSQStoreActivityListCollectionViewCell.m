//
//  HSQStoreActivityListCollectionViewCell.m
//  LiTianDecoration
//
//  Created by administrator on 2018/5/16.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import "HSQStoreActivityListCollectionViewCell.h"

@interface HSQStoreActivityListCollectionViewCell ()

@property (nonatomic, strong) UIView *BgView;

@property (nonatomic, strong) UILabel *ActivityType_Label; // 活动的类型，满优惠还是限时折扣

@property (nonatomic, strong) UILabel *activityTime_Label; // 活动的时间

@property (nonatomic, strong) UILabel *activityContent_Label; // 活动的内容

@property (nonatomic, strong) UILabel *JiangPlacher_Label; // 降字的提示标语

@property (nonatomic, strong) UILabel *BottomPlacher_Label; // 底部的提示标语


@end

@implementation HSQStoreActivityListCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        self.contentView.backgroundColor = [UIColor clearColor];
        
        // 添加视图的控件
        [self SetUpView];
        
        // 添加控件的约束
        [self setUpViewLayOut];
    }
    
    return self;
}

/**
 * @brief 添加视图的控件
 */
- (void)SetUpView{
    
    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:bgView];
    self.BgView = bgView;
    
    // 活动的标题
    UILabel *ActivityType_Label = [[UILabel alloc] init];
    ActivityType_Label.font = [UIFont systemFontOfSize:14.0];
    ActivityType_Label.backgroundColor = [UIColor redColor];
    ActivityType_Label.textColor = [UIColor whiteColor];
    [bgView addSubview:ActivityType_Label];
    self.ActivityType_Label = ActivityType_Label;
    
    // 活动的时间
    UILabel *activityTime_Label = [[UILabel alloc] init];
    activityTime_Label.text = @"活动时间：2017-12-12 10:53:36 至 2018-12-12 10:53:36";
    activityTime_Label.font = [UIFont systemFontOfSize:12.0];
    [bgView addSubview:activityTime_Label];
    self.activityTime_Label = activityTime_Label;
    
    // 活动的内容
    UILabel *activityContent_Label = [[UILabel alloc] init];
    activityContent_Label.text = @" 单笔订单消费满¥2000，立减¥200.免邮费，送面额100元优惠券，送赠品 ";
    activityContent_Label.font = [UIFont systemFontOfSize:14.0];
    activityContent_Label.backgroundColor = RGB(238, 58, 68);
    activityContent_Label.textColor = [UIColor whiteColor];
    activityContent_Label.numberOfLines = 0;
    [bgView addSubview:activityContent_Label];
    self.activityContent_Label = activityContent_Label;
    
//    // 降字的提示标语
//    UILabel *JiangPlacher_Label = [[UILabel alloc] init];
//    JiangPlacher_Label.text = @" 降 ";
//    JiangPlacher_Label.textColor = [UIColor whiteColor];
//    JiangPlacher_Label.backgroundColor = RGB(238, 58, 68);
//    JiangPlacher_Label.font = [UIFont systemFontOfSize:12.0];
//    [bgView addSubview:JiangPlacher_Label];
//    self.JiangPlacher_Label = JiangPlacher_Label;
//
//    // 底部的提示标语
//    UILabel *BottomPlacher_Label = [[UILabel alloc] init];
//    BottomPlacher_Label.text = @" 单笔订单消费满¥2000，立减¥200.免邮费，送面额100元优惠券，送赠品 ";
//    BottomPlacher_Label.font = [UIFont systemFontOfSize:12.0];
//    BottomPlacher_Label.textColor = RGB(150, 150, 150);
//    BottomPlacher_Label.numberOfLines = 0;
//    [bgView addSubview:BottomPlacher_Label];
//    self.BottomPlacher_Label = BottomPlacher_Label;
}

/**
 * @brief 添加控件的约束
 */
- (void)setUpViewLayOut{
    
    self.BgView.sd_layout.leftSpaceToView(self.contentView, 0).topSpaceToView(self.contentView, 5).rightSpaceToView(self.contentView, 0).bottomSpaceToView(self.contentView, 0);
    
    // 活动的类型
    self.ActivityType_Label.sd_layout.leftSpaceToView(self.BgView, 10).topSpaceToView(self.BgView, 10).heightIs(20).autoWidthRatio(0);
    [self.ActivityType_Label setSingleLineAutoResizeWithMaxWidth:KScreenWidth - 20];
    
    // 活动的时间
    self.activityTime_Label.sd_layout.leftSpaceToView(self.BgView, 10).rightSpaceToView(self.BgView, 0).topSpaceToView(self.ActivityType_Label, 10).heightIs(20);
    
    // 活动的内容
    self.activityContent_Label.sd_layout.leftEqualToView(self.activityTime_Label).rightEqualToView(self.activityTime_Label).topSpaceToView(self.activityTime_Label, 10).autoHeightRatio(0);
    
//    // 降字的提示标语
//    self.JiangPlacher_Label.sd_layout.leftEqualToView(self.activityTime_Label).topSpaceToView(self.activityContent_Label, 10).autoWidthRatio(0).autoHeightRatio(0);
//    [self.JiangPlacher_Label setSingleLineAutoResizeWithMaxWidth:60];
//    
//    // 底部的提示标语
//    self.BottomPlacher_Label.sd_layout.leftSpaceToView(self.JiangPlacher_Label, 0).topEqualToView(self.JiangPlacher_Label).rightSpaceToView(self.BgView, 10).autoHeightRatio(0);
    
}


/**
 * @brief 店铺限时折扣活动的数据
 */
- (void)setDiscountList_diction:(NSDictionary *)discountList_diction{
    
    _discountList_diction = discountList_diction;
    
    // 标题
    self.ActivityType_Label.text = [NSString stringWithFormat:@"  %@  ",discountList_diction[@"discountTitleFinal"]];
    
    // 时间
    self.activityTime_Label.text = [NSString stringWithFormat:@"活动时间：%@至%@",discountList_diction[@"startTime"],discountList_diction[@"endTime"]];
    
    // 活动的内容
    self.activityContent_Label.text = [NSString stringWithFormat:@"活动商品享受%@折，优惠价",discountList_diction[@"discountRate"]];
    
    
}

/**
 * @brief  店铺优惠券活动的数据
 */
- (void)setConformList_diction:(NSDictionary *)conformList_diction{
    
    _conformList_diction = conformList_diction;
    
    // 标题
    self.ActivityType_Label.text = [NSString stringWithFormat:@"  %@  ",conformList_diction[@"conformTileFinal"]];
    
    // 时间
    self.activityTime_Label.text = [NSString stringWithFormat:@"活动时间：%@至%@",conformList_diction[@"startTime"],conformList_diction[@"endTime"]];
    
    // 活动的内容
    self.activityContent_Label.text = [NSString stringWithFormat:@"%@",conformList_diction[@"contentRule"]];
    
    self.activityContent_Label.backgroundColor = RGB(200, 118, 170);
}





@end
