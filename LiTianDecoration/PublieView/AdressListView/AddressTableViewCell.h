//
//  AddressTableViewCell.h
//  ChooseLocation
//
//  Created by Sekorm on 16/8/26.
//  Copyright © 2016年 HY. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HSQAdressListModel;

@interface AddressTableViewCell : UITableViewCell

@property (nonatomic,strong) HSQAdressListModel * item;

@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@end
