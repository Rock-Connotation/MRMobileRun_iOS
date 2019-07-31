//
//  ZYLTimeStamp.m
//  MRMobileRun
//
//  Created by 丁磊 on 2019/5/3.
//

#import "ZYLTimeStamp.h"

@implementation ZYLTimeStamp
+ (NSString *)getTimeStamp{
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970];
    NSString *timeString = [NSString stringWithFormat:@"%d", (int)a];
    NSLog(@"%@",timeString);
    return timeString;
}
+ (NSString *)getCodeTimeStamp{
    UInt64 recordTime = [[NSDate date] timeIntervalSince1970]*1000;
    NSString *timeString = [NSString stringWithFormat:@"%llu", recordTime];
    NSLog(@"%@",timeString);
    return timeString;
}

+ (NSDate *)getDateFromTimeStamp:(NSString *)timeStamp{
    NSTimeInterval time=[timeStamp doubleValue];//如果是美国则因为时差问题要加8小时 == 28800 sec，这里不需要加
    NSDate *detaildate = [NSDate dateWithTimeIntervalSince1970:time];
    return detaildate;
}
@end
