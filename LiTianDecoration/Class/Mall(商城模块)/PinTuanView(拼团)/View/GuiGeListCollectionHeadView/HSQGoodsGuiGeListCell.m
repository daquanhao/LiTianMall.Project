//
//  HSQGoodsGuiGeListCell.m
//  LiTianDecoration
//
//  Created by administrator on 2018/5/14.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import "HSQGoodsGuiGeListCell.h"
#import "HSQGoodsGuiGeTypeModel.h"

@interface HSQGoodsGuiGeListCell ()

@property (weak, nonatomic) IBOutlet UILabel *GuiGeName_Label;

@property (weak, nonatomic) IBOutlet UIImageView *BgImageView;

@end

@implementation HSQGoodsGuiGeListCell

- (void)setListModel:(HSQGoodsGuiGeListModel *)ListModel{
    
    _ListModel = ListModel;
    
    self.GuiGeName_Label.text = ListModel.specValueName;
    
    if (ListModel.IsSelect.integerValue == 0) // 没有被选中
    {
        self.GuiGeName_Label.textColor = RGB(51, 51, 51);
        self.BgImageView.image = [UIImage ReturnAPictureOfStretching:@"7D99DFED-F3B6-4DB1-9F77-E24CA867DD17"];
    }
    else
    {
        self.GuiGeName_Label.textColor = RGB(238, 58, 68);
        self.BgImageView.image = [UIImage ReturnAPictureOfStretching:@"24BB2CFF-14F5-4974-BE1A-0D9A10EA0857"];
    }
}


- (void)awakeFromNib {
    
    [super awakeFromNib];
   
}

@end
