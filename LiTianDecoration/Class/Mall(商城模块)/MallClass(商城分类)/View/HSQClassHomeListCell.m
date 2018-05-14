//
//  HSQClassHomeListCell.m
//  LiTianDecoration
//
//  Created by administrator on 2018/4/12.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import "HSQClassHomeListCell.h"
#import "HSQLeftCategoryModel.h"

@interface HSQClassHomeListCell ()

@property (nonatomic, strong) UILabel *title_Label;

@property (nonatomic, strong) UIView *line_View;

@end

@implementation HSQClassHomeListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        // 标题下面的分割线
        UIView *line_View = [[UIView alloc] init];
        
        line_View.backgroundColor = KViewBackGroupColor;
        
        [self.contentView addSubview:line_View];
        
        self.line_View = line_View;
        
        // 分类的标题
        UILabel *title_label = [[UILabel alloc] init];
        
        title_label.textColor = [UIColor blackColor];
        
        title_label.font = [UIFont systemFontOfSize:12];
        
        title_label.textAlignment = NSTextAlignmentCenter;
        
        [self.contentView addSubview:title_label];
        
        self.title_Label = title_label;
        
        // 添加约束
        self.line_View.sd_layout.leftSpaceToView(self.contentView, 0).topSpaceToView(self.contentView, 0).rightSpaceToView(self.contentView, 0).heightIs(2);
        
        self.title_Label.sd_layout.leftSpaceToView(self.contentView, 0).rightSpaceToView(self.contentView, 0).topSpaceToView(self.line_View, 0).bottomSpaceToView(self.contentView, 0);
    }
    
    return self;
}

- (void)setModel:(HSQLeftCategoryModel *)model{
    
    _model = model;
    
    // 1.分类的名字
    self.title_Label.text = model.categoryName;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];

    self.title_Label.textColor = (self.selected ? [UIColor redColor] : [UIColor blackColor]);
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.contentView.backgroundColor =(self.selected ? KViewBackGroupColor : [UIColor whiteColor]);
}














@end
