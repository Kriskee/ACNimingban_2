//
//  KGetTime.m
//  KGetTime
//
//  Created by lanou3g on 16/1/8.
//  Copyright © 2016年 刘超凯. All rights reserved.
//

#import "KGetTime.h"

@implementation KGetTime
NSDate *date;
NSDateFormatter *formatter;

+ (NSInteger)nowHour_24{
    date = [NSDate dateWithTimeIntervalSinceNow:0];
    formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH"];
    return [[formatter stringFromDate:date] integerValue];
}

+ (NSInteger)nowHour_12{
    date = [NSDate dateWithTimeIntervalSinceNow:0];
    formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"hh"];
    return [[formatter stringFromDate:date] integerValue];
}

+ (NSInteger)nowMinute{
    date = [NSDate dateWithTimeIntervalSinceNow:0];
    formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"mm"];
    return [[formatter stringFromDate:date] integerValue];
}

+ (NSInteger)nowSecond{
    date = [NSDate dateWithTimeIntervalSinceNow:0];
    formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"ss"];
    return [[formatter stringFromDate:date] integerValue];
}

+ (NSString*)nowDate:(NSString*)formatter_{
    date = [NSDate dateWithTimeIntervalSinceNow:0];
    formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:formatter_];
    return [formatter stringFromDate:date];
}

// 根据
+ (NSString*)getDateForSec:(NSInteger)seconds formatter:(NSString*)formatter_{
    date = [NSDate dateWithTimeIntervalSince1970:seconds];
    formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:formatter_];
    return [formatter stringFromDate:date];
}
@end

 // Formatter格式:
 /*
 d:    将日显示为不带前导零的数字（如 1）
 dd:   将日显示为带前导零的数字（如 01）
 EEE:  将日显示为缩写形式（例如 Sun）
 EEEE: 将日显示为全名（例如 Sunday）
 M:    将月份显示为不带前导零的数字（如一月表示为 1）
 MM:   将月份显示为带前导零的数字（例如 01/12/01）
 MMM:  将月份显示为缩写形式（例如 Jan）
 MMMM: 将月份显示为完整月份名（例如 January）
 gg:   显示时代/纪元字符串（例如 A.D.）
 h:    使用 12 小时制将小时显示为不带前导零的数字（例如 1:15:15 PM）
 hh:   使用 12 小时制将小时显示为带前导零的数字（例如 01:15:15 PM）
 H:    使用 24 小时制将小时显示为不带前导零的数字（例如 1:15:15）
 HH:   使用 24 小时制将小时显示为带前导零的数字（例如 01:15:15）
 m:    将分钟显示为不带前导零的数字（例如 12:1:15）
 mm:   将分钟显示为带前导零的数字（例如 12:01:15）
 s:    将秒显示为不带前导零的数字（例如 12:15:5）
 ss:   将秒显示为带前导零的数字（例如 12:15:05）
 f:    显示秒的小数部分。例如，ff 将精确显示到百分之一秒，而 ffff 将精确显示到万分之一秒。用户定义格式中最多可使用七个 f 符号
 t:    使用 12 小时制，并对中午之前的任一小时显示大写的 A，对中午到 11:59 P.M 之间的任一小时显示大写的 P
 tt:   对于使用 12 小时制的区域设置，对中午之前任一小时显示大写的 AM，对中午到 11:59 P.M 之间的任一小时显示大写的 PM
       对于使用 24 小时制的区域设置，不显示任何字符
 y:    将年份 (0-9) 显示为不带前导零的数字
 yy:   以带前导零的两位数字格式显示年份（如果适用）
 yyy:  以四位数字格式显示年份
 yyyy: 以四位数字格式显示年份
 z:    显示不带前导零的时区偏移量（如 -8）
 zz:   显示带前导零的时区偏移量（例如 -08）
 zzz:  显示完整的时区偏移量（例如 -08:00）
 */

