//
//  GYYHealthTableViewCell.m
//  MRMobileRun
//
//  Created by 郭蕴尧 on 2020/7/9.
//

#import "GYYHealthManager.h"
#import <UIKit/UIDevice.h>

#define HKVersion [[[UIDevice currentDevice] systemVersion] doubleValue]  //取系统版本号
#define CustomHealthErrorDomain @"com.sdqt.healthError"

@implementation GYYHealthManager

+ (id)shareInstance {   //单例  程序启动之后，全局通用
    static id manager; //只开辟一次空间   存储在静态空间
    static dispatch_once_t onceToken;   //GCD
    dispatch_once(&onceToken, ^{
        manager = [[[self class] alloc] init];
    });
    return manager;
}

//检查是否支持获取健康数据
- (void)authorizeHealthKit:(void(^)(BOOL success, NSError *error))compltion{
    if (HKVersion >= 8.0) {
        if (![HKHealthStore isHealthDataAvailable]) {
            NSLog(@"该设备不支持HealthKit");
        }else{
            //只需要初始化一次
            if(self.healthStore == nil)
                self.healthStore = [[HKHealthStore alloc] init];
            
            //组装需要读写的数据类型
            NSSet *writeDataTypes = [self dataTypesToWrite];
            NSSet *readDataTypes = [self dataTypesRead];
            
            //注册需要读写的数据类型，也可以在"设置 - 健康"中重新修改
            //ShareTypes  写的内容
            //readTypes   读的内容
            [self.healthStore requestAuthorizationToShareTypes:writeDataTypes readTypes:readDataTypes completion:^(BOOL success, NSError *error) {
                // success = 0   1
                if (compltion != nil) {
                    NSLog(@"error->%@", error.localizedDescription);
                    compltion(success, error);
                }
            }];
        }
    } else {
        NSLog(@"iOS 系统低于8.0");
    }
}

//获取步数
- (void)getStepCountIsToday:(BOOL)isToday completion:(void(^)(double value, NSError *error))completion{
    //1.确定类型 HKQuantityTypeIdentifierStepCount
    HKQuantityType *stepType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount];
    //2.确定检索
    NSSortDescriptor *start = [NSSortDescriptor sortDescriptorWithKey:HKSampleSortIdentifierStartDate ascending:NO];
    NSSortDescriptor *end = [NSSortDescriptor sortDescriptorWithKey:HKSampleSortIdentifierEndDate ascending:NO];
 
    HKSampleQuery *query = [[HKSampleQuery alloc] initWithSampleType:stepType predicate:[GYYHealthManager predicateForSamplesToday:isToday] limit:HKObjectQueryNoLimit sortDescriptors:@[start, end] resultsHandler:^(HKSampleQuery *query, NSArray *results, NSError *error) {
        
        if(error){
            completion(0,error);
        }else{
            NSInteger totleSteps = 0;
            for(HKQuantitySample *quantitySample in results){
                HKQuantity *quantity = quantitySample.quantity;
                HKUnit *heightUnit = [HKUnit countUnit];
                double usersHeight = [quantity doubleValueForUnit:heightUnit];
                totleSteps += usersHeight;
            }
            completion(totleSteps, error);
        }
    }];
    [self.healthStore executeQuery:query];
}


//获取阶梯数
- (void)getStairIsToday:(BOOL)isToday completion:(void(^)(double value, NSError *error))completion{
    //1.要检索的数据类型
    HKQuantityType *stairType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierFlightsClimbed];   //用系统方法，拿quantity，阶梯类型
    //2.数据的排序描述
    NSSortDescriptor *start = [NSSortDescriptor sortDescriptorWithKey:HKSampleSortIdentifierStartDate ascending:NO];  //渐进
    NSSortDescriptor *end = [NSSortDescriptor sortDescriptorWithKey:HKSampleSortIdentifierEndDate ascending:NO];           ////NSSortDescriptors用来告诉healthStore怎么样将结果排序。   我们这里用起止时间

    /*
     @param         sampleType      要检索的数据类型。
     @param         predicate       数据应该匹配的基准。3  配置系统要求的NSPredicate 类型的参数
    4 @param         limit           返回的最大数据条数   HKObjectQueryNoLimit = 0  系统静态   0就是没有限制
     @param         sortDescriptors 数据的排序描述    
     @param         resultsHandler  结束后返回结果
     */
    HKSampleQuery *query = [[HKSampleQuery alloc] initWithSampleType:stairType predicate:[GYYHealthManager predicateForSamplesToday:isToday] limit:HKObjectQueryNoLimit sortDescriptors:@[start, end] resultsHandler:^(HKSampleQuery * _Nonnull query, NSArray<__kindof HKSample *> * _Nullable results, NSError * _Nullable error) {
 
        if(error) {
            completion(0,error);
        } else {
            //健康根据时间段记录  会有很多段记录   遍历results集合  取到quantitySample  样例
            double totleSteps = 0;
            //5.拿到系统返回的数据集合
            for(HKQuantitySample *quantitySample in results) {
                HKQuantity *quantity = quantitySample.quantity;
                HKUnit *countUnit = [HKUnit countUnit];
                double usersHeight = [quantity doubleValueForUnit:countUnit];
                totleSteps += usersHeight;  // totleSteps = totleSteps + usersHeight；
            }
            completion(totleSteps, error);
        }
    }];
    [self.healthStore executeQuery:query];
}

