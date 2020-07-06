//
//  ZYLHealthManager.m
//  MRMobileRun
//
//  Created by 丁磊 on 2020/4/6.
//

#import "ZYLHealthManager.h"

@implementation ZYLHealthManager
+(id)shareInstance
{
    static id manager ;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[[self class] alloc] init];
        [manager getPermissions];//检查是否获取权限
    });
    return manager;
}

- (void)getPermissions
{
    if (![HKHealthStore isHealthDataAvailable]) {
        NSLog(@"该设备不支持HealthKit");
    }
    else{
        //创建healthStore对象
            self.healthStore = [[HKHealthStore alloc]init];
            
            //设置需要获取的权限 这里仅设置了步数
            HKObjectType *stepType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount];
            HKObjectType *stairType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierFlightsClimbed];
            HKObjectType *kiloType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierActiveEnergyBurned];
            HKObjectType *distanceType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierDistanceWalkingRunning];
            NSSet *healthSet = [NSSet setWithObjects:stepType, stairType, kiloType, distanceType, nil];
            
            //从健康应用中获取权限
            [self.healthStore requestAuthorizationToShareTypes:nil readTypes:healthSet completion:^(BOOL success, NSError * _Nullable error) {
                if (success) {
                    //获取步数后我们调用获取步数的方法
                    NSLog(@"获得步数权限成功");
                }
                else
                {
                    NSLog(@"获取步数权限失败");
                }
            }];
    }
}
- (NSInteger)getTodayStepCount{
    return [self readDataType: HKQuantityTypeIdentifierStepCount ForDate:1];
}

- (NSInteger)getYesterdayStepCount{
    return [self readDataType: HKQuantityTypeIdentifierStepCount ForDate:-1];
}

- (NSInteger)getTodayFlightsClimbedCount{
    return [self readDataType: HKQuantityTypeIdentifierFlightsClimbed ForDate:1];
}

- (NSInteger)getYesterdayFlightsClimbedCount{
    return [self readDataType: HKQuantityTypeIdentifierFlightsClimbed ForDate:-1];
}

//参数1 获取数据类型（步数、卡路里、运动距离、已爬台阶）
//参数2 获取时间段 今天传入1， 昨天传入-1
- (NSInteger)readDataType:(HKQuantityTypeIdentifier)identifer ForDate:(NSInteger) istoday{
    HKSampleType *sampleType = [HKQuantityType quantityTypeForIdentifier:identifer];
    NSSortDescriptor *start = [NSSortDescriptor sortDescriptorWithKey:HKSampleSortIdentifierStartDate ascending:NO];
    NSSortDescriptor *end = [NSSortDescriptor sortDescriptorWithKey:HKSampleSortIdentifierEndDate ascending:NO];
    NSDate *now = [NSDate date];
    NSCalendar *calender = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *dateComponent = [calender components:unitFlags fromDate:now];
    int hour = (int)[dateComponent hour];
    int minute = (int)[dateComponent minute];
    int second = (int)[dateComponent second];
    NSDate *startDay = [[NSDate alloc] init];
    NSDate *endDay = [[NSDate alloc] init];
    if (istoday == 1) {
        startDay = [NSDate dateWithTimeIntervalSinceNow:  - (hour*3600 + minute * 60 + second) ];
        //时间结果与想象中不同是因为它显示的是0区
        NSLog(@"今天%@",startDay);
        endDay = [NSDate dateWithTimeIntervalSinceNow:  - (hour*3600 + minute * 60 + second)  + 86400];
        NSLog(@"明天%@",endDay);
    }
    else{
        startDay = [NSDate dateWithTimeIntervalSinceNow:  - (hour*3600 + minute * 60 + second) - 86400 ];
        //时间结果与想象中不同是因为它显示的是0区
        NSLog(@"昨天%@",startDay);
        endDay = [NSDate dateWithTimeIntervalSinceNow:  - (hour*3600 + minute * 60 + second) ];
        NSLog(@"今天%@",endDay);
    }
   //设置一个int型变量来作为数据统计
    __block NSInteger allCount = 0;
    NSPredicate *predicate = [HKQuery predicateForSamplesWithStartDate:startDay endDate:endDay options:(HKQueryOptionNone)];
    HKSampleQuery *sampleQuery = [[HKSampleQuery alloc]initWithSampleType:sampleType predicate:predicate limit:0 sortDescriptors:@[start,end] resultsHandler:^(HKSampleQuery * _Nonnull query, NSArray<__kindof HKSample *> * _Nullable results, NSError * _Nullable error) {
        //设置一个int型变量来作为步数统计
        for (int i = 0; i < results.count; i ++) {
            //把结果转换为字符串类型
            HKQuantitySample *result = results[i];
            HKQuantity *quantity = result.quantity;
            NSMutableString *stepCount = (NSMutableString *)quantity;
            NSString *stepStr =[ NSString stringWithFormat:@"%@",stepCount];
            //获取51 count此类字符串前面的数字
            NSString *str = [stepStr componentsSeparatedByString:@" "][0];
            int stepNum = [str intValue];
            NSLog(@"%d",stepNum);
            //把一天中所有时间段中的步数加到一起
            allCount = allCount + stepNum;
        }
        NSLog(@"总步数＝＝＝＝%ld",(long)allCount);
    }];
    [self.healthStore executeQuery:sampleQuery];
    return  allCount;
}

@end
