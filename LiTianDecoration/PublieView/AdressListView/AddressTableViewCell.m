//
//  AddressTableViewCell.m
//  ChooseLocation
//
//  Created by Sekorm on 16/8/26.
//  Copyright © 2016年 HY. All rights reserved.
//

#import "AddressTableViewCell.h"
#import "HSQAdressListModel.h"

@interface AddressTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *selectFlag;

@end

@implementation AddressTableViewCell

- (void)setItem:(HSQAdressListModel *)item{
    
    _item = item;
    
    self.addressLabel.text = item.areaName;
    
    self.addressLabel.textColor = item.isSelected ? [UIColor orangeColor] : [UIColor blackColor] ;
    
    self.selectFlag.hidden = !item.isSelected;
}

- (void)awakeFromNib{
    
    [super awakeFromNib];
    
}






@end
