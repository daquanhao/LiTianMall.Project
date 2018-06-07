//
//  HSQShopCarGoodsGuiGeListView.m
//  LiTianDecoration
//
//  Created by administrator on 2018/5/21.
//  Copyright © 2018年 administrator. All rights reserved.
//
#define HWStatusPhotoMargin 10

#import "HSQShopCarGoodsGuiGeListView.h"
#import "HSQShopCarGoodsGuiGeDataView.h"
#import "HSQShopCarGoodsTypeListModel.h"

@interface HSQShopCarGoodsGuiGeListView ()<HSQShopCarGoodsGuiGeDataViewDelegate>

@property (nonatomic, strong) HSQShopCarGoodsGuiGeDataView *GoodsGuiGeDataView; // 商品数据的view

@end

@implementation HSQShopCarGoodsGuiGeListView

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
        
        HSQShopCarGoodsGuiGeDataView *photoView = [[HSQShopCarGoodsGuiGeDataView alloc] init];
                
        photoView.delegate = self;
        
        [self addSubview:photoView];
    }
    
    // 遍历所有的图片控件，设置图片
    for (int i = 0; i<self.subviews.count; i++) {
        
        HSQShopCarGoodsGuiGeDataView *photoView = self.subviews[i];
        
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
        
        HSQShopCarGoodsGuiGeDataView *photoView = self.subviews[i];
        
        HSQShopCarGoodsTypeListModel *model = self.GuiGeData_Array[i];
        
        CGSize NameSize = [NSString SizeOfTheText:model.goodsFullSpecs font:[UIFont systemFontOfSize:12.0] MaxSize:CGSizeMake(KScreenWidth-155, MAXFLOAT)];
        photoView.height = NameSize.height + 10 + 20;
        
        photoView.width = KScreenWidth;
        
        photoView.mj_x = 0;
        
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
        
         CGSize NameSize = [NSString SizeOfTheText:TypeModel.goodsFullSpecs font:[UIFont systemFontOfSize:12.0] MaxSize:CGSizeMake(KScreenWidth-155, MAXFLOAT)];
        ViewH = ViewH + (NameSize.height + 10 + 20);
    }
    
    return CGSizeMake(KScreenWidth, ViewH + (dataSource.count - 1) * HWStatusPhotoMargin);
}

/** 加好按钮的点击事件*/
- (void)AddButtonInShopCarGoodsListCellClickAction:(UIButton *)sender{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(AddButtonInhopCarGoodsGuiGeListViewClickAction:)]) {
        
        [self.delegate AddButtonInhopCarGoodsGuiGeListViewClickAction:sender];
    }
}

/** 减号按钮的点击事件*/
- (void)JianHaoButtonInShopCarGoodsListCellClickAction:(UIButton *)sender{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(JianHaoButtonInhopCarGoodsGuiGeListViewClickAction:)]) {
        
        [self.delegate JianHaoButtonInhopCarGoodsGuiGeListViewClickAction:sender];
    }
}

/** 输入框的点击事件*/
- (void)ShopCarGoodsCountTextFieldInShopCarGoodsListCellClickAction:(UIButton *)sender{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(ShopCarGoodsCountTextFieldInhopCarGoodsGuiGeListViewClickAction:)]) {
        
        [self.delegate ShopCarGoodsCountTextFieldInhopCarGoodsGuiGeListViewClickAction:sender];
    }
}

/**小圆点的点击事件*/
- (void)LeftXiaoYuanDianButtonInShopCarGoodsListCellClickAction:(UIButton *)sender{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(LeftXiaoYuanDianButtonInhopCarGoodsGuiGeListViewClickAction:)]) {
        
        [self.delegate LeftXiaoYuanDianButtonInhopCarGoodsGuiGeListViewClickAction:sender];
    }
}








@end
