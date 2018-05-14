//
//  HSQCollectionViewLayout.m
//  LiTianDecoration
//
//  Created by administrator on 2018/4/17.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import "HSQCollectionViewLayout.h"

/** 默认的列数*/
//static NSUInteger const DefauilColumns = 2;

@interface HSQCollectionViewLayout ()

/** 定义一个数据记录所有列最大的Y值,以便于比较,找出最短的列*/
@property (nonatomic, strong) NSMutableArray *MaxColumnsY;

/** 定义一个数组保存所有的子控件的布局对象*/
@property (nonatomic, strong) NSMutableArray *attrsArray;

@end

@implementation HSQCollectionViewLayout

/**
 *  懒加载
 */
-(NSMutableArray *)MaxColumnsY{
    
    if (_MaxColumnsY == nil) {
        
        self.MaxColumnsY = [NSMutableArray array];
        
        // 初始化一下所有的默认值
        for (int i = 0; i < [self.delegate DefauilColumns:self]; i++) {
            
            _MaxColumnsY[i] = @([self.delegate collectionViewEdgeInsets:self].top);
        }
    }
    return _MaxColumnsY;
}

#pragma mark - 1.准备布局
- (void)prepareLayout{
    
    [super prepareLayout];
    
    // 1.每次计算之前重置保存每一列最大Y值的数据
    [self.MaxColumnsY removeAllObjects];
    
    for (int i = 0; i < [self.delegate DefauilColumns:self]; i++) {
        
        _MaxColumnsY[i] = @([self.delegate collectionViewEdgeInsets:self].top);
    }
    // 2.获取当前CollectionView中有多少个子控件
    NSInteger count = [self.collectionView numberOfItemsInSection:_second];
    
    NSMutableArray *arrayM = [NSMutableArray array];
    
    // 3.利用循环创建所有的子控件对应的属性对象
    for (int i = 0; i < count; i++) {
        
        NSIndexPath *path = [NSIndexPath indexPathForRow:i inSection:_second];
        
        UICollectionViewLayoutAttributes *attrs = [self layoutAttributesForItemAtIndexPath:path];
        
        [arrayM addObject:attrs];
    }
    
    self.attrsArray = arrayM;
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{
    
    return self.attrsArray;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewLayoutAttributes *attr = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    CGFloat Width = [self.delegate waterFlowLayout:self atIndexPath:indexPath].width;
    
    CGFloat height = [self.delegate waterFlowLayout:self atIndexPath:indexPath].height;
    
    CGFloat destY = [self.MaxColumnsY[0] doubleValue];
    
    NSUInteger destIndex = 0;
    
    for (int i = 0; i < [self.delegate DefauilColumns:self]; i++) {
        
        CGFloat tempY = [self.MaxColumnsY[i] doubleValue];
        
        if (destY > tempY) {
            
            destY = tempY;
            
            destIndex = i;
        }
    }
    
    CGFloat X = [self.delegate collectionViewEdgeInsets:self].left + (Width + [self.delegate DefauilColumnsMargin:self])*destIndex;
    
    CGFloat Y = destY + [self.delegate DefauilRowMargin:self];
    
    attr.frame = CGRectMake(X, Y, Width, height);
    
    self.MaxColumnsY[destIndex] = @(CGRectGetMaxY(attr.frame));
    
    return attr;
}

/**
 * 返回collectionView的滚动范围
 */
- (CGSize)collectionViewContentSize{
    
    CGFloat destY = [self.MaxColumnsY[0] doubleValue];
    
    for (int i = 0; i < [self.delegate DefauilColumns:self]; i++) {
        
        CGFloat tempY = [self.MaxColumnsY[i] doubleValue];
        
        if (destY < tempY) {
            
            destY = tempY;
        }
    }
    return CGSizeMake(0, destY + [self.delegate collectionViewEdgeInsets:self].bottom);
}












@end
