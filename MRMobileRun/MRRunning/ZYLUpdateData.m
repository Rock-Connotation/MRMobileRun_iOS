//
//  ZYLUpdateData.m
//  MRMobileRun
//
//  Created by 丁磊 on 2019/5/3.
//

#import "ZYLUpdateData.h"

@implementation ZYLUpdateData
+ (NSDictionary *)ZYLGetUpdateDataDictionaryWithBegintime:(NSNumber *)begin Endtime:(NSNumber *)end distance:(NSNumber *)distance lat_lng:(NSArray *)lat_lng andSteps:(NSNumber *)steps{
    NSString *student = @"2017210338";
//    记得改
    NSDictionary *dic = @{@"begin_time": begin,
                          @"distance": distance,
                          @"end_time": end,
                          @"lat_lng": lat_lng,
                          @"steps": steps,
                          @"student_id": student
                          };
    
    return dic;
}
@end
