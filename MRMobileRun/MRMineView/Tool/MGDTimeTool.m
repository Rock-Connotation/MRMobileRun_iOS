//
//  MGDTimeTool.m
//  MRMobileRun
//
//  Created by 阿栋 on 2020/10/11.
//

#import "MGDTimeTool.h"

@implementation MGDTimeTool

//返回当前的时间
+ (NSString *) dateToString:(NSDate *)date {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateStr = [dateFormatter stringFromDate:date];
    return dateStr;
}

//返回昨天
+ (NSString *) yesterdayTostring:(NSDate *)date {
     NSDate *mydate=[NSDate date];
     NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
     NSDateComponents *comps = nil;
     comps = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:mydate];
     NSDateComponents *adcomps = [[NSDateComponents alloc] init];
     [adcomps setYear:0];
     [adcomps setMonth:0];
     [adcomps setDay:-1];
     NSDate *newdate = [calendar dateByAddingComponents:adcomps toDate:mydate options:0];
     return [self dateToString:newdate];
}

//配速的字符串
+ (NSString *)getAverageSpeed:(NSString *)averagespeed {
    NSArray  *array = [averagespeed componentsSeparatedByString:@"."];
    NSString *speed = [NSString stringWithFormat:@"%@'%@''",array[0],array[1]];
    return speed;
}

//跑步时间的字符串
+ (NSString *)getRunTimeFromSS:(NSString *)totalTime{
    NSInteger seconds = [totalTime integerValue];
    NSString *str_minute = [NSString stringWithFormat:@"%02ld",(long)(seconds%3600)/60];
    NSString *str_second = [NSString stringWithFormat:@"%02ld",(long)seconds%60];
    NSString *format_time = [NSString stringWithFormat:@"%@:%@",str_minute,str_second];
    return format_time;
}

//秒数转换成时分秒
+ (NSString *)getMMSSFromSS:(NSString *)totalTime{
    NSInteger seconds = [totalTime integerValue];
    NSString *str_minute = [[NSString alloc] init];
    NSString *str_second = [NSString stringWithFormat:@"%02ld",(long)seconds%60];
    if (seconds >= 6000) {
        str_minute = [NSString stringWithFormat:@"%03ld",(long)(seconds%3600)/60];
    }else {
        str_minute = [NSString stringWithFormat:@"%02ld",(long)(seconds%3600)/60];
    }
    NSString *format_time = [NSString stringWithFormat:@"%@:%@",str_minute,str_second];
    return format_time;
}

//时间戳换成日期
+ (NSString *)getDateStringWithTimeStr:(NSString *)str{
    NSTimeInterval time=[str doubleValue];
    NSDate *detailDate=[NSDate dateWithTimeIntervalSince1970:time];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
        [dateFormatter setDateFormat:@"MM-dd"];
    NSString *currentDateStr = [dateFormatter stringFromDate: detailDate];
    return currentDateStr;
}

//时间戳换成具体的时间
+ (NSString *)getTimeStringWithTimeStr:(NSString *)str {
    NSTimeInterval time=[str doubleValue];
    NSDate *detailDate=[NSDate dateWithTimeIntervalSince1970:time];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
        [dateFormatter setDateFormat:@"HH:mm"];
    NSString *currentDateStr = [dateFormatter stringFromDate: detailDate];
    return currentDateStr;
}

//返回年份
+ (NSString *) dateToYear:(NSDate *)date {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy"];
    NSString *dateStr = [dateFormatter stringFromDate:date];
    return dateStr;
}

//返回去年的时间
+ (NSString *) lastDateTostring:(NSDate *)date {
    NSDate *mydate=[NSDate date];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comps = nil;
    comps = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:mydate];
    NSDateComponents *adcomps = [[NSDateComponents alloc] init];
    [adcomps setYear:-1];
    [adcomps setMonth:0];
    [adcomps setDay:0];
    NSDate *newdate = [calendar dateByAddingComponents:adcomps toDate:mydate options:0];
    return [self dateToString:newdate];
}

//获取当前的年份，并且设置列表的年份为 上一年，本年，下一年
+ (NSArray *)columnYearLabelYear {
    NSMutableArray *yearArray = [NSMutableArray new];
    NSDate *date =[NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy"];
    NSInteger currentYear=[[formatter stringFromDate:date] integerValue];
    for (int i = 2;i >= 0; i--) {
        [yearArray addObject:[NSString stringWithFormat:@"%ld",(long)(currentYear  - i)]];
    }
    return [yearArray copy];
}


@end
