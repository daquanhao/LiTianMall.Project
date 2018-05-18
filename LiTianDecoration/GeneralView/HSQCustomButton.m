//
//  HSQCustomButton.m
//  测试demo
//
//  Created by administrator on 2018/4/8.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import "HSQCustomButton.h"

//获得按钮的大小
#define btnWidth self.bounds.size.width
#define btnHeight self.bounds.size.height

//获得按钮中UILabel文本的大小
#define labelWidth self.titleLabel.bounds.size.width
#define labelHeight self.titleLabel.bounds.size.height

//获得按钮中image图标的大小
#define imageWidth self.imageView.bounds.size.width
#define imageHeight self.imageView.bounds.size.height

// 图片和文本之间的间距
#define KMarginRadio 0.5

@implementation HSQCustomButton

/**
 * @brief 设置图片与文字之间的间距
 */
- (void)setButtonTopRadio:(CGFloat)buttonTopRadio{
    
    _buttonTopRadio = buttonTopRadio;
    
}

/**
 * @brief 设置按钮的对齐样式
 */
- (void)setAlignmentType:(ButtonAlignmentType)alignmentType{
    
    _alignmentType = alignmentType;
    
}

/**
 * @brief 图片在上，文本在下的时候，改变其内部的frame
 */
- (void)AlignmentTop{
    
    // 1.设置文本的文字居中对齐
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    // 2.设置图片的位置
    CGFloat Image_X = (btnWidth - imageWidth) / 2;
    CGFloat Image_Y = (btnHeight - imageHeight - labelHeight - labelHeight * (self.buttonTopRadio ? self.buttonTopRadio : KMarginRadio)) / 2;
    self.imageView.frame = CGRectMake(Image_X, Image_Y, imageWidth, imageHeight);
    
    // 3.设置titleLabel的位置
    CGFloat Label_X = 5;
    CGFloat Label_Y = CGRectGetMaxY(self.imageView.frame) + labelHeight * (self.buttonTopRadio ? self.buttonTopRadio : KMarginRadio);
    CGFloat Label_W = btnWidth - 2 * Label_X;
    self.titleLabel.frame = CGRectMake(Label_X, Label_Y, Label_W, labelHeight);
    
}

/**
 * @brief 图标在下，文本在上(居中)
 */
- (void)AlignmentBottom{
    
    // 1.设置文本的文字居中对齐
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    // 2.设置titleLabel的位置
    CGFloat Label_X = 5;
    CGFloat Label_Y = (btnHeight - imageHeight - labelHeight - labelHeight * (self.buttonTopRadio ? self.buttonTopRadio : KMarginRadio)) / 2;
    CGFloat Label_W = btnWidth - 2 * Label_X;
    self.titleLabel.frame = CGRectMake(Label_X, Label_Y, Label_W, labelHeight);
    
    // 3.设置图片的位置
    CGFloat Image_X = (btnWidth - imageWidth) / 2;
    CGFloat Image_Y = CGRectGetMaxY(self.titleLabel.frame) + labelHeight * (self.buttonTopRadio ? self.buttonTopRadio : KMarginRadio);
    self.imageView.frame = CGRectMake(Image_X, Image_Y, imageWidth, imageHeight);
    
}

/**
 * @brief 图片在右边，文本在左边
 */
- (void)AlignmentRight{
    
    // 1.获得按钮的文本的frame
    CGRect titleFrame = self.titleLabel.frame;
    
    //获得按钮的图片的frame
    CGRect imageFrame = self.imageView.frame;
    
    // 2.设置按钮的文本的x坐标为0-－－左对齐
    titleFrame.origin.x =(self.mj_w - titleFrame.size.width - imageFrame.size.width)/2;
    
    //设置按钮的图片的x坐标紧跟文本的后面
    imageFrame.origin.x = CGRectGetMaxX(titleFrame);
    
    //重写赋值frame
    self.titleLabel.frame = titleFrame;
    
    self.imageView.frame = imageFrame;
}

- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    if (self.alignmentType == Button_AlignmentStatusNormal)
    {
        
    }
    else  if (self.alignmentType == Button_AlignmentStatusTop)
    {
        [self AlignmentTop];
    }
    else if (self.alignmentType == Button_AlignmentStatusBottom)
    {
        [self AlignmentBottom];
    }
    else if (self.alignmentType == Button_AlignmentStatusRight)
    {
        [self AlignmentRight];
    }
    
}













@end
