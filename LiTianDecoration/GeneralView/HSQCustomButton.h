//
//  HSQCustomButton.h
//  测试demo
//
//  Created by administrator on 2018/4/8.
//  Copyright © 2018年 administrator. All rights reserved
//

#import <UIKit/UIKit.h>

typedef enum {
    
    Button_AlignmentStatusNormal,  // 普通的样式
    
    Button_AlignmentStatusTop, // 图标在上，文本在下(居中)
    
    Button_AlignmentStatusBottom, // 图标在下，文本在上(居中)
    
    Button_AlignmentStatusRight, // 图片在右边，文本在左边
    
}ButtonAlignmentType;


@interface HSQCustomButton : UIButton

/**
 * @brief 图片在上，文本在下的时候，图片与文字之间的间隔比例 （0-1）
 */
@property (nonatomic, assign) CGFloat buttonTopRadio;

/**
 * @brief 按钮内部图片与文字的相对位置
 */
@property (nonatomic, assign) ButtonAlignmentType alignmentType;


@end
