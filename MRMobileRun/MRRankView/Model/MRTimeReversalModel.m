

//
//  MRTimeReversalModel.m
//  MobileRun
//
//  Created by 郑沛越 on 2017/3/2.
//  Copyright © 2017年 郑沛越. All rights reserved.
//

#import "MRTimeReversalModel.h"
@interface MRTimeReversalModel()
@property (nonatomic) int second;
@property (nonatomic) int hour;
@property (nonatomic) int minute;
@property (nonatomic,strong) NSString *secondString;
@property (nonatomic,strong) NSString *minuteString;
@property (nonatomic,strong) NSString *hourString;
@property (nonatomic,strong) NSString *timeString;
@end

@implementation MRTimeReversalModel
//这是一个处理时间相关数据的类
- (NSString *)getTimeStringWithSecond:(int )second{
    
    NSString * secondStr = [NSString stringWithFormat:@"%d",second%60];
    if (second%60 <10 ) {
        self.secondString = [NSString stringWithFormat:@"%@%@",@"0",secondStr];
    }
    else{
        self.secondString = [NSString stringWithFormat:@"%@",secondStr];
    }
    self.second  = [[secondStr substringToIndex:secondStr.length -1 ] intValue];
    
    
    
    NSString * minuteStr = [NSString stringWithFormat:@"%d",second / 60 %60];
    
    if (second/60 % 60< 10) {
        self.minuteString = [NSString stringWithFormat:@"%@%@",@"0",minuteStr];
    }
    else{
        self.minuteString = [NSString stringWithFormat:@"%@",minuteStr];
        
    }
    self.second  = [[minuteStr substringToIndex:secondStr.length -1 ] intValue];
    
    NSString * hourStr = [NSString stringWithFormat:@"%d",second/3600];
    if (second/3600 <10) {
        self.hourString = [NSString stringWithFormat:@"%@%@",@"0",hourStr];
    }
    else{
        self.hourString = [NSString stringWithFormat:@"%@",hourStr];
        
    }
    self.second  = [[hourStr substringToIndex:secondStr.length -1 ] intValue];
    
    
    
    
    
    
    self.timeString = [NSString stringWithFormat:@"%@%@%@%@%@",self.hourString,@":",self.minuteString,@":",self.secondString];
    
    return self.timeString;
    
}//这是将秒数转化为HH:MM:SS格式数据的一个方法


- (NSString *)postDate{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    
    [formatter setDateFormat:@"YYYY-MM-dd"];
    
    //现在时间,你可以输出来看下是什么格式
    
    NSDate *datenow = [NSDate date];
    
    //----------将nsdate按formatter格式转成nsstring
    
    NSString *nowtimeStr = [formatter stringFromDate:datenow];
    
    
    
    return nowtimeStr;
}//这是将系统当前时间处理为上传数据格式YYYY—MM-dd的一个方法

- (NSString *)getTimestamp{
    
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970];
    NSString *timeString = [NSString stringWithFormat:@"%d", (int)a];
    
    return timeString;
    
}//获取系统当前时间并转化为时间戳


- (NSString *)getDateWithEndTime:(NSString *)endTime{
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    formatter.timeZone = [NSTimeZone timeZoneWithName:@"shanghai"];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy/MM/dd HH:mm"];
    
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:[endTime doubleValue]];
    NSString* dateString = [formatter stringFromDate:date];
    return dateString;
    
        
}



- (NSMutableDictionary *)getDateAndChanceFormWithEndTime:(NSString *)endTime{
    
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    formatter.timeZone = [NSTimeZone timeZoneWithName:@"shanghai"];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy/MM/dd/HH/mm"];
    
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:[endTime doubleValue]];
    NSString* dateString = [formatter stringFromDate:date];
    
    
    NSArray *array = [dateString componentsSeparatedByString:@"/"];
    
    
    NSString* dateStringOne = [NSString stringWithFormat:@"%@"@"%@"@"%@"@"%@"@"%@",array[0],@"/",array[1],@"/",array[3]];

    NSString * dateStringTwo = [NSString stringWithFormat:@"%@"@"%@"@"%@",array[3],@":",array[4]];
    //将年月日和时分分别取出来
    
    NSMutableDictionary *dateDic = [[NSMutableDictionary alloc] init];
    [dateDic setObject:dateStringOne forKey:@"date"];
    [dateDic setObject:dateStringTwo forKey:@"time"];
    
    
    
    return dateDic;

    
    
}

- (NSString *)getTimeWithBeginTime:(NSString *)beginTime andEndTime:(NSString *)endTime{
    //传入beginTime和endTime的时间戳转为00：00：00的格式
    


    
    
    NSString *time =[NSString stringWithFormat:@"%lf",[endTime doubleValue] - [beginTime doubleValue]];
    
    time = [self getTimeStringWithSecond:[time intValue]];
    
    
    return time;
    
    
    
    
}
@end
