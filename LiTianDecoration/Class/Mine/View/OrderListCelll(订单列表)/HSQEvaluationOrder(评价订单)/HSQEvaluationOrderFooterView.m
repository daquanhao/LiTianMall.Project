//
//  HSQEvaluationOrderFooterView.m
//  LiTianDecoration
//
//  Created by administrator on 2018/5/28.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import "HSQEvaluationOrderFooterView.h"

@interface HSQEvaluationOrderFooterView ()

/** 描述相符的星星*/
@property (weak, nonatomic) IBOutlet UIButton *MiaoShuFirstStar_Btn;
@property (weak, nonatomic) IBOutlet UIButton *MiaoShuSecondStar_Btn;
@property (weak, nonatomic) IBOutlet UIButton *MiaoShuThirdStar_Btn;
@property (weak, nonatomic) IBOutlet UIButton *MiaoShuFourStar_Btn;
@property (weak, nonatomic) IBOutlet UIButton *MiaoShuFiveStar_Btn;
@property (nonatomic, strong) NSMutableArray *MiaoShu_Array;
@property (nonatomic, strong) NSMutableArray *SelectMiaoShu_Array;

/** 服务态度的星星*/
@property (weak, nonatomic) IBOutlet UIButton *ServerFirstStar_Btn;
@property (weak, nonatomic) IBOutlet UIButton *ServerSecondStar_Btn;
@property (weak, nonatomic) IBOutlet UIButton *ServerThirdStar_Btn;
@property (weak, nonatomic) IBOutlet UIButton *ServerFourStar_Btn;
@property (weak, nonatomic) IBOutlet UIButton *ServerFiveStar_Btn;
@property (nonatomic, strong) NSMutableArray *Server_Array;
@property (nonatomic, strong) NSMutableArray *SelectServer_Array;


/** 发货速度的星星*/
@property (weak, nonatomic) IBOutlet UIButton *SendGoodsFirstStar_Btn;
@property (weak, nonatomic) IBOutlet UIButton *SendGoodsSecondStar_Btn;
@property (weak, nonatomic) IBOutlet UIButton *SendGoodsThirdStar_Btn;
@property (weak, nonatomic) IBOutlet UIButton *SendGoodsFourStar_Btn;
@property (weak, nonatomic) IBOutlet UIButton *SendGoodsFiveStar_Btn;
@property (nonatomic, strong) NSMutableArray *SendGoods_Array;
@property (nonatomic, strong) NSMutableArray *SelectSendGoods_Array;


@end

@implementation HSQEvaluationOrderFooterView

- (NSMutableArray *)SelectMiaoShu_Array{

    if (_SelectMiaoShu_Array == nil) {

        self.SelectMiaoShu_Array = [NSMutableArray array];
    }

    return _SelectMiaoShu_Array;
}

- (NSMutableArray *)SelectServer_Array{

    if (_SelectServer_Array == nil) {

        self.SelectServer_Array = [NSMutableArray array];
    }

    return _SelectServer_Array;
}

- (NSMutableArray *)SelectSendGoods_Array{

    if (_SelectSendGoods_Array == nil) {

        self.SelectSendGoods_Array = [NSMutableArray array];
    }

    return _SelectSendGoods_Array;
}

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    // 描述的数据
    self.MiaoShu_Array = [NSMutableArray arrayWithObjects:self.MiaoShuFirstStar_Btn,self.MiaoShuSecondStar_Btn,self.MiaoShuThirdStar_Btn,self.MiaoShuFourStar_Btn,self.MiaoShuFiveStar_Btn, nil];

    // 服务态度
    self.Server_Array = [NSMutableArray arrayWithObjects:self.ServerFirstStar_Btn,self.ServerSecondStar_Btn,self.ServerThirdStar_Btn,self.ServerFourStar_Btn,self.ServerFiveStar_Btn, nil];

    // 发货速度
    self.SendGoods_Array = [NSMutableArray arrayWithObjects:self.SendGoodsFirstStar_Btn,self.SendGoodsSecondStar_Btn,self.SendGoodsThirdStar_Btn,self.SendGoodsFourStar_Btn,self.SendGoodsFiveStar_Btn, nil];

}

/**
 * @brief 提交评价
 */
- (IBAction)TiJiaoPingJiaBtnClickAction:(UIButton *)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(SubmitOrderRateContentButtonClickAction:)]) {
        
        [self.delegate SubmitOrderRateContentButtonClickAction:sender];
    }
}


/**
 * @brief 商品描述星星的点击
 */
- (IBAction)GoodsDeacribeStarBtnClckAction:(UIButton *)sender {
    
    for (UIButton *btn in self.MiaoShu_Array) {
        
        btn.selected = YES;
    }
    
    [self.SelectMiaoShu_Array removeAllObjects];
    
    for (NSInteger i = 0; i <= sender.tag - 300; i++) {
        
        UIButton *btn = self.MiaoShu_Array[i];
        
        [self.SelectMiaoShu_Array addObject:btn];
    }
    
    for (UIButton *btn in self.SelectMiaoShu_Array) {
        
        btn.selected = NO;
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(TheProductDescribesTheStarClickEvent:StarCount:)]) {
        
        [self.delegate TheProductDescribesTheStarClickEvent:sender StarCount:self.SelectMiaoShu_Array.count];
    }
}

/**
 * @brief 服务态度星星的点击
 */
- (IBAction)ServerTaiStarBtnClickAction:(UIButton *)sender {
    
    for (UIButton *btn in self.Server_Array) {
        
        btn.selected = YES;
    }
    
    [self.SelectServer_Array removeAllObjects];
    
    for (NSInteger i = 0; i <= sender.tag - 305; i++) {
        
        UIButton *btn = self.Server_Array[i];
        
        [self.SelectServer_Array addObject:btn];
    }
    
    for (UIButton *btn in self.SelectServer_Array) {
        
        btn.selected = NO;
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(TheProductDescribesTheStarClickEvent:StarCount:)]) {
        
        [self.delegate TheProductDescribesTheStarClickEvent:sender StarCount:self.SelectServer_Array.count];
    }
}

/**
 * @brief 发货速度星星的点击
 */
- (IBAction)SendGoodsStarBtnClickAction:(UIButton *)sender {
    
    for (UIButton *btn in self.SendGoods_Array) {
        
        btn.selected = YES;
    }
    
    [self.SelectSendGoods_Array removeAllObjects];
    
    for (NSInteger i = 0; i <= sender.tag - 310; i++) {
        
        UIButton *btn = self.SendGoods_Array[i];
        
        [self.SelectSendGoods_Array addObject:btn];
    }
    
    for (UIButton *btn in self.SelectSendGoods_Array) {
        
        btn.selected = NO;
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(TheProductDescribesTheStarClickEvent:StarCount:)]) {
        
        [self.delegate TheProductDescribesTheStarClickEvent:sender StarCount:self.SelectSendGoods_Array.count];
    }
}







@end
