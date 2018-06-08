//
//  HSQPayMoneryTypeListCell.m
//  LiTianDecoration
//
//  Created by administrator on 2018/5/26.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import "HSQPayMoneryTypeListCell.h"

@interface HSQPayMoneryTypeListCell ()

@end

@implementation HSQPayMoneryTypeListCell

/**
 * @brief 开关按钮的点击事件
 */
- (IBAction)IsChoosePayMonerySwitchClickAction:(UISwitch *)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(SelectThePaymentMethodButtonClickEvent:)]) {
        
        [self.delegate SelectThePaymentMethodButtonClickEvent:sender];
    }
}

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    [self.Switch setOn:NO];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
    


}

@end
