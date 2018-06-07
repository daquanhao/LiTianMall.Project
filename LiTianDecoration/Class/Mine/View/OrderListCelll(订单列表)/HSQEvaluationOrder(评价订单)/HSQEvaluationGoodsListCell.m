//
//  HSQEvaluationGoodsListCell.m
//  LiTianDecoration
//
//  Created by administrator on 2018/5/28.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import "HSQEvaluationGoodsListCell.h"
#import "HSQShopCarGoodsTypeListModel.h"

@interface HSQEvaluationGoodsListCell ()

@property (weak, nonatomic) IBOutlet UIImageView *GoodsImageView;

@property (weak, nonatomic) IBOutlet UILabel *GoodsName_Label;

@property (weak, nonatomic) IBOutlet UIButton *FirstRateImage_Btn; // 评论的图片

@property (weak, nonatomic) IBOutlet UIButton *SecondRateIImage_Btn;  // 评论的图片

@property (weak, nonatomic) IBOutlet UIButton *ThirdRateImage_Btn;  // 评论的图片

@property (weak, nonatomic) IBOutlet UIButton *FourRateImage_Btn;  // 评论的图片

@property (weak, nonatomic) IBOutlet UIButton *FiveRateImage_Btn;  // 评论的图片

@property (nonatomic, strong) NSMutableArray *Btn_array;

@property (weak, nonatomic) IBOutlet UIButton *FirstStar_Btn;

@property (weak, nonatomic) IBOutlet UIButton *SecondStar_Btn;

@property (weak, nonatomic) IBOutlet UIButton *ThirdStar_Btn;

@property (weak, nonatomic) IBOutlet UIButton *FourStar_Btn;

@property (weak, nonatomic) IBOutlet UIButton *FiveStar_Btn;

@property (nonatomic, strong) NSMutableArray *Star_array;

@property (weak, nonatomic) IBOutlet UILabel *RateCont_Label; // 已经评论的内容
@end

@implementation HSQEvaluationGoodsListCell

-(NSMutableArray *)Btn_array{
    
    if (_Btn_array == nil) {
        
        self.Btn_array = [NSMutableArray array];
    }
    
    return _Btn_array;
}

-(NSMutableArray *)Star_array{
    
    if (_Star_array == nil) {
        
        self.Star_array = [NSMutableArray array];
    }
    
    return _Star_array;
}

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    self.contentView.backgroundColor = KViewBackGroupColor;
    
    // 评价图片的数组
     [self.Btn_array addObject:self.FirstRateImage_Btn];
     [self.Btn_array addObject:self.SecondRateIImage_Btn];
     [self.Btn_array addObject:self.ThirdRateImage_Btn];
     [self.Btn_array addObject:self.FourRateImage_Btn];
     [self.Btn_array addObject:self.FiveRateImage_Btn];
    
    // 星星数组
    [self.Star_array addObject:self.FirstStar_Btn];
    [self.Star_array addObject:self.SecondStar_Btn];
    [self.Star_array addObject:self.ThirdStar_Btn];
    [self.Star_array addObject:self.FourStar_Btn];
    [self.Star_array addObject:self.FiveStar_Btn];
}

/**
 * @brief 选择评论的相册
 */
- (IBAction)ChooseRateImageFromeMobileBtnClickAction:(UIButton *)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(SelectTheImageOfTheCommentBtnClickAction:)]) {
        
        [self.delegate SelectTheImageOfTheCommentBtnClickAction:sender];
    }
}

/**
 * @brief 数据赋值
 */
- (void)setModel:(HSQShopCarGoodsTypeListModel *)Model{
    
    _Model = Model;
    
    // 商品的图片
    [self.GoodsImageView sd_setImageWithURL:[NSURL URLWithString:Model.goodsFullImage] placeholderImage:KGoodsPlacherImage];
    
    // 商品的名字
    self.GoodsName_Label.text = Model.goodsName;
    
    // 评论的图片
    for (NSInteger i = 0; i < Model.Select_Arrays.count; i++) {
        
        UIButton *btn = (UIButton *)self.Btn_array[i];
        
        [btn setBackgroundImage:Model.Select_Arrays[i] forState:(UIControlStateNormal)];
    }
    
    // 评论的星星个数
    for (NSInteger i = 0; i < Model.RateStarCount.integerValue; i++)
    {
        UIButton *btn = (UIButton *)self.Star_array[i];
        
        [btn setSelected:YES];
    }
    
    // 评论的内容
    self.RateContent_TextField.text = Model.RateContent_String;
    
    // 已经评价的内容
    self.RateCont_Label.text = Model.evaluateContent;
    
}


/**
 * @brief 星星的点击
 */
- (IBAction)FirstStarBtnClickAction:(UIButton *)sender {
    
    [self.FirstStar_Btn setSelected:YES];
    
    [self.SecondStar_Btn setSelected:NO];
    [self.ThirdStar_Btn setSelected:NO];
    [self.FourStar_Btn setSelected:NO];
    [self.FiveStar_Btn setSelected:NO];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(RateStarBtnClickActionEven:)]) {
        
        [self.delegate RateStarBtnClickActionEven:sender];
    }
}

/**
 * @brief 第二个星星的点击
 */
- (IBAction)SecondStarBtnClickAction:(UIButton *)sender {
    
    [self.FirstStar_Btn setSelected:YES];
    [self.SecondStar_Btn setSelected:YES];
    
    [self.ThirdStar_Btn setSelected:NO];
    [self.FourStar_Btn setSelected:NO];
    [self.FiveStar_Btn setSelected:NO];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(RateStarBtnClickActionEven:)]) {
        
        [self.delegate RateStarBtnClickActionEven:sender];
    }
}

/**
 * @brief 第三个星星的点击
 */
- (IBAction)ThirdStarBtnClickAction:(UIButton *)sender {
    
    [self.FirstStar_Btn setSelected:YES];
    [self.SecondStar_Btn setSelected:YES];
    [self.ThirdStar_Btn setSelected:YES];
    
    [self.FourStar_Btn setSelected:NO];
    [self.FiveStar_Btn setSelected:NO];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(RateStarBtnClickActionEven:)]) {
        
        [self.delegate RateStarBtnClickActionEven:sender];
    }
}

/**
 * @brief 第四个星星的点击
 */
- (IBAction)FourStarBtnClickAction:(UIButton *)sender {
    
    [self.FirstStar_Btn setSelected:YES];
    [self.SecondStar_Btn setSelected:YES];
    [self.ThirdStar_Btn setSelected:YES];
    [self.FourStar_Btn setSelected:YES];
    
    [self.FiveStar_Btn setSelected:NO];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(RateStarBtnClickActionEven:)]) {
        
        [self.delegate RateStarBtnClickActionEven:sender];
    }
}

/**
 * @brief 第五个星星的点击
 */
- (IBAction)FiveStarBtnClickAction:(UIButton *)sender {
    
    [self.FirstStar_Btn setSelected:YES];
    [self.SecondStar_Btn setSelected:YES];
    [self.ThirdStar_Btn setSelected:YES];
    [self.FourStar_Btn setSelected:YES];
    [self.FiveStar_Btn setSelected:YES];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(RateStarBtnClickActionEven:)]) {
        
        [self.delegate RateStarBtnClickActionEven:sender];
    }
}


















- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
