//
//  HSQEvaluationGoodsListCell.h
//  LiTianDecoration
//
//  Created by administrator on 2018/5/28.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HSQShopCarGoodsTypeListModel;

@protocol HSQEvaluationGoodsListCellDelegate <NSObject>

/**
 * @brief 选择评论的图片
 */
- (void)SelectTheImageOfTheCommentBtnClickAction:(UIButton *)sender;

/**
 * @brief 星星按钮的点击
 */
- (void)RateStarBtnClickActionEven:(UIButton *)sender;

@end

@interface HSQEvaluationGoodsListCell : UITableViewCell

/**
 * @brief 设置代理
 */
@property (nonatomic, weak) id <HSQEvaluationGoodsListCellDelegate>delegate;

/**
 * @brief 数据模型
 */
@property (nonatomic, strong) HSQShopCarGoodsTypeListModel *Model;

/**
 * @brief 评价的内容
 */
@property (weak, nonatomic) IBOutlet UITextField *RateContent_TextField;

/**
 * @brief 评论的背景View
 */
@property (weak, nonatomic) IBOutlet UIView *RateContentBgView;

@end
