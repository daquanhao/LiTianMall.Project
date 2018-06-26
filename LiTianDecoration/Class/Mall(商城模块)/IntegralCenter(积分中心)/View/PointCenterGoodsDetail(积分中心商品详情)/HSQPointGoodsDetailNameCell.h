//
//  HSQPointGoodsDetailNameCell.h
//  LiTianDecoration
//
//  Created by administrator on 2018/6/21.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HSQPointGoodsDetailNameCellDelegate <NSObject>

- (void)ChooseTheSpecificationsOfTheGoods:(UIButton *)sender;

@end

@interface HSQPointGoodsDetailNameCell : UICollectionViewCell

/**
 * @brief 商品信息
 */
@property (nonatomic, strong) NSDictionary *pointsGoodsDetailVo;

/**
 * @brief 商品的规格
 */
@property (weak, nonatomic) IBOutlet UILabel *goodsSpecs_Label;

/**
 * @brief 设置代理
 */
@property (nonatomic, weak) id<HSQPointGoodsDetailNameCellDelegate>delegate;

@end
