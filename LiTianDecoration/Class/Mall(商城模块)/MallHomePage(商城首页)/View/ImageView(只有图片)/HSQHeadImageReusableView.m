//
//  HSQHeadImageReusableView.m
//  LiTianDecoration
//
//  Created by administrator on 2018/5/7.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import "HSQHeadImageReusableView.h"
#import "HSQMallHomeDataModel.h"
#import "TXScrollLabelView.h"

@interface HSQHeadImageReusableView ()<TXScrollLabelViewDelegate>

@property (nonatomic, strong) UIImageView *OneImageView;

@property (nonatomic, strong) UIImageView *LeftHeader_Image;

@property (nonatomic,strong) TXScrollLabelView *scrollLabelView;

@end

@implementation HSQHeadImageReusableView

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor orangeColor];
        
        UIImageView *OneImageView = [[UIImageView alloc] init];
        [self addSubview:OneImageView];
        self.OneImageView = OneImageView;
        
        UIImageView *LeftHeader_Image = [[UIImageView alloc] init];
        LeftHeader_Image.image = KImageName(@"123");
        [self addSubview:LeftHeader_Image];
        self.LeftHeader_Image = LeftHeader_Image;
        
        // 跑马灯文字视图
        TXScrollLabelView *scrollLabelView = [TXScrollLabelView scrollWithTextArray:nil type:TXScrollLabelViewTypeUpDown velocity:2 options:UIViewAnimationOptionCurveEaseInOut inset:UIEdgeInsetsZero];;
        scrollLabelView.scrollLabelViewDelegate = self;
        [self addSubview:scrollLabelView];
        self.scrollLabelView = scrollLabelView;
        scrollLabelView.scrollSpace = 10;
        scrollLabelView.font = [UIFont systemFontOfSize:KLabelFont(14.0, 12.0)];
        scrollLabelView.textAlignment = NSTextAlignmentLeft;
        scrollLabelView.backgroundColor = [UIColor clearColor];
        scrollLabelView.scrollTitleColor = RGB(74, 74, 74);
        
        self.OneImageView.sd_layout.leftSpaceToView(self, 0).rightSpaceToView(self, 0).topSpaceToView(self, 0).bottomSpaceToView(self, 0);
        
        self.LeftHeader_Image.sd_layout.leftSpaceToView(self, 10).centerYEqualToView(self).widthIs(70).heightIs(30);
        
        // 跑马灯文本视图
        self.scrollLabelView.sd_layout.leftSpaceToView(self.LeftHeader_Image, 10).rightSpaceToView(self, 10).centerYEqualToView(self.LeftHeader_Image).heightIs(30);
    }
    
    return self;
}

/**
 *  @brief  跑马灯的代理事件
 * @param scrollLabelView 滚动的视图
 *  @param text 跑马灯的文字
 *  @param index 第几段文字
 */
- (void)scrollLabelView:(TXScrollLabelView *)scrollLabelView didClickWithText:(NSString *)text atIndex:(NSInteger)index{
    
    NSLog(@"%@--%ld",text, (long)index);
}

/**
 * @brief 数据赋值
 */
- (void)setModel:(HSQMallHomeDataModel *)model{
    
    _model = model;

    if ([model.itemType isEqualToString:@"text"])  // 跑马灯
    {
        [self.OneImageView setHidden:YES];
        [self.LeftHeader_Image setHidden:NO];
        [self.scrollLabelView setHidden:NO];
        
        NSMutableArray *banners = [NSMutableArray array];
        
        for (NSDictionary *diction in model.itemDataSource) {
            
            [banners addObject:diction[@"text"]];
        }
        
        // 跑马灯的文字
        self.scrollLabelView.textArray = banners;
        
        [self.scrollLabelView beginScrolling];  // 开始滚动
    }
    else
    {
        [self.OneImageView setHidden:NO];
        [self.LeftHeader_Image setHidden:YES];
        [self.scrollLabelView setHidden:YES];
        
        NSDictionary *diction = [model.itemDataSource firstObject];
        [self.OneImageView sd_setImageWithURL:[NSURL URLWithString:diction[@"imageUrl"]] placeholderImage:KGoodsPlacherImage];
    }
}

@end
