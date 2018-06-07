//
//  HSQSubmitOrderHomeView.m
//  LiTianDecoration
//
//  Created by administrator on 2018/5/25.
//  Copyright © 2018年 administrator. All rights reserved.
//

#define HWStatusPhotoMargin 5

#import "HSQSubmitOrderHomeView.h"
#import "HSQSubmitOrderGoodsGuiGeListView.h"
#import "HSQShopCarGoodsTypeListModel.h"

@interface HSQSubmitOrderHomeView ()

@property (nonatomic, strong) HSQSubmitOrderGoodsGuiGeListView *GoodsGuiGeListView;

@end

@implementation HSQSubmitOrderHomeView

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        
    }
    
    return self;
}


/**
 * @brief 根据数据创建规格列表View
 */
- (void)setGuiGeData_Array:(NSArray *)GuiGeData_Array{
    
    _GuiGeData_Array = GuiGeData_Array;
    
    NSUInteger photosCount = GuiGeData_Array.count;
    
    // 创建足够数量的图片控件
    // 这里的self.subviews.count不要单独赋值给其他变量
    while (self.subviews.count < photosCount) {
        
        HSQSubmitOrderGoodsGuiGeListView *photoView = [[HSQSubmitOrderGoodsGuiGeListView alloc] init];
        
        [self addSubview:photoView];
    }
    
    // 遍历所有的图片控件，设置图片
    for (int i = 0; i<self.subviews.count; i++) {
        
        HSQSubmitOrderGoodsGuiGeListView *photoView = self.subviews[i];
        
        if (i < photosCount) { // 显示
            
            photoView.model = GuiGeData_Array[i];
            
            photoView.hidden = NO;
            
        } else { // 隐藏
            photoView.hidden = YES;
        }
    }
}

/**
 * @brief 设置控件的尺寸
 */
- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    // 设置图片的尺寸和位置
    NSUInteger photosCount = self.GuiGeData_Array.count;
    
    int maxCol = 1;
    
    for (int i = 0; i<photosCount; i++) {
        
        HSQSubmitOrderGoodsGuiGeListView *photoView = self.subviews[i];
        
        HSQShopCarGoodsTypeListModel *model = self.GuiGeData_Array[i];
        
        CGSize NameSize = [NSString SizeOfTheText:model.goodsFullSpecs font:[UIFont systemFontOfSize:12.0] MaxSize:CGSizeMake(KScreenWidth*0.7, MAXFLOAT)];
        
        photoView.height = NameSize.height + 15 + 20;
        
        photoView.width = KScreenWidth - 20;
        
        photoView.mj_x = 10;
        
        int row = i / maxCol;
        photoView.mj_y = row * (photoView.height + HWStatusPhotoMargin);
        
    }
}


/**
 * @brief 根据数组返回view的尺寸
 */
+(CGSize)SizeWithDataModelArray:(NSArray *)dataSource{
    
    CGFloat ViewH = 0;
    
    for (NSInteger i = 0; i < dataSource.count ; i++)
    {
        HSQShopCarGoodsTypeListModel *TypeModel = dataSource[i];
        
        CGSize NameSize = [NSString SizeOfTheText:TypeModel.goodsFullSpecs font:[UIFont systemFontOfSize:12.0] MaxSize:CGSizeMake(KScreenWidth * 0.7, MAXFLOAT)];
        
        ViewH = ViewH + (NameSize.height + 15 + 20);
    }
    
    return CGSizeMake(KScreenWidth, ViewH + (dataSource.count - 1) * HWStatusPhotoMargin);
}

@end