+ (NSPredicate *)predicateForSamplesToday:(BOOL)isToday{
    NSCalendar *calendar = [NSCalendar currentCalendar];   //拿日历
    NSDate *now = [NSDate date];   //获取当前date
    NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:now];    //date 组件
    [components setHour:0];    // 2020-07-13 00:00:00
    [components setMinute:0];
    [components setSecond:0];
 
    if (isToday) {
        NSDate *startDate = [calendar dateFromComponents:components];  //2020-07-13 00:00:00、
                                                //计数单位  天
        NSDate *endDate = [calendar dateByAddingUnit:NSCalendarUnitDay value:1 toDate:startDate options:0];  //2020-07-14 00：00:00
        NSPredicate *predicate = [HKQuery predicateForSamplesWithStartDate:startDate endDate:endDate options:HKQueryOptionNone];   //拼参数
        return predicate;
    }else{
        NSDate *endDate = [calendar dateFromComponents:components];  //2020-07-13 00:00:00
        NSDate *startDate = [calendar dateByAddingUnit:NSCalendarUnitDay value:-1 toDate:endDate options:0];  //2020-07-12 00:00:00、
        NSPredicate *predicate = [HKQuery predicateForSamplesWithStartDate:startDate endDate:endDate options:HKQueryOptionNone];
        return predicate;
    }
}

/**   官方文档  翻译     静态常量 字符串
 身体测量
 1. HKQuantityTypeIdentifierBodyMassIndex      身高体重指数
 2. HKQuantityTypeIdentifierBodyFatPercentage  体脂率
 3. HKQuantityTypeIdentifierHeight             身高
 4. HKQuantityTypeIdentifierBodyMass           体重
 5. HKQuantityTypeIdentifierLeanBodyMass       去脂体重
 
 健身数据
 1. HKQuantityTypeIdentifierStepCount               步数
 2. HKQuantityTypeIdentifierDistanceWalkingRunning  步行+跑步距离
 3. HKQuantityTypeIdentifierDistanceCycling         骑车距离
 4. HKQuantityTypeIdentifierBasalEnergyBurned       静息能量
 5. HKQuantityTypeIdentifierActiveEnergyBurned      活动能量
 6. HKQuantityTypeIdentifierFlightsClimbed          已爬楼层

 主要特征
 1. HKQuantityTypeIdentifierHeartRate 心率
 2. HKQuantityTypeIdentifierBodyTemperature  体温
 3. HKQuantityTypeIdentifierBasalBodyTemperature 基础体温
 4. HKQuantityTypeIdentifierBloodPressureSystolic  收缩压
 5. HKQuantityTypeIdentifierBloodPressureDiastolic  舒张压
 6. HKQuantityTypeIdentifierRespiratoryRate  呼吸速率

 数据结果、营养摄入
 */
 
//写权限集合
- (NSSet *)dataTypesToWrite{
    
    HKQuantityType *heightType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierHeight];
    HKQuantityType *weightType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyMass];
    HKQuantityType *temperatureType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyTemperature];
    HKQuantityType *activeEnergyType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierActiveEnergyBurned];
 
    return [NSSet setWithObjects:heightType, temperatureType, weightType,activeEnergyType,nil];
}
 
//读权限集合
- (NSSet *)dataTypesRead{
    HKCharacteristicType *birthdayType = [HKObjectType characteristicTypeForIdentifier:HKCharacteristicTypeIdentifierDateOfBirth];
    HKCharacteristicType *sexType = [HKObjectType characteristicTypeForIdentifier:HKCharacteristicTypeIdentifierBiologicalSex];

    HKQuantityType *heightType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierHeight];
    HKQuantityType *weightType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyMass];
    HKQuantityType *stepCountType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount];
    HKQuantityType *stairType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierFlightsClimbed];
    HKQuantityType *distanceType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierDistanceWalkingRunning];
    HKQuantityType *activeEnergyType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierActiveEnergyBurned];
 
    return [NSSet setWithObjects:birthdayType, sexType, heightType, weightType, stepCountType, stairType, distanceType, activeEnergyType, nil];
}

@end
