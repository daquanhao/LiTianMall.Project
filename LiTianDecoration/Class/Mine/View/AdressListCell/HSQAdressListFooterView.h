//
//  HSQAdressListFooterView.h
//  LiTianDecoration
//
//  Created by administrator on 2018/4/25.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HSQAdressListFooterViewDelegate <NSObject>

- (void)AddNewAdressWithFooterView:(UIButton *)sender;

@end

@interface HSQAdressListFooterView : UITableViewHeaderFooterView

@property (nonatomic, weak) id<HSQAdressListFooterViewDelegate>delegate;

@end
