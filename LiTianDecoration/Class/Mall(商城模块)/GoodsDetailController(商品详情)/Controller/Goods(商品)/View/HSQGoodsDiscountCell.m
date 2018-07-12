//
//  HSQGoodsDiscountCell.m
//  LiTianDecoration
//
//  Created by administrator on 2018/7/10.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import "HSQGoodsDiscountCell.h"
#import "HSQCountdownView.h"

@interface HSQGoodsDiscountCell ()

@property (nonatomic, strong) HSQCountdownView *CountdownView;  // 倒计时的视图

@end

@implementation HSQGoodsDiscountCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        // 倒计时的视图
        HSQCountdownView *CountdownView = [[HSQCountdownView alloc] initCountdownViewWithXIB];
        
        [self.contentView addSubview:CountdownView];
        
        self.CountdownView = CountdownView;
        
        // 倒计时的视图
        self.CountdownView.sd_layout.leftSpaceToView(self.contentView, 0).topSpaceToView(self.contentView, 0).rightSpaceToView(self.contentView, 0).bottomSpaceToView(self.contentView, 0);
    }
    
    return self;
}

/**
 * @brief 商品折扣的数据
 */
- (void)setDiscount_diction:(NSDictionary *)discount_diction{
    
    _discount_diction = discount_diction;
    
    self.CountdownView.discount_diction = discount_diction;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];

    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

@end
