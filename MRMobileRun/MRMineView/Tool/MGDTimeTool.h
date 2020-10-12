//
//  MGDTimeTool.h
//  MRMobileRun
//
//  Created by 阿栋 on 2020/10/11.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MGDTimeTool : NSObject
//返回当前的时间
+ (NSString *) dateToString:(NSDate *)date;
//返回年份
+ (NSString *) dateToYear:(NSDate *)date;
//返回昨天
+ (NSString *) yesterdayTostring:(NSDate *)date;
//配速的字符串
+ (NSString *) getAverageSpeed:(NSString *)averagespeed;
//跑步时间的字符串
+ (NSString *) getRunTimeFromSS:(NSString *)totalTime;
//秒数转换成时分秒
+ (NSString *) getMMSSFromSS:(NSString *)totalTime;
//时间戳换成日期
+ (NSString *) getDateStringWithTimeStr:(NSString *)str;
//时间戳换成具体的时间
+ (NSString *) getTimeStringWithTimeStr:(NSString *)str;
//返回去年
+ (NSString *) lastDateTostring:(NSDate *)date;
//获取当前的年份，并且设置列表的年份为 上一年，本年，下一年
+ (NSArray *)columnYearLabelYear;

@end

NS_ASSUME_NONNULL_END
