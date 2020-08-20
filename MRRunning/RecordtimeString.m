//
//  RecordtimeString.m
//  MRMobileRun
//
//  Created by 石子涵 on 2020/7/29.
//

#import "RecordtimeString.h"

@implementation RecordtimeString
//将秒数转化为HH:MM:SS格式数据的一个方法
+ (NSString *)getTimeStringWithSeconds:(int)second{
    NSString *timeString = [[NSString alloc] init];
    
    NSString *secondString = [[NSString alloc] init];
    NSString *minuteString = [[NSString alloc] init];
    NSString *hourString = [[NSString alloc] init];
    
    NSString *secondStr = [NSString stringWithFormat:@"%d",second%3600%60];
    
    if (second%3600%60 <10 ) {
        secondString = [NSString stringWithFormat:@"%@%@",@"0",secondStr];
    }
    else{
        secondString = [NSString stringWithFormat:@"%@",secondStr];
    }
    
    NSString * minuteStr = [NSString stringWithFormat:@"%d",second%3600/60];
    
    if (second%3600/60<10) {
        minuteString = [NSString stringWithFormat:@"%@%@",@"0",minuteStr];
    }
    else{
        minuteString = [NSString stringWithFormat:@"%@",minuteStr];
        
    }
    NSString * hourStr = [NSString stringWithFormat:@"%d",second/3600];
    if (second/3600 <10) {
        hourString = [NSString stringWithFormat:@"%@%@",@"0",hourStr];
    }
    else{
        hourString = [NSString stringWithFormat:@"%@",hourStr];
        
    }
    timeString = [NSString stringWithFormat:@"%@%@%@%@%@",hourString,@":",minuteString,@":",secondString];
    NSLog(@"%@",timeString);
    
    return timeString;
}
@end
