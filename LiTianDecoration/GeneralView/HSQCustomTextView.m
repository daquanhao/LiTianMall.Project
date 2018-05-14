//
//  HSQCustomTextView.m
//  LiTianDecoration
//
//  Created by administrator on 2018/4/8.
//  Copyright © 2018年 administrator. All rights reserved.

/********************** 特别注意 **************************/

// UITextView的光标的位置及大小

// IphoneX (4, 7, 2, 19.666666)

// Iphone 7 plus (4, 7, 2, 21.66666)

// iphone 7 (4, 7, 2, 19.5)

// iphone SE (4, 7, 2, 17)

// 综上所述：光标的高度会根据UITextView里面文字的大小而改变。


#define KPlaceholderX 6
#define KPlaceholderY 8

#import "HSQCustomTextView.h"

@implementation HSQCustomTextView

/**
 * @brief 初始化textView
 */
- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        // 当TextView的文字发生变化的时候，TextView会发送一个UITextViewTextDidChangeNotification的通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(TextChange) name:UITextViewTextDidChangeNotification object:self];
    }
    
    return self;
}

/**
 * @brief 当UITextView是从xib上加载的时候，则通过awakeFromNib监听消息
 */
- (void)awakeFromNib{
    
    [super awakeFromNib];
    
    // 当TextView的文字发生变化的时候，TextView会发送一个UITextViewTextDidChangeNotification的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(TextChange) name:UITextViewTextDidChangeNotification object:self];
}

/**
 * @brief 监听TextView文字的改变
 */
- (void)TextChange{
    
    [self setNeedsDisplay];
}

/**
 * @brief 当提示文字发生改变的时候，重绘提示文字
 */
- (void)setPlaceholder:(NSString *)placeholder{
    
    _placeholder = placeholder;
    
    [self setNeedsDisplay];
}

/**
 * @brief 当提示文字的颜色发生改变的时候，重绘提示文字的颜色
 */
- (void)setPlaceholderColor:(NSString *)placeholderColor{
    
    _placeholderColor = placeholderColor;
    
    [self setNeedsDisplay];
}

/**
 * @brief 当TextView的文字发生改变的时候，也需要重绘提示文字
 */
- (void)setText:(NSString *)text{
    
    [super setText:text];
    
    [self setNeedsDisplay];
}

/**
 * @brief 当TextView的位子大小发生改变的时候,也需要重绘提示文字
 */
- (void)setFont:(UIFont *)font{
    
    [super setFont:font];
    
    [self setNeedsDisplay];
}

/**
 * @brief 使用dramRect的方法，绘画提示的文字
 */
- (void)drawRect:(CGRect)rect {
    
    // 当有文字的时候，停止绘画
    if (self.hasText) return;
    
    NSMutableDictionary *attribes = [NSMutableDictionary dictionary];
    
    attribes[NSFontAttributeName] = self.font;
    
    attribes[NSForegroundColorAttributeName] = self.placeholderColor ? self.placeholderColor : [UIColor grayColor];
    
    [self.placeholderColor drawInRect:CGRectMake(KPlaceholderX, KPlaceholderY, rect.size.width - 2 * KPlaceholderX, rect.size.height - 2 * KPlaceholderY) withAttributes:attribes];
}


@end
