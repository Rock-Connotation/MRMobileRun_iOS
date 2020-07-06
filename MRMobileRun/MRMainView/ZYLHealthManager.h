//
//  ZYLHealthManager.h
//  MRMobileRun
//
//  Created by 丁磊 on 2020/4/6.
//

#import <Foundation/Foundation.h>
#import <HealthKit/HealthKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface ZYLHealthManager : NSObject
@property (nonatomic, strong) HKHealthStore *healthStore;


+(id)shareInstance;
//- (void)getRealTimeStepCountCompletionHandler:(void(^)(double value, NSError *error))handler;
////获取当天实时步数
//- (void)getStepCount:(NSPredicate *)predicate completionHandler:(void(^)(double value, NSError *error))handler;
////获取时间段步数
//- (void)getKilocalorieUnit:(NSPredicate *)predicate quantityType:(HKQuantityType*)quantityType completionHandler:(void(^)(double value, NSError *error))handler;
////获取卡路里
//
//+ (NSPredicate *)predicateForSamplesToday;
////当天时间段

- (NSInteger) getTodayStepCount;
- (NSInteger) getYesterdayStepCount;
- (NSInteger) getTodayFlightsClimbedCount;
- (NSInteger) getYesterdayFlightsClimbedCount;

@end

NS_ASSUME_NONNULL_END
