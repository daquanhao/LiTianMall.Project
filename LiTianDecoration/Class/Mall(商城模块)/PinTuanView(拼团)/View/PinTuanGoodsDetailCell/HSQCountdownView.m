//
//  HSQCountdownView.m
//  LiTianDecoration
//
//  Created by administrator on 2018/5/14.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import "HSQCountdownView.h"

@interface HSQCountdownView ()

{
    dispatch_source_t _timer;
}

@property (weak, nonatomic) IBOutlet UILabel *Price_Label; // 商品的现价

@property (weak, nonatomic) IBOutlet UIButton *PinTuanCount_Btn; // 拼团的人数

@property (weak, nonatomic) IBOutlet UILabel *ShengMonery_Label; // 拼团省多少钱

@property (weak, nonatomic) IBOutlet UILabel *YiTuanCountGoods_Label; // 已团多少件商品

@property (weak, nonatomic) IBOutlet UILabel *OrginPrice_Label; // 商品的原价


@end

@implementation HSQCountdownView

- (HSQCountdownView *)initCountdownViewWithXIB{
    
    return [[[NSBundle mainBundle] loadNibNamed:@"HSQCountdownView" owner:self options:nil]firstObject];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    
    if (self = [super initWithCoder:aDecoder]) {
        
    }
    
    return self;
}

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
     self.backgroundColor = [UIColor redColor];
    

}

/**
 * @brief 接收上面的数据
 */
-(void)setDataDiction:(NSDictionary *)dataDiction{
    
    _dataDiction = dataDiction;
    
    NSArray *array = dataDiction[@"groupGoodsDetailVo"][@"goodsList"];
    
    NSDictionary *GoodsDiction = [array firstObject];
    
    // 原来的价格
    NSString *OrginMonery = GoodsDiction[@"appPrice0"];
    
    // 现在的价格
    NSString *PrsentMonery = GoodsDiction[@"groupPrice"];
    
    // 商品的现在的价格
    self.Price_Label.text = [NSString stringWithFormat:@"¥%.2f",[PrsentMonery floatValue]];
    
    // 几人团
    NSString *Persons = [NSString stringWithFormat:@"%@",dataDiction[@"groupGoodsDetailVo"][@"groups"][@"groupRequireNum"]];
    [self.PinTuanCount_Btn setTitle:[NSString stringWithFormat:@"%@人开团",Persons] forState:(UIControlStateNormal)];
    
    // 商品的原价--下划线
    NSString *Orgin_Monery = [NSString stringWithFormat:@"¥%.2f",[OrginMonery floatValue]];
    
    NSDictionary *attribtDic = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
    
    NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:Orgin_Monery attributes:attribtDic];
    
    self.OrginPrice_Label.attributedText = attribtStr;
    
    // 已团多少件
    self.YiTuanCountGoods_Label.text = [NSString stringWithFormat:@"已团%@%@", dataDiction[@"groupGoodsDetailVo"][@"groupsSaleNum"],dataDiction[@"groupGoodsDetailVo"][@"unitName"]];
    
    // 节省多少钱
    NSString *ShengMonery = [NSString stringWithFormat:@"%.2f",OrginMonery.floatValue - PrsentMonery.floatValue];
    self.ShengMonery_Label.text = [NSString stringWithFormat:@"拼团省¥%@",ShengMonery];
    
    // 秒杀倒计时
    NSString *EndTime = [NSString stringWithFormat:@"%@",dataDiction[@"groupGoodsDetailVo"][@"groups"][@"endTime"]];
    
    [self CountdownTimer:EndTime];
    
}

/**
 * @brief 秒杀倒计时
 * @param timerInterval 时间戳
 */
- (void)CountdownTimer:(NSString *)timerInterval{
    
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *endDate = [dateFormatter dateFromString:timerInterval];
    
    NSDate *endDate_tomorrow = [[NSDate alloc] initWithTimeIntervalSinceReferenceDate:([endDate timeIntervalSinceReferenceDate] + 24*3600)];
    
    NSDate *startDate = [NSDate date];
    
    NSTimeInterval timeInterval =[endDate_tomorrow timeIntervalSinceDate:startDate];
    
    if (_timer==nil) {
        __block int timeout = timeInterval; //倒计时时间
        
        if (timeout!=0) {
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
            dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
            dispatch_source_set_event_handler(_timer, ^{
                if(timeout<=0) //倒计时结束，关闭
                {
                    dispatch_source_cancel(_timer);
                    _timer = nil;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        self.dayLabel.text = @"";
                        self.hourLabel.text = @"00";
                        self.minuteLabel.text = @"00";
                        self.secondLabel.text = @"00";
                    });
                }
                else
                {
                    int days = (int)(timeout/(3600*24));
                    int hours = (int)((timeout-days*24*3600)/3600);
                    int minute = (int)(timeout-days*24*3600-hours*3600)/60;
                    int second = timeout-days*24*3600-hours*3600-minute*60;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        if (days==0)
                        {
                            self.dayLabel.text = @"0天";
                        }
                        else
                        {
                            self.dayLabel.text = [NSString stringWithFormat:@"%d天",days];
                        }
                        if (hours<10)
                        {
                            self.hourLabel.text = [NSString stringWithFormat:@"0%d",hours];
                        }
                        else
                        {
                            self.hourLabel.text = [NSString stringWithFormat:@"%d",hours];
                        }
                        if (minute<10)
                        {
                            self.minuteLabel.text = [NSString stringWithFormat:@"0%d",minute];
                        }
                        else
                        {
                            self.minuteLabel.text = [NSString stringWithFormat:@"%d",minute];
                        }
                        if (second<10)
                        {
                            self.secondLabel.text = [NSString stringWithFormat:@"0%d",second];
                        }
                        else
                        {
                            self.secondLabel.text = [NSString stringWithFormat:@"%d",second];
                        }
                        
                    });
                    timeout--;
                }
            });
            dispatch_resume(_timer);
        }
    }
    
}


@end
