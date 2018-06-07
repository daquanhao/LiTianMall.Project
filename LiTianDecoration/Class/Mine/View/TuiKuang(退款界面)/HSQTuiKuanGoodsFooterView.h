//
//  HSQTuiKuanGoodsFooterView.h
//  LiTianDecoration
//
//  Created by administrator on 2018/6/7.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HSQTuiKuanGoodsFooterViewDelegate <NSObject>

/**
 * @brief 选择退款凭证
 */
- (void)ChooseRefundImageViewButtonClickAction:(UIButton *)sender;

/**
 * @brief 提交
 */
- (void)SubmitButtonClickAction:(UIButton *)sender;

@end

@interface HSQTuiKuanGoodsFooterView : UITableViewHeaderFooterView

/**
 * @brief 接收上一个界面的数据
 */
@property (nonatomic, strong) NSDictionary *OrderDataDiction;

/**
 * @brief 设置代理
 */
@property (nonatomic, weak) id<HSQTuiKuanGoodsFooterViewDelegate>delegate;

/**
 * @brief 退款说明
 */
@property (weak, nonatomic) IBOutlet UITextField *ShuoMing_TextField;

/**
 * @brief 退款凭证的图片数组
 */
@property (nonatomic, strong) NSMutableArray *Picture_array;

@end
