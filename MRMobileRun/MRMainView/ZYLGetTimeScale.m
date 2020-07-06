//
//  ZYLGetTimeScale.m
//  MRMobileRun
//
//  Created by 丁磊 on 2020/4/5.
//

#import "ZYLGetTimeScale.h"

@implementation ZYLGetTimeScale
+ (NSString *)getTimeScaleString{
    NSDate *date = [NSDate date]; // 获得时间对象
    NSDateFormatter *forMatter = [[NSDateFormatter alloc] init];
    [forMatter setDateFormat:@"HH-mm-ss yyyy-MM-dd"];
    NSString *dateStr = [forMatter stringFromDate:date];
    NSInteger hour = [dateStr substringToIndex:2].integerValue;
    NSString *ret = [[NSString alloc] init];
    if (hour > 0 && hour < 12) {
        ret = @"上午好，";
    }else if (hour < 19){
        ret = @"下午好，";
    }else{
        ret = @"晚上好，";
    }
    return ret;
}
@end
