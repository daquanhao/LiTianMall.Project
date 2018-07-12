//
//  HSQFurnitureHallCollectionViewCell.m
//  LiTianDecoration
//
//  Created by administrator on 2018/7/11.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import "HSQFurnitureHallCollectionViewCell.h"
#import "HW3DBannerView.h"

@interface HSQFurnitureHallCollectionViewCell ()

@property (nonatomic,strong) HW3DBannerView *scrollView;

@end

@implementation HSQFurnitureHallCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        self.contentView.backgroundColor = [UIColor clearColor];
        
        HW3DBannerView *scrollView = [HW3DBannerView initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height) imageSpacing:10 imageWidth:frame.size.width - 20];
        
        scrollView.initAlpha = 0.5; // 设置两边卡片的透明度
        
        scrollView.imageRadius = 0; // 设置卡片圆角
        
        scrollView.imageHeightPoor = 5; // 设置中间卡片与两边卡片的高度差
        
        // 设置要加载的图片
        scrollView.data = @[
                            @"http://d.hiphotos.baidu.com/image/pic/item/b7fd5266d016092408d4a5d1dd0735fae7cd3402.jpg",
                            @"http://h.hiphotos.baidu.com/image/h%3D300/sign=2b3e022b262eb938f36d7cf2e56085fe/d0c8a786c9177f3e18d0fdc779cf3bc79e3d5617.jpg",
                            @"http://a.hiphotos.baidu.com/image/pic/item/b7fd5266d01609240bcda2d1dd0735fae7cd340b.jpg",
                            @"http://h.hiphotos.baidu.com/image/pic/item/728da9773912b31b57a6e01f8c18367adab4e13a.jpg",
                            @"http://h.hiphotos.baidu.com/image/pic/item/0d338744ebf81a4c5e4fed03de2a6059242da6fe.jpg"
                                        ];
//        scrollView.data = @[@"fangan01",@"fangan02",@"fangan03"];
        
        scrollView.placeHolderImage = [UIImage imageNamed:@""]; // 设置占位图片
        
        [self.contentView addSubview:scrollView];
        
        self.scrollView = scrollView;
        
        self.scrollView.clickImageBlock = ^(NSInteger currentIndex) { // 点击中间图片的回调
            
            
        };
    }
    
    return self;
}

@end
