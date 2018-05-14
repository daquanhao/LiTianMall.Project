//
//  NSString+HSQ.m
//  LiTianDecoration
//
//  Created by administrator on 2018/4/9.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import "NSString+HSQ.h"

@implementation NSString (HSQ)

/**
 * @brief 判断文字是否是手机号
 */
- (BOOL)isPhone{
    
    if (self.length != 11) return NO;

    /**
     * 手机号码:
     * 13[0-9], 14[5,7], 15[0, 1, 2, 3, 5, 6, 7, 8, 9], 17[6, 7, 8], 18[0-9], 170[0-9]
     * 移动号段: 134,135,136,137,138,139,150,151,152,157,158,159,182,183,184,187,188,147,178,1705
     * 联通号段: 130,131,132,155,156,185,186,145,176,1709
     * 电信号段: 133,153,180,181,189,177,1700
     */
    NSString *MOBILE = @"^1(3[0-9]|4[57]|5[0-35-9]|8[0-9]|7[0678])\\d{8}$";
    /**
     * 中国移动：China Mobile
     * 134,135,136,137,138,139,150,151,152,157,158,159,182,183,184,187,188,147,178,1705
     */
    NSString *CM = @"(^1(3[4-9]|4[7]|5[0-27-9]|7[8]|8[2-478])\\d{8}$)|(^1705\\d{7}$)";
    /**
     * 中国联通：China Unicom
     * 130,131,132,155,156,185,186,145,176,1709
     */
    NSString *CU = @"(^1(3[0-2]|4[5]|5[56]|7[6]|8[56])\\d{8}$)|(^1709\\d{7}$)";
    /**
     * 中国电信：China Telecom
     * 133,153,180,181,189,177,1700
     */
    NSString *CT = @"(^1(33|53|77|8[019])\\d{8}$)|(^1700\\d{7}$)";
    /**
     * 大陆地区固话及小灵通
     * 区号：010,020,021,022,023,024,025,027,028,029
     * 号码：七位或八位
     */
    NSString * PHS = @"^(0[0-9]{2})\\d{8}$|^(0[0-9]{3}(\\d{7,8}))$";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    NSPredicate *regextestct01 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", PHS];
    if (([regextestmobile evaluateWithObject:self] == YES) || ([regextestcm evaluateWithObject:self] == YES) || ([regextestct evaluateWithObject:self] == YES)|| ([regextestcu evaluateWithObject:self] == YES) || ([regextestct01 evaluateWithObject:self] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

/**
 * @brief 验证邮箱
 */
-(BOOL)validateEmail:(NSString*)email{
    
    if((0 != [email rangeOfString:@"@"].length) && (0 != [email rangeOfString:@"."].length))
    {
        NSCharacterSet* tmpInvalidCharSet = [[NSCharacterSet alphanumericCharacterSet] invertedSet];
        
        NSMutableCharacterSet* tmpInvalidMutableCharSet = [tmpInvalidCharSet mutableCopy];
        
        [tmpInvalidMutableCharSet removeCharactersInString:@"_-"];
        
        /*
         *使用compare option 来设定比较规则，如
         *NSCaseInsensitiveSearch是不区分大小写
         *NSLiteralSearch 进行完全比较,区分大小写
         *NSNumericSearch 只比较定符串的个数，而不比较字符串的字面值
         */
        NSRange range1 = [email rangeOfString:@"@" options:NSCaseInsensitiveSearch];
        
        //取得用户名部分
        NSString* userNameString = [email substringToIndex:range1.location];
        NSArray* userNameArray   = [userNameString componentsSeparatedByString:@"."];
        
        for(NSString* string in userNameArray)
        {
            NSRange rangeOfInavlidChars = [string rangeOfCharacterFromSet: tmpInvalidMutableCharSet];
            if(rangeOfInavlidChars.length != 0 || [string isEqualToString:@""])
                return NO;
        }
        
        //取得域名部分
        NSString *domainString = [email substringFromIndex:range1.location+1];
        NSArray *domainArray   = [domainString componentsSeparatedByString:@"."];
        
        for(NSString *string in domainArray)
        {
            NSRange rangeOfInavlidChars=[string rangeOfCharacterFromSet:tmpInvalidMutableCharSet];
            if(rangeOfInavlidChars.length !=0 || [string isEqualToString:@""])
                return NO;
        }
        
        return YES;
    }
    else {
        return NO;
    }
}

//利用正则表达式验证
-(BOOL)isValidateEmail:(NSString *)email {
    
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailTest evaluateWithObject:email];
}

/**
 * @brief 判断输入的是否是纯数字
 */
- (BOOL)isPureInt:(NSString *)string{
    
    NSScanner* scan = [NSScanner scannerWithString:string];
    
    int val;
    
    return [scan scanInt:&val] && [scan isAtEnd];
}

/**
 * @brief 将大于10000的文字转换成带有万字的字符串
 */
+ (NSString *)ReturnsAStringWithAThousandWords:(NSString *)string{
    
    if (string.integerValue < 1000)
    {
        return string;
    }
    else
    {
        double wan = string.integerValue / 10000.00;
        
        string = [NSString stringWithFormat:@"%.1f万",wan];
        
        string = [string stringByReplacingOccurrencesOfString:@".0" withString:@""];
        
        return string;
    }
}

/**
 * @brief 计算文字的大小
 */
+ (CGSize)SizeOfTheText:(NSString *)text font:(UIFont *)font MaxSize:(CGSize)maxSize{
    
    NSDictionary *diction = @{NSFontAttributeName : font};
    
    return [text boundingRectWithSize:maxSize options:(NSStringDrawingUsesLineFragmentOrigin) attributes:diction context:nil].size;
}

/**
 * @brief 将时间戳转化为时间格式类
 * @param time 时间戳 例如：18902827642
 * @param type 时间的类型 例如：YYYY年mm月dd日
 */
+ (NSString *)stringWithTheTimeStamp:(NSString *)time TimeType:(NSString *)type{
    
    // 1.创建时间格式类
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    // 2.将时间戳转化为北京时间
    formatter.timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    
    // 3.
    [formatter setDateStyle:(NSDateFormatterMediumStyle)];
    
    // 4.
    [formatter setTimeStyle:(NSDateFormatterShortStyle)];
    
    // 5.转化的格式
    [formatter setDateFormat:type];
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[time doubleValue]];
    
    NSString *string = [formatter stringFromDate:date];
                    
    return string;
    
}

/**
 * @brief 将时间格式类转化为时间戳
 * @param string 时间 例如：2018年04月09日
 * @param type 时间的类型 例如：YYYY年mm月dd日
 */
+ (NSString *)timeStampWithString:(NSString *)string TimeType:(NSString *)type{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    
    [formatter setDateFormat:type]; //(@"YYYY-MM-dd hh:mm:ss") ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    
    [formatter setTimeZone:timeZone];
    
    NSDate* date = [formatter dateFromString:string]; //------------将字符串按formatter转成nsdate
    
    //时间转时间戳的方法:
    NSInteger timeSp = [[NSNumber numberWithDouble:[date timeIntervalSince1970]] integerValue];
    
    return [NSString stringWithFormat:@"%ld",timeSp];
}

/**
 * @brief 改变字符串指定位置的颜色
 */
+ (NSMutableAttributedString *)attributedStringWithString:(NSString *)text Color:(UIColor *)color range:(NSRange)rang{
    
    NSMutableAttributedString *attribe = [[NSMutableAttributedString alloc] initWithString:text];
    
    [attribe setAttributes:@{NSForegroundColorAttributeName : color} range:rang];
    
    return attribe;
}

/**
 * @brief 改变字符串指定位置的大小
 */
+ (NSMutableAttributedString *)attributedStringWithString:(NSString *)text font:(UIFont *)font range:(NSRange)rang{
    
    NSMutableAttributedString *attribe = [[NSMutableAttributedString alloc] initWithString:text];
    
    [attribe setAttributes:@{NSFontAttributeName : font} range:rang];
    
    return attribe;
}

/**
 * @brief 改变字符串指定位置的大小或者颜色
 * @param colorRang 颜色的范围
 * @param fontRang  大小的范围
 */
+ (NSMutableAttributedString *)attributedStringWithString:(NSString *)text font:(UIFont *)font  color:(UIColor *)color  ColorRange:(NSRange)colorRang FontRang:(NSRange)fontRang{
    
    NSMutableAttributedString *attribe = [[NSMutableAttributedString alloc] initWithString:text];
    
    [attribe setAttributes:@{NSFontAttributeName : font} range:fontRang];
    
    [attribe setAttributes: @{NSForegroundColorAttributeName : color} range:colorRang];
    
    return attribe;
}




@end
