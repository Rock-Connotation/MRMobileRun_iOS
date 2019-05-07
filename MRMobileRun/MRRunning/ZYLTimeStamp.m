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
@end
